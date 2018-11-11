local C = require "console"

local trigger = {}

function bindKeys()
  return {"cmd", "ctrl"}
end

trigger["bindKeys"] = bindKeys

function trigger.isBindKeyDown(event)
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
