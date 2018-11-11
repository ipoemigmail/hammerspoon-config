local C = require "console"
local T = require "trigger"
local W = require "window"
local M = require "mouse"

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
