data:extend({
  {
    type = "custom-input",
    name = "toggle-inventory-gauge",
    key_sequence = "CONTROL + I",
    consuming = "none"
  }
})

-- Segmented inventory bar styles.
-- Colors are now applied dynamically in control.lua based on per-player settings.
local styles = data.raw["gui-style"].default

-- Base progressbar style (colors set at runtime)
styles.inv_bar_segment = {
  type = "progressbar_style",
  padding = 0,
  bar_width = 20
}

styles.inv_bar_text = {
  type = "label_style",
  font = "default-bold"
}

