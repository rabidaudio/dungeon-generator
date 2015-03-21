require 'coffee-script/register'
chai = require('chai')
expect = chai.expect
chai.use(require('chai-things'))

Map = require '../lib/map'
Room = require '../lib/room'

describe 'Map', ->
  m = new Map 3,4

  it "should know it's boundaries", ->
    expect(m.inBounds(0,0)).to.be.true
    expect(m.inBounds(2,3)).to.be.true
    expect(m.inBounds(-1,0)).to.be.false
    expect(m.inBounds(3,3)).to.be.false

  it "should allow you to set cells within the boundaries", ->
    m.updateCell(0,0, {north:'wall'})
    m.updateCell(2,3, {east: 'door'})
    expect(m.getCell(0,0)).to.have.property 'north', 'wall'
    expect(m.getCell(2,3)).to.have.property 'east', 'door'

  it "should *only* allow you to set cells within the boundaries", ->
    expect(()-> m.updateCell(-1,0, {north:'wall'})).to.throw /Out of Bounds/
    expect(()-> m.updateCell(3,3, {east: 'door'})).to.throw /Out of Bounds/

  it "should let you read from cells", ->
    expect(m.getCell(0,0)).to.have.property 'north', 'wall'

  it "should let you update cells", ->
    m.updateCell 1,1, {south: 'door', west: 'wall'}
    expect(m.getCell(1,1)).to.have.property 'north', 'empty'
    expect(m.getCell(1,1)).to.have.property 'south', 'door'
    expect(m.getCell(1,1)).to.have.property 'east', 'empty'
    expect(m.getCell(1,1)).to.have.property 'west', 'wall'

  it "should be able to find adjacent cell locations", ->
    expect( m.getAdjacent(0,0, 'east') ).to.deep.equal [1, 0]
    expect( m.getAdjacent(0,0, 'south') ).to.deep.equal [0, 1]
    expect( m.getAdjacent(-1,0, 'east') ).to.deep.equal [0, 0]

  it "shouldn't find out-of-bounds cell locations", ->
    expect( m.hasAdjacent(0,0, 'north') ).to.be.false

  it "should return adjacent cells as well", ->
    expect( m.getAdjacentCell(0,0, 'east') ).to.deep.equal m.getCell(1, 0)

  it "should find corridor cells", ->
    m.getCell(1,1).corridor = true
    expect(m.corridorLocations()).to.include.something.that.deep.equals [1,1]

  it "should find dead ends", ->
    m = new Map 1,4
    expect( m.deadEndLocations() ).to.be.empty
    m.updateCell 0, 3, {north: 'wall', east: 'wall', south: 'wall'}
    expect( m.deadEndLocations() ).to.deep.equal [[0,3]]

  it "should allow us to get an entire side horizontally", ->
    m = new Map 3,3
    expect(m.getSide('north')).to.have.length 3
    expect(m.getSide('north')).to.include.something.that.deep.equals [0,0]
    expect(m.getSide('north')).not.to.include.something.that.deep.equals [2,2]

  it "should allow us to get an entire side vertically", ->
    m = new Map 3,3
    expect(m.getSide('east')).to.have.length 3
    expect(m.getSide('east')).to.include.something.that.deep.equals [2,1]
    expect(m.getSide('east')).not.to.include.something.that.deep.equals [0,0]

describe 'Map.overlap', ->
  r1 = new Room 1, 1
  r2 = new Room 2, 1
  r3 = new Room 4, 4
  empty = new Map 10, 10
  it "should know if two maps don't overlap", ->
    expect( Map.overlap(r1,empty,0,0) ).to.equal 0

  it "should know if two maps do overlap", ->
    expect( Map.overlap(r1, r2, 0, 0) ).to.be.greaterThan 0

  it "should correctly count the number of overlapping rooms", ->
    expect( Map.overlap(r2, r3, 0, 0) ).to.equal 2