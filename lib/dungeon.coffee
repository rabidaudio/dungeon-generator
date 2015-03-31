DIRECTIONS = require './directions'
TYPES = require './types'
Map = require './map'
Room = require './room'
Cell = require './cell'
MTRandom = require './random'

module.exports = class Dungeon extends Map

  constructor: (width, height, seed=null) ->
    @rooms = []
    @visited = []
    @Random = new MTRandom seed
    super(width, height)

  addRoom: (room, x, y) ->
    room.forAllLocations (rx,ry,c) => @setCell x+rx, y+ry, c
    room.dungeon = this
    room.location = [x, y]
    @rooms.push room

  adjacentIsCorridor: (x, y, direction) ->
    if @hasAdjacent(x,y,direction) then @getAdjacentCell(x,y,direction).corridor else false

  createDoor: (x, y, direction) ->
    throw new Error("Can't edit cell at #{x}, #{y}: Out of bounds") if not @inBounds(x,y)
    if @hasAdjacent(x,y,direction)
      @setSide x, y, direction, TYPES.DOOR
      @setSide @getAdjacent(x,y,direction)..., DIRECTIONS.opposite(direction), TYPES.DOOR

  createCorridor: (x, y, direction) ->
    throw new Error("Can't edit cell at #{x}, #{y}: Out of bounds") if not @inBounds(x,y)
    @getCell(x, y).makeCorridor(direction)
    @getAdjacentCell(x,y,direction).makeCorridor(direction) if @hasAdjacent(x,y,direction)
    return @getAdjacent(x,y,direction)

  willFit: (room, x=0, y=0) -> room.width <= (@width - x) and room.height <= (@height - y)

  roomPlacementScore: (room, x, y) ->
    return -Infinity if not @willFit room, x, y
    score = 0
    room.forAllLocations (roomX, roomY, c) =>
      dX = x + roomX
      dY = y + roomY
      #loose 1 point for each adjacent corridor to the cell
      (score-- if @adjacentIsCorridor(dX, dY, direction)) for direction in DIRECTIONS
      dCell = @getCell(dX, dY)
      if dCell.notBlank()
        #loose 3 points if the cell overlaps an existing corridor
        score-=3 if dCell.corridor
        # loose 100 points if the cell overlaps any existing room cells
        score-=100 if not dCell.corridor
    return score

  generateRooms: (number, minWidth, maxWidth, minHeight, maxHeight) ->
    for count in [0..number]
      room = new Room @Random.next(minWidth, maxWidth), @Random.next(minHeight, maxHeight)
      bestScore = -Infinity
      bestSpot = undefined
      @forAllLocations (dX, dY) =>
        newScore = @roomPlacementScore(room, dX, dY)
        if newScore>bestScore
          bestScore = newScore
          bestSpot = [dX, dY]
      if bestSpot?
        @addRoom room, bestSpot...
    return @
  
  addDoors: ->
    for room in @rooms
      [dX, dY] = room.location
      for direction in DIRECTIONS
        if not room.hasDoorOnSide direction
          [rX, rY] = room.getRandomCellAlongSide direction, @Random
          @createDoor dX+rX, dY+rY, direction
    return @




  flagAllCellsAsUnvisited: -> @forAllLocations (x,y,c)-> c.clearVisits()

  pickRandomCell: ->
    throw new Error("All cells visited already") if @allCellsVisited()
    x = @Random.next 0, @width-1
    y = @Random.next 0, @height-1
    if @getCell(x,y).visited then @pickRandomCell() else [x, y]

  visitCell: (x,y) ->
    cell = @getCell(x,y)
    throw new Error("Cell #{[x,y]} is already visited") if cell.visited
    cell.visit()
    @visited.push [x,y]

  adjacentIsVisited: (x, y, direction) ->
    if @adjacentInBounds(x,y,direction) then @getAdjacentCell(x,y,direction).visited

  # getRandomVisitedCell: ->
  #   throw new Error("No visited cells yet") if @visited.length is 0
  #   @visited[@Random.next(0, @visited.length-1)]

  allCellsVisited: -> @visited.length is @width * @height

  validWalkDirections: (x,y) ->
    d for d in DIRECTIONS when @adjacentInBounds(x,y,d) and not @adjacentIsVisited(x,y,d)

  createDenseMaze: (zigzagyness) ->
    @flagAllCellsAsUnvisited()
    until @allCellsVisited()
      [x, y] = @pickRandomCell()
      @visitCell x, y
      valid = @validWalkDirections(x, y)
      direction = DIRECTIONS.NORTH

      while valid.length > 0
        #change direction if neccessary
        if valid.indexOf(direction) is -1 or @Random.next(0, 100) > zigzagyness
          direction = valid[@Random.next(0, valid.length-1)]
        [x, y] = @createCorridor x, y, direction
        @visitCell x, y
        valid = @validWalkDirections(x, y)
    @flagAllCellsAsUnvisited()
    return @