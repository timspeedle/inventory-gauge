data:extend({
  {
    type = "custom-input",
    name = "toggle-inventory-gauge",
    key_sequence = "CONTROL + I",
    consuming = "none"
  }
})

-- Segmented inventory bar styles (colored rectangles).
-- Using button_style for simple colored blocks (no interaction wired).
-- If these cause unwanted borders, we can switch to frame_style variants.
local styles = data.raw["gui-style"].default

-- Read color settings
local occupied = settings.startup["inventory-gauge-occupied"].value
local partial = settings.startup["inventory-gauge-partial"].value
local reserved = settings.startup["inventory-gauge-reserved"].value
local free = settings.startup["inventory-gauge-free"].value
local text = settings.startup["inventory-gauge-text"].value

-- Full stack segment
styles.inv_bar_segment_full = {
  type = "empty_widget_style",
  padding = 0,
  graphical_set = {
    base = {
      filename = "__core__/graphics/white-square.png",
      size = 1,
      tint = {r=occupied.r, g=occupied.g, b=occupied.b, a=occupied.a},
      scale = 16
    },
  }
}

-- Partially filled stack segment
styles.inv_bar_segment_partial = {
  type = "empty_widget_style",
  padding = 0,
  graphical_set = {
    base = {
      filename = "__core__/graphics/white-square.png",
      size = 1,
      tint = {r=partial.r, g=partial.g, b=partial.b, a=partial.a},
      scale = 16
    },
  }
}

styles.inv_bar_segment_reserved = {
  type = "empty_widget_style",
  padding = 0,
  graphical_set = {
    base = {
      filename = "__core__/graphics/white-square.png",
      size = 1,
      tint = {r=reserved.r, g=reserved.g, b=reserved.b, a=reserved.a},
      scale = 16
    },
  }
}

styles.inv_bar_segment_free = {
  type = "empty_widget_style",
  padding = 0,
  graphical_set = {
    base = {
      filename = "__core__/graphics/white-square.png",
      size = 1,
      tint = {r=free.r, g=free.g, b=free.b, a=free.a},
      scale = 16
    },
  }
}

styles.inv_bar_text = {
  type = "label_style",
  font = "default-bold",
  font_color = {r=text.r, g=text.g, b=text.b, a=text.a},
  hovered_font_color = {r=text.r, g=text.g, b=text.b, a=text.a},
  clicked_font_color = {r=text.r, g=text.g, b=text.b, a=text.a},
  disabled_font_color = {r=text.r, g=text.g, b=text.b, a=text.a}
}

