-- Handle player initialization
script.on_event(defines.events.on_player_created, function(event)
  local player = game.get_player(event.player_index)
  if player then
    storage.dialog_visible = storage.dialog_visible or {}
    storage.dialog_visible[event.player_index] = false
  end
end)

-- Function to calculate inventory fullness
local function get_inventory_fullness(player)
  -- Check if player is in a vehicle and use vehicle inventory if so
  local inventory
  if player.vehicle then
    inventory = player.vehicle.get_inventory(defines.inventory.car_trunk)
    if not inventory then
      -- Try spider vehicle inventory
      inventory = player.vehicle.get_inventory(defines.inventory.spider_trunk)
    end
  end
  
  -- Fall back to player's main inventory if no vehicle or vehicle has no inventory
  if not inventory then
    inventory = player.get_main_inventory()
  end
  
  if not inventory then
    return 0, 0, 0, 0
  end
  
  local total_slots = #inventory
  local full_slots = 0
  local partial_slots = 0
  local reserved_empty_slots = 0
  for i = 1, total_slots do
    local stack = inventory[i]
    if stack.valid_for_read then
      local prototype = stack.prototype
      local max = prototype and prototype.stack_size or stack.count -- fallback
      if stack.count >= max then
        full_slots = full_slots + 1
      else
        partial_slots = partial_slots + 1
      end
    else
      if inventory.get_filter(i) ~= nil then
        reserved_empty_slots = reserved_empty_slots + 1
      end
    end
  end
  return full_slots, partial_slots, total_slots, reserved_empty_slots
end

-- Function to update the progress bar
local function any_player_debug_enabled()
  for _, p in pairs(game.players) do
    local setting = p.mod_settings["inventory-gauge-log-level"]
    if setting and setting.value == "Debug" then
      return true
    end
  end
  return false
end

local function debug_log(message)
  if any_player_debug_enabled() then
    log("[InventoryUI] " .. message)
  end
end

-- Overlay formatting moved earlier for availability in update_progress_bar
local function format_overlay(player, full, partial, reserved, total)
  local setting = player.mod_settings["inventory-gauge-overlay-format"]
  local template = setting and setting.value or "%I%% full (%E free)"
  local free = math.max(total - full - partial - reserved, 0)
  local used = full + partial -- non-empty slots (contains items)
  local percent_items = total > 0 and math.floor(((full + partial) / total) * 100 + 0.5) or 0
  local map = {
    F = full,
    P = partial,
    R = reserved,
    E = free,
    T = total,
    I = percent_items,
    U = used,
    ['%'] = '%'
  }
  local result = template:gsub("%%(.)", function(c)
    if map[c] ~= nil then return tostring(map[c]) end
    return '%' .. c
  end)
  return result
end

-- Function to destroy the dialog
local function destroy_dialog(player)
  storage.dialog_auto_hide = storage.dialog_auto_hide or {}
  if player.gui.screen.inventory_dialog then
    player.gui.screen.inventory_dialog.destroy()
  end
  storage.dialog_visible[player.index] = false
end

local function update_progress_bar(player)
    local dialog = player.gui.screen.inventory_dialog
    if not dialog then
      debug_log("ERROR: Dialog not found for player " .. player.name)
      return
    end
    -- Store the current position before updating, so it can be restored on next open if needed
    if dialog and dialog.valid and dialog.location then
      storage.window_positions = storage.window_positions or {}
      storage.window_positions[player.index] = {x = dialog.location.x, y = dialog.location.y}
    end
    local flow = nil
    for _, child in pairs(dialog.children) do
      if child.type == "flow" then
        flow = child
        break
      end
    end
    if not flow then
      debug_log("ERROR: Flow for segmented bar not found")
      return
    end
    local full, partial, total, reserved = get_inventory_fullness(player)
    if total == 0 then
      debug_log("No inventory found for player " .. player.name .. ", hiding dialog")
      destroy_dialog(player)
      storage.dialog_auto_hide[player.index] = true
      return
    end
    local overlay_caption = format_overlay(player, full, partial, reserved, total)
    local seg_container = flow.inventory_segments
    if seg_container then
      seg_container.destroy()
    end
    create_segmented_inventory_bar(flow, full, partial, reserved, total, player)
    debug_log("Segmented bar updated for player " .. player.name .. ": " .. overlay_caption)
  end

