namespace :kafka do
  desc "purchase.completed イベントを購読し、対応する mail_log を送信済みに更新する（Resend未連携のため送信をシミュレートするConsumer）"
  task consume: :environment do
    consumer = Rdkafka::Config.new(
      "bootstrap.servers" => ENV.fetch("KAFKA_BROKERS", "localhost:9092"),
      "group.id" => "virtualec-mail-consumer",
      # 起動前に配信されたイベントも取りこぼさないよう、グループとして未読の先頭から読む
      "auto.offset.reset" => "earliest"
    ).consumer

    consumer.subscribe("purchase.completed")

    puts "[kafka] purchase.completed の購読を開始しました (Ctrl+Cで終了)"

    # Kafkaからのメッセージを1件ずつブロッキングで受け取るループ。
    # 1件の処理で例外が起きても begin/rescue で捕まえ、ループ自体は止めずに次のメッセージへ進む
    # （1件の不正データのせいでConsumerプロセス全体が落ちるのを防ぐため）。
    consumer.each do |message|
      payload = JSON.parse(message.payload)
      purchase = Purchase.find_by(id: payload["purchase_id"])

      if purchase&.mail_log
        purchase.mail_log.update!(status: "sent", sent_at: Time.current)
        puts "[kafka] purchase_id=#{purchase.id} のメールログを送信済みに更新しました"
      else
        puts "[kafka] purchase_id=#{payload['purchase_id']} が見つからないためスキップしました"
      end
    rescue StandardError => e
      Rails.logger.error("[kafka consumer] #{e.class}: #{e.message}")
    end
  end
end
