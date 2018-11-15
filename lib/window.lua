local C = require "lib/console"

local W = {}

local keyboardResizeFactor = 0.07
local scrollResizeFactor = 0.008
local mouseResizeFactor = 0.001
local minimumWidthFactor = 2 * keyboardResizeFactor
local minimumHeightFactor = 3 * keyboardResizeFactor
local defaultWidthFactor = 3.5 / 5
local defaultWindowRatio = 10.0 / 16

function W.resizeMax()
  W.resizeMaxWidth()
  W.resizeMaxHeight()
end

function W.toggleMax()
  if (W.isCurrentWindowMax()) then
    W.resizeDefault() 
    W.locateCenter()
  else
    W.resizeMax()
    W.locateLeft()
    W.locateTop()
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

function W.resize(deltaX, deltaY, duration)
  W.resizeWithFactor(deltaX, deltaY, keyboardResizeFactor, duration)
end

function W.resizeWithMouse(deltaX, deltaY, duration)
  W.resizeWithFactor(deltaX, deltaY, mouseResizeFactor, duration)
end

function W.resizeWithScroll(deltaX, deltaY, duration)
  W.resizeWithFactor(deltaX, deltaY, scrollResizeFactor, duration)
end

function W.resizeWithFactor(deltaX, deltaY, factor, duration)
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local nextWidth = deltaX * factor* max.w + f.w
    local nextHeight = deltaY * factor * max.h + f.h

    if (factor == 0) then
      nextWidth = deltaX + f.w
      nextHeight = deltaY+ f.h
    end

    if (nextWidth < max.w * minimumWidthFactor) then nextWidth = max.w * minimumWidthFactor end
    if (nextWidth > max.w) then nextWidth = max.w end
    if (nextHeight < max.w * minimumHeightFactor) then nextHeight = max.w * minimumHeightFactor end
    if (nextHeight > max.w) then nextHeight = max.w end

    f.w = nextWidth
    f.h = nextHeight
    win:setFrame(f, duration)
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

    f.x = max.w - f.w
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

    f.y = max.h - f.h
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
