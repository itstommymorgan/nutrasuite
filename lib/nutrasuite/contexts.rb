# Public: Namespace module for all Nutrasuite functionality.
module Nutrasuite
  # Public: ContextHelpers contains all of the Nutrasuite Context methods. This
  # will be included in Test::Unit::TestCase by default.
  module ContextHelpers

    # Public: These methods will each define a context and push it onto the
    # context stack for the duration of the passed in block.
    #
    # Signature
    #   <article> "name of the context"
    #
    # Examples
    #
    #   a "User with a bad hair day" do
    #     ...tests...
    #   end
    #
    #   the "SingletonObject" do
    #     ...tests...
    #   end
    #
    ["a", "an", "and_also", "that", "the"].each do |article|
      eval <<-HERE
        def #{article}(name, &block)
          name = "#{article.gsub("_"," ")} " << name
          Context.push(name, &block)
        end
      HERE
    end

    # Public: use before to declare steps that need to be run before every test
    # in a context.
    def before(&block)
      Context.current_context.setups << block
    end

    # Public: use after to declare steps that need to be run after every test in
    # a context.
    def after(&block)
      Context.current_context.teardowns << block
    end

    # Public: defines a test to be executed. Will run any setup blocks on the
    # context stack before execution, then execute the specified test, then will
    # run any teardown blocks on the context stack after the test has executed.
    #
    # name - The name of the test, used for human-readable test identification.
    # &block - the body of the test, can use any and all assertions that would
    #          otherwise be available to a MiniTest test.
    #
    # Examples
    #
    #   it "tests that true is truthy" do
    #     assert true
    #   end
    #
    def it(name, &block)
      build_test(name, &block)
    end

    # Public: defines a test method that should be skipped. Context
    # setup/teardown will still be executed, but the actual test method will
    # show up as a MiniTest skip with a description of "not yet implemented."
    #
    # This method exists to make it easy to switch a test between a pending and
    # an active state: just switch the method name from "it" to "it eventually."
    #
    # name - The name of the test, used for human-readable test identification.
    # &block - the body of the test. Doesn't have to be functional ruby as the
    #          block will be skipped in this method.
    #
    # Examples
    #
    #   it_eventually "has some really smart logic" do
    #     assert self.has_smart_logic?
    #   end
    #
    def it_eventually(name, &block)
      build_test("eventually #{name}", :skip => true, &block)
    end

    # Internal: This method actually builds out the test method that MiniTest
    # knows how to execute. It's responsible for running the current list of
    # setups and teardowns and relies on 'define_method' to set up a test method
    # that MiniTest can parse and execute.
    #
    def build_test(name, options = {}, &block)
      test_name = Context.build_test_name(name)

      setups = []
      teardowns = []
      Context.context_stack.each do |context|
        setups.concat(context.setups)
        teardowns.concat(context.teardowns)
      end

      if options[:skip]
        define_method test_name do
          skip "not yet implemented"
        end
      else
        define_method test_name do
          test = MiniTest::Unit::TestCase.current
          setups.each { |setup| test.instance_eval &setup }
          test.instance_eval &block
          teardowns.each { |teardown| test.instance_eval &teardown }
        end
      end
    end
  end

  # Internal: The Context class represents each context that can go on the
  # context stack. Each context is responsible for tracking its specific
  # information (mostly its name and its setup and teardown methods). Contexts
  # should only be created using one of the article methods in ContextHelpers.
  class Context

    # Internal: Get the name, setup methods, and teardown methods for this
    # Context.
    attr_reader :name, :setups, :teardowns

    # Internal: Create a new Context object.
    #
    # name   - The name of the context, which will be prepended to any nested
    #          contexts/tests in the final test name
    # &block - The block that defines the contents of the context; should
    #          consist of:
    #          - test definitions
    #          - sub-context definitions
    #          - setup and teardown declarations
    #
    def initialize(name, &block)
      @name = name
      @block = block

      @setups = []
      @teardowns = []
    end

    # Internal: build runs the block that defines the context's contents, thus
    # setting up any nested contexts and tests.
    #
    def build
      @block.call
    end

    # Internal: builds a test name based on the current state of the context
    # stack.
    #
    # Examples
    #
    #   # Assuming the context stack looks like "a user","that is an admin":
    #   Context.build_test_name("has admin privileges") 
    #   #=> "test a user that is an admin has admin privileges"
    #
    # Returns a string name for a method that will automatically be executed by
    # MiniTest.
    #
    def self.build_test_name(name="")
      full_name = "test "
      context_stack.each do |context|
        unless context.name.nil?
          full_name << context.name << " "
        end
      end
      full_name << name
    end

    # Internal: pushes a new context onto the stack, builds that context out,
    # and then removes it from the stack.
    #
    # This method should be the only means by which contexts get built, as it
    # ensures that the context is removed from the context stack when it's done
    # building itself.
    #
    def self.push(name, &block)
      context = Context.new(name, &block)
      context_stack.push(context)

      context.build

      context_stack.pop
    end

    # Internal: get the context stack, or initialize it to an empty list if
    # necessary.
    #
    # Returns: an Array representing the context stack.
    def self.context_stack
      @context_stack ||= [Context.new(nil)]
    end

    # Internal: get the current context.
    #
    # Returns: the context currently at the top of the stack, or nil if there
    # are no contexts in the stack at the moment.
    def self.current_context
      context_stack.last
    end
  end
end

# In slightly older versions of MiniTest the TestCase#current method is not
# defined, but Nutrasuite definitely needs it in order to be useful. This bit of
# monkey-patching hackery ensures that this method is present even if you're
# using an older version of the library.
unless defined? MiniTest::Unit::TestCase.current
  class MiniTest::Unit::TestCase
    def initialize name
      @__name__ = name
      @__io__ = nil
      @passed = nil
      @@current = self
    end

    def self.current
      @@current ||= nil
    end
  end
end


class MiniTest::Unit::TestCase
  extend Nutrasuite::ContextHelpers
end
