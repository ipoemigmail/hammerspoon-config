require "lib/autoreload"
local C = require "lib/console"
local T = require "lib/trigger"
local W = require "lib/window"
local M = require "lib/mouse"

hs.hotkey.bind(T.bindKeys(), "=", function()
  W.resizeLarger()
end)

hs.hotkey.bind(T.bindKeys(), "-", function()
  W.resizeSmaller()
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
