ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Minitest 6 で Minitest::Mock（Object#stub）が削除されたための簡易代替。
    # OpensearchClient/EventPublisher など、外部サービスに実際に接続するクラスメソッドを
    # テスト中だけ差し替えたい場合に使う（ブロックを抜けたら必ず元のメソッドに戻す）。
    def stub_singleton_method(object, method_name, implementation)
      original = object.method(method_name)
      object.define_singleton_method(method_name, &implementation)
      yield
    ensure
      object.define_singleton_method(method_name, original)
    end
  end
end
