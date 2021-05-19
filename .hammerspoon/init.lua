-- load stackline
stackline = require "stackline.stackline.stackline"
--
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
-- draw indicator in future
-- c = require("hs.canvas")
-- local a = c.new{ x = 100, y = 100, h = 500, w = 500 }
-- a[1] = {
-- coordinates = {
--     { x = ".1", y = ".5" },
--     { x = ".9", y = ".5", c1x = ".1", c1y = ".1", c2x = ".9", c2y = ".9" },
--     { x = ".1", y = ".5", c1x = ".9", c1y = ".1", c2x = ".1", c2y = ".9" },
-- },
-- fillColor = { blue = 1 },
-- type = "segments",
-- }

-- a[2] = {
-- coordinates = {
--     { x = ".5", y = ".1" },
--     { x = ".5", y = ".9", c1x = ".1", c1y = ".1", c2x = ".9", c2y = ".9" },
--     { x = ".5", y = ".1", c1x = ".1", c1y = ".9", c2x = ".9", c2y = ".1" },
-- },
-- fillColor = { blue = 1 },
-- type = "segments",
-- }

-- local function showA()
--     a:show()
-- end

-- local function hideA()
--     a:hide()
-- end

-- hs.hotkey.bind('cmd', 'b', nil, showA, nil, nil)
-- hs.hotkey.bind('cmd', 'g', nil, hideA, nil, nil)