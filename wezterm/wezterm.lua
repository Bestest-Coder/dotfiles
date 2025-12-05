local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- config.color_scheme = 

config.font = wezterm.font 'Terminess Nerd Font Mono'
config.font_size = 15

config.window_padding = {
    left = '0.25cell',
    right = '0.25cell',
    top = 0,
    bottom = 0,
}

-- wezterm.on('open-uri', function(window, pane, uri)
--     local editor = 'nvim'
--
--     if uri:find '^file:' == 1 and not pane:is_alt_screen_active() then
--         local url = wezterm.url.parse(uri)
--         if is_shell(pane:get_foreground_process_name()) then
--             local success, stdout, _ = wezterm.run_child_process {
--                 'file',
--                 '--brief',
--                 '--mime-type',
--                 uri.file_path,
--             }
--             if success then
--                 if stdout:find 'directory' then
--                     -- if directory, cd in and do ls
--                     pane:send_text(
--                         wezterm.shell_join_args { 'cd', url.file_path } .. '\r'
--                     )
--                     pane:send_text(wezterm.shell_join_args {
--                         'eza',
--                         '-a',
--                         '-F',
--                         '--group-directories-first',
--                         '--hyperlink',
--                     } .. '\r')
--                     return false
--                 end
--
--                 if stdout:find 'text' then
--                     if url.fragment then
--                         pane:send_text(wezterm.shell_join_args {
--                             editor,
--                             '+' .. url.fragment,
--                             url.file_path,
--                         } .. '\r')
--                     else
--                         pane:send_text(
--                             wezterm.shell_join_args { editor, url.file_path } .. '\r'
--                         )
--                     end
--                     return false
--                 end
--             end
--         else
--             -- not in a shell, probably SSH
--             return false
--         end
--     end
--     -- no return, do normal things
-- end)


return config
