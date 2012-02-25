require 'test_helper'

class ContextsTest < Test::Unit::TestCase
  it "allows tests outside of any context" do
    assert true
  end

  it_eventually "allows tests to be skipped outside of any context" do
    raise "This exception should never be thrown."
  end

  it "names tests correctly" do
    assert_equal "test some name", Nutrasuite::Context.build_test_name("some name")
  end

  a "Context" do
    setup do
      @a = 5
    end

    it "runs setups before tests" do
      assert_equal @a, 5
    end

    it_eventually "passes its name onto its tests" do
      # TODO: figure out how to test this
    end

    that "has a nested Context" do
      setup do
        @b = 10
      end

      it "runs both setups" do
        assert_equal @a, 5
        assert_equal @b, 10
      end
    end

    that "has a nested Context with multiple setups" do
      setup do
        @b = 6
      end

      setup do
        @c = 7
        @b = @b + 1
      end

      it "runs all setups in order" do
        assert_equal @b, 7
        assert_equal @b, @c
      end
    end
  end

  the "'the' context" do
    it "works" do
      assert true
    end
  end

  the "'and' context" do
    it "works" do
      assert true
    end
  end

  the "'an' context" do
    it "works" do
      assert true
    end
  end

  the "'that' context" do
    it "works" do
      assert true
    end
  end
end
