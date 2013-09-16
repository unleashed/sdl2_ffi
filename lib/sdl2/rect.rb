require 'sdl2'

# Because SDL_rect.h defines the point struct too, include it here
require 'sdl2/point'

module SDL2

  class Rect < FFI::Struct
    layout :x, :int, :y, :int, :w, :int, :h, :int

    def empty
      return ((!self.null?) || (self[:w] <= 0) || (self[:h] <= 0))
    end

    alias_method :empty?, :empty

    def equals(other)    
      return false if other.nil?
      return false unless other.kind_of? Rect
      
      if self.null? or other.null? # Either null?
        return (self.null? and other.null?) # Equal if both are null!      
      else
        members.each do |field| # Compare our fields.
          return false unless self[field] == other[field]
        end
      end
      return true # if we made it this far
    end

  end

  api :SDL_HasIntersection, [Rect.by_ref, Rect.by_ref], :bool
  api :SDL_IntersectRect, [Rect.by_ref, Rect.by_ref, Rect.by_ref], :bool
  api :SDL_UnionRect, [Rect.by_ref, Rect.by_ref, Rect.by_ref], :void
  api :SDL_EnclosePoints, [Point.by_ref, :count, Rect.by_ref, Rect.by_ref], :bool
  api :SDL_IntersectRectAndLine, [Rect.by_ref, :int, :int, :int, :int], :bool

end