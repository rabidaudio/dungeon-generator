DIRECTIONS = require './directions'
TYPES = require './types'
VisitableMap = require './visitable_map'
Room = require './room'
Cell = require './cell'

module.exports = class Dungeon extends VisitableMap

  constructor: (width, height, seed=null) ->
    @rooms = []
    super(width, height, seed)

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
    return @