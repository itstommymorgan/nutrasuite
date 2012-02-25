module Nutrasuite
  module ContextHelpers
    ["a", "an", "and", "that", "the"].each do |article|
      eval <<-HERE
        def #{article}(name, &block)
          name = "#{article} " << name
          Context.push(name, &block)
        end
      HERE
    end

    # Code to be run before the context
    def setup(&block)
      if Context.current_context?
        Context.current_context.setups << block
      else
        warn "Not in a context"
      end
    end

    # Code to be run when the context is finished
    def teardown(&block)
      if Context.current_context?
        Context.current_context.teardowns << block
      else
        warn "Not in a context"
      end
    end

    # Defines an actual test based on the given context
    def it(name, &block)
      build_test(name, &block)
    end

    # Defines a test based on the given context that will be skipped for now
    def it_eventually(name, &block)
      build_test("eventually #{name}", :skip => true, &block)
    end

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
          setups.each { |setup| setup.call }
          block.call
          teardowns.each { |teardown| teardown.call }
        end
      end
    end

    def warn(message)
      puts " * Warning: #{message}"
    end

    # ugly, but we need to make sure that all assertions work as intended
    def method_missing(name, *args, &block)
      unless MiniTest::Unit::TestCase.current.nil?
        MiniTest::Unit::TestCase.current.send(name, *args, &block)
      else
        super(name, *args, &block)
      end
    end
  end

  class Context

    attr_reader :name, :setups, :teardowns

    def initialize(name, &block)
      @name = name
      @block = block

      @setups = []
      @teardowns = []
    end

    def build
      @block.call
    end

    def self.build_test_name(name="")
      full_name = "test "
      context_stack.each do |context|
        full_name << context.name << " "
      end
      full_name << name
    end

    def self.push(name, &block)
      context = Context.new(name, &block)
      context_stack.push(context)

      context.build

      context_stack.pop
    end

    def self.context_stack
      @context_stack ||= []
    end

    def self.current_context
      context_stack.last
    end

    def self.current_context?
      !context_stack.empty?
    end
  end
end

# backwards compatibility with some slightly older versions of minitest
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
