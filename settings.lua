data:extend({
  -- Full slots color
  {
    type = "color-setting",
    name = "inventory-gauge-occupied",
    setting_type = "startup",
    default_value = {r=1, g=0.18, b=0.05, a=0.88},
    order = "color-a"
  },
  
  -- Partially filled slots color
  {
    type = "color-setting",
    name = "inventory-gauge-partial",
    setting_type = "startup",
    default_value = {r=1, g=1, b=0.05, a=0.69},
    order = "color-b"
  },
  
  -- Reserved (filtered but empty) slots color
  {
    type = "color-setting",
    name = "inventory-gauge-reserved",
    setting_type = "startup",
    default_value = {r=0.05, g=0.65, b=1, a=0.71},
    order = "color-c"
  },
  
  -- Free slots color
  {
    type = "color-setting",
    name = "inventory-gauge-free",
    setting_type = "startup",
    default_value = {r=0.05, g=0.95, b=0.35, a=0.73},
    order = "color-d"
  },
  
  -- Text color (default: black)
  {
    type = "color-setting",
    name = "inventory-gauge-text",
    setting_type = "startup",
    default_value = {r=0.0, g=0.0, b=0.0},
    order = "color-z"
  },

  -- Whether the inventory dialog should always open centered.
  -- When OFF, the dialog reopens where the player last closed it.
  {
    type = "bool-setting",
    name = "inventory-gauge-center-on-open",
    setting_type = "runtime-per-user",
    default_value = false,
    order = "z-a"
  }
  ,
  -- Per-player overlay text format. Supports tokens:
  -- %F full stacks, %P partial stacks, %R reserved (filtered) slots,
  -- %E empty free slots, %C total slots, %I percent filled (items), %% literal %.
  {
    type = "string-setting",
    name = "inventory-gauge-overlay-format",
    setting_type = "runtime-per-user",
    default_value = "%I%% full (%E empty)",
    allow_blank = false,
    order = "z-b"
  }
  ,
  -- Per-player log level: None or Debug
  {
    type = "string-setting",
    name = "inventory-gauge-log-level",
    setting_type = "runtime-per-user",
    default_value = "None",
    allowed_values = {"None", "Debug"},
    order = "z-c"
  }
})
