# frozen_string_literal: true

module RuboCop
  module Cop
    module Style
      # This cop checks for uses of class variables. Offenses
      # are signaled only on assignment to class variables to
      # reduce the number of offenses that would be reported.
      #
      # You have to be careful when setting a value for a class
      # variable; if a class has been inherited, changing the
      # value of a class variable also affects the inheriting
      # classes. This means that it's almost always better to
      # use a class instance variable instead.
      #
      # @example
      #   # bad
      #   class A
      #     def self.test(value)
      #       @value = value
      #     end
      #   end
      #
      #   class A
      #     def self.test(name, value)
      #       instance_variable_set("@#{name}", value)
      #     end
      #   end
      #
      #   class A; end
      #   A.instance_variable_set(:@test, 10)
      #
      #   TODO: find all the cases where it's possible to set an instance variable
      #   inside a class method
      #
      #   # good
      #   TODO: figure out what would be good in this case
      #
      class ClassVars < Base
        MSG = 'Replace class var %<class_var>s with a class instance var.'
        RESTRICT_ON_SEND = %i[class_variable_set].freeze

        def on_cvasgn(node)
          add_offense(node.loc.name, message: format(MSG, class_var: node.children.first))
        end

        def on_send(node)
          add_offense(
            node.first_argument, message: format(MSG, class_var: node.first_argument.source)
          )
        end
      end
    end
  end
end
