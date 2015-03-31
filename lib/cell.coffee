DIRECTONS = require './directions'
TYPES = require './types'


module.exports = class Cell
  ###
    @constructor
    @param {Object} data - The state to initialize the cell with. Keys are DIRECTIONS and
      values are TYPES. For example:
        {
          'north': 'wall',
          'east': 'door'
        }
      Any unspecified directions will be set to 'empty'.
  ###
  constructor: (data=null) ->
    if data?
      for direction in DIRECTONS
        @[direction] = data[direction] or TYPES.EMPTY
      @blank = false
    else
      @blank = true

  isDeadEnd: -> @wallCount() is 3

  wallCount: -> 
    walls = 0
    (walls++ if @[d] is TYPES.WALL) for d in DIRECTONS
    walls

  doorCount: ->
    doors = 0
    (doors++ if @[d] is TYPES.DOOR) for d in DIRECTONS
    doors

  isEmpty: -> @wallCount()+@doorCount() is 0

  makeCorridor: (direction) ->
    switch direction
      when DIRECTONS.NORTH, DIRECTONS.SOUTH
        @[DIRECTONS.EAST] = @[DIRECTONS.WEST] = TYPES.WALL
      when DIRECTONS.NORTH, DIRECTONS.SOUTH
        @[DIRECTONS.EAST] = @[DIRECTONS.WEST] = TYPES.WALL
    @corridor = true
    @blank = false

  deadEndDirection: ->
    return false unless @isDeadEnd()
    for d in DIRECTONS
      return d if @[d] is TYPES.EMPTY

  # set: (direction, type) -> @[direction] = type if direction in DIRECTONS

  # notBlank: -> not @blank

  setSide: (direction, value) ->
    @[direction] = value
    @blank = false

  update: (d) ->
    for direction in DIRECTONS
      @[direction] = if d[direction]? then d[direction] else TYPES.EMPTY
    @blank = false

  visit: -> @visited = true

  clearVisits: -> @visited = false