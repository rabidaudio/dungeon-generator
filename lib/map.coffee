ArrayGrid = require 'array-grid'
Cell = require './cell'
_ = require 'lodash'

class Map
  constructor: (@width, @height) ->
    @cells = new ArrayGrid [], [@width, @height]
    # @cells.data.push new Cell for c in [1..@width*@height]

  getCell: (x, y)-> @cells.get x, y

  setCell: (x, y, val) ->
    throw "Out of Bounds: #{x}, #{y}" if not @inBounds x, y
    cell = @cells.get(x, y)
    if cell? then cell.update(val) else @cells.set(x,y, new Cell(val))

  forAllLocations: (cb) ->
    for y in [0..@height-1]
      for x in [0..@width-1]
        cb x, y, @getCell(x,y)

  nonEmptyLocations: -> @cells.coordsAt(index) for cell, index in @cells.data

  deadEndLocations:  -> @cells.coordsAt(index) for cell, index in @cells.data when cell?.isDeadEnd()

  corridorLocations: -> @cells.coordsAt(index) for cell, index in @cells.data when cell?.corridor?

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

  populate: ->
    @forAllLocations (x,y) =>
      c = {}
      c.north = 'wall' if y is 0
      c.south = 'wall' if y is @height - 1
      c.west  = 'wall' if x is 0
      c.east  = 'wall' if x is @width - 1
      @setCell x, y, c

  toString: ->
    map = ""
    for y in [0..@height-1]
      for x in [0..@width-1]
        cell = @getCell x, y
        if cell?
          if cell.isEmpty() then map+= " " else map+= "X"
        else
          map+="?"
      map+="\n"
    map

###
  If I were to place mapA into mapB at x and y, how many cells would overlap?
###
Map.overlap = (mapA, mapB, x, y) ->
  cellsA = mapA.nonEmptyLocations()
  cellsB = mapB.nonEmptyLocations()
  overlaps = 0
  for cellA in cellsA
    cellA[0]+=x
    cellA[1]+=y
    for cellB in cellsB
      overlaps++ if _.isEqual cellA, cellB
  overlaps



# Map.overlap = (roomA, xA, yA, roomB, xB, yB) ->
  # ( xB < xA+roomA.width and xA < xB+roomB.width ) and ( yB < yA+roomA.height and yA < yB+roomB.height )


module.exports = Map