require 'coffee-script/register'
chai = require 'chai'
expect = chai.expect

Dungeon = require '../lib/dungeon'
Room = require '../lib/room'
Map = require '../lib/map'
Direction = require '../lib/direction'

Generator = require '../lib'

describe 'Dungeon Generator', ->
  d = new Dungeon 10, 10
  square = new Room 3, 3

  for x in [3..6]
    d.createCorridor x, 1, Direction.EAST

  d.addRoom square, 0, 0
  d.addRoom square, 7, 0

  ###
      XXX????XXX
      X XCCCCX X
      XXX????XXX
      ??????????
      ??????????
      ??????????
      ??????????
      ??????????
      ??????????
      ??????????
  ###

  describe "roomPlacementScore", ->

    it "should fail rooms that are bigger than the dungeon", ->
      expect(d.roomPlacementScore( new Room(20,20), 0,0 )).to.equal -Infinity

    it "should pass rooms that will fit", ->
      expect( d.roomPlacementScore(new Room(3,3),5,5) ).to.equal 0

    it "should prefer overwriting corridors to overwriting rooms", ->
      blockCorridor = d.roomPlacementScore new Room(1,1), 5, 1
      blockRoom = d.roomPlacementScore new Room(1,1), 1, 1
      blockNone = d.roomPlacementScore new Room(1,1), 5, 5
      expect(blockCorridor).to.be.greaterThan blockRoom
      expect(blockNone).to.be.greaterThan blockCorridor


describe "Generation", ->
  SEED = "8675309"
  dungeon = new Dungeon(25, 25, SEED)

  it "should generate the proper default values for the dungeon", ->
    expect(dungeon.width).to.equal 25
    expect(dungeon.height).to.equal 25
    expect(dungeon.rooms).to.be.empty
    expect(cell.isEmpty()).to.equal true for cell in dungeon.data

  it "should generate zigzaggy dungeons", ->
    dungeon.createDenseMaze(30)
    expect(dungeon.rooms).to.be.empty
    # TODO how to measure zigzaggyness

  it "should generate sparse dungeons", ->
    dungeon.createDenseMaze(30).sparsifyMaze(100)
    expect(cell.wallCount()).to.eq 4 for cell in dungeon.data #all cells should have been blocked

  it "should generate non-sparse dungeons", ->
    dungeon.createDenseMaze(30).sparsifyMaze(0)
    expect(cell.wallCount()).to.be.lessThan 4 for cell in dungeon.data #no cells should have been blocked

  it "should generate medium-sparce dungeons", ->
    dungeon.createDenseMaze(30).sparsifyMaze(50)
    blockCells = (cell for cell in dungeon.data when cell.wallCount() == 4)
    expect(blockCells.length).to.eq Math.ceil(25*25/2) # half of the cells should have been blocked
  
  it "should generate dungeons with dead-ends", ->
    dungeon.createDenseMaze(30).sparsifyMaze(70)
    deadEnds = dungeon.deadEndLocations()
    expect(deadEnds.length).to.be.greaterThan 0
    dungeon.removeDeadEnds(0)
    newDeadEnds = dungeon.deadEndLocations()
    expect(newDeadEnds.length).to.eq deadEnds.length

  it "should generate dungeons without dead-ends", ->
    dungeon.createDenseMaze(30).sparsifyMaze(70)
    deadEnds = dungeon.deadEndLocations()
    expect(deadEnds.length).to.be.greaterThan 0
    dungeon.removeDeadEnds(100)
    deadEnds = dungeon.deadEndLocations()
    expect(deadEnds.length).to.eq 0

  it "should generate rooms", ->
    dungeon.createDenseMaze(30).sparsifyMaze(70).removeDeadEnds(50)
    expect(dungeon.rooms).to.be.empty
    dungeon.generateRooms 3, 3, 3, 3, 3
    expect(dungeon.rooms.length).to.eq 3
    # for room in dungeon.rooms
      # expect(dungeon.roomOverlapsExisting()).to.eq 0 #no overlapping rooms