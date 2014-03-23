-- Shipped with awesome
require("awful")
require("awful.autofocus")
require("beautiful")

-- External
package.path = awful.util.getdir("config").."/lib/?.lua;" .. package.path
require("shifty")
require("vicious")
require("mpd")

if io.open(awful.util.getdir("config") .. "/.laptop_mode") then
    config_mode = 'laptop'
else
    config_mode = 'desktop'
end


-- MPD Control
function get_mpd()
    local stats = mpc:send("status")
    if stats.errormsg or not mpc.connected then
        now_playing = "MPD Stopped"
    else
        if stats.state == 'stop' then
            now_playing = 'stopped'
        else
            local zstats = mpc:send('playlistid ' .. stats.songid)
            now_playing = ( zstats.artist or 'NA' ) .. ' - '
            now_playing = now_playing .. ( zstats.album or 'NA' ) .. ' - '
            now_playing = now_playing .. ( zstats.title or string.gsub(zstats.file, ".*/", "" ) ) 
        end
    end

    if stats.state == 'pause' then
        now_playing = "<span color='#505050'>" .. awful.util.escape(now_playing) .. "</span>"
    else
        now_playing = awful.util.escape(now_playing)
    end
    return now_playing
end




key.none        = {}
key.alt         = {"Mod1"}
key.super       = {"Mod4"}
key.shift       = {"Shift"}
key.control     = {"Control"}

key.super_alt       = {key.super[1], key.alt[1]}
key.super_shift     = {key.super[1], key.shift[1]}
key.super_control   = {key.super[1], key.control[1]}
key.control_alt     = {key.control[1], key.alt[1]}
key.shift_alt       = {key.shift[1], key.alt[1]}

theme_path = awful.util.getdir("config") .. "/themes/zenburn.theme"
beautiful.init(theme_path)

-- Initialise tables
settings            = {}
settings.widget     = {}
settings.apps       = {}
settings.tag        = {}
settings.bindings   = {}

settings.tag.mwfact = 0.5

settings.apps.terminal      = 'urxvt'
settings.apps.lock_screen   = 'xscreensaver-command -lock'
settings.apps.browser       = 'firefox'
settings.apps.reader        = 'evince'
settings.apps.mpc_next      = 'mpc next'
settings.apps.mpc_prev      = 'mpc prev'
settings.apps.mpc_toggle    = 'mpc toggle'
settings.apps.noise         = 'play -n synth 60:00 tpdfnoise'

settings.floating = {
    ["gimp"] = true,
    ["feh"] = true,
    ["gnuplot"] = true,
}


settings.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating,
}
settings.default_layout = settings.layouts[1]

settings.wibox = {
    position    = "top",
    height      = 18,
    fg          = beautiful.fg_normal,
    bg          = beautiful.bg_normal,
}

-- Spawning
settings.bindings.spawn = {
    { {key.super,     "Return"},  settings.apps.terminal },
    { {key.super,     "b"},      settings.apps.browser },
    { {key.super,     "e"},      settings.apps.reader },
    { {key.super,     "l"},      settings.apps.lock_screen },
    { {key.super,     "n"},      settings.apps.noise },
}
globalkeys = {}
for _,k in pairs(settings.bindings.spawn) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key(k[1][1], k[1][2], function() awful.util.spawn(k[2]) end))
end

-- MPD Commands
settings.bindings.mpd = {
    { {key.alt, "c"},               "next" },
    { {key.none, "XF86AudioNext"},  "next" },
    { {key.alt, "z"},               "prev" },
    { {key.none, "XF86AudioPrev"},  "prev" },
    { {key.alt, "x"},               "toggle" },
    { {key.alt, "XF86AudioPlay"},   "toggle" },
}

for _,k in pairs(settings.bindings.mpd) do
    if k[2] == "next" then
        globalkeys = awful.util.table.join(globalkeys,
            awful.key(k[1][1], k[1][2], function()
                mpc:next()
                mpd_status.widgets[1].text = get_mpd()
            end))
    elseif k[2] == "prev" then
        globalkeys = awful.util.table.join(globalkeys,
            awful.key(k[1][1], k[1][2], function()
                mpc:previous()
                mpd_status.widgets[1].text = get_mpd()
            end))
    else
        globalkeys = awful.util.table.join(globalkeys,
            awful.key(k[1][1], k[1][2], function()
                mpc:toggle_play()
                mpd_status.widgets[1].text = get_mpd()
            end))
    end
