local C = require "lib/console"
local T = require "lib/trigger"
local W = require "lib/window"

local K = {}

local events = hs.eventtap.event.types
local eventProperties = hs.eventtap.event.properties

K.keyDownEventTap = hs.eventtap.new({events.keyDown}, function(event)
  local status, err = pcall(function()
    C.printConsole("keyDown: " .. tostring(event:getKeyCode()))
    if (event:getKeyCode() == hs.keycodes.map["left"]) then
      if (T.isBindKeyDown(event)) then
        if W.isLeft() and (W.isTop() or W.isBottom()) then
          if W.isMaxHeight() or W.isThreeQuartersHeight() or W.isHalfHeight() or W.isQuarterHeight() then
            if W.isMaxWidth() then
              W.resizeThreeQuartersWidth()
            elseif W.isThreeQuartersWidth() then
              W.resizeHalfWidth()
            elseif W.isHalfWidth() then
              W.resizeQuarterWidth()
            elseif W.isQuarterWidth() then
              W.resizeMaxWidth()
            end
          else
            W.resizeHalfWidth()
          end
        else
          W.locateTop()
          W.resizeMaxHeight()
          W.resizeHalfWidth()
        end
        W.locateLeft()
      end
    elseif (event:getKeyCode() == hs.keycodes.map["right"]) then
      if (T.isBindKeyDown(event)) then
        if W.isRight() and (W.isTop() or W.isBottom()) then
          if W.isMaxHeight() or W.isThreeQuartersHeight() or W.isHalfHeight() or W.isQuarterHeight() then
            if W.isMaxWidth() then
              W.resizeThreeQuartersWidth()
            elseif W.isThreeQuartersWidth() then
              W.resizeHalfWidth()
            elseif W.isHalfWidth() then
              W.resizeQuarterWidth()
            elseif W.isQuarterWidth() then
              W.resizeMaxWidth()
            end
          else
            W.resizeHalfWidth()
          end
        else
          W.locateTop()
          W.resizeMaxHeight()
          W.resizeHalfWidth()
        end
        W.locateRight()
      end
    elseif (event:getKeyCode() == hs.keycodes.map["up"]) then
      if (T.isBindKeyDown(event)) then
        if W.isTop() and (W.isLeft() or W.isRight()) then
          if W.isMaxHeight() or W.isThreeQuartersHeight() or W.isHalfHeight() or W.isQuarterHeight() then
            if W.isMaxHeight() then
              W.resizeThreeQuartersHeight()
            elseif W.isThreeQuartersHeight() then
              W.resizeHalfHeight()
            elseif W.isHalfHeight() then
              W.resizeQuarterHeight()
            elseif W.isQuarterHeight() then
              W.resizeMaxHeight()
            end
          else
            W.resizeHalfHeight()
          end
        else
          W.locateLeft()
          W.resizeMaxWidth()
          W.resizeHalfHeight()
        end
        W.locateTop()
      end
    elseif (event:getKeyCode() == hs.keycodes.map["down"]) then
      if (T.isBindKeyDown(event)) then
        if W.isBottom() and (W.isLeft() or W.isRight()) then
          if W.isMaxHeight() or W.isThreeQuartersHeight() or W.isHalfHeight() or W.isQuarterHeight() then
            if W.isMaxHeight() then
              W.resizeThreeQuartersHeight()
            elseif W.isThreeQuartersHeight() then
              W.resizeHalfHeight()
            elseif W.isHalfHeight() then
              W.resizeQuarterHeight()
            elseif W.isQuarterHeight() then
              W.resizeMaxHeight()
            end
          else
            W.resizeHalfHeight()
          end
        else
          W.locateLeft()
          W.resizeMaxWidth()
          W.resizeHalfHeight()
        end
        W.locateDown()
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

return K
