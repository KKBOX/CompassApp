module Lemonade::SassExtensions::Functions::Lemonade

  def sprite_image(file, add_x = nil, add_y = nil, margin_top_or_both = nil, margin_bottom = nil)
    assert_type file, :String
    unless (file.to_s =~ %r(^"(.+/)?(.+?)/(.+?)\.(png|gif|jpg)"$)) == 0
      raise Sass::SyntaxError, 'Please provide a file in a folder: e.g. sprites/button.png'
    end
    dir, name, filename = $1, $2, $3
    filestr = file.to_s.gsub('"', '')

    $lemonade_sprites ||= {}
    sprite = $lemonade_sprites["#{ dir }/#{ name }"] ||= {
        :height => 0,
        :width => 0,
        :images => [],
        :margin_bottom => 0
      }

    if image = sprite[:images].detect{ |image| image[:file] == filestr }
      y = image[:y]
    else
      height = image_height(file).value
      width = image_width(file).value
      margin_top = calculate_margin_top(sprite, margin_top_or_both, margin_bottom)
      x = (add_x and add_x.numerator_units == %w(%)) ? add_x.value / 100 : 0
      y = sprite[:height] + margin_top
      sprite[:height] += height + margin_top
      sprite[:width] = width if width > sprite[:width]
      sprite[:images] << { :file => filestr, :height => height, :width => width, :x => x, :y => y }
    end
    
    position = background_position(0, y, add_x, add_y)
    output_file = image_url(Sass::Script::String.new("#{ dir }#{ name }.png"))
    Sass::Script::String.new("#{ output_file }#{ position }")
  end
  alias_method :sprite_img, :sprite_image
  
private

  def background_position(x, y, add_x, add_y)
    y = -y
    x = add_x ? add_x.to_s : 0
    y += add_y.value if add_y
    unless (add_x.nil? or add_x.value == 0) and y == 0
      " #{ x } #{ y }#{ 'px' unless y == 0 }"
    end
  end
  
  def calculate_margin_top(sprite, margin_top_or_both, margin_bottom)
    margin_top_or_both = margin_top_or_both ? margin_top_or_both.value : 0
    margin_top = (sprite[:margin_bottom] ||= 0) > margin_top_or_both ? sprite[:margin_bottom] : margin_top_or_both
    sprite[:margin_bottom] = margin_bottom ? margin_bottom.value : margin_top_or_both
    margin_top
  end

end