end

  
settings.bindings.wm = {
    { {key.super,         "k"},       function() 
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end end },
    { {key.super,         "j"},       function()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end end },
    { {key.super,         "Tab"},     function()
            awful.client.focus.history.previous()
            if client.focus then client.focus:raise() end end },
    { {key.super_shift,   "k"},       function() awful.client.swap.byidx(-1) end              },
    { {key.super_shift,   "j"},       function() awful.client.swap.byidx(1) end               },
    { {key.super,         "l"},       function() awful.tag.incmwfact(0.05) end                },
    { {key.super,         "h"},       function() awful.tag.incmwfact(-0.05) end               },
    { {key.super_shift,   "l"},       function() awful.tag.incnmaster(1) end                  },
    { {key.super_shift,   "h"},       function() awful.tag.incnmaster(-1) end                 },
    { {key.super_control, "l"},       function() awful.tag.incncol(1) end                     },
    { {key.super_control, "h"},       function() awful.tag.incncol(-1) end                    },
    { {key.super,         "Escape"},  function() awful.screen.focus_relative(1) end           },
    { {key.super_shift,   "Escape"},  function() awful.screen.focus_relative(-1) end          },
    { {key.super,         "]"},       function() awful.layout.inc(settings.layouts,1) end     },
    { {key.super,         "["},       function() awful.layout.inc(settings.layouts,-1) end    },
    { {key.super_shift,   "r"},       awesome.restart                                         },
    { {key.super_shift,   "q"},       awesome.quit                                            },
    { {key.super,         "r"},       
        function ()
            awful.prompt.run( {prompt='Run: ' },
                s_promptbox[mouse.screen].widget,
                function (...)
                    s_promptbox[mouse.screen].text = awful.util.spawn(unpack(arg), false)
                end,
                awful.completion.shell,
                awful.util.getdir("cache") .. "/history")
        end },
}
for _,k in pairs(settings.bindings.wm) do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key(k[1][1], k[1][2], k[2]) )
end

settings.bindings.taglist = {
    { {key.none, 1},        awful.tag.viewonly},
}

s_taglist_buttons = {}
for _,k in pairs(settings.bindings.taglist) do
    s_taglist_buttons = awful.util.table.join(s_taglist_buttons,
        awful.button(k[1][1], k[1][2], k[2]) )
end

settings.bindings.tasklist = {
    { {key.none, 1},    function (c) client.focus = c; client.focus:raise() end },
    { {key.none, 2},    function (c) client.focus = c; c:kill() end             },
}
for _,k in pairs(settings.bindings.tasklist) do
    s_tasklist_buttons = awful.util.table.join(s_tasklist_buttons,
        s_tasklist_buttons, awful.button(k[1][1], k[1][2], k[2]) )
end


settings.bindings.client = {
    { {key.control, "space"},   awful.client.floating.toggle        },
    { {key.alt,     "F4"},      function() client.focus:kill() end  },
}

settings.bindings.digits = {
    { {key.super},            awful.tag.viewonly                              },
    { {key.super_control},    function(t) t.selected = not t.selected end     },
    { {key.super_shift},      awful.client.movetotag                          },
}

for i=1,9 do
    for _,k in pairs(settings.bindings.digits) do
        globalkeys = awful.util.table.join(globalkeys,
            awful.key(k[1][1], i, function()
                t = shifty.getpos(i + (mouse.screen-1)*9 )
                if not t then return end
                k[2](t)
                awful.client.focus.history.previous()
                if client.focus then
                    client.focus:raise()
                end
            end))
    end
end

settings.bindings.mouse_client = {
    { {key.none,    1},     function (c) client.focus = c; client.focus:raise() end },
    { {key.super,   1},     awful.mouse.client.move                                 },
    { {key.super,   3},     awful.mouse.client.resize                               },
}
c_mouse_buttons = {}
for _,k in pairs(settings.bindings.mouse_client) do
    c_mouse_buttons = awful.util.table.join(c_mouse_buttons,
        c_mouse_buttons, awful.button(k[1][1], k[1][2], k[2]) )
end
root.keys(globalkeys)



beautiful.markup = {}
function beautiful.markup.bg(color, text)   return '<bg color="'..color..'" />'..text end
function beautiful.markup.fg(color, text)   return '<span color="'..color..'">'..text..'</span>' end
function beautiful.markup.font(font, text)  return '<span font_desc="'..font..'">'..text..'</span>' end
function beautiful.markup.title(t)          return t end
function beautiful.markup.title_normal(t)   return beautiful.title(t) end

function beautiful.markup.title_focus(t)
    return beautiful.markup.bg(
        beautiful.bg_focus, beautiful.markup.fg(beautiful.fg_focus, beautiful.markup.title(t)))
end

function beautiful.markup.title_urgent(t)
    return beautiful.markup.bg(
        beautiful.bg_urgent, beautiful.markup.fg(beautiful.fg_urgent, beautiful.markup.title(t)))
end

function beautiful.markup.bold(text)    return '<b>'..text..'</b>' end

