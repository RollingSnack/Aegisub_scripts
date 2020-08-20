-- Automation 4 script
-- This script is modified based on Domo's script (v1.2)

local tr = aegisub.gettext
script_name = tr("Add k tags")
script_description = tr("Add k tags to selected lines")
script_author = "Rolling Snack"
script_version = "1.2.2"

include("unicode.lua")

function add_k1(subtitles, selected_lines, active_line)
    add_k(subtitles, selected_lines, active_line, "k1")
end

function add_k_avg(subtitles, selected_lines, active_line)
    add_k(subtitles, selected_lines, active_line, "avg")
end

function add_k_percent(subtitles, selected_lines, active_line)
    local dialog_config = {
        {class="label", x=2, y=0, width=1, height=1, label="Percent(%):"},
        {class="intedit", name="Percent", x=3, y=0, width=1, min=1, max=100, height=1, value="100"},
    }
    local btn, config = aegisub.dialog.display(dialog_config)
    local percent = config.Percent
    if btn then
        add_k(subtitles, selected_lines, active_line, "percentage", percent)
    end
end

function add_k(subtitles, selected_lines, active_line, k_type, percent)
    local k_value = 1
    for z, i in ipairs(selected_lines) do
        local l = subtitles[i]
        if k_type == "avg" then
            k_value = math.floor((l.end_time - l.start_time) / 10 / unicode.len(l.text) + 0.5)
        elseif k_type == "percentage" then
            k_value = math.floor((l.end_time - l.start_time) / 10 / unicode.len(l.text) * percent / 100 + 0.5)
        end
        if string.find(l.text, "[\\|{|}]") ~= nil then
            aegisub.debug.out("Please delete all existing tags in line "..tostring(z).."\n")
        else
            local text = ""
            for uchar in string.gmatch(l.text, "[%z\1-\127\194-\244][\128-\191]*") do
                text = text..string.format("{\\k%d}", k_value)..uchar
            end
            l.text = text
            subtitles[i] = l
        end
    end
    aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name.."/k1", tr"Add {\\k1} for all lines", add_k1)
aegisub.register_macro(script_name.."/avg k", tr"Add average k tags for all lines", add_k_avg)
aegisub.register_macro(script_name.."/percent k", tr"Add k tags by percent of average time for all lines", add_k_percent)