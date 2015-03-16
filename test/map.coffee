require 'coffee-script/register'
expect = require('chai').expect

Map = require '../lib/map'

describe 'Map', ->
  m = new Map 3,4

  it "should know it's boundaries", ->
    expect(m.inBounds(0,0)).to.be.true
    expect(m.inBounds(2,3)).to.be.true
    expect(m.inBounds(-1,0)).to.be.false
    expect(m.inBounds(3,3)).to.be.false

  it "should allow you to set cells within the boundaries", ->
    expect(m.setCell(0,0, 'wall')).to.be.true
    expect(m.setCell(2,3, 'door')).to.be.true

  it "should *only* allow you to set cells within the boundaries", ->
    expect(m.setCell(-1,0, 'wall')).not.to.be.true
    expect(m.setCell(3,3, 'door')).not.to.be.true