function beautiful.markup.heading(text)
    return beautiful.markup.fg(beautiful.fg_focus, beautiful.markup.bold(text))
end




settings.widgets = {}

sep = widget({ type = 'imagebox' })
sep.image = image(beautiful.widget_sep)

space = widget({ type = 'textbox' })
space.text = ' '

up_img = widget({ type = 'imagebox' })
up_img.image = image(beautiful.widget_up)

down_img = widget({ type = 'imagebox' })
down_img.image = image(beautiful.widget_down)


cpu_w = {
    widgets = {
        widget({ type = 'textbox'}),
        space,
        widget({ type = 'textbox'}),
        widget({ type = 'imagebox' }),
        space,
        sep,
        space
    },
    screen = 1,
    side = 'right',
    mode = nil,
    name = 'cpu'
}
cpu_w.widgets[4].image = image(beautiful.widget_cpu)
vicious.register(cpu_w.widgets[3], vicious.widgets.cpu, "$1%")
vicious.register(cpu_w.widgets[1], vicious.widgets.thermal, " $1°C", 19, "thermal_zone0")

mem_w = {
    widgets = {
        widget({type = 'textbox'}),
        widget({ type = 'imagebox'}),
        space,
        sep,
        space,
    },
    screen = 1,
    side = 'right',
    mode = nil, 
    name = 'mem'
}
mem_w.widgets[2].image = image(beautiful.widget_mem)
vicious.register(mem_w.widgets[1], vicious.widgets.mem, "$1%", 10)

load_w = {
    widgets = {
        widget({ type = 'textbox' }),
        space,
        sep,
        space,
    },
    screen = 1,
    side = 'right',
    mode = nil,
    name = 'load'
}
vicious.register(load_w.widgets[1], vicious.widgets.uptime, "$4 $5 $6", 10)


wifi_status = {
    widgets = {
        widget({ type = 'textbox' }),
        space,
        widget({ type = 'imagebox'}),
        space,
        sep,
        space
    },
    screen = 1,
    side = 'right',
    mode = 'laptop',
    name = 'wifi'
}
if config_mode == 'laptop' then
    wifi_status.widgets[3].image = image(beautiful.widget_wifi)
    vicious.register(wifi_status.widgets[1], vicious.widgets.wifi, "'${ssid}'   ${rate} ", 45, "wlan0")
end

date_widget = { 
    widgets = {
        widget({ type = 'textbox' }),
        space,sep,space
    },
    screen = 1,
    side = 'right',
    mode = nil,
    name = 'date'
}
vicious.register(date_widget.widgets[1], vicious.widgets.date, "%a %Y.%m.%d, %k:%M", 30)


eth0_status = {
    widgets = {
        down_img,
        widget({ type = 'textbox' }),
        up_img,
        space, sep, space
    },
    screen = 1,
    side = 'right',
    mode = nil,
    name = 'eth0'
}
vicious.register(eth0_status.widgets[2], vicious.widgets.net, "${eth0 down_kb} ${eth0 up_kb}", 20)


wlan0_status = {
    widgets = {
        down_img,
        widget({ type = 'textbox' }),
        up_img,
        space, sep, space
    },
    screen = 1,
    side = 'right',
    mode = 'laptop',
    name = 'wlan0'
}
if config_mode == 'laptop' then
    vicious.register(wlan0_status.widgets[2], vicious.widgets.net, "${wlan0 down_kb} ${wlan0 up_kb}", 20)
end
 
bat_status = {
    widgets = {
        widget({ type = 'imagebox'}),
        space,
        widget({type = 'textbox'}),
        space, sep, space
    },
    screen = 1,
    side = 'right',
    mode = 'laptop',
    name = 'battery',
}
if config_mode == 'laptop' then
    bat_status.widgets[1].image = image(beautiful.widget_bat)
    vicious.register(bat_status.widgets[3], vicious.widgets.bat, "$2% $3", 61, "BAT0")
end

