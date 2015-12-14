Direction = require './direction'
Type = require './type'

###
  An individual location on a Map. Has 4 sides `['north', 'south', 'east', 'west']`
  which will be one of `['door', 'wall', 'empty']` unless `isBlank()`
###
module.exports = class Cell
  ###
    @param {Object} data - The state to initialize the cell with. Keys are Direction and
      values are Type. For example:
        {
          'north': 'wall',
          'east': 'door'
        }
      Any unspecified Direction will be set to 'empty'.
      If it is omitted, the cell will be marked as blank and none of the Direction
      will be set.
  ###
  constructor: (data=null) ->
    if data? then @update(data) else @_blank = true
    @corridor = false

  isDeadEnd: -> @wallCount() is 3

  isEmpty: -> @wallCount()+@doorCount() is 0

  isBlank: -> @_blank

  isVisited: -> @_visited

  wallCount: -> @typeCount Type.WALL

  doorCount: -> @typeCount Type.DOOR 

  typeCount: (type) ->
    count = 0
    (count++ if @[d] is type) for d in Direction
    return count

  deadEndDirection: ->
    return false unless @isDeadEnd()
    for d in Direction
      return d if @[d] is Type.EMPTY

  setSide: (direction, value) ->
    @[direction] = value
    @_blank = false

  update: (data) ->
    for direction in Direction
      @[direction] = if data[direction]? then data[direction] else Type.EMPTY
    @_blank = false

  ###
    Return a 3x3 character representation of the cell
  ###
  print: ->
    return "▒▒▒\n▒▒▒\n▒▒▒\n" if @isBlank() or @wallCount() is 4
    cell = new Array(9)
    #center
    if @corridor then cell[4] = "c" else cell[4] = "*"
    #edges
    cell[1] = switch @[Direction.NORTH]
      when Type.WALL  then "─"
      when Type.DOOR  then "~"
      when Type.EMPTY then " "
    cell[7] = switch @[Direction.SOUTH]
      when Type.WALL  then "─"
      when Type.DOOR  then "~"
      when Type.EMPTY then " "
    cell[3] = switch @[Direction.WEST]
      when Type.WALL  then "│"
      when Type.DOOR  then "~"
      when Type.EMPTY then " "
    cell[5] = switch @[Direction.EAST]
      when Type.WALL  then "│"
      when Type.DOOR  then "~"
      when Type.EMPTY then " "
    #corners
    if @[Direction.NORTH] isnt Type.EMPTY and @[Direction.WEST] isnt Type.EMPTY then cell[0] = "┌"
    else if @[Direction.NORTH] isnt Type.EMPTY then cell[0] = "─"
    else if @[Direction.WEST]  isnt Type.EMPTY then cell[0] = "│"
    else cell[0] = " "
    if @[Direction.SOUTH] isnt Type.EMPTY and @[Direction.WEST] isnt Type.EMPTY then cell[6] = "└"
    else if @[Direction.SOUTH] isnt Type.EMPTY then cell[6] = "─"
    else if @[Direction.WEST]  isnt Type.EMPTY then cell[6] = "│"
    else cell[6] = " "
    if @[Direction.SOUTH] isnt Type.EMPTY and @[Direction.EAST] isnt Type.EMPTY then cell[8] = "┘"
    else if @[Direction.SOUTH] isnt Type.EMPTY then cell[8] = "─"
    else if @[Direction.EAST]  isnt Type.EMPTY then cell[8] = "│"
    else cell[8] = " "
    if @[Direction.NORTH] isnt Type.EMPTY and @[Direction.EAST] isnt Type.EMPTY then cell[2] = "┐"
    else if @[Direction.NORTH] isnt Type.EMPTY then cell[2] = "─"
    else if @[Direction.EAST]  isnt Type.EMPTY then cell[2] = "│"
    else cell[2] = " "
    return [cell[0..2].join(""), cell[3..5].join(""), cell[6..8].join("")].join("\n")