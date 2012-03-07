require 'test_helper'

# ActiveSupport does funny stuff with its test cases, so we have to be
# especially sure that nutrasuite plays nicely with it (and vice versa).
class ActivesupportTest < ActiveSupport::TestCase
  
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
    before do
      @a = 5
    end

    it "runs befores before tests" do
      assert_equal @a, 5
    end

    it_eventually "passes its name onto its test" do
      # TODO: figure out how to test this
    end

    it "doesn't run befores from nested contexts" do
      assert_equal nil, @b
    end

    that "has a nested Context" do
      before do
        @b = 10
      end

      it "runs both befores" do
        assert_equal @a, 5
        assert_equal @b, 10
      end
    end

    that "has a nested Context with multiple befores" do
      before do
        @b = 6
      end

      before do
        @c = 7
        @b = @b + 1
      end

      it "runs all befores in order" do
        assert_equal @b, 7
        assert_equal @b, @c
      end
    end
  end

  a "Second context" do
    before do
      @b = true
    end

    it "isn't affected by befores from other contexts" do
      assert_equal true, @b
      assert @a.nil?
    end
  end

  the "'the' context" do
    it "works" do
      assert true
    end
  end

  an "'an' context" do
    it "works" do
      assert true
    end
  end

  and_also "the 'and_also' context" do
    it "works" do
      assert true
    end
  end

  a "'a' context" do
    it "works" do
      assert true
    end
  end

  that "'that' context" do
    it "works" do
      assert true
    end
  end
end

