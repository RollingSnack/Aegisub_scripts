-- Automation 4 script

local tr = aegisub.gettext

script_name = tr("Shift one frame")
script_description = tr("Shift the start time and/or the end time by one frame to all selected lines.")
script_author = "Rolling Snack"
script_version = "1.1"

function macro_advance_start(subtitles, selected_lines, active_line)
    shift_one_frame(subtitles, selected_lines, active_line, true, false, -1)
end

function macro_delay_start(subtitles, selected_lines, active_line)
    shift_one_frame(subtitles, selected_lines, active_line, true, false, 1)
end

function macro_advance_end(subtitles, selected_lines, active_line)
    shift_one_frame(subtitles, selected_lines, active_line, false, true, -1)
end

function macro_delay_end(subtitles, selected_lines, active_line)
    shift_one_frame(subtitles, selected_lines, active_line, false, true, 1)
end

function macro_advance_both(subtitles, selected_lines, active_line)
    shift_one_frame(subtitles, selected_lines, active_line, true, true, -1)
end

function macro_delay_both(subtitles, selected_lines, active_line)
    shift_one_frame(subtitles, selected_lines, active_line, true, true, 1)
end

function shift_one_frame(subtitles, selected_lines, active_line, is_start, is_end, is_delay)
    local fdur = aegisub.ms_from_frame(1)
    for z, i in ipairs(selected_lines) do
        local l = subtitles[i]
        if is_start == true then
            l.start_time = l.start_time + is_delay * fdur
        end
        if is_end == true then
            l.end_time = l.end_time + is_delay * fdur
        end
        subtitles[i] = l
    end
    aegisub.set_undo_point(script_name)
end

function macro_can_shift_one_frame(subs)
    if aegisub.ms_from_frame(1) == nil then
        return false
    else
        return true
    end
end

aegisub.register_macro(script_name.."/advance start", tr("Advance the start time by one frame to all selected lines"), macro_advance_start, macro_can_shift_one_frame)
aegisub.register_macro(script_name.."/advance end", tr("Advance the end time by one frame to all selected lines"), macro_advance_end, macro_can_shift_one_frame)
aegisub.register_macro(script_name.."/advance both", tr("Advance the start & the end time by one frame to all selected lines"), macro_advance_both, macro_can_shift_one_frame)
aegisub.register_macro(script_name.."/delay start", tr("Delay the start time by one frame to all selected lines"), macro_delay_start, macro_can_shift_one_frame)
aegisub.register_macro(script_name.."/delay end", tr("Delay the end time by one frame to all selected lines"), macro_delay_end, macro_can_shift_one_frame)
aegisub.register_macro(script_name.."/delay both", tr("Delay the start & the end time by one frame to all selected lines"), macro_delay_both, macro_can_shift_one_frame)