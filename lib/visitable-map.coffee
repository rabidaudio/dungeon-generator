DIRECTIONS = require './directions'
Map = require './map'
MTRandom = require './random'

module.exports = class VisitableMap extends Map

  constructor: (width, height, seed=null) ->
    @visitedCount = 0
    @Random = new MTRandom seed
    super(width, height, null)

  unvisitedLocations:-> @coordsAt(index) for cell, index in @data when not cell._visited

  flagAllCellsAsUnvisited: ->
    c._visited = false for c in @data
    @visitedCount = 0

  pickRandomCell: ->
    throw new Error("All cells visited already") if @allCellsVisited()
    unvisited = @unvisitedLocations()
    return unvisited[@Random.next(0, unvisited.length-1)]

  visitCell: (x,y) ->
    cell = @get(x,y)
    throw new Error("Cell #{[x,y]} is already visited") if cell.isVisited()
    cell._visited = true
    @visitedCount++

  adjacentIsVisited: (x, y, direction) ->
    if @adjacentInBounds(x,y,direction) then @getAdjacentCell(x,y,direction).isVisited()

  allCellsVisited: -> @visitedCount is @width*@height

  validWalkDirections: (x,y) ->
    d for d in DIRECTIONS when @adjacentInBounds(x,y,d) and not @adjacentIsVisited(x,y,d)