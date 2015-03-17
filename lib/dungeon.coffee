DIRECTIONS = require './directions'
Map = require './map'
Room = require './room'
Cell = require './cell'
MTRandom = new require('./random')(8675309)

module.exports = class Dungeon extends Map

  rooms: []

  constructor: (width, height) ->
    super

  addRoom: (room, x, y) ->
    room.forAllLocations (rx,ry,c) =>
      @setCell x+rx, y+ry, c
    room.dungeon = this
    room.location = [x, y]
    @rooms.push room

  adjacentIsCorridor: (x, y, direction) ->
    @getAdjacentCell(x,y,direction)?.corridor

  createSide: (x, y, direction, type) ->
    throw "Can't place a cell at #{x}, #{y}: Out of bounds" if not (@inBounds(x,y) and @hasAdjacent(x,y,direction))
    @getCell(x,y).set direction, type
    @getAdjacentCell(x,y,direction).set DIRECTIONS.opposite(direction), type

  createCorridor: (x, y, direction) ->
    @createSide x,y, direction, 'empty'
    @getCell(x,y).corridor = @getAdjacentCell(x,y,direction).corridor = true

  createWall: (x, y, direction) -> @createSide x, y, direction, 'wall'

  createDoor: (x, y, direction) -> @createSide x, y, direction, 'door'


  roomPlacementScore: (room, x, y) ->
    return -Infinity if room.width > (@width - x) or room.height > (@height - y) # won't fit
    score = 0
    room.forAllLocations (roomX, roomY, c)=>
      dX = x + roomX
      dY = y + roomY
      #Add 1 point for each adjacent corridor to the cell
      (score-- if @adjacentIsCorridor(dX, dY, direction)) for direction in DIRECTIONS
      dCell = @getCell(dX, dY)
      if dCell?
        #Add 3 points if the cell overlaps an existing corridor
        score-=3 if dCell.corridor
        # Add 100 points if the cell overlaps any existing room cells
        score-=100 if not dCell.corridor
    score

  generateRooms: (number, minWidth, maxWidth, minHeight, maxHeight) ->
    for count in [0..number]
      room = new Room MTRandom.next(minWidth, maxWidth), MTRandom.next(minHeight, maxHeight)
      bestScore = -Infinity
      bestSpot = undefined
      @forAllLocations (dX, dY) =>
        newScore = @roomPlacementScore(room, dX, dY)
        if newScore>bestScore
          bestScore = newScore
          bestSpot = [dX, dY]
      if bestSpot?
        room.forAllLocations (rX,rY,c)->
          @createDoor(rX, rY, DIRECTIONS.WEST)  if rX is 0 and not room.hasDoorOnSide DIRECTIONS.WEST
          @createDoor(rX, rY, DIRECTIONS.EAST)  if rX is room.width-1 and not room.hasDoorOnSide DIRECTIONS.EAST
          @createDoor(rX, rY, DIRECTIONS.NORTH) if rY is 0 and not room.hasDoorOnSide DIRECTIONS.NORTH
          @createDoor(rX, rY, DIRECTIONS.SOUTH) if rY is room.height-1 and not room.hasDoorOnSide DIRECTIONS.SOUTH
        @addRoom room, bestSpot...