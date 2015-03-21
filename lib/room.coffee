Map = require './map'
TYPES = require './types'

module.exports = class Room extends Map
  constructor: (width, height) ->
    super
    @makeWalls()

  location: undefined
  dungeon: undefined

  hasDoorOnSide: (direction)->
    for [x, y] in @getSide(direction)
      return true if @getCell(x,y).doorCount() > 0
    return false

  makeWalls: ->
    @forAllLocations (x,y) =>
      c = {}
      c.north = TYPES.WALL if y is 0
      c.south = TYPES.WALL if y is @height - 1
      c.west  = TYPES.WALL if x is 0
      c.east  = TYPES.WALL if x is @width - 1
      @updateCell x, y, c

  makeCorridor: -> @forAllLocations (x,y,c) -> c.corridor = true