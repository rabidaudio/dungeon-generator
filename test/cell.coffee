
expect = require('chai').expect

DG = require '../'

describe 'Cell', ->
  it 'should be an empty tile by default', ->
    c = new DG.Cell
    expect(c).to.have.property DG.directionTypes.NORTH, DG.sideTypes.EMPTY
    expect(c).to.have.property DG.directionTypes.SOUTH, DG.sideTypes.EMPTY
    expect(c).to.have.property DG.directionTypes.EAST, DG.sideTypes.EMPTY
    expect(c).to.have.property DG.directionTypes.WEST, DG.sideTypes.EMPTY

