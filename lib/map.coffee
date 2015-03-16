ArrayGrid = require 'array-grid'
Cell = require './cell'

module.exports = class Map
  cells = undefined
  constructor: (@width, @height) ->
    cells = new ArrayGrid [], [@width, @height]

  getCell: (x, y)-> cells.get x, y

  setCell: (x, y, val) -> cells.set x, y, new Cell val if @inBounds x, y

  clearCell: (x,y) -> @setCell x, y, undefined

  # cellLocations: -> cells.coordsAt(index) for cell, index in cells.data
  deadEndLocations: -> cells.coordsAt(index) for cell, index in cells.data when cell.isDeadEnd()
  corridorLocations: -> cells.coordsAt(index) for cell, index in cells.data when cell.corridor?

  bounds: -> [@width -1, @height -1]

  inBounds: (x, y) -> x >= 0 and x < @width and y >=0 and y < @height

  getAdjacent: (x, y, direction) ->
    switch direction
      when 'north' then return [x, y-1]
      when 'south' then return [x, y+1]
      when 'west'  then return [x-1, y]
      when 'east'  then return [x+1, y]
      else return false

  getAdjacentCell: (x, y, direction) ->
    [nx, ny] = @getAdjacent x, y, direction
    @getCell nx, ny

  hasAdjacent: (x, y, direction) ->
    return false if !@inBounds x,y
    [nx, ny] = @getAdjacent x, y, direction
    return @inBounds nx, ny