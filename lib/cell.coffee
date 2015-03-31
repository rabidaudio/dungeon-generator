DIRECTONS = require './directions'
TYPES = require './types'

module.exports = class Cell

  constructor: (d=null, @corridor=false) ->
    if d?
      for direction in DIRECTONS
        this[direction] = d[direction] or TYPES.EMPTY
      @blank = false
    else
      @blank = true

  isDeadEnd: -> @wallCount() is 3

  wallCount: -> 
    walls = 0
    (walls++ if this[d] is TYPES.WALL) for d in DIRECTONS
    walls

  doorCount: ->
    doors = 0
    (doors++ if this[d] is TYPES.DOOR) for d in DIRECTONS
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
      return d if this[d] is TYPES.EMPTY

  # set: (direction, type) -> this[direction] = type if direction in DIRECTONS

  notBlank: -> not @blank

  update: (d) ->
    for direction in DIRECTONS
      this[direction] = if d[direction]? then d[direction] else TYPES.EMPTY
    @blank = false

  visit: -> @visited = true

  clearVisits: -> @visited = false