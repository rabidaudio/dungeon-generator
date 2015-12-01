Dungeon = require './dungeon'

generate = (opts={}) ->
  {width = 25, height=25, zigzagyness=30, sparseness=70, deadendRemovalness=50, roomCount=10, minWidth=1, maxWidth=5, minHeight=1, maxHeight=5, seed=null} = opts
  dungeon = new Dungeon width, height, seed

  dungeon
    .createDenseMaze(zigzagyness)
    .sparsifyMaze(sparseness)
    .removeDeadEnds(deadendRemovalness)
    .generateRooms(roomCount, minWidth, maxWidth, minHeight, maxHeight)
    # .addDoors()


generate.DIRECTIONS = require './directions'
generate.TYPES = require './types'
module.exports = generate