mpc = mpd:new()
mpd_status = {
    widgets = {
        widget({ type = 'textbox'}),
        space,sep,space,
    },
    screen = 1,
    side = 'right',
    mode = nil,
    name = 'mpd',
}
--mpd_status.widgets[1]:buttons( awful.util.table.join(
--    awful.button({ }, 1, function() mpc:toggle_play() end),
--    awful.button({ }, 4, function() mpc:next() mpd_status.widgets[1].text = get_mpd() end),
--    awful.button({ }, 5, function() mpc:previous() mpd_status.widgets[1].text = get_mpd() end),
--)

settings.widgets = {
    mpd_status,
    eth0_status,
    wlan0_status,
    wifi_status,
    load_w,
    mem_w,
    cpu_w,
    bat_status,
    date_widget,
}


-- Defaults for new tags.
shifty.config.defaults = {
    layout = awful.layout.suit.tile,
    mwfact = settings.tag.mwfact,
    exclusive = false,
    solitary = true,
    slave = true,
    leave_kills = true
}

-- Precreate 9 tags for each screen.
shifty.config.tags = {}
for i = 1, screen.count() do
    for j = 1, 9 do
        -- The SCREEN%d gets gsub'ed out by the tasklist.
        shifty.config.tags['SCREEN'..i..'.'..j] = {
            position = j + (i-1)*9,
            screen = i,
            init = true,
        }
    end
end

s_promptbox         = {}
s_layoutbox         = {}
s_taglist           = {}
s_tasklist          = {}
s_wibox             = {}
s_taglist_buttons   = {}
s_tasklist_buttons  = {}
s_systray           = {}

s_layoutbox_buttons = awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(settings.layouts, 1)    end),
        awful.button({ }, 3, function () awful.layout.inc(settings.layouts, -1)   end),
        awful.button({ }, 4, function () awful.layout.inc(settings.layouts, 1)    end),
        awful.button({ }, 5, function () awful.layout.inc(settings.layouts, -1)   end) 
    )

for s = 1,screen.count() do

    settings.default_layout = settings.layouts[1]
    s_promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })

    s_layoutbox[s] = awful.widget.layoutbox(s)
    s_layoutbox[s]:buttons( s_layoutbox_buttons )

    s_taglist[s] = awful.widget.taglist(s,
        function (t)
            text, bg_col, bg_img, bg_resize = awful.widget.taglist.label.noempty(t)
            if text then
                text = string.gsub(text, "SCREEN[0-9]\.([0-9])", "%1")
            end
            return text, bg_col, bg_img, bg_resize
        end,
        s_taglist_buttons)

    s_tasklist[s] = awful.widget.tasklist(
        function(c)
            return awful.widget.tasklist.label.currenttags(c,s)
        end,
        s_tasklist_buttons)

    s_systray[s] = widget({type="systray", align="right"})
    s_wibox[s] = awful.wibox({
        position    = "top",
        height      = 18,
        fg          = beautiful.fg_normal,
        bg          = beautiful.bg_normal,
        screen      = s,
    })

    lr_widgets = {
        s_taglist[s],
        s_promptbox[s],
        layout=awful.widget.layout.horizontal.rightleft
    }
    for _,p in ipairs(settings.widgets) do
        if p.screen == s and p.side == 'left' then 
            table.insert(lr_widgets, p.w)
        end
    end
    lr_widgets['layout'] = awful.widget.layout.horizontal.leftright

    rl_widgets = {
        layout=awful.widget.layout.horizontal.rightleft
    }
    for _,p in ipairs(settings.widgets) do
        if 
            (p.screen == s or p.screen == 0)
            and (p.mode == nil or p.mode == config_mode)
            and p.side == 'right' then
            
            for _,w in ipairs(p.widgets) do
                table.insert(rl_widgets, 1, w)
            end
        end
    end
    table.insert(rl_widgets, 1, s_layoutbox[s])
    table.insert(rl_widgets, s_tasklist[s])
    s_wibox[s].widgets = {
        {
            lr_widgets,
            layout = awful.widget.layout.horizontal.leftright
        },
        rl_widgets,
        layout=awful.widget.layout.horizontal.rightleft
    }
end

shifty.taglist = s_taglist
shifty.init()


client.add_signal("focus",      function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus",    function(c) c.border_color = beautiful.border_normal end)


client.add_signal("manage", function(c, startup)
    local class = ""
    local instance = ""
    local buttons = {}
    local ckeys = {}
    
    if not startup and awful.client.focus.filter(c) then
        c.screen = mouse.screen
    end


    c.border_width = beautiful.border_width
    c.border_color = beautiful.border_normal


    if c.class then class = c.class:lower() end
    if c.instance then instance = c.name:lower() end

    if settings.floating[class] then
        awful.client.floating.set(c, settings.floating[class])
    elseif settings.floating[instance] then
        awful.client.floating.set(c, settings.floating[class])
    end
    
    c:buttons(c_mouse_buttons)
    -- TODO:  application->screen/tag mapping?  In default rc.lua
    client.focus = c

   
    ckeys = {} 
    for _,k in pairs(settings.bindings.client) do
        ckeys = awful.util.table.join(ckeys,
            ckeys, awful.key(k[1][1], k[1][2], k[2]) )
    end
    c:keys(ckeys)

    c.size_hints_honor = false

    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

end)

mpdtimer = timer { timeout = 10 }
mpdtimer:add_signal("timeout", function()
        mpd_status.widgets[1].text = get_mpd()
    end)
mpdtimer:start()
mpd_status.widgets[1].text = get_mpd()
    
-- vim: filetype=lua tabstop=2 shiftwidth=2 expandtab 
