Map = require './map'
Type = require './type'
Direction = require './direction'

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
    for direction in Direction
      for [x,y] in @getSide direction
        @get(x,y).setSide direction, Type.WALL

    # for cell, index in @data
    #   [x, y] = @coordsAt index
    #   c = {}
    #   c.north = Type.WALL if y is 0
    #   c.south = Type.WALL if y is @height - 1
    #   c.west  = Type.WALL if x is 0
    #   c.east  = Type.WALL if x is @width - 1
    #   @update x, y, c if c.north or c.south or c.east or c.west

  makeCorridor: -> c.corridor = true for c in @data