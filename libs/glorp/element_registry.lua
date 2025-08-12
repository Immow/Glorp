local folder_path = (...):match("(.-)[^%.]+$")

return {
    button = require(folder_path .. "button"),
    slider = require(folder_path .. "slider"),
    dropdown = require(folder_path .. "dropdown"),
    image = require(folder_path .. "image"),
    text = require(folder_path .. "text"),
    form = require(folder_path .. "form"),
    checkbox = require(folder_path .. "checkbox"),
    radiobutton = require(folder_path .. "radiobutton"),
    block = require(folder_path .. "block"),
    titlebar = require(folder_path .. "titlebar"),
    bar = require(folder_path .. "bar"),
    track = require(folder_path .. "track"),
}
