Enum = require './enum'

Direction = new Enum 'north', 'south', 'east', 'west'

Direction.opposite = (dir) ->
  switch dir
    when @NORTH then return @SOUTH
    when @SOUTH then return @NORTH
    when @EAST  then return @WEST
    when @WEST  then return @EAST
    else throw "Invalid direction #{dir}"

module.exports = Direction