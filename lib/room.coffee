Map = require './map'
TYPES = require './types'
DIRECTONS = require './directions'

module.exports = class Room extends Map
  constructor: (width, height) ->
    super(width, height, {})
    @makeWalls()
    @location = undefined
    @dungeon = undefined

  hasDoorOnSide: (direction)->
    for [x, y] in @getSide direction
      return true if @get(x,y).doorCount() > 0
    return false

  makeWalls: ->
    for direction in DIRECTONS
      for [x,y] in @getSide direction
        @get(x,y).setSide direction, TYPES.WALL

    # for cell, index in @data
    #   [x, y] = @coordsAt index
    #   c = {}
    #   c.north = TYPES.WALL if y is 0
    #   c.south = TYPES.WALL if y is @height - 1
    #   c.west  = TYPES.WALL if x is 0
    #   c.east  = TYPES.WALL if x is @width - 1
    #   @update x, y, c if c.north or c.south or c.east or c.west

  makeCorridor: -> c.corridor = true for c in @data