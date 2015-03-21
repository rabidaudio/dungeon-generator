DIRECTIONS = require './directions'
ArrayGrid = require 'array-grid'
Cell = require './cell'
deepEqual = require 'lodash.isequal'

class Map
  constructor: (@width, @height) ->
    @cells = new ArrayGrid [], [@width, @height]
    @forAllLocations (x,y) => @cells.set(x, y, new Cell() )

  getCell: (x, y)->
    throw new Error("Out of Bounds: #{x}, #{y}") if not @inBounds x, y
    @cells.get x, y

  updateCell: (x, y, val) ->
    throw new Error("Out of Bounds: #{x}, #{y}") if not @inBounds x, y
    @cells.get(x, y).update(val)

  setCell: (x, y, c) ->
    throw new Error("Out of Bounds: #{x}, #{y}") if not @inBounds x, y
    @cells.set(x, y, c)

  getSide: (direction) ->
    sides = []
    switch direction
      when DIRECTIONS.NORTH then sides.push([x, 0])         for x in [0..@width-1]
      when DIRECTIONS.SOUTH then sides.push([x, @height-1]) for x in [0..@width-1]
      when DIRECTIONS.EAST  then sides.push([@width-1, y])  for y in [0..@height-1]
      when DIRECTIONS.WEST  then sides.push([0, y])         for y in [0..@height-1]
      else throw new Error('Invalid direction: #{direction}')
    sides

  setSide: (x,y,direction, value) ->
    data = {}
    data[direction] = value
    @updateCell(x,y,data)

  forAllLocations: (cb) ->
    for y in [0..@height-1]
      for x in [0..@width-1]
        cb x, y, @getCell(x,y)

  nonEmptyLocations: -> @cells.coordsAt(index) for cell, index in @cells.data when cell?.notBlank()

  deadEndLocations:  -> @cells.coordsAt(index) for cell, index in @cells.data when cell?.isDeadEnd()

  corridorLocations: -> @cells.coordsAt(index) for cell, index in @cells.data when cell?.corridor

  inBounds: (x, y) -> x >= 0 and x < @width and y >= 0 and y < @height

  getAdjacent: (x, y, direction) ->
    switch direction
      when DIRECTIONS.NORTH then return [x, y-1]
      when DIRECTIONS.SOUTH then return [x, y+1]
      when DIRECTIONS.WEST  then return [x-1, y]
      when DIRECTIONS.EAST  then return [x+1, y]
      else throw new Error('Invalid direction: #{direction}')

  getAdjacentCell: (x, y, direction) -> @getCell @getAdjacent(x, y, direction)...

  hasAdjacent: (x, y, direction) ->
    @inBounds(@getAdjacent(x, y, direction)...) and @getAdjacentCell(x,y,direction).notBlank()

  getRandomCellAlongSide: (direction, generator) ->
    switch direction
      when DIRECTIONS.NORTH then return [ generator.next(0, @width-1), 0 ]
      when DIRECTIONS.SOUTH then return [ generator.next(0, @width-1), @height-1 ]
      when DIRECTIONS.WEST  then return [ 0, generator.next(0, @height-1) ]
      when DIRECTIONS.EAST  then return [ @width-1, generator.next(0, @height-1) ]
      else throw new Error('Invalid direction: #{direction}')

  toString: ->
    map = ""
    for y in [0..@height-1]
      for x in [0..@width-1]
        cell = @getCell x, y
        if cell.notBlank()
          if cell.isEmpty() then  map+= " "
          else if cell.corridor then map+="X"
          else if cell.doorCount() > 0 then map+='\\'
          else map+= "#"
        else map+="."
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
      overlaps++ if deepEqual cellA, cellB
  overlaps

module.exports = Map