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


# describe "Integration Test", ->
#   SEED = 8675309

#   it "should generate the proper default value dungeon", ->
#     dungeon = Generator(25, 25, 30, 70, 50, SEED)

#   it "should generate zigzaggy dungeons", ->

#   it "should generate sparse dungeons", ->

#   it "should generate dungeons with lots of dead-ends", ->
#   