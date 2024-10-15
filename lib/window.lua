local C = require "lib/console"

local W = {}

local minDelta = 3
local keyboardResizeFactor = 0.07
local scrollResizeFactor = 0.008
local mouseResizeFactor = 0.001
local minimumWidthFactor = 2 * keyboardResizeFactor
local minimumHeightFactor = 3 * keyboardResizeFactor
local defaultWidthFactor = 1.2 / 2
local defaultWindowRatio = 11.0 / 16

local windowSizeMap = {}
local windowQuarterWidth = {}
local windowQuarterHeight = {}

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
    W.locateLeft()
    W.locateTop()
    W.resizeMax()
  else
    win:setFrame(oldFrame, 0)
    windowSizeMap[win:id()] = nil
  end
end

function W.isWidthRatio(ratio)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local minErrorSize = max.w / 100
  return (f.w <= max.w * ratio + minErrorSize) and (f.w >= max.w * ratio - minErrorSize)
end

function W.isHeightRatio(ratio)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local minErrorSize = max.h / 100
  return (f.h <= max.h * ratio + minErrorSize) and (f.h >= max.h * ratio - minErrorSize)
end

function W.isQuarterWidth()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  return W.isWidthRatio(1 / 4) or (windowQuarterWidth[win:id()] == f.w)
end

function W.isHalfWidth()
  return W.isWidthRatio(1 / 2)
end

function W.isThreeQuartersWidth()
  return W.isWidthRatio(3 / 4)
end

function W.isMaxWidth()
  return W.isWidthRatio(1)
end

function W.isQuarterHeight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  return W.isHeightRatio(1 / 4) or (windowQuarterHeight[win:id()] == f.h)
end

function W.isHalfHeight()
  return W.isHeightRatio(1 / 2)
end

function W.isThreeQuartersHeight()
  return W.isHeightRatio(3 / 4)
end

function W.isMaxHeight()
  return W.isHeightRatio(1)
end

function W.resizeWidthRatio(ratio)
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.w = max.w * ratio
    win:setFrame(f, 0)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeHeightRatio(ratio)
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.h = max.h * ratio
    win:setFrame(f, 0)
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.resizeQuarterWidth()
  local result = W.resizeWidthRatio(1 / 4)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  C.printConsole("ff.w:" .. tostring(f.w))
  windowQuarterWidth[win:id()] = f.w
  return result
end

function W.resizeHalfWidth()
  return W.resizeWidthRatio(1 / 2)
end

function W.resizeThreeQuartersWidth()
  return W.resizeWidthRatio(3 / 4)
end

function W.resizeMaxWidth()
  return W.resizeWidthRatio(1)
end

function W.resizeQuarterHeight()
  local result = W.resizeHeightRatio(1 / 4)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  C.printConsole("ff.h:" .. tostring(f.h))
  windowQuarterHeight[win:id()] = f.h
  return result
end

function W.resizeHalfHeight()
  return W.resizeHeightRatio(1 / 2)
end

function W.resizeThreeQuartersHeight()
  return W.resizeHeightRatio(3 / 4)
end

function W.resizeMaxHeight()
  return W.resizeHeightRatio(1)
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

    C.printConsole("resize before (" ..
      tostring(f.w) .. " -> " .. tostring(nextWidth) .. ", " .. tostring(f.h) .. " -> " .. tostring(nextHeight) .. ")")

    if (nextWidth < max.w * minimumWidthFactor) then nextWidth = max.w * minimumWidthFactor end
    if (nextWidth > max.w) then nextWidth = max.w end
    if (nextHeight < max.h * minimumHeightFactor) then nextHeight = max.w * minimumHeightFactor end
    if (nextHeight > max.h) then nextHeight = max.h end

    f.w = nextWidth
    f.h = nextHeight
    win:setFrame(f)

    f = win:frame()
    C.printConsole("resize after (" ..
      tostring(f.w) .. " -> " .. tostring(nextWidth) .. ", " .. tostring(f.h) .. " -> " .. tostring(nextHeight) .. ")")
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

function W.isTop()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  return f.y == max.y
end

function W.isBottom()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  return f.y == max.y + max.h - f.h
end

function W.isLeft()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  return f.x == max.x
end

function W.isRight()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  return f.x == max.x + max.w - f.w
end

