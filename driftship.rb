require 'gosu'
#big size
#$width = 1280
#$height = 720
#standard size
$width = 640
$height = 480

$wrap = false

class GameWindow < Gosu::Window
  def initialize(width=$width, height=$height, fullscreen=false)
    super
    self.caption = 'Driftship'
    @player = Player.new
    @player.warp($width/2, $height/2)

    @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
    @stars = Array.new
    @font = Gosu::Font.new(20)
  end

  def update
    if Gosu.button_down? Gosu::KB_A or Gosu::button_down? Gosu::GP_LEFT
          @player.turn_left
        end
        if Gosu.button_down? Gosu::KB_D or Gosu::button_down? Gosu::GP_RIGHT
          @player.turn_right
        end
        if Gosu.button_down? Gosu::KB_W or Gosu::button_down? Gosu::GP_UP
          @player.accelerate
        end
        @player.move
        @player.collect_stars(@stars)

        #if rand(100) < 4 and @stars.size < 25
        if @stars.size < 1
          @stars.push(Star.new(@star_anim))
        end
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
    @stars.each { |star| star.draw }
    @font.draw_text("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
  end
end

class Player
  def initialize
    @image = Gosu::Image.new("media/starfighter.bmp")
    @score = 0
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @friction = 0.98
    @maxSpeed = 0.45
    @turnSpeed = 6.0

  end

  def score
    @score
  end

  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu.distance(@x, @y, star.x, star.y) < 35
        @score += 10
        true
      else
        false
      end
    end
  end

  def warp(x, y)
    @x, @y = x, y
    @vel_x = @vel_y = 0.0
    @score = 0
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

    @vel_x *= @friction
    @vel_y *= @friction

    if $wrap
      @x %= $width
      @y %= $height
    else
      warp($width/2, $height/2) if @x > $width or @x < 0.0 or @y > $height or @y < 0.0
    end

  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end

module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end

class Star
  attr_reader :x, :y

  def initialize(animation)
    @animation = animation
    @color = Gosu::Color::WHITE.dup
    #@color = Gosu::Color::BLACK.dup
    #@color.red = rand(256 - 40) + 40
    #@color.green = rand(256 - 40) + 40
    #@color.blue = rand(256 - 40) + 40
    @x = (0.9 * rand + 0.05) * $width
    @y = (0.9 * rand + 0.05) * $height
  end

  def draw
    img = @animation[Gosu.milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::STARS, 1, 1, @color, :add)
  end
end

window = GameWindow.new
window.show
