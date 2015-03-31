require 'coffee-script/register'
chai = require('chai')
expect = chai.expect

Dungeon = require '../lib/dungeon'
Room = require '../lib/room'

Generator = require '../lib'

describe 'Room', ->
  r = new Room 3, 3
  ###
        1 2 3
        4 5 6
        7 8 9
  ###
  one   = r.getCell 0, 0
  two   = r.getCell 1, 0
  three = r.getCell 2, 0
  four  = r.getCell 0, 1
  five  = r.getCell 1, 1
  six   = r.getCell 2, 1
  seven = r.getCell 0, 2
  eight = r.getCell 1, 2
  nine  = r.getCell 2, 2

  it "should correctly place on edges", =>
    expect(two).to.have.property 'north', 'wall'
    expect(two.wallCount()).to.equal 1
    
    expect(four).to.have.property 'west', 'wall'
    expect(four.wallCount()).to.equal 1

    expect(six).to.have.property 'east', 'wall'
    expect(six.wallCount()).to.equal 1
    
    expect(eight).to.have.property 'south', 'wall'
    expect(eight.wallCount()).to.equal 1

  it "should correctly place on corners", =>
    expect(one).to.have.property 'north', 'wall'
    expect(one).to.have.property 'west', 'wall'
    expect(one.wallCount()).to.equal 2

    expect(three).to.have.property 'north', 'wall'
    expect(three).to.have.property 'east', 'wall'
    expect(three.wallCount()).to.equal 2

    expect(seven).to.have.property 'south', 'wall'
    expect(seven).to.have.property 'west', 'wall'
    expect(seven.wallCount()).to.equal 2

    expect(nine).to.have.property 'south', 'wall'
    expect(nine).to.have.property 'east', 'wall'
    expect(nine.wallCount()).to.equal 2

  it "shoud correctly place empty spaces", =>    
    expect(five.wallCount()).to.equal 0

  it "should know when it has a door on a side", ->
    two.north = 'door'
    four.west = 'door'
    expect(r.hasDoorOnSide('north')).to.be.true
    expect(r.hasDoorOnSide('south')).to.be.false
    expect(r.hasDoorOnSide('east')).to.be.false
    expect(r.hasDoorOnSide('west')).to.be.true

describe 'Dungeon', ->
  describe 'core', ->
    d = new Dungeon 10, 10

    it "should be initally empty", ->
      expect(d.nonEmptyLocations()).to.have.length 0

    it "should be able to add rooms", ->
      d.addRoom(new Room(3,3), 0, 0)
      expect(d.nonEmptyLocations()).to.have.length 9

    it "shouldn't let you add rooms outside it's boundaries", ->
      expect( ()-> d.addRoom(new Room(3,3), 8, 8) ).to.throw /Out of Bounds/

  describe "validWalkDirections", ->
    d = new Dungeon 10, 10

    it "should know when all directions are valid", ->
      expect(d.validWalkDirections(5,5)).to.have.length 4

    it "should know when adjacent cells are out of bounds", ->
      expect(d.validWalkDirections(0,0)).to.have.length 2

    it "should know when adjacent cells are visited", ->
      d.visitCell(1,0)
      d.visitCell(0,1)
      expect(d.validWalkDirections(1,1)).to.have.length 2

    it "should know when all adjacent cells are visited", ->
      d.visitCell(2,1)
      d.visitCell(1,2)
      expect(d.validWalkDirections(1,1)).to.have.length 0

  describe 'visiting', ->
    v = new Dungeon 10,10
    it "shouldn't have any visits initally", ->
      expect(v.visited.length).to.equal 0

    it "should allow you to visit a particular cell", ->
      v.visitCell 0,0
      expect(v.visited.length).to.equal 1

    it "should allow you to visit a random cell", ->
      v.visitCell(v.pickRandomCell()...)
      expect(v.visited.length).to.equal 2

    it "should not allow you to visit an already visited cell", ->
      expect(()-> v.visitCell(0,0)).to.throw /visited/

    it "should allow you to random walk", ->
      expect( ()-> v.createDenseMaze(50) ).not.to.throw Error
      expect(v.allCellsVisited()).to.be.true

    it "should know when all the cells have been visited", ->
      q = new Dungeon 5, 5
      for x in [0..4]
        for y in [0..4]
          q.visitCell x, y
      expect(q.visited).to.have.length 25
      expect(q.allCellsVisited()).to.be.true

    it "should let you vist all cells by choosing randomly", (done) ->
      setTimeout(()->
        r = new Dungeon 50,50
        r.visitCell r.pickRandomCell()... until r.allCellsVisited()
        done()
      ,0)


describe "createDoor()", ->
  d = new Dungeon 10, 10
  d.addRoom( new Room(3,3), 0, 0)
  d.addRoom( new Room(3,3), 3, 0)
  it "should update both sides of a cell pair", ->
    d.createDoor(2,2, 'east')
    expect(d.getCell(2,2)).to.have.property 'east', 'door'
    expect(d.getCell(3,2)).to.have.property 'west', 'door'

  it "shouldn't try to add doors to outside the map", ->
    d.createDoor(0,0, 'north')
    expect(d.getCell(0,0)).to.have.property 'north', 'wall'
    expect(()-> d.getCell(0,-1)).to.throw /Out of Bounds/

  it "shouldn't try to add doors to empty cells", ->
    d.createDoor(0,2, 'south')
    expect(d.getCell(0,2)).to.have.property 'south', 'wall'
    expect(d.getCell(0,3).blank).to.be.true


describe 'Dungeon Generator', ->
  d = new Dungeon 10, 10
  square = new Room 3, 3
  hall = new Room 4, 1

  hall.forAllLocations (x,y,c)-> c.corridor = true

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