function W.locateLeft()
  local status, err = pcall(function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    win:setFrame(f, 0)
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
    win:setFrame(f, 0)
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
    win:setFrame(f, 0)
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
    win:setFrame(f, 0)
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

function W.moveToPrevSpace()
  local win = hs.window.focusedWindow()
  local curScreen = win:screen()
  local curScreenId = curScreen:getUUID()
  local curSpace = hs.spaces.activeSpaceOnScreen(curScreen)
  local allSpaces = {}
  for k1, v1 in pairs(hs.spaces.allSpaces()) do
    for _, v2 in pairs(v1) do
      table.insert(allSpaces, { k1, v2 })
    end
  end
  local found = -1
  for i, v in pairs(allSpaces) do
    if v[1] == curScreenId and v[2] == curSpace then
      found = i
      break
    end
  end
  if found == -1 or found - 1 < 1 then
    return
  end
  if allSpaces[found - 1][1] == curScreenId then
    MoveWindowOneSpace('left', true)
  end
  if allSpaces[found - 1][1] ~= curScreenId then
    local max = curScreen:frame()
    W.move(-max.w, 0, 0)
    W.locateCenter()
  end
end

function W.moveToNextSpace()
  local win = hs.window.focusedWindow()
  local curScreen = win:screen()
  local curScreenId = curScreen:getUUID()
  local curSpace = hs.spaces.activeSpaceOnScreen(curScreen)
  local allSpaces = {}
  for k1, v1 in pairs(hs.spaces.allSpaces()) do
    for _, v2 in pairs(v1) do
      table.insert(allSpaces, { k1, v2 })
    end
  end
  local found = -1
  for i, v in pairs(allSpaces) do
    if v[1] == curScreenId and v[2] == curSpace then
      found = i
      break
    end
  end
  if found == -1 or found + 1 > #allSpaces then
    return
  end
  if allSpaces[found + 1][1] == curScreenId then
    MoveWindowOneSpace('right', true)
  end
  if allSpaces[found + 1][1] ~= curScreenId then
    local max = curScreen:frame()
    W.move(max.w, 0, 0)
    W.locateCenter()
  end
end

local hsee, hst = hs.eventtap.event, hs.timer
local spaces = require "hs.spaces"


function FlashScreen(screen)
  local flash = hs.canvas.new(screen:fullFrame()):appendElements({
    action = "fill",
    fillColor = { alpha = 0.35, red = 1 },
    type = "rectangle"
  })
  flash:show()
  hs.timer.doAfter(.25, function() flash:delete() end)
end

function SwitchSpace(skip, dir)
  for i = 1, skip do
    hs.eventtap.keyStroke({ "ctrl", "fn" }, dir, 0) -- "fn" is a bugfix!
  end
end

function MoveWindowOneSpace(dir, switch)
  local win = hs.window.focusedWindow()
  if not win then return end
  local screen = win:screen()
  local uuid = screen:getUUID()
  local userSpaces = nil
  for k, v in pairs(spaces.allSpaces()) do
    userSpaces = v
    if k == uuid then break end
  end
  if not userSpaces then return end

  for i, spc in ipairs(userSpaces) do
    if spaces.spaceType(spc) ~= "user" then -- skippable space
      table.remove(userSpaces, i)
    end
  end
  if not userSpaces then return end

  local initialSpace = spaces.windowSpaces(win)
  if not initialSpace then return else initialSpace = initialSpace[1] end
  local currentCursor = hs.mouse.getRelativePosition()

  if (dir == "right" and initialSpace == userSpaces[#userSpaces]) or
      (dir == "left" and initialSpace == userSpaces[1]) then
    FlashScreen(screen) -- End of Valid Spaces
  else
    local zoomPoint = hs.geometry(win:zoomButtonRect())
    local safePoint = zoomPoint:move({ -1, -1 }).topleft
    hsee.newMouseEvent(hsee.types.leftMouseDown, safePoint):post()
    SwitchSpace(1, dir)
    hst.waitUntil(
      function() return spaces.windowSpaces(win)[1] ~= initialSpace end,
      function()
        hsee.newMouseEvent(hsee.types.leftMouseUp, safePoint):post()
        hs.mouse.setRelativePosition(currentCursor)
      end, 0.05)
  end
end

return W
