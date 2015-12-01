Enum = require './enum'

DIRECTIONS = new Enum 'north', 'south', 'east', 'west'

DIRECTIONS.opposite = (dir) ->
  switch dir
    when @NORTH then return @SOUTH
    when @SOUTH then return @NORTH
    when @EAST  then return @WEST
    when @WEST  then return @EAST
    else throw "Invalid direction #{dir}"

module.exports = DIRECTIONS