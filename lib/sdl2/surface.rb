require 'sdl2'
require 'sdl2/rwops'
require 'sdl2/pixels'
require 'sdl2/rect'
#require 'sdl2/pixel_format'

module SDL2
  typedef :uint32, :surface_flags
  class Surface < FFI::Struct
    layout :flags, :surface_flags,
      :format, PixelFormat.by_ref,
      :w, :int,
      :h, :int,
      :pixels, :pointer,
      :userdata, :pointer,
      :locked, :int,
      :lock_data, :pointer,
      :clip_rect, Rect,
      :map, :pointer,
      :refcount, :int      
      
    def self.release(pointer)
      SDL2.free_surface(pointer)
    end
      
    # Surface Flags, Used internally but maybe useful
    SWSURFACE = 0
    PREALLOC  = 0x00000001
    RLEACCEL  = 0x00000002
    DONTFREE  = 0x00000004
    
    # Macro, redefined here for use.
    def mustlock?
      self[:flags] & RLEACCEL != 0
    end
  
  end
  
  callback :blit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
  
  
  api :SDL_CreateRGBSurface, [:surface_flags, :int, :int, :int, :uint32, :uint32, :uint32, :uint32], Surface.auto_ptr
  api :SDL_FreeSurface, [Surface.by_ref], :void
  api :SDL_SetSurfacePalette, [Surface.by_ref, Palette.by_ref], :int
  api :SDL_LockSurface, [Surface.by_ref], :int
  api :SDL_UnlockSurface, [Surface.by_ref], :void
  api :SDL_LoadBMP_RW, [RWops.by_ref, :int], Surface.auto_ptr
  # Redefine SDL_LoadBMP macro:
  def self.load_bmp(file)
    SDL2.load_bmp_rw(RWops.from_file(file, 'rb'), 1)
  end
  api :SDL_SaveBMP_RW, [Surface.by_ref, RWops.by_ref, :int], :int
  
  def self.save_bmp(file)
    SDL2.save_bmp_rw(RWops.from_file(file, 'wb'), 1)
  end
  
  api :SDL_SetSurfaceRLE, [Surface.by_ref, :int], :int
  api :SDL_SetColorKey, [Surface.by_ref, :int, :uint32], :int
  api :SDL_GetColorKey, [Surface.by_ref, UInt32Struct.by_ref], :int
  api :SDL_SetSurfaceColorMod, [Surface.by_ref, :uint8, :uint8, :uint8], :int
  api :SDL_GetSurfaceColorMod, [Surface.by_ref, UInt8Struct.by_ref,UInt8Struct.by_ref,UInt8Struct.by_ref], :int
  api :SDL_SetSurfaceAlphaMod, [Surface.by_ref, :uint8], :int
  api :SDL_GetSurfaceAlphaMod, [Surface.by_ref,UInt8Struct.by_ref], :int
  api :SDL_SetSurfaceBlendMode, [Surface.by_ref, :blend_mode], :int
  api :SDL_GetSurfaceBlendMode, [Surface.by_ref, BlendModeStruct.by_ref], :int
  api :SDL_SetClipRect, [Surface.by_ref, Rect.by_ref], :int
  api :SDL_GetClipRect, [Surface.by_ref, Rect.by_ref], :int
  api :SDL_ConvertSurface, [Surface.by_ref, PixelFormat.by_ref, :surface_flags], Surface.auto_ptr
  api :SDL_ConvertSurfaceFormat, [Surface.by_ref, :pixel_format, :surface_flags], Surface.auto_ptr
  api :SDL_ConvertPixels, [:int, :int, :pixel_format, :pointer, :int, :pixel_format, :pointer, :int], :int
  api :SDL_FillRect, [Surface.by_ref, Rect.by_ref, :uint32], :int
  api :SDL_FillRects, [Surface.by_ref, Rect.by_ref, :count, :uint32], :int
  api :SDL_UpperBlit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
  #alias_method :blit_surface, :upper_blit # TODO: Review if this is what line 447 means.
  #alias_class_method :blit_surface, :upper_blit
  api :SDL_LowerBlit, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
  api :SDL_SoftStretch, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
  api :SDL_UpperBlitScaled, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
  alias_method :blit_scaled, :upper_blit_scaled
  api :SDL_LowerBlitScaled, [Surface.by_ref, Rect.by_ref, Surface.by_ref, Rect.by_ref], :int
    
end