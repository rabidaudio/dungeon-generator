require 'coffee-script/register'
chai = require('chai')
expect = chai.expect
chai.use(require('chai-things'))

Map = require '../lib/map'

describe 'Map', ->
  m = new Map 3,4

  it "should know it's boundaries", ->
    expect(m.inBounds(0,0)).to.be.true
    expect(m.inBounds(2,3)).to.be.true
    expect(m.inBounds(-1,0)).to.be.false
    expect(m.inBounds(3,3)).to.be.false

  it "should allow you to set cells within the boundaries", ->
    m.setCell(0,0, {north:'wall'})
    m.setCell(2,3, {east: 'door'})
    expect(m.getCell(0,0).edges).to.have.property 'north', 'wall'
    expect(m.getCell(2,3).edges).to.have.property 'east', 'door'

  it "should *only* allow you to set cells within the boundaries", ->
    expect(()-> m.setCell(-1,0, {north:'wall'})).to.throw /Out of Bounds/
    expect(()-> m.setCell(3,3, {east: 'door'})).to.throw /Out of Bounds/

  it "should let you read from cells", ->
    expect(m.getCell(0,0).edges).to.have.property 'north', 'wall'

  it "should let you update cells", ->
    expect(m.getCell(1,1).edges).to.have.property 'north', 'empty'
    expect(m.getCell(1,1).edges).to.have.property 'south', 'empty'
    expect(m.getCell(1,1).edges).to.have.property 'east', 'empty'
    expect(m.getCell(1,1).edges).to.have.property 'west', 'empty'

    m.setCell 1,1, {south: 'door', west: 'wall'}
    expect(m.getCell(1,1).edges).to.have.property 'north', 'empty'
    expect(m.getCell(1,1).edges).to.have.property 'south', 'door'
    expect(m.getCell(1,1).edges).to.have.property 'east', 'empty'
    expect(m.getCell(1,1).edges).to.have.property 'west', 'wall'

  it "should be able to find adjacent cell locations", ->
    expect( m.getAdjacent(0,0, 'east') ).to.deep.equal [1, 0]
    expect( m.getAdjacent(0,0, 'south') ).to.deep.equal [0, 1]
    expect( m.getAdjacent(-1,0, 'east') ).to.deep.equal [0, 0]

  it "shouldn't find out-of-bounds cell locations", ->
    expect( m.hasAdjacent(0,0, 'north') ).to.be.false

  it "should return adjacent cells as well", ->
    expect( m.getAdjacentCell(0,0, 'east') ).to.deep.equal m.getCell(1, 0)

  it "should find corridor cells", ->
    m.getCell(2,1).corridor = true
    expect(m.corridorLocations()).to.include.something.that.deep.equals [2,1]

  it "should find dead ends", ->
    m = new Map 1,4
    expect( m.deadEndLocations() ).to.be.empty
    m.setCell 0, 3, {north: 'wall', east: 'wall', south: 'wall'}
    expect( m.deadEndLocations() ).to.deep.equal [[0,3]]