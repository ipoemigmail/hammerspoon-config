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

M.mouseRightClickEventTap = hs.eventtap.new({events.rightMouseDown}, function(event)
  local status, err = pcall(function()
    if (T.isBindKeyDown(event)) then
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

M.mouseRightDragEventTap = hs.eventtap.new({events.rightMouseDragged}, function(event)
  local status, err = pcall(function()
    if (T.isBindKeyDown(event)) then
      C.printConsole("left drag: " .. tostring(event:getProperty(eventProperties["mouseEventDeltaX"])) .. ", " .. tostring(event:getProperty(eventProperties["mouseEventDeltaY"])))
      W.resize(
        event:getProperty(eventProperties["mouseEventDeltaX"]),
        event:getProperty(eventProperties["mouseEventDeltaY"]),
        0)
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

M.mouseScrollEventTap = hs.eventtap.new({events.scrollWheel}, function(event)
  local status, err = pcall(function()
    if (T.isBindKeyDown(event)) then
      C.printConsole("mouse scroll: " .. tostring(event:getProperty(eventProperties["scrollWheelEventDeltaAxis2"])) .. ", " .. tostring(event:getProperty(eventProperties["scrollWheelEventDeltaAxis1"])))
      W.resizeWithMouse(
        event:getProperty(eventProperties["scrollWheelEventDeltaAxis2"]),
        event:getProperty(eventProperties["scrollWheelEventDeltaAxis1"]),
        --event:getProperty(eventProperties["scrollWheelEventFixedPtDeltaAxis2"]),
        --event:getProperty(eventProperties["scrollWheelEventFixedPtDeltaAxis1"]),
        --event:getProperty(eventProperties["scrollWheelEventPointDeltaAxis2"]),
        --event:getProperty(eventProperties["scrollWheelEventPointDeltaAxis1"]),
        0)
      --W.locateCenter()
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
