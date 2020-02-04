local C = require "lib/console"

local trigger = {}

bindKeys = function()
  return {"alt", "ctrl"}
end

trigger.bindKeys = bindKeys

trigger.isBindKeyDown = function(event)
  local flag = true
  local status, err = pcall(function()
    for i, key in ipairs(bindKeys()) do
      flag = flag and event:getFlags()[key]
    end
    return flag
  end)
  if (not status) then
    C.printError(err)
    return false
  else
    return err
  end
end

return trigger
