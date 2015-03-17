DIRECTIONS = require './directions'
Map = require './map'
Room = require './room'
Cell = require './cell'
MTRandom = new require('./random')(8675309)

module.exports = class Dungeon extends Map

  # rooms: []

  constructor: (width, height) ->
    super

  addRoom: (room, x, y) ->
    # @rooms.push room
    room.forAllLocations (rx,ry,c) =>
      @setCell x+rx, y+ry, c

  adjacentIsCorridor: (x, y, direction) ->
    @getAdjacentCell(x,y,direction)?.corridor

  createSide: (x, y, direction, type) ->
    throw "Can't place a cell at #{x}, #{y}: Out of bounds" if not @inBounds x,y
    @getCell(x,y).set direction, type

  createCorridor: (x, y, direction) ->
    @createSide x,y, direction, 'empty'
    @getCell(x,y).corridor = true

  createWall: (x, y, direction) ->
    @createSide x, y, direction, 'wall'

  createDoor: (x, y, direction) ->
    @createSide x, y, direction, 'door'


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

