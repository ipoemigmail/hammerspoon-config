local C = require "lib/console"
local T = require "lib/trigger"
local W = require "lib/window"

local M = {}

local events = hs.eventtap.event.types
local eventProperties = hs.eventtap.event.properties

local leftKeyDown = false
local rightKeyDown = false
local upKeyDown = false
local downKeyDown = false

M.mouseDoubleClickEventTap = hs.eventtap.new({events.leftMouseDown}, function(event)
  local status, err = pcall(function()
    if (event:getProperty(eventProperties["mouseEventClickState"]) == 2 and T.isBindKeyDown(event)) then
      W.toggleMax()
      return true
    elseif (T.isBindKeyDown(event)) then
      return true
    end
  end)
  if (not status) then
    C.printError(err)
  end
  return err

end):start()

M.mouseLeftDragEventTap = hs.eventtap.new({events.leftMouseDragged}, function(event)
  local status, err = pcall(function()
    if (T.isBindKeyDown(event)) then
      C.printConsole("left drag: " .. tostring(event:getProperty(eventProperties["mouseEventDeltaX"])) .. ", " .. tostring(event:getProperty(eventProperties["mouseEventDeltaY"])))
      W.move(event:getProperty(eventProperties["mouseEventDeltaX"]), event:getProperty(eventProperties["mouseEventDeltaY"]), 0)
      return true
    end
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end

end):start()

return M
