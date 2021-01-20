local C = require "lib/console"
local T = require "lib/trigger"
local W = require "lib/window"

local K = {}

local events = hs.eventtap.event.types
local eventProperties = hs.eventtap.event.properties

local leftKeyDown = false
local rightKeyDown = false
local upKeyDown = false
local downKeyDown = false

local lastAction = ""

K.keyDownEventTap = hs.eventtap.new({events.keyDown}, function(event)
  local status, err = pcall(function()
    C.printConsole("keyDown: " .. tostring(event:getKeyCode()))
    C.printConsole("lastAction: " .. lastAction)
    if (event:getKeyCode() == hs.keycodes.map["left"]) then
      leftKeyDown = true
      if (T.isBindKeyDown(event)) then
        if lastAction == "left" then
          W.resizeQuarterWidth()
          lastAction = ""
        else
          W.resizeHalfWidth()
          lastAction = "left"
        end
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
        if lastAction == "right" then
          W.resizeQuarterWidth()
          lastAction = ""
        else
          W.resizeHalfWidth()
          lastAction = "right"
        end
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
        if lastAction == "up" then
          W.resizeQuarterHeight()
          lastAction = ""
        else
          W.resizeHalfHeight()
          lastAction = "up"
        end
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
        if lastAction == "down" then
          W.resizeQuarterHeight()
          lastAction = ""
        else
          W.resizeHalfHeight()
          lastAction = "down"
        end
        W.resizeMaxWidth()
        W.locateDown()
        W.locateLeft()
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
    elseif (event:getKeyCode() == hs.keycodes.map["1"]) then
      if (T.isBindKeyDown(event)) then
        hs.eventtap.keyStrokes("정병준")
      end
    elseif (event:getKeyCode() == hs.keycodes.map["2"]) then
      if (T.isBindKeyDown(event)) then
        hs.eventtap.keyStrokes("ipoemi@naver.com")
      end
    elseif (event:getKeyCode() == hs.keycodes.map["3"]) then
      if (T.isBindKeyDown(event)) then
        hs.eventtap.keyStrokes("카카오")
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

K.keyUpEventTap = hs.eventtap.new({events.keyUp}, function(event)
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

return K
