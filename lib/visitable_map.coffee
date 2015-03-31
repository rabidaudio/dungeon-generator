DIRECTIONS = require './directions'
Map = require './map'
MTRandom = require './random'

module.exports = class VisitableMap extends Map

  constructor: (width, height, seed=null) ->
    @visited = 0
    @Random = new MTRandom seed
    super(width, height)

  flagAllCellsAsUnvisited: ->
    @forAllLocations (x,y,c)-> c.clearVisits()
    @visited = 0

  pickRandomCell: ->
    throw new Error("All cells visited already") if @allCellsVisited()
    # n = @Random.next 1, @width*@height - @visited.length
    # for i in [0..@width*@height]
    #   return @getCellCoordinates(i) if @visited.indexOf(i) is -1 and --n is 0
    x = @Random.next 0, @width-1
    y = @Random.next 0, @height-1
    if @getCell(x,y).visited then @pickRandomCell() else [x, y]

  visitCell: (x,y) ->
    cell = @getCell(x,y)
    throw new Error("Cell #{[x,y]} is already visited") if cell.visited
    cell.visit()
    @visited++

  adjacentIsVisited: (x, y, direction) ->
    if @adjacentInBounds(x,y,direction) then @getAdjacentCell(x,y,direction).visited

  # getRandomVisitedCell: ->
  #   throw new Error("No visited cells yet") if @visited.length is 0
  #   @visited[@Random.next(0, @visited.length-1)]

  allCellsVisited: -> @visited is @width * @height

  validWalkDirections: (x,y) ->
    d for d in DIRECTIONS when @adjacentInBounds(x,y,d) and not @adjacentIsVisited(x,y,d)