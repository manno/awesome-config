-- {{{ Rules
--
local function add_rule(rule)
	table.insert (awful.rules.rules, rule)
end

local function float(rule)
	add_rule({ rule = rule, properties = { floating = true } })
end

local function fullscreen(rule)
	add_rule({ rule = rule, properties = { fullscreen = true } })
end

local function assign_tag(rule, tag)
	add_rule({ rule = rule, properties = tag })
end

assign_tag({ class = "Firefox" }, { tag = tags[2][2] })
assign_tag({ class = "Google-chrome-stable" }, { tag = tags[1][3] })
assign_tag({ class = "Pidgin" }, { tag = tags[1][4] })
assign_tag({ class = "Evolution" }, { tag = tags[1][5] })
assign_tag({ class = "Keepassx" }, { tag = tags[1][7] })

float({ class = "Gmrun" })
float({ class = "X2goclient", instance="x2goclient" })
fullscreen({ class = "Meld" })
fullscreen({ class = "Gitk" })
fullscreen({ class = "Gitg" })
fullscreen({ class = "Spotify" })
float({ class = "MPlayer" })
float({ class = "pinentry" })
float({ class = "Tomboy" })
float({ class = "awn-applet" })
float({ class = "awn-settings" })
float({ class = "Dialog" })
float({ class = "Download" })
float({ class = "Eog" })
float({ class = "Evince" })
float({ class = "TeamViewer.exe" })
float({ title = "TeamViewer" })
float({ title = "Steam - Update News" })
float({ class = "Wine" })
float({ class = "Signon-ui" })
float({ class = "Nm-applet" })

--add_rule({ rule = { class = "Tomboy" }, properties = { tag = tags[1][6], floating = true } })

-- }}}
