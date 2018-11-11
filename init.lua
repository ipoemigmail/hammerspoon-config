local bindKeys = {"cmd", "ctrl"}
local resizeFactor = 0.07
local minimumWidthFactor = 2 * resizeFactor
local minimumHeightFactor = 3 * resizeFactor
local defaultWidthFactor = 3.5 / 5
local defaultWindowRatio = 10.0 / 16

function printConsole(msg)
  --print(msg)
end

function printError(err)
  print(tostring(err))
end

function resizeMax()
  resizeMaxWidth()
  resizeMaxHeight()
end

function resizeHalfWidth()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.w = max.w / 2
  win:setFrame(f)
end

function resizeMaxWidth()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.w = max.w
  win:setFrame(f)
end

function resizeHalfHeight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h / 2
  win:setFrame(f)
end

function resizeMaxHeight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h
  win:setFrame(f)
end

function locateLeft()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  win:setFrame(f)
end

function locateTop()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.y
  win:setFrame(f)
end

function locateRight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.w - f.w
  win:setFrame(f)
end

function locateDown()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.h - f.h
  win:setFrame(f)
end

function resizeLarger()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local nextWidth = f.w + (max.w * resizeFactor)
  local nextHeight = f.h + (max.h * resizeFactor)

  f.x = f.x
  f.y = f.y
  f.w = math.min(nextWidth, max.w)
  f.h = math.min(nextHeight, max.h)
  win:setFrame(f)
end

function resizeSmaller()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local nextWidth = f.w - (max.w * resizeFactor)
  local nextHeight = f.h - (max.h * resizeFactor)

  f.x = f.x
  f.y = f.y
  if (nextWidth > (max.w * minimumWidthFactor) and nextHeight > (max.h * minimumHeightFactor)) then
    f.w = nextWidth
    f.h = nextHeight
  end
  win:setFrame(f)
end

function locateCenter()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local nextX = max.x + max.w / 2 - (f.w / 2)
  local nextY = max.y + max.h / 2 - (f.h / 2)

  f.x = nextX
  f.y = nextY
  win:setFrame(f)
end

function resizeDefault()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = f.x
  f.y = f.y
  f.w = max.w * defaultWidthFactor
  f.h = f.w * defaultWindowRatio
  win:setFrame(f)
end

function moveWindow(deltaX, deltaY, duration)
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + deltaX
  f.y = f.y + deltaY
  win:setFrame(f, duration)
end

hs.hotkey.bind(bindKeys, "=", function()
  resizeLarger()
  locateCenter()
end)

hs.hotkey.bind(bindKeys, "-", function()
  resizeSmaller()
  locateCenter()
end)

hs.hotkey.bind(bindKeys, "c", function()
  locateCenter()
end)

hs.hotkey.bind(bindKeys, "return", function()
  resizeDefault()
  locateCenter()
end)

local events = hs.eventtap.event.types
local eventProperties = hs.eventtap.event.properties

function isCurrentWindowMax()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  printConsole("f: " .. tostring(f))
  printConsole("max: " .. tostring(max))
  if (f.x == max.x and f.y == max.y and
      (f.w <= max.w and f.w >= max.w - (resizeFactor * max.w)) and
      (f.h <= max.h and f.h >= max.h - (resizeFactor * max.h))
      ) then
    return true
  else
    return false
  end

end

function isBindKeyDown(event)
  local flag = true
  local status, err = pcall(function()
    for i, key in ipairs(bindKeys) do
      flag = flag and event:getFlags()[key]
    end
    return flag
  end)
  if (not status) then
    printError(err)
    return false
  else
    return err
  end
end

hs.eventtap.new({events.leftMouseDown}, function(event)
  local status, err = pcall(function()
    if (event:getProperty(eventProperties["mouseEventClickState"]) == 2 and isBindKeyDown(event)) then
      local win = hs.window.focusedWindow()
      local f = win:frame()
      local screen = win:screen()
      local max = screen:frame()
      if (isCurrentWindowMax()) then
        resizeDefault() 
        locateCenter()
      else
        resizeMax()
        locateLeft()
        locateTop()
      end
      return true
    elseif (isBindKeyDown(event)) then
      printConsole("cmd+alt+click")
      return true
    end
  end)
  if (not status) then
    printError(err)
  end
  return err

end):start()

hs.eventtap.new({events.leftMouseDragged}, function(event)
  local status, err = pcall(function()
    if (isBindKeyDown(event)) then
      printConsole("left drag: " .. tostring(event:getProperty(eventProperties["mouseEventDeltaX"])) .. ", " .. tostring(event:getProperty(eventProperties["mouseEventDeltaY"])))
      moveWindow(event:getProperty(eventProperties["mouseEventDeltaX"]), event:getProperty(eventProperties["mouseEventDeltaY"]), 0)
      return true
    end
  end)
  if (not status) then
    printError(err)
    return false
  else
    return err
  end

end):start()

local leftKeyDown = false
local rightKeyDown = false
local upKeyDown = false
local downKeyDown = false

hs.eventtap.new({events.keyDown}, function(event)
  local status, err = pcall(function()
    printConsole("keyDown: " .. tostring(event:getKeyCode()))
    if (event:getKeyCode() == hs.keycodes.map["left"]) then
      leftKeyDown = true
      if (isBindKeyDown(event)) then
        resizeHalfWidth()
        resizeMaxHeight()
        locateLeft()
        locateTop()
        if (upKeyDown) then
          resizeHalfHeight()
          printConsole("left + up")
        elseif (downKeyDown) then
          resizeHalfHeight()
          locateDown()
          printConsole("left + down")
        end
        return true
      end
    elseif (event:getKeyCode() == hs.keycodes.map["right"]) then
      rightKeyDown = true
      if (isBindKeyDown(event)) then
        resizeHalfWidth()
        resizeMaxHeight()
        locateRight()
        locateTop()
        if (upKeyDown) then
          resizeHalfHeight()
          printConsole("right + up")
        elseif (downKeyDown) then
          resizeHalfHeight()
          locateDown()
          printConsole("right + down")
        end
        return true
      end
    elseif (event:getKeyCode() == hs.keycodes.map["up"]) then
      upKeyDown = true
      if (isBindKeyDown(event)) then
        resizeHalfHeight()
        resizeMaxWidth()
        locateTop()
        locateLeft()
        if (leftKeyDown) then
          resizeHalfWidth()
          printConsole("right + up")
        elseif (rightKeyDown) then
          resizeHalfWidth()
          locateRight()
          printConsole("left + up")
        end
        return true
      end
    elseif (event:getKeyCode() == hs.keycodes.map["down"]) then
      downKeyDown = true
      if (isBindKeyDown(event)) then
        resizeHalfHeight()
        resizeMaxWidth()
        locateDown()
        if (leftKeyDown) then
          resizeHalfWidth()
          printConsole("right + down")
        elseif (rightKeyDown) then
          resizeHalfWidth()
          locateRight()
          printConsole("left + down")
        end
        return true
      end
    end
  end)
  if (not status) then
    printError(err)
    return false
  else
    return err
  end

end):start()

hs.eventtap.new({events.keyUp}, function(event)
  local status, err = pcall(function()
    printConsole("keyUp: " .. tostring(event:getKeyCode()))
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
    printError(err)
    return false
  else
    return err
  end

end):start()