-- Function to create the dialog GUI
local function create_dialog(player)
  -- Create the main frame
  local frame = player.gui.screen.add{
    type = "frame",
    name = "inventory_dialog",
    direction = "vertical",
    caption = "Inventory"
  }
  
  -- Determine centering behavior from per-user setting
  local center_setting = player.mod_settings["inventory-gauge-center-on-open"] and player.mod_settings["inventory-gauge-center-on-open"].value
  local remembered = storage.window_positions and storage.window_positions[player.index]
  if center_setting then
    frame.auto_center = true
  else
    frame.auto_center = false
    if remembered and remembered.x and remembered.y then
      frame.location = {x = remembered.x, y = remembered.y}
    else
      -- First open without remembered position: fall back to centered once
      frame.auto_center = true
    end
  end
  
  -- Add a flow for the progress bar and label
  local flow = frame.add{
    type = "flow",
    direction = "horizontal"
  }
  flow.style.vertical_align = "center"
  flow.style.horizontal_spacing = 8
  
  -- Calculate initial inventory fullness
  local full, partial, total, reserved = get_inventory_fullness(player)
  local progress_value = total > 0 and ((full + partial) / total) or 0
  
  -- Add segmented bar (full / partial / reserved / free)
  create_segmented_inventory_bar(flow, full, partial, reserved, total, player)

  storage.dialog_visible[player.index] = true
  
  return frame
end

-- Function to toggle the dialog
local function toggle_dialog(player)
  local player_index = player.index
  storage.dialog_visible = storage.dialog_visible or {}
  
  if storage.dialog_visible[player_index] then
    -- Dialog is visible, hide it
    local center_setting = player.mod_settings["inventory-gauge-center-on-open"] and player.mod_settings["inventory-gauge-center-on-open"].value
    if not center_setting then
      local frame = player.gui.screen.inventory_dialog
      if frame and frame.valid and frame.location then
        storage.window_positions = storage.window_positions or {}
        storage.window_positions[player_index] = {x = frame.location.x, y = frame.location.y}
      end
    end
    destroy_dialog(player)
  else
    -- Dialog is hidden, show it
    create_dialog(player)
  end
end

-- Handle custom input (keyboard shortcut)
script.on_event("toggle-inventory-gauge", function(event)
  local player = game.get_player(event.player_index)
  if player then
    toggle_dialog(player)
  end
end)

-- Handle shortcut button click
script.on_event(defines.events.on_lua_shortcut, function(event)
  if event.prototype_name == "toggle-inventory-gauge" then
    local player = game.get_player(event.player_index)
    if player then
      toggle_dialog(player)
    end
  end
end)

-- Handle close button click
script.on_event(defines.events.on_gui_click, function(event)
  if event.element.name == "inventory_dialog_close" then
    local player = game.get_player(event.player_index)
    if player then
      destroy_dialog(player)
      storage.dialog_visible[event.player_index] = false
    end
  end
end)

-- Update progress bar when inventory changes
local function on_inventory_changed(event)
  -- Instead of updating immediately (which can read a transient pre-consolidation state),
  -- queue a refresh for next tick so stack merges/collapses have completed.
  storage.pending_refresh = storage.pending_refresh or {}
  storage.pending_refresh[event.player_index] = true
end

script.on_event(defines.events.on_player_main_inventory_changed, on_inventory_changed)
script.on_event(defines.events.on_picked_up_item, on_inventory_changed)
script.on_event(defines.events.on_player_mined_item, on_inventory_changed)
script.on_event(defines.events.on_player_cursor_stack_changed, on_inventory_changed)

