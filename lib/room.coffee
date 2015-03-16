
Map = require './map'

module.exports = class Room extends Map
  constructor: (width, height) ->
    super
    for x in [0..width-1]
      for y in [0..height-1]
        c = {}
        c.north = 'wall' if y is 0
        c.south = 'wall' if y is height - 1
        c.west  = 'wall' if x is 0
        c.east  = 'wall' if x is width - 1
        @setCell x, y, c