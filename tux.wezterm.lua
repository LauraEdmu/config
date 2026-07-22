-- Pull in the WezTerm API.
local wezterm = require 'wezterm'

-- Build the configuration.
local config = wezterm.config_builder()
local act = wezterm.action

-- Initial window size.
config.initial_cols = 120
config.initial_rows = 28

-- JetBrains Mono Nerd Font.
config.font = wezterm.font 'JetBrainsMono Nerd Font'
config.font_size = 11
config.default_cursor_style = 'BlinkingBar'

-- Aesthetic.
config.color_scheme = 'tokyonight_night'
config.colors = {
    background = '#282c34',
}

config.window_decorations = 'RESIZE'
config.enable_tab_bar = true

-- Launch Zsh as a login shell by default.
config.default_prog = { 'zsh', '-l' }

-- Start maximised.
wezterm.on('gui-startup', function(cmd)
    local _, _, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

-- Shell launcher entries.
config.launch_menu = {
    {
        label = 'Zsh',
        args = { 'zsh', '-l' },
    },
    {
        label = 'Bash',
        args = { 'bash', '-l' },
    },
    {
        label = 'PowerShell 7',
        args = { 'pwsh', '-NoLogo' },
    },
    {
        label = 'POSIX sh',
        args = { 'sh', '-l' },
    },
}

-- Keyboard shortcuts.
config.keys = {
    -- Split panes running the default shell with Ctrl+Alt+Arrow.
    {
        key = 'LeftArrow',
        mods = 'CTRL|ALT',
        action = act.SplitPane {
            direction = 'Left',
            size = { Percent = 50 },
        },
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|ALT',
        action = act.SplitPane {
            direction = 'Right',
            size = { Percent = 50 },
        },
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|ALT',
        action = act.SplitPane {
            direction = 'Up',
            size = { Percent = 50 },
        },
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|ALT',
        action = act.SplitPane {
            direction = 'Down',
            size = { Percent = 50 },
        },
    },

    -- Split panes running Bash with Ctrl+Alt+Shift+Arrow.
    {
        key = 'LeftArrow',
        mods = 'CTRL|ALT|SHIFT',
        action = act.SplitPane {
            direction = 'Left',
            size = { Percent = 50 },
            command = {
                args = { 'bash', '-l' },
            },
        },
    },
    {
        key = 'RightArrow',
        mods = 'CTRL|ALT|SHIFT',
        action = act.SplitPane {
            direction = 'Right',
            size = { Percent = 50 },
            command = {
                args = { 'bash', '-l' },
            },
        },
    },
    {
        key = 'UpArrow',
        mods = 'CTRL|ALT|SHIFT',
        action = act.SplitPane {
            direction = 'Up',
            size = { Percent = 50 },
            command = {
                args = { 'bash', '-l' },
            },
        },
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|ALT|SHIFT',
        action = act.SplitPane {
            direction = 'Down',
            size = { Percent = 50 },
            command = {
                args = { 'bash', '-l' },
            },
        },
    },

    -- Move between panes with Alt+Arrow.
    {
        key = 'LeftArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'RightArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Right',
    },
    {
        key = 'UpArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'DownArrow',
        mods = 'ALT',
        action = act.ActivatePaneDirection 'Down',
    },

    -- Resize the active pane.
    {
        key = '[',
        mods = 'ALT',
        action = act.AdjustPaneSize { 'Left', 1 },
    },
    {
        key = ']',
        mods = 'ALT',
        action = act.AdjustPaneSize { 'Right', 1 },
    },
    {
        key = '-',
        mods = 'ALT',
        action = act.AdjustPaneSize { 'Up', 1 },
    },
    {
        key = '=',
        mods = 'ALT',
        action = act.AdjustPaneSize { 'Down', 1 },
    },

    -- Open a new tab using the default Zsh shell.
    {
        key = 't',
        mods = 'ALT',
        action = act.SpawnTab 'CurrentPaneDomain',
    },

    -- Open a new Bash tab.
    {
        key = 't',
        mods = 'CTRL|ALT',
        action = act.SpawnCommandInNewTab {
            args = { 'bash', '-l' },
        },
    },

    -- Close the current tab.
    {
        key = 'w',
        mods = 'CTRL',
        action = act.CloseCurrentTab {
            confirm = false,
        },
    },

    -- Close the current pane.
    {
        key = 'w',
        mods = 'ALT',
        action = act.CloseCurrentPane {
            confirm = false,
        },
    },

    -- Open the shell launcher.
    {
        key = 'l',
        mods = 'CTRL|SHIFT',
        action = act.ShowLauncherArgs {
            flags = 'FUZZY|LAUNCH_MENU_ITEMS',
        },
    },
}

return config