-- Handle initialization for existing saves
script.on_init(function()
  storage.dialog_visible = {}
  storage.pending_refresh = {}
  storage.window_positions = storage.window_positions or {}
end)

-- Periodic refresh to catch non-item changes (e.g., slot filter adjustments)
script.on_nth_tick(60, function()
  if not storage.dialog_visible then return end
  for player_index, visible in pairs(storage.dialog_visible) do
    local player = game.get_player(player_index)
    if player then
      if visible then
        update_progress_bar(player)
      else
        debug_log("Player " .. player.name .. " has dialog hidden, checking for auto-show: " .. tostring(storage.dialog_auto_hide and storage.dialog_auto_hide[player_index]))
        if storage.dialog_auto_hide and storage.dialog_auto_hide[player_index] == true then
          local inventory = player.get_main_inventory()
          if inventory then
            create_dialog(player)
            storage.dialog_auto_hide[player_index] = nil
          end
        end
      end
    end
  end
end)

-- Next-tick refresh handler for queued inventory updates to ensure post-consolidation state
script.on_event(defines.events.on_tick, function()
  if not storage.pending_refresh then return end
  for player_index, _ in pairs(storage.pending_refresh) do
    if storage.dialog_visible and storage.dialog_visible[player_index] then
      local player = game.get_player(player_index)
      if player then
        update_progress_bar(player)
      end
    end
    storage.pending_refresh[player_index] = nil
  end
end)

-- Constants and helpers for segmented bar
local BAR_WIDTH = 200

function build_segment(parent, name, width, tooltip, color)
  local seg = parent.add{
    type = "progressbar",
    name = name,
    style = "inv_bar_segment",
    value = 1.0
  }
  seg.style.padding = 0
  seg.style.margin = 0
  seg.style.width = width
  seg.style.height = 20
  seg.style.color = color
  seg.tooltip = tooltip
  return seg
end


function create_segmented_inventory_bar(flow, full, partial, reserved, total, player)
  local container = flow.add{
    type = "flow",
    name = "inventory_segments",
    direction = "horizontal"
  }
  container.style.horizontal_spacing = 0
  container.style.vertically_stretchable = false
  
  -- Get colors from player settings
  local occupied_color = player.mod_settings["inventory-gauge-occupied"].value
  local partial_color = player.mod_settings["inventory-gauge-partial"].value
  local reserved_color = player.mod_settings["inventory-gauge-reserved"].value
  local free_color = player.mod_settings["inventory-gauge-free"].value
  local text_color = player.mod_settings["inventory-gauge-text"].value
  
  local free = math.max(total - full - partial - reserved, 0)
  local full_w = total > 0 and math.floor(BAR_WIDTH * full / total + 0.5) or 0
  local partial_w = total > 0 and math.floor(BAR_WIDTH * partial / total + 0.5) or 0
  local res_w = total > 0 and math.floor(BAR_WIDTH * reserved / total + 0.5) or 0
  local free_w = BAR_WIDTH - full_w - partial_w - res_w
  if full_w > 0 then build_segment(container, "seg_full", full_w, full .. " full stacks", occupied_color) end
  if partial_w > 0 then build_segment(container, "seg_partial", partial_w, partial .. " partial stacks", partial_color) end
  if res_w > 0 then build_segment(container, "seg_reserved", res_w, reserved .. " reserved (filtered)", reserved_color) end
  if free_w > 0 then build_segment(container, "seg_free", free_w, free .. " free", free_color) end
  local overlay_caption = player and format_overlay(player, full, partial, reserved, total) or ("F " .. full .. " P " .. partial .. " / " .. total .. " (R " .. reserved .. ")")
  local overlay = container.add{ type = "label", name = "inventory_segments_label", caption = overlay_caption, style = "inv_bar_text", ignored_by_interaction = true }
  overlay.style.font_color = text_color
  overlay.style.left_margin = -BAR_WIDTH -- pull back to start
  overlay.style.width = BAR_WIDTH
  overlay.style.horizontal_align = "center"
end
