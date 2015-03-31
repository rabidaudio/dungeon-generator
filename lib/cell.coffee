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

  makeCorridor: (direction) ->
    switch direction
      when DIRECTONS.NORTH, DIRECTONS.SOUTH
        @[DIRECTONS.EAST] = @[DIRECTONS.WEST] = TYPES.WALL
      when DIRECTONS.NORTH, DIRECTONS.SOUTH
        @[DIRECTONS.EAST] = @[DIRECTONS.WEST] = TYPES.WALL
    @corridor = true
    @_blank = false

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
    Do not call this directly. Use `VisitableMap::visitCell()`
    @private
  ###
  visit: -> @_visited = true

  clearVisits: -> @_visited = false