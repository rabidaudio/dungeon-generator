
Map = require './map'
Room = require './room'
MTRandom = new require('./random')(8675309)

module.exports = class Dungeon extends Map

  # rooms: []

  constructor: (width, height) ->
    super

  addRoom: (room, x, y) ->
    # @rooms.push room
    room.forAllLocations (rx,ry,c) =>
      @setCell x+rx, y+ry, c.edges

  adjacentIsCorridor: (x, y, direction) ->
    @getAdjacentCell(x,y,direction)?.corridor?

  createSide: (x, y, direction, type) ->
    throw "Can't place a cell at #{x}, #{y}: Out of bounds" if not @inBounds x,y
    @getCell(x,y).set direction, type


  roomPlacementScore: (room, x, y) ->
    return -1*Infinity if room.width > (@width - x) or room.height > (@height - y) # won't fit
    score = 0
    room.forAllLocations (px, py, c)=>
      #Add 1 point for each adjacent corridor to the cell
      (score-- if @adjacentIsCorridor(px, py, direction)) for direction in ['north', 'south', 'east', 'west']
      #Add 3 points if the cell overlaps an existing corridor
      score-=3 if @getCell(x, y)?.corridor?
      # Add 100 points if the cell overlaps any existing room cells
      score-=(100*Map.overlap(r, this, x, y))
      # for exisingRoom in @rooms
        # score-=100 if Map.overlap room, x, y, this, 0, 0
    score


  generateRooms: (number, minWidth, maxWidth, minHeight, maxHeight) ->
    for count in [0..number]
      room = new Room MTRandom.next(minWidth, maxWidth), MTRandom.next(minHeight, maxHeight)

