Direction = require './direction'
Type = require './type'
VisitableMap = require './visitable-map'
Room = require './room'

module.exports = class Dungeon extends VisitableMap

  constructor: (width, height, seed=null) ->
    @rooms = []
    super(width, height, seed)

  addRoom: (room, x, y) ->
    throw new Error "Can't place Room at #{x}, #{y}: Out of Bounds" if not @willFit(room, x,y)
    @set(x+rx, y+ry, room.get(rx, ry)) for [rx,ry] in room.allLocations()
    room.dungeon = this
    room.location = [x, y]
    @rooms.push room

  adjacentIsCorridor: (x, y, direction) ->
    if @adjacentInBounds(x,y,direction) then @getAdjacentCell(x,y,direction).corridor else false

  setBothSides: (x, y, direction, type) ->
    if not @inBounds(x,y) or not @hasAdjacent(x,y,direction)
      throw new Error "Can't add #{direction} #{type} at #{x}, #{y}: Out of Bounds"
    @setCellSide x, y, direction, type
    @setCellSide @getAdjacent(x,y,direction)..., Direction.opposite(direction), type

  createDoor: (x, y, direction) ->
    @setBothSides x, y, direction, Type.DOOR


  createCorridor: (x, y, direction) ->
    @setBothSides x, y, direction, Type.EMPTY
    return @getAdjacent(x,y,direction)

  willFit: (room, x=0, y=0) -> room.width <= (@width - x) and room.height <= (@height - y)

  roomPlacementScore: (room, x, y) ->
    return -Infinity if not @willFit room, x, y
    score = 0
    for [roomX, roomY] in room.allLocations()
      dX = x + roomX
      dY = y + roomY
      #loose 1 point for each adjacent corridor to the cell
      (score-- if @adjacentIsCorridor(dX, dY, direction)) for direction in Direction
      dCell = @get(dX, dY)
      if not dCell.isBlank()
        #loose 3 points if the cell overlaps an existing corridor
        score -= 3 if dCell.corridor
        # loose 100 points if the cell overlaps any existing room cells
        score -= 100 if not dCell.corridor
    return score

  generateRooms: (number, minWidth, maxWidth, minHeight, maxHeight) ->
    for count in [0...number]
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
      for direction in Direction
        if not room.hasDoorOnSide direction
          [rX, rY] = room.getRandomCellAlongSide direction, @Random
          @createDoor dX+rX, dY+rY, direction
    return @

  createDenseMaze: (zigzagyness) ->
    #fill all cells with walls
    defaultCell = {}
    defaultCell[d] = Type.WALL for d in Direction
    c.update(defaultCell) for c in @data

    @flagAllCellsAsUnvisited()
    [x, y] = @pickRandomUnvisitedCell()
    @visitCell x, y
    direction = Direction.NORTH
    until @allCellsVisited()
      [x, y] = @pickRandomVisitedCell()
      valid = @validWalkDirections(x, y)
      while valid.length > 0 and not @allCellsVisited()
        #change direction if neccessary
        if valid.indexOf(direction) is -1 or @Random.next(1, 99) < zigzagyness
          direction = valid[@Random.next(0, valid.length-1)]
        [x, y] = @createCorridor x, y, direction
        @visitCell x, y
        valid = @validWalkDirections(x, y)
    return @

  sparsifyMaze: (sparseness) ->
    # Calculate the number of cells to remove as a percentage of the total number of cells in the dungeon
    cellsToRemove = Math.ceil((sparseness/100)*(@width * @height))
    for i in [0...cellsToRemove]
      deadEnds = @deadEndLocations()
      break if deadEnds.length is 0
      [deadEndX, deadEndY] = deadEnds[@Random.next(0, deadEnds.length-1)] #get random dead end
      cell = @get deadEndX, deadEndY
      deadEndDirection = cell.deadEndDirection()
      @setBothSides deadEndX, deadEndY, deadEndDirection, Type.WALL
    return @

  removeDeadEnds: (deadendRemovalness) ->
    for [deadEndX, deadEndY] in @deadEndLocations()
      if @Random.next(1, 99) < deadendRemovalness
        cell = @get deadEndX, deadEndY
        while cell.isDeadEnd()
          validDirection = ( d for d in Direction when @hasAdjacent(deadEndX, deadEndY, d) and d isnt cell.deadEndDirection() )
          d = validDirection[@Random.next(0, validDirection.length-1)]
          @createCorridor deadEndX, deadEndY, d
          [deadEndX, deadEndY] = @getAdjacent deadEndX, deadEndY, d
          cell = @get deadEndX, deadEndY
    return @
