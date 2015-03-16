
expect = require('chai').expect

DG = require '../'

describe 'Cell', ->
  it 'should be an empty tile by default', ->
    c = new DG.Cell
    expect(c.directions).to.have.property 'north', 'empty'
    expect(c.directions).to.have.property 'south', 'empty'
    expect(c.directions).to.have.property 'east', 'empty'
    expect(c.directions).to.have.property 'west', 'empty'

  it 'should know how many walls there are', ->
    c = new DG.Cell {north: 'wall', east: 'door', west: 'wall', south: 'empty'}
    expect(c.wallCount()).to.equal 2

  it 'should know when it is a dead end', ->
    c = new DG.Cell {north: 'wall', east: 'wall', west: 'wall', south: 'empty'}
    expect(c.isDeadEnd()).to.be.true
    c = new DG.Cell {north: 'wall', east: 'empty', west: 'empty', south: 'empty'}
    expect(c.isDeadEnd()).to.be.false

  it 'should know what direction a dead end is', ->
    c = new DG.Cell {north: 'wall', east: 'wall', west: 'wall', south: 'empty'}
    console.log c.deadEndDirection()
    expect(c.deadEndDirection()).to.equal 'south'

  it 'shouldn\'t give a direction for non-deadends ', ->
    c = new DG.Cell {north: 'wall', east: 'empty', west: 'empty', south: 'empty'}
    expect(c.deadEndDirection()).to.be.false