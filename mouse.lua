local C = require "console"
local T = require "trigger"
local W = require "window"

local mouse = {}

local events = hs.eventtap.event.types
local eventProperties = hs.eventtap.event.properties

local leftKeyDown = false
local rightKeyDown = false
local upKeyDown = false
local downKeyDown = false

hs.eventtap.new({events.leftMouseDown}, function(event)
  local status, err = pcall(function()
    if (event:getProperty(eventProperties["mouseEventClickState"]) == 2 and T.isBindKeyDown(event)) then
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      if (W.isCurrentWindowMax()) then
        W.resizeDefault() 
        W.locateCenter()
      else
        W.resizeMax()
        W.locateLeft()
        W.locateTop()
      end
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

hs.eventtap.new({events.leftMouseDragged}, function(event)
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

hs.eventtap.new({events.keyDown}, function(event)
  local status, err = pcall(function()
    C.printConsole("keyDown: " .. tostring(event:getKeyCode()))
    if (event:getKeyCode() == hs.keycodes.map["left"]) then
      leftKeyDown = true
      if (T.isBindKeyDown(event)) then
        W.resizeHalfWidth()
        W.resizeMaxHeight()
        W.locateLeft()
        W.locateTop()
        if (upKeyDown) then
          W.resizeHalfHeight()
          C.printConsole("left + up")
        elseif (downKeyDown) then
          W.resizeHalfHeight()
          W.locateDown()
          C.printConsole("left + down")
        end
        return true
      end
    elseif (event:getKeyCode() == hs.keycodes.map["right"]) then
      rightKeyDown = true
      if (T.isBindKeyDown(event)) then
        W.resizeHalfWidth()
        W.resizeMaxHeight()
        W.locateRight()
        W.locateTop()
        if (upKeyDown) then
          W.resizeHalfHeight()
          C.printConsole("right + up")
        elseif (downKeyDown) then
          W.resizeHalfHeight()
          W.locateDown()
          C.printConsole("right + down")
        end
        return true
      end
    elseif (event:getKeyCode() == hs.keycodes.map["up"]) then
      upKeyDown = true
      if (T.isBindKeyDown(event)) then
        W.resizeHalfHeight()
        W.resizeMaxWidth()
        W.locateTop()
        W.locateLeft()
        if (leftKeyDown) then
          W.resizeHalfWidth()
          C.printConsole("right + up")
        elseif (rightKeyDown) then
          W.resizeHalfWidth()
          W.locateRight()
          C.printConsole("left + up")
        end
        return true
      end
    elseif (event:getKeyCode() == hs.keycodes.map["down"]) then
      downKeyDown = true
      if (T.isBindKeyDown(event)) then
        W.resizeHalfHeight()
        W.resizeMaxWidth()
        W.locateDown()
        if (leftKeyDown) then
          W.resizeHalfWidth()
          C.printConsole("right + down")
        elseif (rightKeyDown) then
          W.resizeHalfWidth()
          W.locateRight()
          C.printConsole("left + down")
        end
        return true
      end
    end
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end

end):start()

hs.eventtap.new({events.keyUp}, function(event)
  local status, err = pcall(function()
    C.printConsole("keyUp: " .. tostring(event:getKeyCode()))
    if (event:getKeyCode() == hs.keycodes.map["left"]) then
      leftKeyDown = false
    elseif (event:getKeyCode() == hs.keycodes.map["right"]) then
      rightKeyDown = false
    elseif (event:getKeyCode() == hs.keycodes.map["up"]) then
      upKeyDown = false
    elseif (event:getKeyCode() == hs.keycodes.map["down"]) then
      downKeyDown = false
    end
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end

end):start()

return mouse
