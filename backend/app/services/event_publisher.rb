# Kafkaへイベントをpublishするための薄いラッパー。
#
# 購入処理などの「本業のトランザクション」がKafkaの疎通状況に左右されると困るため、
# publish自体の失敗（Kafkaが未起動・ネットワーク不通など）はここで握りつぶし、
# ログにだけ残す。イベント配信はあくまで付随的な処理として扱う。
class EventPublisher
  class << self
    def publish(topic, payload)
      # rdkafkaのproduceは非同期（内部スレッドが実際の送信を担当）なので、
      # ここでリクエストの応答が数百ms〜数秒ブロックされることはない。
      producer.produce(topic: topic, payload: payload.to_json, key: payload[:key].to_s)
      nil
    rescue StandardError => e
      Rails.logger.warn("[Kafka] publish failed (topic=#{topic}): #{e.class}: #{e.message}")
      nil
    end

    private

    def producer
      @producer ||= begin
        # rdkafkaのproducerは、配信結果を扱うためのポーリング用バックグラウンドスレッドを
        # 内部で起動する。close を呼ばずにプロセスを終了しようとすると、
        # このスレッドが残り続けて `rails test` や `rails runner` が終了しなくなるため、
        # at_exit で必ずクローズするようにしている。
        producer = Rdkafka::Config.new(
          "bootstrap.servers" => ENV.fetch("KAFKA_BROKERS", "localhost:9092"),
          "client.id" => "virtualec-backend",
          # Kafkaに届かないメッセージをいつまでも内部キューに残さないよう、
          # デフォルト(5分)より大幅に短くしておく。
          # これにより producer.close（プロセス終了時）が長時間ブロックされるのを防ぐ。
          "message.timeout.ms" => 3_000
        ).producer
        at_exit { producer.close }
        producer
      end
    end
  end
end
