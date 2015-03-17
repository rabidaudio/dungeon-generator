
Map = require './map'

module.exports = class Room extends Map
  constructor: (width, height) ->
    super
    @populate()

  location: undefined
  dungeon: undefined

  hasDoorOnSide: (direction)->
    for [x, y] in @getSide(direction)
      return true if @getCell(x,y).doorCount() > 0
    return false