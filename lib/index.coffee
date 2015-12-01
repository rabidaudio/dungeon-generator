Dungeon = require './dungeon'

generate = (width=25, height=25, zigzagyness=30, sparseness=70, deadendRemovalness=50, seed=null) ->
  dungeon = new Dungeon width, height, seed

  dungeon
    .createDenseMaze(zigzagyness)
    .sparsifyMaze(sparseness)
    .removeDeadEnds(deadendRemovalness)
    # .generateRooms()
    # .addDoors()


generate.DIRECTIONS = require './directions'
generate.TYPES = require './types'
module.exports = generate