require('lib.moonloader')
local imgui = require 'mimgui'
local ffi = require 'ffi'
local vkeys = require 'vkeys'
local encoding = require 'encoding'
local sampev = require "events"

encoding.default = 'CP1251'
local u8 = encoding.UTF8

local wm = require 'windows.message'
local new, str, sizeof = imgui.new, ffi.string, ffi.sizeof

local renderWindow, freezePlayer, removeCursor = new.bool(), new.bool(), new.bool()
local inputField = new.char[256]
local sizeX, sizeY = getScreenResolution()

local active = false

local list = {
    [VK_Q] = 'Тест'
}


local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(220, 200), imgui.Cond.FirstUseEver)
        imgui.Begin("Auto Report", renderWindow, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
        imgui.Text(u8"Активация авторепорта: Q")
        imgui.Text(u8"Задержка: 250мс")
        imgui.Text(u8"Версия: 1.0")
        imgui.Text(u8"Автор скрипта: twilme")
        imgui.End()
    end
)

function sampev.onTogglePlayerSpectating(state)
    if state then
        if active then
            active = false
            sampAddChatMessage('{7ee5b1}[AutoRep]{ffffff} Вы зашли в рекон. Автоловля автоматически отключена!', 0xffffff)
        end
    end
end


function main()
    while not isSampAvailable() do wait(0) end
    sampRegisterChatCommand('arep', function ()
        renderWindow[0] = not renderWindow[0]
    end)
    while true do
        wait(0)
        for key, text in pairs(list) do
            if wasKeyPressed(key) and not sampIsCursorActive() then
                active = not active
                sampAddChatMessage(active and '{7ee5b1}[AutoRep]{ffffff} Автоловля включена!' or '{7ee5b1}[AutoRep]{ffffff} Автоловля выключена!', 0xffffff)
            end
        end
        if active then
            sampSendChat('/ot')
            wait(250)
        end
    end
end