require 'coffee-script/register'
chai = require 'chai'
expect = chai.expect

Dungeon = require '../lib/dungeon'
Room = require '../lib/room'

Generator = require '../lib'

describe 'Dungeon Generator', ->
  d = new Dungeon 10, 10
  square = new Room 3, 3
  hall = new Room 4, 1

  c.corridor = true for c in hall.data

  d.addRoom square, 0, 0
  d.addRoom square, 7, 0
  d.addRoom hall, 3, 1
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
      blockCorridor = d.roomPlacementScore new Room(1,1), 4, 1
      blockRoom = d.roomPlacementScore new Room(1,1), 1, 1
      expect(blockCorridor).to.be.greaterThan blockRoom


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
    # walls = (cell.wallCount() for cell in dungeon.data).reduce( (a,b) -> a+b )
    # more_zigzaggy_dungeon = new Dungeon(25, 25, SEED).createDenseMaze(90)
    # more_zigzaggy_walls = (cell.wallCount() for cell in more_zigzaggy_dungeon.data).reduce( (a,b) -> a+b )
    # expect(more_zigzaggy_walls).to.be.greaterThan walls
    # TODO how to measure zigzaggyness

  it "should generate sparse dungeons", ->

  it "should generate dungeons with dead-ends", ->
  