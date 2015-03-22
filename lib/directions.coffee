
DIRECTIONS = ['north', 'south', 'east', 'west']

DIRECTIONS.NORTH = 'north'
DIRECTIONS.SOUTH = 'south'
DIRECTIONS.EAST = 'east'
DIRECTIONS.WEST = 'west'

DIRECTIONS.opposite = (dir) ->
  switch dir
    when DIRECTIONS.NORTH then return DIRECTIONS.SOUTH
    when DIRECTIONS.SOUTH then return DIRECTIONS.NORTH
    when DIRECTIONS.EAST  then return DIRECTIONS.WEST
    when DIRECTIONS.WEST  then return DIRECTIONS.EAST
    else throw "Invalid direction #{dir}"

DIRECTIONS.shuffled = (generator) ->
  shuffle(x for x in DIRECTIONS, generator)

# http://stackoverflow.com/a/6274381
shuffle = (array, generator)->
    counter = array.length
    temp = index = 0
    while (counter > 0)
      index = generator.next(0, counter)
      counter--
      temp = array[counter]
      array[counter] = array[index]
      array[index] = temp
    return array

module.exports = DIRECTIONS