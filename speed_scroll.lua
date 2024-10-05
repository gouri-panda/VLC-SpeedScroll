-- VLC Extension: Speed Control with Live Display and Vertical Buttons
-- Opens a dialog to set playback speed and shows the current speed live

function descriptor()
    return {
        title = "Speed Control with Live Display",
        version = "1.3",
        author = "Gouri",
        description = "Set playback speed with vertical buttons and see current speed in real-time",
        capabilities = {}
    }
end

function activate()
    show_input_dialog()
    update_live_speed() -- Start updating the live speed display
end

function deactivate()
end

function close()
    vlc.deactivate()
end

-- Function to show input dialog with preset buttons for playback speed and live speed display
function show_input_dialog()
    -- Create a dialog box that persists until manually closed
    dialog = vlc.dialog("Set Playback Speed")


   

    -- Add a label to display current playback speed
    speed_label = dialog:add_label("Current speed: ", 1, 1, 1, 1)

     -- Create a scrollable container for buttons


    -- Add preset buttons for playback speeds (vertically arranged)
    dialog:add_button("1.00x", function() set_playback_speed(1.00) end, 1, 2, 1, 0.5)
    dialog:add_button("1.25x", function() set_playback_speed(1.25) end, 1, 3, 1, 0.5)
    dialog:add_button("1.50x", function() set_playback_speed(1.50) end, 1, 4, 1, 0.5)
    dialog:add_button("1.75x", function() set_playback_speed(1.75) end, 1, 5, 1, 0.5)
    dialog:add_button("2.00x", function() set_playback_speed(2.00) end, 1, 6, 1, 0.5)
    dialog:add_button("2.25x", function() set_playback_speed(2.25) end, 1, 7, 1, 0.5)
    dialog:add_button("2.50x", function() set_playback_speed(2.50) end, 1, 8, 1, 0.5)
    dialog:add_button("2.75x", function() set_playback_speed(2.75) end, 1, 9, 1, 0.5)

    -- Add a "Close" button to manually close the dialog
    dialog:add_button("Close", function()
        dialog:delete()  -- Close the dialog when the "Close" button is clicked
        close()          -- Call the close function to deactivate the extension
    end, 1, 10, 1, 1)
    --Todo Ensure dialog remains on top of the VLC window
    


end



-- Function to set the VLC playback speed
function set_playback_speed(speed)
    vlc.var.set(vlc.object.input(), "rate", speed)
    vlc.msg.info("Playback speed set to " .. speed .. "x")

    -- Fix this:  Highlight the active button and reset others
    --for i, button in ipairs(dialog.buttons) do
      --  button:set_selected(i == speed_to_index(speed))
    --end
    update_live_speed()  -- Update the live speed display after setting a new speed
end

-- Function to map speed to button index
function speed_to_index(speed)
    if speed == 1.00 then return 1 end
    if speed == 1.25 then return 2 end
    if speed == 1.50 then return 3 end
    if speed == 1.75 then return 4 end
    if speed == 2.00 then return 5 end
    if speed == 2.25 then return 6 end
    if speed == 2.50 then return 7 end
    if speed == 2.75 then return 8 end
    return 1  -- Default to 1.00x
end
-- Function to update the live speed display in real-time
function update_live_speed()
    if not dialog then return end  -- If dialog is closed, stop updating

    local current_speed = vlc.var.get(vlc.object.input(), "rate")
    speed_label:set_text("Current speed: " .. string.format("%.2f", current_speed) .. "x")

    -- Keep updating every 500ms to ensure the display is live
    vlc.misc.mwait(vlc.misc.mdate() + 500000)  -- Wait for 500ms
    update_live_speed()  -- Recursive call to keep updating
end
