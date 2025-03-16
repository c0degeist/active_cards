# TODO: Das muss alles auf "Topic" umgebaut werden.
class Test
  class Factory

    def build_test(deck)
      Test.new(deck: deck)
    end

    def build_all_pending_tests
      pending_tests = []

      Topic.find_each do |topic|
        pending_tests << build_pending_test(topic)
      end

      pending_tests
    end

    def build_pending_test(topic)
      Test::PendingTest.new(topic)
    end

  end
end
