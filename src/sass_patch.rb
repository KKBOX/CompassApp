module Sass
  module Tree
    # A dynamic node representing a mixin definition.
    #   
    # @see Sass::Tree
    class MixinDefNode < Node
      class << self
          attr_accessor :mixins
      end 

      # The mixin name.
      # @return [String]
      attr_reader :name

      # The arguments for the mixin.
      # Each element is a tuple containing the variable for argument
      # and the parse tree for the default value of the argument.
      #   
      # @return [Array<(Script::Node, Script::Node)>]
      attr_accessor :args

      # @param name [String] The mixin name
      # @param args [Array<(Script::Node, Script::Node)>] See \{#args}
      def initialize(name, args)
        self.class.mixins ||= []  
        self.class.mixins << name

        @name = name
        @args = args
        super()
      end 
    end 
  end 
end

module Sass
  module Tree
    # A dynamic node representing a variable definition.
    #   
    # @see Sass::Tree
    class VariableNode < Node
      class << self
          attr_accessor :variables
      end 
      
      # The name of the variable.
      # @return [String]
      attr_reader :name

      # The parse tree for the variable value.
      # @return [Script::Node]
      attr_accessor :expr

      # Whether this is a guarded variable assignment (`!default`).
      # @return [Boolean]
      attr_reader :guarded

      # @param name [String] The name of the variable
      # @param expr [Script::Node] See \{#expr}
      # @param guarded [Boolean] See \{#guarded}
      def initialize(name, expr, guarded)
        self.class.variables ||= []  
        self.class.variables << name

        @name = name
        @expr = expr
        @guarded = guarded
        super()
      end 
    end 
  end 
end

