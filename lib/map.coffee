ArrayGrid = require 'array-grid'
Cell = require './cell'

module.exports = class Map
  cells = undefined
  constructor: (@width, @height) ->
    cells = new ArrayGrid [], [@width, @height]
    cells.data.push new Cell for c in [0..@width*@height]

  getCell: (x, y)-> cells.get x, y

  setCell: (x, y, val) ->
    throw "Out of Bounds: #{x}, #{y}" if not @inBounds x, y
    (cells.get x, y).update val

  deadEndLocations:  -> cells.coordsAt(index) for cell, index in cells.data when cell.isDeadEnd()

  corridorLocations: -> cells.coordsAt(index) for cell, index in cells.data when cell.corridor?

  inBounds: (x, y) -> x >= 0 and x < @width and y >=0 and y < @height

  getAdjacent: (x, y, direction) ->
    switch direction
      when 'north' then return [x, y-1]
      when 'south' then return [x, y+1]
      when 'west'  then return [x-1, y]
      when 'east'  then return [x+1, y]
      else throw 'Invalid direction: #{direction}'

  getAdjacentCell: (x, y, direction) -> @getCell @getAdjacent(x, y, direction)...

  hasAdjacent: (x, y, direction) -> @inBounds @getAdjacent(x, y, direction)...

  # cells: ->
  #   cells