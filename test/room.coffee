require 'coffee-script/register'
chai = require 'chai'
expect = chai.expect

Room = require '../lib/room'

describe 'Room', ->
  r = new Room 3, 3
  ###
        1 2 3
        4 5 6
        7 8 9
  ###
  one   = r.get 0, 0
  two   = r.get 1, 0
  three = r.get 2, 0
  four  = r.get 0, 1
  five  = r.get 1, 1
  six   = r.get 2, 1
  seven = r.get 0, 2
  eight = r.get 1, 2
  nine  = r.get 2, 2

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