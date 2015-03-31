DIRECTIONS = require './directions'
TYPES = require './types'
VisitableMap = require './visitable-map'
Room = require './room'

module.exports = class Dungeon extends VisitableMap

  constructor: (width, height, seed=null) ->
    @rooms = []
    super(width, height, seed)

  addRoom: (room, x, y) ->
    throw new Error("Can't place Room at #{x}, #{y}: Out of Bounds") if not @willFit(room, x,y)
    @set(x+rx, y+ry, room.get(rx, ry)) for [rx,ry] in room.allLocations()
    room.dungeon = this
    room.location = [x, y]
    @rooms.push room

  adjacentIsCorridor: (x, y, direction) ->
    if @hasAdjacent(x,y,direction) then @getAdjacentCell(x,y,direction).corridor else false

  createDoor: (x, y, direction) ->
    if not @inBounds(x,y) or not @hasAdjacent(x,y,direction)
      throw new Error("Can't add #{direction} door at #{x}, #{y}: Out of Bounds")
    @setCellSide x, y, direction, TYPES.DOOR
    @setCellSide @getAdjacent(x,y,direction)..., DIRECTIONS.opposite(direction), TYPES.DOOR

  createCorridor: (x, y, direction) ->
    if not @inBounds(x,y) or not @adjacentInBounds(x,y,direction)
      throw new Error("Can't edit cell at #{x}, #{y}: Out of Bounds") 
    @get(x,y).setSide(direction, TYPES.EMPTY)
    @getAdjacentCell(x,y,direction).setSide(DIRECTIONS.opposite(direction), TYPES.EMPTY)
    # @get(x, y).makeCorridor(direction)
    # @getAdjacentCell(x,y,direction).makeCorridor(direction)
    return @getAdjacent(x,y,direction)

  willFit: (room, x=0, y=0) -> room.width <= (@width - x) and room.height <= (@height - y)

  roomPlacementScore: (room, x, y) ->
    return -Infinity if not @willFit room, x, y
    score = 0
    for [roomX, roomY] in room.allLocations()
      dX = x + roomX
      dY = y + roomY
      #loose 1 point for each adjacent corridor to the cell
      (score-- if @adjacentIsCorridor(dX, dY, direction)) for direction in DIRECTIONS
      dCell = @get(dX, dY)
      if not dCell.isBlank()
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
      for [dX, dY] in @allLocations()
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
    [x, y] = @pickRandomUnvisitedCell()
    @visitCell x, y
    direction = DIRECTIONS.NORTH
    until @allCellsVisited()
      [x, y] = @pickRandomVisitedCell()
      valid = @validWalkDirections(x, y)
      while valid.length > 0 and not @allCellsVisited()
        #change direction if neccessary
        if valid.indexOf(direction) is -1 or @Random.next(0, 100) > zigzagyness
          direction = valid[@Random.next(0, valid.length-1)]
        [x, y] = @createCorridor x, y, direction
        @visitCell x, y
        valid = @validWalkDirections(x, y)
    return @