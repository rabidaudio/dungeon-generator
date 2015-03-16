
Map = require './map'

module.exports = class Dungeon extends Map

  rooms: []

  addRoom: (room) ->
    @rooms.push room

  adjacentIsCorridor: (x, y, direction) ->
    @getAdjacentCell(x,y,direction).corridor?

  createSide: (x, y, direction, type) ->
    throw "Can't place a cell at #{x}, #{y}: Out of bounds" if not @inBounds x,y
    @getCell(x,y).set direction, type