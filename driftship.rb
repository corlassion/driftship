require 'gosu'

class GameWindow < Gosu::Window
  def initialize(width=800, height=600, fullscreen=false)
    super
    self.caption = 'Driftship'
    @player = Player.new
    @player.warp(320, 240)
    $width = 800
    $height = 600
  end

  def update
    if Gosu.button_down? Gosu::KB_A
          @player.turn_left
        end
        if Gosu.button_down? Gosu::KB_D
          @player.turn_right
        end
        if Gosu.button_down? Gosu::KB_W
          @player.accelerate
        end
        @player.move
  end

  def button_down id
    if id == Gosu::KbEscape
      close
    else
      super
    end
  end

  def draw
    @player.draw
  end
end

class Player
  def initialize
    @image = Gosu::Image.new("media/starfighter.bmp")
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @friction = 0.98
    @maxSpeed = 0.45
    @turnSpeed = 6.0

  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @angle -= @turnSpeed
  end

  def turn_right
    @angle += @turnSpeed
  end

  def accelerate
    @vel_x += Gosu.offset_x(@angle, @maxSpeed)
    @vel_y += Gosu.offset_y(@angle, @maxSpeed)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= $width
    @y %= $height

    @vel_x *= @friction
    @vel_y *= @friction
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end

window = GameWindow.new
window.show
