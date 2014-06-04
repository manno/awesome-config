local setmetatable = setmetatable
local capi =
{
    awesome = awesome,
    wibox = wibox,
    widget = widget,
    client = client,
}

local beautiful = require("beautiful")
local util = require("awful.util")
local widget = require("awful.widget")
local client = require("awful.client")
local layout = require("awful.widget.layout")

module("titlebar")

local data = setmetatable({}, { __mode = 'k' })

function create(c)
    if not c or (c.type ~= "normal" and c.type ~= "dialog") then return end

	local args = { modkey = modkey, height = "13", font = "canderel medium 8", 
				   fg = "#3a3a3a",
				   fg_focus = "#ffffff",
				   bg = "#d0d0d0",
				   bg_focus = "#0087af"
			     }
    local theme = beautiful.get()

    -- Store colors
    data[c] = {}
    data[c].fg = args.fg or theme.titlebar_fg_normal or theme.fg_normal
    data[c].bg = args.bg or theme.titlebar_bg_normal or theme.bg_normal
    data[c].fg_focus = args.fg_focus or theme.titlebar_fg_focus or theme.fg_focus
    data[c].bg_focus = args.bg_focus or theme.titlebar_bg_focus or theme.bg_focus
    data[c].width = args.width
    data[c].font = args.font or theme.titlebar_font or theme.font

    local tb = capi.wibox(args)

    local title = capi.widget({ type = "textbox" })
    if c.name then
        title.text = "<span font_desc='" .. data[c].font .. "'> " ..
                     util.escape(c.name) .. " </span>"
    end

    local appicon = capi.widget({ type = "imagebox" })
    appicon.image = c.icon

    tb.widgets = {
        {
            appicon = appicon,
            title = title,
            layout = layout.horizontal.flex
        },
        layout = layout.horizontal.rightleft
    }

    c.titlebar = tb

    c:add_signal("property::icon", update)
    c:add_signal("property::name", update)
    c:add_signal("property::sticky", update)
    c:add_signal("property::floating", update)
    c:add_signal("property::ontop", update)
    c:add_signal("property::maximized_vertical", update)
    c:add_signal("property::maximized_horizontal", update)
	update(c)
end

function update(c)
     if c.titlebar and data[c] then
        local widgets = c.titlebar.widgets
        if widgets[1].title then
            widgets[1].title.text = "<span font_desc='" .. data[c].font ..
            "'> ".. util.escape(c.name or "<unknown>") .. " </span>"
        end
        if widgets[1].appicon then
            widgets[1].appicon.image = c.icon
        end
        if capi.client.focus == c then
            c.titlebar.fg = data[c].fg_focus
            c.titlebar.bg = data[c].bg_focus
        else
            c.titlebar.fg = data[c].fg
            c.titlebar.bg = data[c].bg
        end
    end
end

-- Register standards hooks
capi.client.add_signal("focus", update)
capi.client.add_signal("unfocus", update)
