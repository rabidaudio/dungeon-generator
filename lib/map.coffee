ArrayGrid = require 'array-grid'

module.exports = class Map
  cells = []
  constructor: (@width, @height) ->
    cells = new ArrayGrid [], [@width, @height]

  getCell: (x, y)-> cells.get x, y

  setCell: (x, y, val) -> cells.set x, y, val

  bounds: -> [@width, @height]

  inBounds: (x, y) -> x >= 0 and x < @width and y >=0 and y < @height

  getAdjacent: (x, y, direction) ->
    switch direction
      when 'north' then return [x, y-1]
      when 'south' then return [x, y+1]
      when 'west'  then return [x-1, y]
      when 'east'  then return [x+1, y]
      else return false

  hasAdjacent: (x, y, direction) ->
    return false if !@inBounds x,y
    [nx, ny] = @getAdjacent(x, y, direction)
    return @inBounds nx, ny
