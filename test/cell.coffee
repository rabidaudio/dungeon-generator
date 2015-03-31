require 'coffee-script/register'
expect = require('chai').expect

Cell = require '../lib/cell'

describe 'Cell', ->
  it 'should be an empty tile by default', ->
    c = new Cell
    expect(c.isBlank()).to.be.true

  it "should be initializable", ->
    c = new Cell {}
    expect(c).to.have.property 'north', 'empty'
    expect(c).to.have.property 'south', 'empty'
    expect(c).to.have.property 'east', 'empty'
    expect(c).to.have.property 'west', 'empty'
    expect(c.isBlank()).to.be.false

  it 'should know how many walls there are', ->
    c = new Cell {north: 'wall', east: 'door', west: 'wall', south: 'empty'}
    expect(c.wallCount()).to.equal 2

  it 'should know when it is a dead end', ->
    c = new Cell {north: 'wall', east: 'wall', west: 'wall', south: 'empty'}
    expect(c.isDeadEnd()).to.be.true
    c = new Cell {north: 'wall', east: 'empty', west: 'empty', south: 'empty'}
    expect(c.isDeadEnd()).to.be.false

  it 'should know what direction a dead end is', ->
    c = new Cell {north: 'wall', east: 'wall', west: 'wall', south: 'empty'}
    expect(c.deadEndDirection()).to.equal 'south'

  it 'shouldn\'t give a direction for non-deadends ', ->
    c = new Cell {north: 'wall', east: 'empty', west: 'empty', south: 'empty'}
    expect(c.deadEndDirection()).to.be.false