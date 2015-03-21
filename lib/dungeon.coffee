DIRECTIONS = require './directions'
Map = require './map'
Room = require './room'
Cell = require './cell'
MTRandom = require('./random')

module.exports = class Dungeon extends Map

  rooms: []

  constructor: (width, height, seed=null) ->
    @Random = new MTRandom seed
    super(width, height)

  addRoom: (room, x, y) ->
    room.forAllLocations (rx,ry,c) =>
      @setCell x+rx, y+ry, c
    room.dungeon = this
    room.location = [x, y]
    @rooms.push room

  adjacentIsCorridor: (x, y, direction) ->
    if @hasAdjacent(x,y,direction) then @getAdjacentCell(x,y,direction)?.corridor else false

  createDoor: (x, y, direction) ->
    throw new Error("Can't edit cell at #{x}, #{y}: Out of bounds") if not @inBounds(x,y)
    if @hasAdjacent(x,y,direction)
      @setSide x, y, direction, 'door'
      @setSide @getAdjacent(x,y,direction)..., DIRECTIONS.opposite(direction), 'door'

  willFit: (room, x=0, y=0) -> room.width <= (@width - x) and room.height <= (@height - y)

  roomPlacementScore: (room, x, y) ->
    return -Infinity if not @willFit room, x, y
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
      room = new Room @Random.next(minWidth, maxWidth), @Random.next(minHeight, maxHeight)
      bestScore = -Infinity
      bestSpot = undefined
      @forAllLocations (dX, dY) =>
        newScore = @roomPlacementScore(room, dX, dY)
        if newScore>bestScore
          bestScore = newScore
          bestSpot = [dX, dY]
      if bestSpot?
        [dX, dY] = bestSpot
        @addRoom room, bestSpot...
      @addDoors()
  
  addDoors: ->
    for room in @rooms
      [dX,dY] = room.location
      for direction in DIRECTIONS
        if not room.hasDoorOnSide direction
          [rX, rY] = room.getRandomCellAlongSide direction, @Random
          @createDoor(dX+rX, dY+rY, direction)