local C = require "lib/console"

local W = {}

local minDelta = 3
local keyboardResizeFactor = 0.07
local scrollResizeFactor = 0.008
local mouseResizeFactor = 0.001
local minimumWidthFactor = 2 * keyboardResizeFactor
local minimumHeightFactor = 3 * keyboardResizeFactor
local defaultWidthFactor = 1.3 / 2
local defaultWindowRatio = 10.0 / 16

local windowSizeMap = {}

function W.resizeMax()
  W.resizeMaxWidth()
  W.resizeMaxHeight()
end

function W.toggleMax()
  local win = hs.window.focusedWindow()
  local oldFrame = windowSizeMap[win:id()]
  C.printConsole("oldFrame: " .. tostring(oldFrame))
  if (oldFrame == nil or not W.isCurrentWindowMax()) then
    windowSizeMap[win:id()] = win:frame()
    W.resizeMax()
    W.locateLeft()
    W.locateTop()
  else
    W.resize(oldFrame.w, oldFrame.h)
    windowSizeMap[win:id()] = nil
    W.locateCenter()
  end
end

function W.isHalfWidth()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local minErrorSize = max.w / 1000

  return (f.w <= max.w / 2 + minErrorSize) and (f.w >= max.w / 2 - minErrorSize)
end

function W.resizeQuarterWidth()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w / 4
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeHalfWidth()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w / 2
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeMaxWidth()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.isHalfHeight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local minErrorSize = max.h / 1000

  return (f.h <= max.h / 2 + minErrorSize) and (f.h >= max.h / 2 - minErrorSize)
end

function W.resizeQuarterHeight()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.h = max.h / 4
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeHalfHeight()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.h = max.h / 2
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeMaxHeight()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.h = max.h
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeDelta(deltaX, deltaY, duration)
  W.resizeDeltaWithFactor(deltaX, deltaY, keyboardResizeFactor, duration)
end

function W.resizeWithMouse(deltaX, deltaY, duration)
  W.resizeDeltaWithFactor(deltaX, deltaY, mouseResizeFactor, duration)
end

function W.resizeWithScroll(deltaX, deltaY, duration)
  W.resizeDeltaWithFactor(deltaX, deltaY, scrollResizeFactor, duration)
end

function W.resize(width, height, duration)
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    f.w = width 
    f.h = height
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function sign(x)
  return (x < 0 and -1) or 1
end

--function W.resizeWithFactor(deltaX, deltaY, factor, duration)
--  local status, err = pcall(function()
--    if (deltaX == 0 and deltaY == 0) then return end
--    local win = hs.window.focusedWindow()
--    local f = win:frame()
--    local screen = win:screen()
--    local max = screen:frame()
--
--    local nextWidth = deltaX * factor * max.w + f.w
--    local nextHeight = deltaY * factor * max.h + f.h
--
--    if ((not deltaX == 0) and math.abs(f.w - nextWidth) < minDelta) then
--      nextWidth = f.w + sign(deltaX) * minDelta
--    end
--
--    if ((not deltaY == 0) and math.abs(f.h - nextHeight) < minDelta) then
--      nextHeight = f.h + sign(deltaY) * minDelta
--    end
--
--    if (factor == nil) then
--      nextWidth = deltaX + f.w
--      nextHeight = deltaY + f.h
--    end
--
--    C.printConsole("resize (" .. tostring(f.w) .. " -> " .. tostring(nextWidth) .. ", " .. tostring(f.h) .. " -> " .. tostring(nextHeight) .. ")")
--
--    --if (nextWidth < max.w * minimumWidthFactor) then nextWidth = max.w * minimumWidthFactor end
--    --if (nextWidth > max.w) then nextWidth = max.w end
--    --if (nextHeight < max.h * minimumHeightFactor) then nextHeight = max.w * minimumHeightFactor end
--    --if (nextHeight > max.h) then nextHeight = max.h end
--
--    f.w = nextWidth
--    f.h = nextHeight
--    win:setFrame(f, duration)
--  end)
--  if (not status) then
--    C.printError(err)
--    return false
--  else
--    return err
--  end
--end

function W.resizeDeltaWithFactor(deltaX, deltaY, factor, duration)
  local status, err = pcall(function()
    if (deltaX == 0 and deltaY == 0) then return end
    local win = hs.window.focusedWindow()
    local f = win:frame()
    C.printConsole("f: " .. tostring(f))
    local screen = win:screen()
    local max = screen:frame()

    local nextWidth = deltaX * factor * max.w + f.w
    local nextHeight = deltaY * factor * max.h + f.h

    if ((not deltaX == 0) and math.abs(f.w - nextWidth) < minDelta) then
      nextWidth = f.w + sign(deltaX) * minDelta
    end

    if ((not deltaY == 0) and math.abs(f.h - nextHeight) < minDelta) then
      nextHeight = f.h + sign(deltaY) * minDelta
    end

    if (factor == nil) then
      nextWidth = deltaX + f.w
      nextHeight = deltaY + f.h
    end

    C.printConsole("resize before (" .. tostring(f.w) .. " -> " .. tostring(nextWidth) .. ", " .. tostring(f.h) .. " -> " .. tostring(nextHeight) .. ")")

    if (nextWidth < max.w * minimumWidthFactor) then nextWidth = max.w * minimumWidthFactor end
    if (nextWidth > max.w) then nextWidth = max.w end
    if (nextHeight < max.h * minimumHeightFactor) then nextHeight = max.w * minimumHeightFactor end
    if (nextHeight > max.h) then nextHeight = max.h end

    f.w = nextWidth
    f.h = nextHeight
    win:setFrame(f)

    f = win:frame()
    C.printConsole("resize after (" .. tostring(f.w) .. " -> " .. tostring(nextWidth) .. ", " .. tostring(f.h) .. " -> " .. tostring(nextHeight) .. ")")
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end


function W.locateLeft()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.locateTop()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.y = max.y
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.locateRight()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x + max.w - f.w
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.locateDown()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.y = max.y + max.h - f.h
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeLarger()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local nextWidth = f.w + (max.w * keyboardResizeFactor)
    local nextHeight = f.h + (max.h * keyboardResizeFactor)

    f.x = f.x
    f.y = f.y
    f.w = math.min(nextWidth, max.w)
    f.h = math.min(nextHeight, max.h)
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeSmaller()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local nextWidth = f.w - (max.w * keyboardResizeFactor)
    local nextHeight = f.h - (max.h * keyboardResizeFactor)

    f.x = f.x
    f.y = f.y
    if (nextWidth > (max.w * minimumWidthFactor) and nextHeight > (max.h * minimumHeightFactor)) then
      f.w = nextWidth
      f.h = nextHeight
    end
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.locateCenter()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local nextX = max.x + max.w / 2 - (f.w / 2)
    local nextY = max.y + max.h / 2 - (f.h / 2)

    f.x = nextX
    f.y = nextY
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeDefault()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = f.x
    f.y = f.y
    f.w = max.w * defaultWidthFactor
    f.h = f.w * defaultWindowRatio
    win:setFrame(f)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.move(deltaX, deltaY, duration)
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()

    f.x = f.x + deltaX
    f.y = f.y + deltaY
    win:setFrame(f, duration)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.isCurrentWindowMax()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    C.printConsole("f: " .. tostring(f))
    C.printConsole("max: " .. tostring(max))

    if (f.x == max.x and f.y == max.y and
        (f.w <= max.w and f.w >= max.w - (keyboardResizeFactor * max.w)) and
        (f.h <= max.h and f.h >= max.h - (keyboardResizeFactor * max.h))
        ) then
      return true
    else
      return false
    end
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end

end

return W
