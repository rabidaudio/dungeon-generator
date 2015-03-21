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

  # createSide: (x, y, direction, type) ->
  #   throw new Error("Can't place a cell at #{x}, #{y}: Out of bounds") if not @inBounds(x,y)
  #   current = {}
  #   current[direction] = type
  #   @updateCell(x,y,current)
  #   opposite = {}
  #   opposite[DIRECTIONS.opposite(direction)] = type
  #   @updateCell(@getAdjacent(x,y,direction)..., opposite) if @hasAdjacent(x,y,direction)

  # createCorridor: (x, y, direction) ->
  #   @createSide x,y, direction, 'empty'
  #   @getCell(x,y).corridor = @getAdjacentCell(x,y,direction).corridor = true

  # createWall: (x, y, direction) -> @createSide x, y, direction, 'wall'

  createDoor: (x, y, direction) ->
    throw new Error("Can't place a cell at #{x}, #{y}: Out of bounds") if not @inBounds(x,y)
    if @hasAdjacent(x,y,direction)
      current = {}
      current[direction] = 'door'
      @updateCell(x,y,current)
      opposite = {}
      opposite[DIRECTIONS.opposite(direction)] = 'door'
      @updateCell(@getAdjacent(x,y,direction)..., opposite)

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
      #add doors
      @addDoors()
  
  addDoors: ->
    for room in @rooms
      [dX,dY] = room.location
      for direction in DIRECTIONS
        if not room.hasDoorOnSide direction
          [rX, rY] = room.getRandomCellAlongSide direction, @Random
          console.log "adding #{direction} door at #{[rX, rY]}"
          @createDoor(dX+rX, dY+rY, direction)
      # room.forAllLocations (rX,rY) =>
      #   # console.log [rX, rY, room.width-1, room.height-1] if rX is 0 or rX is room.width-1 or rY is 0 or rY is room.height-1
      #   @createDoor(dX+rX, dY+rY, DIRECTIONS.WEST)  if rX is 0 and not room.hasDoorOnSide(DIRECTIONS.WEST) and @hasAdjacent(dX+rX, dY+rY, DIRECTIONS.WEST)
      #   @createDoor(dX+rX, dY+rY, DIRECTIONS.EAST)  if rX is room.width-1 and not room.hasDoorOnSide(DIRECTIONS.EAST) and @hasAdjacent(dX+rX, dY+rY, DIRECTIONS.EAST)
      #   @createDoor(dX+rX, dY+rY, DIRECTIONS.NORTH) if rY is 0 and not room.hasDoorOnSide(DIRECTIONS.NORTH)
      #   @createDoor(dX+rX, dY+rY, DIRECTIONS.SOUTH) if rY is room.height-1 and not room.hasDoorOnSide(DIRECTIONS.SOUTH)