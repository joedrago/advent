fs = require 'fs'

bailOut = (reason) ->
  console.log(reason)
  process.exit(0)

class CalorieList
  constructor: ->
    @list = []

  load: (filename) ->
    if not fs.existsSync(filename)
      bailOut "Can't find file: #{filename}"
    lines = fs.readFileSync(filename, "utf8").split(/[\r\n]/)

    elf = null
    for line in lines
      if line.length == 0
        elf = null
      else
        if not elf?
          elf =
            index: @list.length
            calories: 0
          @list.push elf
        elf.calories += parseInt(line)

  dump: ->
    for elf in @list
      console.log "Elf ##{elf.index+1}: #{elf.calories} calories"

  top: ->
    if @list.length < 1
      return null
    sorted = @list.slice(0).sort (a, b) ->
      b.calories - a.calories
    return sorted

main = (argv) ->
  if argv.length != 1
    bailOut "Syntax: calories.coffee [calories.txt]"

  list = new CalorieList
  list.load(argv[0])

  topElves = list.top()
  console.log "Top Elves:"
  total = 0
  for elf, elfIndex in topElves
    if elfIndex > 2
      break
    total += elf.calories
    console.log " * Elf ##{elf.index}: #{elf.calories}"
  console.log " = #{total} total"

main(process.argv.slice(2))
