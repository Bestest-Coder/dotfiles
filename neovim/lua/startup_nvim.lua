local settings = {
    section_1 = {
        type = "text",
        align = "center",
        title = "header",
        content = {"Welcome Fucker to this Magical Wonderland"}
    },
    section_2 = {
        type = "mapping",
        align = "center",
        title = "mapping display",
        content = {
            {"Find a file", "Telescope find_files", "<leader>ff"},
            --{}
        }
    },
    options = {
        mapping_keys = true,
        after = function()
            -- open Neotree maybe?
        end,
        disable_statuslines = true,
    },
    mappings = {
        execute_command = "<CR>",
        open_file = "o",
        open_file_split = "<c-o>",
        open_help = "?",
    },
    parts = {"section_1","section_2"}
}

return settings
