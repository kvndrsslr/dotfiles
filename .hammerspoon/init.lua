require("hs.ipc")
hs.ipc.cliInstall()
-- Press Cmd+Q twice to quit
local lastCmdQ = 0
local function doQuit()
    local interval = hs.timer.secondsSinceEpoch() - lastCmdQ
    lastCmdQ = hs.timer.secondsSinceEpoch()
    if interval < 1.5 then
        local app = hs.application.frontmostApplication()
        app:kill()
	lastCmdQ = 0
    end
end
hs.hotkey.bind('cmd', 'q', nil, doQuit, nil, nil)
-- load stackline
stackline = require "stackline.stackline.stackline"
-- stackline:init()
