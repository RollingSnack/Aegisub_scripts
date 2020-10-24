-- Automation 4 script

local tr = aegisub.gettext

script_name = tr("More borders")
script_description = tr("Create more borders for subtitles.")
script_author = "Rolling Snack"
script_version = "1.0"

include("karaskel.lua")

function dialogs(layer)
    local dialog_config = {
        {class="label", label="Layer " .. tostring(layer), x=0, y=0, height=1},
        {class="label", label="Size:", x=0, y=1, height=1},
        {class="floatedit", name="size", x=1, y=1, height=1, min=0, value=8},
        {class="label", label="Color:", x=0, y=2, height=2},
        {class="color", name="color", x=1, y=2, height=2},
        {class="label", label="Use style color", x=2, y=2, height=2},
        {class="checkbox", name="is_style", x=3, y=2, height=2, value=true},
    }
    local btn, config = aegisub.dialog.display(dialog_config, {"OK", "Cancel", "More Borders"})
    if btn == "Cancel" then
        return false, {}
    else
        local configs = {config}
        if btn == "More Borders" then
            local more_btn, more_configs = dialogs(layer + 1)
            if more_btn then
                for _, conf in ipairs(more_configs) do
                    table.insert(configs, conf)
                end
            end
        end
        return true, configs
    end
end

function more_borders(subtitles, selected_lines, active_lines)
    local btn, configs = dialogs(1)
    if not btn then
        return
    end
    local layers = #configs

    local _, styles = karaskel.collect_head(subtitles)
    local count = 0
    original_lines = {}
    for _, index in ipairs(selected_lines) do
        original_index = index + count * layers
        local l = subtitles[original_index]
        for i, config in ipairs(configs) do
            local size, color, is_style = config.size, config.color, config.is_style
            if is_style then
                color = styles[l.style].color1
            end
            local new_l = util.copy(l)
            new_l.layer = new_l.layer + layers - i
            new_l.text = "{\\3c" .. util.color_from_style(color) .. "\\bord" .. size .. "}" .. new_l.text
            subtitles.insert(original_index + i, new_l)
            table.insert(original_lines, original_index)
        end
        l.layer = l.layer + layers
        subtitles[index + count * layers] = l
        count = count + 1
    end
    aegisub.set_undo_point(script_name)
    return original_lines
end

aegisub.register_macro(script_name, tr(script_description), more_borders)
