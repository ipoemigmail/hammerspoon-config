local C = require "console"

local W = {}

local resizeFactor = 0.07
local minimumWidthFactor = 2 * resizeFactor
local minimumHeightFactor = 3 * resizeFactor
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
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.w = max.w / 2
  win:setFrame(f)
end

function W.resizeMaxWidth()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.w = max.w
  win:setFrame(f)
end

function W.resizeHalfHeight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h / 2
  win:setFrame(f)
end

function W.resizeMaxHeight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h
  win:setFrame(f)
end

function W.locateLeft()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  win:setFrame(f)
end

function W.locateTop()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.y
  win:setFrame(f)
end

function W.locateRight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.w - f.w
  win:setFrame(f)
end

function W.locateDown()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.h - f.h
  win:setFrame(f)
end

function W.resizeLarger()
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

function W.resizeSmaller()
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

function W.locateCenter()
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

function W.resizeDefault()
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

function W.move(deltaX, deltaY, duration)
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + deltaX
  f.y = f.y + deltaY
  win:setFrame(f, duration)
end

function W.isCurrentWindowMax()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  C.printConsole("f: " .. tostring(f))
  C.printConsole("max: " .. tostring(max))
  if (f.x == max.x and f.y == max.y and
      (f.w <= max.w and f.w >= max.w - (resizeFactor * max.w)) and
      (f.h <= max.h and f.h >= max.h - (resizeFactor * max.h))
      ) then
    return true
  else
    return false
  end

end

return W