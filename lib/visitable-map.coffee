DIRECTIONS = require './directions'
TYPES = require './types'
Map = require './map'
MTRandom = require './random'

module.exports = class VisitableMap extends Map

  constructor: (width, height, seed=null) ->
    @visitedCount = 0
    @Random = new MTRandom seed
    defaultCell = {}
    defaultCell[d] = TYPES.WALL for d in DIRECTIONS
    super(width, height, defaultCell)

  unvisitedLocations:-> @coordsAt(index) for cell, index in @data when not cell._visited

  visitedLocations:-> @coordsAt(index) for cell, index in @data when cell._visited

  flagAllCellsAsUnvisited: ->
    c._visited = false for c in @data
    @visitedCount = 0

  pickRandomUnvisitedCell: ->
    throw new Error("All cells visited already") if @allCellsVisited()
    unvisited = @unvisitedLocations()
    return unvisited[@Random.next(0, unvisited.length-1)]

  pickRandomVisitedCell: ->
    throw new Error("All cells visited already") if @allCellsVisited()
    visited = @visitedLocations()
    return visited[@Random.next(0, visited.length-1)]

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