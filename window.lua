local C = require "console"

local window = {}

local resizeFactor = 0.07
local minimumWidthFactor = 2 * resizeFactor
local minimumHeightFactor = 3 * resizeFactor
local defaultWidthFactor = 3.5 / 5
local defaultWindowRatio = 10.0 / 16

function window.resizeMax()
  window.resizeMaxWidth()
  window.resizeMaxHeight()
end

function window.resizeHalfWidth()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.w = max.w / 2
  win:setFrame(f)
end

function window.resizeMaxWidth()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.w = max.w
  win:setFrame(f)
end

function window.resizeHalfHeight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h / 2
  win:setFrame(f)
end

function window.resizeMaxHeight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h
  win:setFrame(f)
end

function window.locateLeft()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  win:setFrame(f)
end

function window.locateTop()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.y
  win:setFrame(f)
end

function window.locateRight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.w - f.w
  win:setFrame(f)
end

function window.locateDown()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = max.h - f.h
  win:setFrame(f)
end

function window.resizeLarger()
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

function window.resizeSmaller()
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

function window.locateCenter()
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

function window.resizeDefault()
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

function window.move(deltaX, deltaY, duration)
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + deltaX
  f.y = f.y + deltaY
  win:setFrame(f, duration)
end

function window.isCurrentWindowMax()
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

return window
