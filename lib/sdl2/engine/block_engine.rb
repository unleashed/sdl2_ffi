require 'sdl2/engine'

module SDL2

  class Engine

    class BlockEngine < Engine

      def initialize(opts={})
        super(opts)
        painter = opts[:painter]
      end

      attr_accessor :painter

      def paint_to(surface)
        unless painter.nil?
          return painter.call(surface)
        else
          return super(surface)
        end
      end
    end

  end

end