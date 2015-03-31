require 'coffee-script/register'
chai = require 'chai'
expect = chai.expect

Dungeon = require '../lib/dungeon'
Room = require '../lib/room'

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