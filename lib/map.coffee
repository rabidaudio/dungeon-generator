Direction = require './direction'
ArrayGrid = require 'array-grid'
Cell = require './cell'

###
  A 2D array of Cells
###
class Map extends ArrayGrid
  constructor: (@width, @height, defaultCell=null) ->
    super(new Array(@width*@height), [@width, @height]) #build parent 2D array
    @set(x, y, new Cell(defaultCell)) for [x, y] in @allLocations() #populate

  update: (x,y,val) -> if @inBounds(x,y) then @get(x,y).update(val) else throw new Error "Out of Bounds: #{x}, #{y}"

  getSide: (direction) ->
    switch direction
      when Direction.NORTH then return ([x, 0] for x in [0..@width-1])
      when Direction.SOUTH then return ([x, @height-1] for x in [0..@width-1])
      when Direction.EAST  then return ([@width-1, y] for y in [0..@height-1])
      when Direction.WEST  then return ([0, y] for y in [0..@height-1])
      else throw new Error "Invalid direction: #{direction}"

  setCellSide: (x,y, direction, value) -> @get(x,y).setSide direction, value

  allLocations: -> @coordsAt(index) for index in [0..@data.length-1]

  nonEmptyLocations: -> @coordsAt(index) for cell, index in @data when not cell.isBlank()

  deadEndLocations: -> @coordsAt(index) for cell, index in @data when cell.isDeadEnd()

  corridorLocations: -> @coordsAt(index) for cell, index in @data when cell.corridor

  inBounds: (x, y) -> x >= 0 and x < @width and y >= 0 and y < @height

  getAdjacent: (x, y, direction) ->
    switch direction
      when Direction.NORTH then return [x,  y-1]
      when Direction.SOUTH then return [x,  y+1]
      when Direction.WEST  then return [x-1,  y]
      when Direction.EAST  then return [x+1,  y]
      else throw new Error "Invalid direction: #{direction}"

  getAdjacentCell: (x, y, direction) -> @get @getAdjacent(x, y, direction)...

  adjacentInBounds: (x,y, direction) -> @inBounds(@getAdjacent(x, y, direction)...)

  hasAdjacent: (x, y, direction) -> @adjacentInBounds(x,y,direction) and not @getAdjacentCell(x,y,direction).isBlank()

  getRandomCellAlongSide: (direction, generator) ->
    switch direction
      when Direction.NORTH then return [generator.next(0, @width-1), 0]
      when Direction.SOUTH then return [generator.next(0, @width-1), @height-1]
      when Direction.WEST  then return [0, generator.next(0, @height-1)]
      when Direction.EAST  then return [@width-1, generator.next(0, @height-1)]
      else throw new Error "Invalid direction: #{direction}"

  print: ->
    map = ""
    for y in [0..@height-1]
      for x in [0..@width-1]
        cell = @get x, y
        if cell.isBlank() then map += "."
        else if cell.isEmpty() then  map +=  " "
        else if cell.corridor then map += "X"
        else if cell.doorCount() > 0 then map += '\\'
        else map += "#"
      map += "\n"
    map

  printFull: ->
    map = ""
    for y in [0..@height-1]
      rows = ["","",""]
      for x in [0..@width-1]
        current = @get(x,y).print().split("\n")
        rows[0] += current[0]
        rows[1] += current[1]
        rows[2] += current[2]
      map += rows.join("\n") + "\n"
    map

###
  If I were to place aMap into bMap at x and y, how many cells would overlap?
###
Map.overlap = (aMap, bMap, x, y) ->
  aCells = aMap.nonEmptyLocations()
  bCells = bMap.nonEmptyLocations()
  overlaps = 0
  for [xa, ya] in aCells
    xa += x
    ya += y
    for [xb, yb] in bCells
      overlaps++ if xa is xb and ya is yb
  overlaps

module.exports = Map