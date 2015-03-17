
Map = require './map'

module.exports = class Room extends Map
  constructor: (width, height) ->
    super
    @populate()