-- Startup
--

do
    local cmds =
    {
		"awsetbg ~/.local/share/wallpaper.png",
		"gnome-session &",
		"xcompmgr &",
		"tomboy &",
		"/opt/synapse/bin/synapse -s &",
		"~/.i3/bin/pa-applet &",
		"~/.i3/bin/pidgin  &",
		"~/.i3/bin/xinput-tp.sh &",
		"~/.i3/bin/i3keymap &"
    }

	for _,i in pairs(cmds) do
		print("Startup: "..i)
        awful.util.spawn_with_shell(i)
    end
end

