local console = {}

console.printConsole = function(msg)
  print(msg)
end

console.printError = function(err)
  print(tostring(err))
end

return console
