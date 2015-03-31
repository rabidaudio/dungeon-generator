DIRECTONS = require './directions'
TYPES = require './types'

###
  An individual location on a Map. Has 4 sides `['north', 'south', 'east', 'west']`
  which will be one of `['door', 'wall', 'empty']` unless `isBlank()`
###
module.exports = class Cell
  ###
    @param {Object} data - The state to initialize the cell with. Keys are DIRECTIONS and
      values are TYPES. For example:
        {
          'north': 'wall',
          'east': 'door'
        }
      Any unspecified directions will be set to 'empty'.
      If it is omitted, the cell will be marked as blank and none of the directions
      will be set.
  ###
  constructor: (data=null) -> if data? then @update(data) else @_blank = true

  isDeadEnd: -> @wallCount() is 3

  isEmpty: -> @wallCount()+@doorCount() is 0

  isBlank: -> @_blank

  isVisited: -> @_visited

  wallCount: -> @typeCount TYPES.WALL

  doorCount: -> @typeCount TYPES.DOOR 

  typeCount: (type) ->
    count = 0
    (count++ if @[d] is type) for d in DIRECTONS
    count

  deadEndDirection: ->
    return false unless @isDeadEnd()
    for d in DIRECTONS
      return d if @[d] is TYPES.EMPTY

  setSide: (direction, value) ->
    @[direction] = value
    @_blank = false

  update: (data) ->
    for direction in DIRECTONS
      @[direction] = if data[direction]? then data[direction] else TYPES.EMPTY
    @_blank = false

  ###
    Return a 3x3 character representation of the cell
  ###
  print: ->
    return "▒▒▒\n▒▒▒\n▒▒▒\n" if @isBlank()
    cell = new Array(9)
    #center
    cell[4] = "*"
    #edges
    cell[1] = switch @[DIRECTONS.NORTH]
      when TYPES.WALL  then "─"
      when TYPES.DOOR  then "~"
      when TYPES.EMPTY then " "
    cell[7] = switch @[DIRECTONS.SOUTH]
      when TYPES.WALL  then "─"
      when TYPES.DOOR  then "~"
      when TYPES.EMPTY then " "
    cell[3] = switch @[DIRECTONS.WEST]
      when TYPES.WALL  then "│"
      when TYPES.DOOR  then "~"
      when TYPES.EMPTY then " "
    cell[5] = switch @[DIRECTONS.EAST]
      when TYPES.WALL  then "│"
      when TYPES.DOOR  then "~"
      when TYPES.EMPTY then " "
    #corners
    if @[DIRECTONS.NORTH] isnt TYPES.EMPTY and @[DIRECTIONS.WEST] isnt TYPES.EMPTY then cell[0] = "┌"
    else if @[DIRECTIONS.NORTH] isnt TYPES.EMPTY then cell[0] = "─"
    else if @[DIRECTIONS.WEST]  isnt TYPES.EMPTY then cell[0] = "│"
    else cell[0] = " "
    if @[DIRECTONS.SOUTH] isnt TYPES.EMPTY and @[DIRECTIONS.WEST] isnt TYPES.EMPTY then cell[6] = "└"
    else if @[DIRECTIONS.SOUTH] isnt TYPES.EMPTY then cell[6] = "─"
    else if @[DIRECTIONS.WEST]  isnt TYPES.EMPTY then cell[6] = "│"
    else cell[6] = " "
    if @[DIRECTONS.SOUTH] isnt TYPES.EMPTY and @[DIRECTIONS.EAST] isnt TYPES.EMPTY then cell[8] = "┘"
    else if @[DIRECTIONS.SOUTH] isnt TYPES.EMPTY then cell[8] = "─"
    else if @[DIRECTIONS.EAST]  isnt TYPES.EMPTY then cell[8] = "│"
    else cell[8] = " "
    if @[DIRECTONS.NORTH] isnt TYPES.EMPTY and @[DIRECTIONS.EAST] isnt TYPES.EMPTY then cell[2] = "┐"
    else if @[DIRECTIONS.NORTH] isnt TYPES.EMPTY then cell[2] = "─"
    else if @[DIRECTIONS.EAST]  isnt TYPES.EMPTY then cell[2] = "│"
    else cell[2] = " "
    return [cell[0..2].join(""), cell[3..5].join(""), cell[6..8].join("")].join("\n")