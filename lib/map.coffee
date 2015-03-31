DIRECTIONS = require './directions'
ArrayGrid = require 'array-grid'
Cell = require './cell'

class Map extends ArrayGrid
  constructor: (@width, @height, defaultCell=null) ->
    super(new Array(@width*@height), [@width, @height]) #build parent 2D array
    @set(x, y, new Cell(defaultCell)) for [x, y] in @allLocations() #populate

  update: (x,y,val) -> if @inBounds(x,y) then @get(x,y).update(val) else throw new Error "Out of Bounds: #{x}, #{y}"

  getSide: (direction) ->
    sides = []
    switch direction
      when DIRECTIONS.NORTH then sides.push([x, 0])         for x in [0..@width-1]
      when DIRECTIONS.SOUTH then sides.push([x, @height-1]) for x in [0..@width-1]
      when DIRECTIONS.EAST  then sides.push([@width-1, y])  for y in [0..@height-1]
      when DIRECTIONS.WEST  then sides.push([0, y])         for y in [0..@height-1]
      else throw new Error("Invalid direction: #{direction}")
    sides

  setCellSide: (x,y, direction, value) ->
    @get(x,y).setSide direction, value

  allLocations:      -> @coordsAt(index) for index in [0..@data.length-1]

  nonEmptyLocations: -> @coordsAt(index) for cell, index in @data when not cell.isBlank()

  deadEndLocations:  -> @coordsAt(index) for cell, index in @data when cell.isDeadEnd()

  corridorLocations: -> @coordsAt(index) for cell, index in @data when cell.corridor

  inBounds: (x, y) -> x >= 0 and x < @width and y >= 0 and y < @height

  getAdjacent: (x, y, direction) ->
    switch direction
      when DIRECTIONS.NORTH then return [x, y-1]
      when DIRECTIONS.SOUTH then return [x, y+1]
      when DIRECTIONS.WEST  then return [x-1, y]
      when DIRECTIONS.EAST  then return [x+1, y]
      else throw new Error("Invalid direction: #{direction}")

  getAdjacentCell: (x, y, direction) -> @get @getAdjacent(x, y, direction)...

  adjacentInBounds: (x,y, direction) -> @inBounds(@getAdjacent(x, y, direction)...)

  ###
    @return {Boolean} - True if both the cell is in bounds and isn't blank
  ###
  hasAdjacent: (x, y, direction) -> @adjacentInBounds(x,y,direction) and not @getAdjacentCell(x,y,direction).isBlank()

  getRandomCellAlongSide: (direction, generator) ->
    switch direction
      when DIRECTIONS.NORTH then return [ generator.next(0, @width-1), 0 ]
      when DIRECTIONS.SOUTH then return [ generator.next(0, @width-1), @height-1 ]
      when DIRECTIONS.WEST  then return [ 0, generator.next(0, @height-1) ]
      when DIRECTIONS.EAST  then return [ @width-1, generator.next(0, @height-1) ]
      else throw new Error("Invalid direction: #{direction}")

  print: ->
    map = ""
    for y in [0..@height-1]
      for x in [0..@width-1]
        cell = @get x, y
        if cell.isBlank() then map+="."
        else if cell.isEmpty() then  map+= " "
        else if cell.corridor then map+="X"
        else if cell.doorCount() > 0 then map+='\\'
        else map+= "#"
      map+="\n"
    map

###
  If I were to place mapA into mapB at x and y, how many cells would overlap?
###
Map.overlap = (mapA, mapB, x, y) ->
  cellsA = mapA.nonEmptyLocations()
  cellsB = mapB.nonEmptyLocations()
  overlaps = 0
  for [aX, aY] in cellsA
    aX+=x
    aY+=y
    for [bX, bY] in cellsB
      overlaps++ if aX is bX and aY is bY
  overlaps

module.exports = Map