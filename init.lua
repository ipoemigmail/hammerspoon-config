require "lib/autoreload"
local C = require "lib/console"
local T = require "lib/trigger"
local W = require "lib/window"
local M = require "lib/mouse"
local K = require "lib/keyboard"

hs.hotkey.bind(T.bindKeys(), "=", function()
  W.resizeLarger()
  W.locateCenter()
end)

hs.hotkey.bind(T.bindKeys(), "-", function()
  W.resizeSmaller()
  W.locateCenter()
end)

hs.hotkey.bind(T.bindKeys(), "c", function()
  W.locateCenter()
end)

hs.hotkey.bind(T.bindKeys(), "delete", function()
  W.resizeDefault()
  W.locateCenter()
end)

hs.hotkey.bind(T.bindKeys(), "return", function()
  W.toggleMax()
end)
