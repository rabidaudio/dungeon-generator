(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}g.DungeonGenerator = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Cell, Direction, Type;

Direction = require('./direction');

Type = require('./type');


/*
  An individual location on a Map. Has 4 sides `['north', 'south', 'east', 'west']`
  which will be one of `['door', 'wall', 'empty']` unless `isBlank()`
 */

module.exports = Cell = (function() {

  /*
    @param {Object} data - The state to initialize the cell with. Keys are Direction and
      values are Type. For example:
        {
          'north': 'wall',
          'east': 'door'
        }
      Any unspecified Direction will be set to 'empty'.
      If it is omitted, the cell will be marked as blank and none of the Direction
      will be set.
   */
  function Cell(data) {
    if (data == null) {
      data = null;
    }
    if (data != null) {
      this.update(data);
    } else {
      this._blank = true;
    }
  }

  Cell.prototype.isDeadEnd = function() {
    return this.wallCount() === 3;
  };

  Cell.prototype.isEmpty = function() {
    return this.wallCount() + this.doorCount() === 0;
  };

  Cell.prototype.isBlank = function() {
    return this._blank;
  };

  Cell.prototype.isVisited = function() {
    return this._visited;
  };

  Cell.prototype.wallCount = function() {
    return this.typeCount(Type.WALL);
  };

  Cell.prototype.doorCount = function() {
    return this.typeCount(Type.DOOR);
  };

  Cell.prototype.typeCount = function(type) {
    var count, d, i, len;
    count = 0;
    for (i = 0, len = Direction.length; i < len; i++) {
      d = Direction[i];
      if (this[d] === type) {
        count++;
      }
    }
    return count;
  };

  Cell.prototype.deadEndDirection = function() {
    var d, i, len;
    if (!this.isDeadEnd()) {
      return false;
    }
    for (i = 0, len = Direction.length; i < len; i++) {
      d = Direction[i];
      if (this[d] === Type.EMPTY) {
        return d;
      }
    }
  };

  Cell.prototype.setSide = function(direction, value) {
    this[direction] = value;
    return this._blank = false;
  };

  Cell.prototype.update = function(data) {
    var direction, i, len;
    for (i = 0, len = Direction.length; i < len; i++) {
      direction = Direction[i];
      this[direction] = data[direction] != null ? data[direction] : Type.EMPTY;
    }
    return this._blank = false;
  };


  /*
    Return a 3x3 character representation of the cell
   */

  Cell.prototype.print = function() {
    var cell;
    if (this.isBlank()) {
      return "▒▒▒\n▒▒▒\n▒▒▒\n";
    }
    cell = new Array(9);
    cell[4] = "*";
    cell[1] = (function() {
      switch (this[Direction.NORTH]) {
        case Type.WALL:
          return "─";
        case Type.DOOR:
          return "~";
        case Type.EMPTY:
          return " ";
      }
    }).call(this);
    cell[7] = (function() {
      switch (this[Direction.SOUTH]) {
        case Type.WALL:
          return "─";
        case Type.DOOR:
          return "~";
        case Type.EMPTY:
          return " ";
      }
    }).call(this);
    cell[3] = (function() {
      switch (this[Direction.WEST]) {
        case Type.WALL:
          return "│";
        case Type.DOOR:
          return "~";
        case Type.EMPTY:
          return " ";
      }
    }).call(this);
    cell[5] = (function() {
      switch (this[Direction.EAST]) {
        case Type.WALL:
          return "│";
        case Type.DOOR:
          return "~";
        case Type.EMPTY:
          return " ";
      }
    }).call(this);
    if (this[Direction.NORTH] !== Type.EMPTY && this[Direction.WEST] !== Type.EMPTY) {
      cell[0] = "┌";
    } else if (this[Direction.NORTH] !== Type.EMPTY) {
      cell[0] = "─";
    } else if (this[Direction.WEST] !== Type.EMPTY) {
      cell[0] = "│";
    } else {
      cell[0] = " ";
    }
    if (this[Direction.SOUTH] !== Type.EMPTY && this[Direction.WEST] !== Type.EMPTY) {
      cell[6] = "└";
    } else if (this[Direction.SOUTH] !== Type.EMPTY) {
      cell[6] = "─";
    } else if (this[Direction.WEST] !== Type.EMPTY) {
      cell[6] = "│";
    } else {
      cell[6] = " ";
    }
    if (this[Direction.SOUTH] !== Type.EMPTY && this[Direction.EAST] !== Type.EMPTY) {
      cell[8] = "┘";
    } else if (this[Direction.SOUTH] !== Type.EMPTY) {
      cell[8] = "─";
    } else if (this[Direction.EAST] !== Type.EMPTY) {
      cell[8] = "│";
    } else {
      cell[8] = " ";
    }
    if (this[Direction.NORTH] !== Type.EMPTY && this[Direction.EAST] !== Type.EMPTY) {
      cell[2] = "┐";
    } else if (this[Direction.NORTH] !== Type.EMPTY) {
      cell[2] = "─";
    } else if (this[Direction.EAST] !== Type.EMPTY) {
      cell[2] = "│";
    } else {
      cell[2] = " ";
    }
    return [cell.slice(0, 3).join(""), cell.slice(3, 6).join(""), cell.slice(6, 9).join("")].join("\n");
  };

  return Cell;

})();


},{"./direction":2,"./type":9}],2:[function(require,module,exports){
var Direction, Enum;

Enum = require('./enum');

Direction = new Enum('north', 'south', 'east', 'west');

Direction.opposite = function(dir) {
  switch (dir) {
    case this.NORTH:
      return this.SOUTH;
    case this.SOUTH:
      return this.NORTH;
    case this.EAST:
      return this.WEST;
    case this.WEST:
      return this.EAST;
    default:
      throw "Invalid direction " + dir;
  }
};

module.exports = Direction;


},{"./enum":4}],3:[function(require,module,exports){
var Direction, Dungeon, Room, Type, VisitableMap,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

Direction = require('./direction');

Type = require('./type');

VisitableMap = require('./visitable-map');

Room = require('./room');

module.exports = Dungeon = (function(superClass) {
  extend(Dungeon, superClass);

  function Dungeon(width, height, seed) {
    if (seed == null) {
      seed = null;
    }
    this.rooms = [];
    Dungeon.__super__.constructor.call(this, width, height, seed);
  }

  Dungeon.prototype.addRoom = function(room, x, y) {
    var j, len, ref, ref1, rx, ry;
    if (!this.willFit(room, x, y)) {
      throw new Error("Can't place Room at " + x + ", " + y + ": Out of Bounds");
    }
    ref = room.allLocations();
    for (j = 0, len = ref.length; j < len; j++) {
      ref1 = ref[j], rx = ref1[0], ry = ref1[1];
      this.set(x + rx, y + ry, room.get(rx, ry));
    }
    room.dungeon = this;
    room.location = [x, y];
    return this.rooms.push(room);
  };

  Dungeon.prototype.adjacentIsCorridor = function(x, y, direction) {
    if (this.adjacentInBounds(x, y, direction)) {
      return this.getAdjacentCell(x, y, direction).corridor;
    } else {
      return false;
    }
  };

  Dungeon.prototype.setBothSides = function(x, y, direction, type) {
    if (!this.inBounds(x, y) || !this.hasAdjacent(x, y, direction)) {
      throw new Error("Can't add " + direction + " " + type + " at " + x + ", " + y + ": Out of Bounds");
    }
    this.setCellSide(x, y, direction, type);
    return this.setCellSide.apply(this, slice.call(this.getAdjacent(x, y, direction)).concat([Direction.opposite(direction)], [type]));
  };

  Dungeon.prototype.createDoor = function(x, y, direction) {
    return this.setBothSides(x, y, direction, Type.DOOR);
  };

  Dungeon.prototype.createCorridor = function(x, y, direction) {
    this.setBothSides(x, y, direction, Type.EMPTY);
    return this.getAdjacent(x, y, direction);
  };

  Dungeon.prototype.willFit = function(room, x, y) {
    if (x == null) {
      x = 0;
    }
    if (y == null) {
      y = 0;
    }
    return room.width <= (this.width - x) && room.height <= (this.height - y);
  };

  Dungeon.prototype.roomPlacementScore = function(room, x, y) {
    var dCell, dX, dY, direction, j, k, len, len1, ref, ref1, roomX, roomY, score;
    if (!this.willFit(room, x, y)) {
      return -Infinity;
    }
    score = 0;
    ref = room.allLocations();
    for (j = 0, len = ref.length; j < len; j++) {
      ref1 = ref[j], roomX = ref1[0], roomY = ref1[1];
      dX = x + roomX;
      dY = y + roomY;
      for (k = 0, len1 = Direction.length; k < len1; k++) {
        direction = Direction[k];
        if (this.adjacentIsCorridor(dX, dY, direction)) {
          score--;
        }
      }
      dCell = this.get(dX, dY);
      if (!dCell.isBlank()) {
        if (dCell.corridor) {
          score -= 3;
        }
        if (!dCell.corridor) {
          score -= 100;
        }
      }
    }
    return score;
  };

  Dungeon.prototype.generateRooms = function(number, minWidth, maxWidth, minHeight, maxHeight) {
    var bestScore, bestSpot, count, dX, dY, j, k, len, newScore, ref, ref1, ref2, room;
    for (count = j = 0, ref = number; 0 <= ref ? j < ref : j > ref; count = 0 <= ref ? ++j : --j) {
      room = new Room(this.Random.next(minWidth, maxWidth), this.Random.next(minHeight, maxHeight));
      bestScore = -Infinity;
      bestSpot = void 0;
      ref1 = this.allLocations();
      for (k = 0, len = ref1.length; k < len; k++) {
        ref2 = ref1[k], dX = ref2[0], dY = ref2[1];
        newScore = this.roomPlacementScore(room, dX, dY);
        if (newScore > bestScore) {
          bestScore = newScore;
          bestSpot = [dX, dY];
        }
      }
      if (bestSpot != null) {
        this.addRoom.apply(this, [room].concat(slice.call(bestSpot)));
      }
    }
    return this;
  };

  Dungeon.prototype.addDoors = function() {
    var dX, dY, direction, j, k, len, len1, rX, rY, ref, ref1, ref2, room;
    ref = this.rooms;
    for (j = 0, len = ref.length; j < len; j++) {
      room = ref[j];
      ref1 = room.location, dX = ref1[0], dY = ref1[1];
      for (k = 0, len1 = Direction.length; k < len1; k++) {
        direction = Direction[k];
        if (!room.hasDoorOnSide(direction)) {
          ref2 = room.getRandomCellAlongSide(direction, this.Random), rX = ref2[0], rY = ref2[1];
          this.createDoor(dX + rX, dY + rY, direction);
        }
      }
    }
    return this;
  };

  Dungeon.prototype.createDenseMaze = function(zigzagyness) {
    var c, d, defaultCell, direction, j, k, len, len1, ref, ref1, ref2, ref3, valid, x, y;
    defaultCell = {};
    for (j = 0, len = Direction.length; j < len; j++) {
      d = Direction[j];
      defaultCell[d] = Type.WALL;
    }
    ref = this.data;
    for (k = 0, len1 = ref.length; k < len1; k++) {
      c = ref[k];
      c.update(defaultCell);
    }
    this.flagAllCellsAsUnvisited();
    ref1 = this.pickRandomUnvisitedCell(), x = ref1[0], y = ref1[1];
    this.visitCell(x, y);
    direction = Direction.NORTH;
    while (!this.allCellsVisited()) {
      ref2 = this.pickRandomVisitedCell(), x = ref2[0], y = ref2[1];
      valid = this.validWalkDirections(x, y);
      while (valid.length > 0 && !this.allCellsVisited()) {
        if (valid.indexOf(direction) === -1 || this.Random.next(1, 99) < zigzagyness) {
          direction = valid[this.Random.next(0, valid.length - 1)];
        }
        ref3 = this.createCorridor(x, y, direction), x = ref3[0], y = ref3[1];
        this.visitCell(x, y);
        valid = this.validWalkDirections(x, y);
      }
    }
    return this;
  };

  Dungeon.prototype.sparsifyMaze = function(sparseness) {
    var cell, cellsToRemove, deadEndDirection, deadEndX, deadEndY, deadEnds, i, j, ref, ref1;
    cellsToRemove = Math.ceil((sparseness / 100) * (this.width * this.height));
    for (i = j = 0, ref = cellsToRemove; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
      deadEnds = this.deadEndLocations();
      if (deadEnds.length === 0) {
        break;
      }
      ref1 = deadEnds[this.Random.next(0, deadEnds.length - 1)], deadEndX = ref1[0], deadEndY = ref1[1];
      cell = this.get(deadEndX, deadEndY);
      deadEndDirection = cell.deadEndDirection();
      this.setBothSides(deadEndX, deadEndY, deadEndDirection, Type.WALL);
    }
    return this;
  };

  Dungeon.prototype.removeDeadEnds = function(deadendRemovalness) {
    var cell, d, deadEndX, deadEndY, j, len, ref, ref1, ref2, validDirection;
    ref = this.deadEndLocations();
    for (j = 0, len = ref.length; j < len; j++) {
      ref1 = ref[j], deadEndX = ref1[0], deadEndY = ref1[1];
      if (this.Random.next(1, 99) < deadendRemovalness) {
        cell = this.get(deadEndX, deadEndY);
        while (cell.isDeadEnd()) {
          validDirection = (function() {
            var k, len1, results;
            results = [];
            for (k = 0, len1 = Direction.length; k < len1; k++) {
              d = Direction[k];
              if (this.hasAdjacent(deadEndX, deadEndY, d) && d !== cell.deadEndDirection()) {
                results.push(d);
              }
            }
            return results;
          }).call(this);
          d = validDirection[this.Random.next(0, validDirection.length - 1)];
          this.createCorridor(deadEndX, deadEndY, d);
          ref2 = this.getAdjacent(deadEndX, deadEndY, d), deadEndX = ref2[0], deadEndY = ref2[1];
          cell = this.get(deadEndX, deadEndY);
        }
      }
    }
    return this;
  };

  return Dungeon;

})(VisitableMap);


},{"./direction":2,"./room":8,"./type":9,"./visitable-map":10}],4:[function(require,module,exports){

/*
An enum is just an array of strings which also sets the values as all-caps parameters.
This allows for both for-each loops and named keys.

For example:
  e = new Enum 'one', 'two'
  e.ONE # => 'one'
  e.TWO # => 'two'
  console.log i for i in e #=> 'one', 'two'
 */
var Enum,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

module.exports = Enum = (function(superClass) {
  extend(Enum, superClass);

  function Enum() {
    var field, i, len;
    this.push.apply(this, arguments);
    for (i = 0, len = this.length; i < len; i++) {
      field = this[i];
      this[field.toUpperCase()] = field;
    }
  }

  return Enum;

})(Array);


},{}],5:[function(require,module,exports){
var Dungeon, generate;

Dungeon = require('./dungeon');

generate = function(opts) {
  var deadendRemovalness, dungeon, height, maxHeight, maxWidth, minHeight, minWidth, ref, ref1, ref10, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, roomCount, seed, sparseness, width, zigzagyness;
  if (opts == null) {
    opts = {};
  }
  width = (ref = opts.width) != null ? ref : 25, height = (ref1 = opts.height) != null ? ref1 : 25, zigzagyness = (ref2 = opts.zigzagyness) != null ? ref2 : 30, sparseness = (ref3 = opts.sparseness) != null ? ref3 : 70, deadendRemovalness = (ref4 = opts.deadendRemovalness) != null ? ref4 : 50, roomCount = (ref5 = opts.roomCount) != null ? ref5 : 10, minWidth = (ref6 = opts.minWidth) != null ? ref6 : 1, maxWidth = (ref7 = opts.maxWidth) != null ? ref7 : 5, minHeight = (ref8 = opts.minHeight) != null ? ref8 : 1, maxHeight = (ref9 = opts.maxHeight) != null ? ref9 : 5, seed = (ref10 = opts.seed) != null ? ref10 : null;
  dungeon = new Dungeon(width, height, seed);
  return dungeon.createDenseMaze(zigzagyness).sparsifyMaze(sparseness).removeDeadEnds(deadendRemovalness).generateRooms(roomCount, minWidth, maxWidth, minHeight, maxHeight);
};

generate.Direction = require('./direction');

generate.Type = require('./type');

module.exports = generate;


},{"./direction":2,"./dungeon":3,"./type":9}],6:[function(require,module,exports){
var ArrayGrid, Cell, Direction, Map,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Direction = require('./direction');

ArrayGrid = require('array-grid');

Cell = require('./cell');


/*
  A 2D array of Cells
 */

Map = (function(superClass) {
  extend(Map, superClass);

  function Map(width, height, defaultCell) {
    var i, len, ref, ref1, x, y;
    this.width = width;
    this.height = height;
    if (defaultCell == null) {
      defaultCell = null;
    }
    Map.__super__.constructor.call(this, new Array(this.width * this.height), [this.width, this.height]);
    ref = this.allLocations();
    for (i = 0, len = ref.length; i < len; i++) {
      ref1 = ref[i], x = ref1[0], y = ref1[1];
      this.set(x, y, new Cell(defaultCell));
    }
  }

  Map.prototype.update = function(x, y, val) {
    if (this.inBounds(x, y)) {
      return this.get(x, y).update(val);
    } else {
      throw new Error("Out of Bounds: " + x + ", " + y);
    }
  };

  Map.prototype.getSide = function(direction) {
    var x, y;
    switch (direction) {
      case Direction.NORTH:
        return (function() {
          var i, ref, results;
          results = [];
          for (x = i = 0, ref = this.width - 1; 0 <= ref ? i <= ref : i >= ref; x = 0 <= ref ? ++i : --i) {
            results.push([x, 0]);
          }
          return results;
        }).call(this);
      case Direction.SOUTH:
        return (function() {
          var i, ref, results;
          results = [];
          for (x = i = 0, ref = this.width - 1; 0 <= ref ? i <= ref : i >= ref; x = 0 <= ref ? ++i : --i) {
            results.push([x, this.height - 1]);
          }
          return results;
        }).call(this);
      case Direction.EAST:
        return (function() {
          var i, ref, results;
          results = [];
          for (y = i = 0, ref = this.height - 1; 0 <= ref ? i <= ref : i >= ref; y = 0 <= ref ? ++i : --i) {
            results.push([this.width - 1, y]);
          }
          return results;
        }).call(this);
      case Direction.WEST:
        return (function() {
          var i, ref, results;
          results = [];
          for (y = i = 0, ref = this.height - 1; 0 <= ref ? i <= ref : i >= ref; y = 0 <= ref ? ++i : --i) {
            results.push([0, y]);
          }
          return results;
        }).call(this);
      default:
        throw new Error("Invalid direction: " + direction);
    }
  };

  Map.prototype.setCellSide = function(x, y, direction, value) {
    return this.get(x, y).setSide(direction, value);
  };

  Map.prototype.allLocations = function() {
    var i, index, ref, results;
    results = [];
    for (index = i = 0, ref = this.data.length - 1; 0 <= ref ? i <= ref : i >= ref; index = 0 <= ref ? ++i : --i) {
      results.push(this.coordsAt(index));
    }
    return results;
  };

  Map.prototype.nonEmptyLocations = function() {
    var cell, i, index, len, ref, results;
    ref = this.data;
    results = [];
    for (index = i = 0, len = ref.length; i < len; index = ++i) {
      cell = ref[index];
      if (!cell.isBlank()) {
        results.push(this.coordsAt(index));
      }
    }
    return results;
  };

  Map.prototype.deadEndLocations = function() {
    var cell, i, index, len, ref, results;
    ref = this.data;
    results = [];
    for (index = i = 0, len = ref.length; i < len; index = ++i) {
      cell = ref[index];
      if (cell.isDeadEnd()) {
        results.push(this.coordsAt(index));
      }
    }
    return results;
  };

  Map.prototype.corridorLocations = function() {
    var cell, i, index, len, ref, results;
    ref = this.data;
    results = [];
    for (index = i = 0, len = ref.length; i < len; index = ++i) {
      cell = ref[index];
      if (cell.corridor) {
        results.push(this.coordsAt(index));
      }
    }
    return results;
  };

  Map.prototype.inBounds = function(x, y) {
    return x >= 0 && x < this.width && y >= 0 && y < this.height;
  };

  Map.prototype.getAdjacent = function(x, y, direction) {
    switch (direction) {
      case Direction.NORTH:
        return [x, y - 1];
      case Direction.SOUTH:
        return [x, y + 1];
      case Direction.WEST:
        return [x - 1, y];
      case Direction.EAST:
        return [x + 1, y];
      default:
        throw new Error("Invalid direction: " + direction);
    }
  };

  Map.prototype.getAdjacentCell = function(x, y, direction) {
    return this.get.apply(this, this.getAdjacent(x, y, direction));
  };

  Map.prototype.adjacentInBounds = function(x, y, direction) {
    return this.inBounds.apply(this, this.getAdjacent(x, y, direction));
  };

  Map.prototype.hasAdjacent = function(x, y, direction) {
    return this.adjacentInBounds(x, y, direction) && !this.getAdjacentCell(x, y, direction).isBlank();
  };

  Map.prototype.getRandomCellAlongSide = function(direction, generator) {
    switch (direction) {
      case Direction.NORTH:
        return [generator.next(0, this.width - 1), 0];
      case Direction.SOUTH:
        return [generator.next(0, this.width - 1), this.height - 1];
      case Direction.WEST:
        return [0, generator.next(0, this.height - 1)];
      case Direction.EAST:
        return [this.width - 1, generator.next(0, this.height - 1)];
      default:
        throw new Error("Invalid direction: " + direction);
    }
  };

  Map.prototype.print = function() {
    var cell, i, j, map, ref, ref1, x, y;
    map = "";
    for (y = i = 0, ref = this.height - 1; 0 <= ref ? i <= ref : i >= ref; y = 0 <= ref ? ++i : --i) {
      for (x = j = 0, ref1 = this.width - 1; 0 <= ref1 ? j <= ref1 : j >= ref1; x = 0 <= ref1 ? ++j : --j) {
        cell = this.get(x, y);
        if (cell.isBlank()) {
          map += ".";
        } else if (cell.isEmpty()) {
          map += " ";
        } else if (cell.corridor) {
          map += "X";
        } else if (cell.doorCount() > 0) {
          map += '\\';
        } else {
          map += "#";
        }
      }
      map += "\n";
    }
    return map;
  };

  Map.prototype.printFull = function() {
    var current, i, j, map, ref, ref1, rows, x, y;
    map = "";
    for (y = i = 0, ref = this.height - 1; 0 <= ref ? i <= ref : i >= ref; y = 0 <= ref ? ++i : --i) {
      rows = ["", "", ""];
      for (x = j = 0, ref1 = this.width - 1; 0 <= ref1 ? j <= ref1 : j >= ref1; x = 0 <= ref1 ? ++j : --j) {
        current = this.get(x, y).print().split("\n");
        rows[0] += current[0];
        rows[1] += current[1];
        rows[2] += current[2];
      }
      map += rows.join("\n") + "\n";
    }
    return map;
  };

  return Map;

})(ArrayGrid);


/*
  If I were to place aMap into bMap at x and y, how many cells would overlap?
 */

Map.overlap = function(aMap, bMap, x, y) {
  var aCells, bCells, i, j, len, len1, overlaps, ref, ref1, xa, xb, ya, yb;
  aCells = aMap.nonEmptyLocations();
  bCells = bMap.nonEmptyLocations();
  overlaps = 0;
  for (i = 0, len = aCells.length; i < len; i++) {
    ref = aCells[i], xa = ref[0], ya = ref[1];
    xa += x;
    ya += y;
    for (j = 0, len1 = bCells.length; j < len1; j++) {
      ref1 = bCells[j], xb = ref1[0], yb = ref1[1];
      if (xa === xb && ya === yb) {
        overlaps++;
      }
    }
  }
  return overlaps;
};

module.exports = Map;


},{"./cell":1,"./direction":2,"array-grid":11}],7:[function(require,module,exports){
var MersenneTwister, RandomJS;

RandomJS = require('random-js');

module.exports = MersenneTwister = (function() {
  function MersenneTwister(seed) {
    if (seed == null) {
      seed = null;
    }
    this.engine = RandomJS.engines.mt19937();
    if (seed != null) {
      this.engine.seed(seed);
    } else {
      this.engine.autoSeed();
    }
  }

  MersenneTwister.prototype.next = function(min, max) {
    if (max == null) {
      max = min;
      min = 0;
    }
    return RandomJS.integer(min, max)(this.engine);
  };

  return MersenneTwister;

})();


},{"random-js":12}],8:[function(require,module,exports){
var Direction, Map, Room, Type,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Map = require('./map');

Type = require('./type');

Direction = require('./direction');

module.exports = Room = (function(superClass) {
  extend(Room, superClass);

  function Room(width, height) {
    Room.__super__.constructor.call(this, width, height, {});
    this.makeWalls();
    this.location = void 0;
    this.dungeon = void 0;
  }

  Room.prototype.hasDoorOnSide = function(direction) {
    var i, len, ref, ref1, x, y;
    ref = this.getSide(direction);
    for (i = 0, len = ref.length; i < len; i++) {
      ref1 = ref[i], x = ref1[0], y = ref1[1];
      if (this.get(x, y).doorCount() > 0) {
        return true;
      }
    }
    return false;
  };

  Room.prototype.makeWalls = function() {
    var direction, i, len, results, x, y;
    results = [];
    for (i = 0, len = Direction.length; i < len; i++) {
      direction = Direction[i];
      results.push((function() {
        var j, len1, ref, ref1, results1;
        ref = this.getSide(direction);
        results1 = [];
        for (j = 0, len1 = ref.length; j < len1; j++) {
          ref1 = ref[j], x = ref1[0], y = ref1[1];
          results1.push(this.get(x, y).setSide(direction, Type.WALL));
        }
        return results1;
      }).call(this));
    }
    return results;
  };

  Room.prototype.makeCorridor = function() {
    var c, i, len, ref, results;
    ref = this.data;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      c = ref[i];
      results.push(c.corridor = true);
    }
    return results;
  };

  return Room;

})(Map);


},{"./direction":2,"./map":6,"./type":9}],9:[function(require,module,exports){
var Enum;

Enum = require('./enum');

module.exports = new Enum('door', 'wall', 'empty');


},{"./enum":4}],10:[function(require,module,exports){
var Direction, MTRandom, Map, VisitableMap,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Direction = require('./direction');

Map = require('./map');

MTRandom = require('./random');

module.exports = VisitableMap = (function(superClass) {
  extend(VisitableMap, superClass);

  function VisitableMap(width, height, seed) {
    if (seed == null) {
      seed = null;
    }
    this.visitedCount = 0;
    this.Random = new MTRandom(seed);
    VisitableMap.__super__.constructor.call(this, width, height, null);
  }

  VisitableMap.prototype.unvisitedLocations = function() {
    var cell, i, index, len, ref, results;
    ref = this.data;
    results = [];
    for (index = i = 0, len = ref.length; i < len; index = ++i) {
      cell = ref[index];
      if (!cell._visited) {
        results.push(this.coordsAt(index));
      }
    }
    return results;
  };

  VisitableMap.prototype.visitedLocations = function() {
    var cell, i, index, len, ref, results;
    ref = this.data;
    results = [];
    for (index = i = 0, len = ref.length; i < len; index = ++i) {
      cell = ref[index];
      if (cell._visited) {
        results.push(this.coordsAt(index));
      }
    }
    return results;
  };

  VisitableMap.prototype.flagAllCellsAsUnvisited = function() {
    var c, i, len, ref;
    ref = this.data;
    for (i = 0, len = ref.length; i < len; i++) {
      c = ref[i];
      c._visited = false;
    }
    return this.visitedCount = 0;
  };

  VisitableMap.prototype.pickRandomUnvisitedCell = function() {
    var unvisited;
    if (this.allCellsVisited()) {
      throw new Error("All cells visited already");
    }
    unvisited = this.unvisitedLocations();
    return unvisited[this.Random.next(0, unvisited.length - 1)];
  };

  VisitableMap.prototype.pickRandomVisitedCell = function() {
    var visited;
    if (this.allCellsVisited()) {
      throw new Error("All cells visited already");
    }
    visited = this.visitedLocations();
    return visited[this.Random.next(0, visited.length - 1)];
  };

  VisitableMap.prototype.visitCell = function(x, y) {
    var cell;
    cell = this.get(x, y);
    if (cell.isVisited()) {
      throw new Error("Cell " + [x, y] + " is already visited");
    }
    cell._visited = true;
    return this.visitedCount++;
  };

  VisitableMap.prototype.adjacentIsVisited = function(x, y, direction) {
    if (this.adjacentInBounds(x, y, direction)) {
      return this.getAdjacentCell(x, y, direction).isVisited();
    }
  };

  VisitableMap.prototype.allCellsVisited = function() {
    return this.visitedCount === this.width * this.height;
  };

  VisitableMap.prototype.validWalkDirections = function(x, y) {
    var d, i, len, results;
    results = [];
    for (i = 0, len = Direction.length; i < len; i++) {
      d = Direction[i];
      if (this.adjacentInBounds(x, y, d) && !this.adjacentIsVisited(x, y, d)) {
        results.push(d);
      }
    }
    return results;
  };

  return VisitableMap;

})(Map);


},{"./direction":2,"./map":6,"./random":7}],11:[function(require,module,exports){
module.exports = ArrayGrid

function ArrayGrid(data, shape, stride, offset){
  
  if (!(this instanceof ArrayGrid)){
    return new ArrayGrid(data, shape, stride, offset)
  }

  this.data = data
  this.shape = shape || [data.length, 1]
  this.stride = stride || [this.shape[1], 1]
  this.offset = offset || 0
}

ArrayGrid.prototype.get = function(row, col){
  if (row < this.shape[0] && col < this.shape[1]){
    return this.data[this.index(row,col)]
  }
}

ArrayGrid.prototype.set = function(row, col, value){
  if (row < this.shape[0] && col < this.shape[1]){
    this.data[this.index(row, col)] = value
    return true
  } else {
    return false
  }
}

ArrayGrid.prototype.index = function(row, col){
  if (row < this.shape[0] && col < this.shape[1]){
    // handle negative stride
    row = this.stride[0] < 0 ? -this.shape[0] + row + 1 : row
    col = this.stride[1] < 0 ? -this.shape[1] + col + 1 : col
    return this.offset + (this.stride[0] * row) + (this.stride[1] * col)
  }
}

ArrayGrid.prototype.place = function(originRow, originCol, array){
  for (var r=0;r<array.shape[0];r++){
    for (var c=0;c<array.shape[1];c++){
      this.set(originRow + r, originCol + c, array.get(r, c))
    }
  }
}

ArrayGrid.prototype.lookup = function(value){
  var index = this.data.indexOf(value)
  if (~index){
    return this.coordsAt(index)
  }
}

ArrayGrid.prototype.coordsAt = function(index){
  var max = this.shape[0] * this.shape[1]
  if (index >= 0 && index < max){
    index = index - this.offset
    return [
      Math.floor(index / this.stride[0]) % this.shape[0],
      Math.floor(index / this.stride[1]) % this.shape[1]
    ]
  }
}
},{}],12:[function(require,module,exports){
/*jshint eqnull:true*/
(function (root) {
  "use strict";

  var GLOBAL_KEY = "Random";

  var imul = (typeof Math.imul !== "function" || Math.imul(0xffffffff, 5) !== -5 ?
    function (a, b) {
      var ah = (a >>> 16) & 0xffff;
      var al = a & 0xffff;
      var bh = (b >>> 16) & 0xffff;
      var bl = b & 0xffff;
      // the shift by 0 fixes the sign on the high part
      // the final |0 converts the unsigned value into a signed value
      return (al * bl) + (((ah * bl + al * bh) << 16) >>> 0) | 0;
    } :
    Math.imul);

  var stringRepeat = (typeof String.prototype.repeat === "function" && "x".repeat(3) === "xxx" ?
    function (x, y) {
      return x.repeat(y);
    } : function (pattern, count) {
      var result = "";
      while (count > 0) {
        if (count & 1) {
          result += pattern;
        }
        count >>= 1;
        pattern += pattern;
      }
      return result;
    });

  function Random(engine) {
    if (!(this instanceof Random)) {
      return new Random(engine);
    }

    if (engine == null) {
      engine = Random.engines.nativeMath;
    } else if (typeof engine !== "function") {
      throw new TypeError("Expected engine to be a function, got " + typeof engine);
    }
    this.engine = engine;
  }
  var proto = Random.prototype;

  Random.engines = {
    nativeMath: function () {
      return (Math.random() * 0x100000000) | 0;
    },
    mt19937: (function (Int32Array) {
      // http://en.wikipedia.org/wiki/Mersenne_twister
      function refreshData(data) {
        var k = 0;
        var tmp = 0;
        for (;
          (k | 0) < 227; k = (k + 1) | 0) {
          tmp = (data[k] & 0x80000000) | (data[(k + 1) | 0] & 0x7fffffff);
          data[k] = data[(k + 397) | 0] ^ (tmp >>> 1) ^ ((tmp & 0x1) ? 0x9908b0df : 0);
        }

        for (;
          (k | 0) < 623; k = (k + 1) | 0) {
          tmp = (data[k] & 0x80000000) | (data[(k + 1) | 0] & 0x7fffffff);
          data[k] = data[(k - 227) | 0] ^ (tmp >>> 1) ^ ((tmp & 0x1) ? 0x9908b0df : 0);
        }

        tmp = (data[623] & 0x80000000) | (data[0] & 0x7fffffff);
        data[623] = data[396] ^ (tmp >>> 1) ^ ((tmp & 0x1) ? 0x9908b0df : 0);
      }

      function temper(value) {
        value ^= value >>> 11;
        value ^= (value << 7) & 0x9d2c5680;
        value ^= (value << 15) & 0xefc60000;
        return value ^ (value >>> 18);
      }

      function seedWithArray(data, source) {
        var i = 1;
        var j = 0;
        var sourceLength = source.length;
        var k = Math.max(sourceLength, 624) | 0;
        var previous = data[0] | 0;
        for (;
          (k | 0) > 0; --k) {
          data[i] = previous = ((data[i] ^ imul((previous ^ (previous >>> 30)), 0x0019660d)) + (source[j] | 0) + (j | 0)) | 0;
          i = (i + 1) | 0;
          ++j;
          if ((i | 0) > 623) {
            data[0] = data[623];
            i = 1;
          }
          if (j >= sourceLength) {
            j = 0;
          }
        }
        for (k = 623;
          (k | 0) > 0; --k) {
          data[i] = previous = ((data[i] ^ imul((previous ^ (previous >>> 30)), 0x5d588b65)) - i) | 0;
          i = (i + 1) | 0;
          if ((i | 0) > 623) {
            data[0] = data[623];
            i = 1;
          }
        }
        data[0] = 0x80000000;
      }

      function mt19937() {
        var data = new Int32Array(624);
        var index = 0;
        var uses = 0;

        function next() {
          if ((index | 0) >= 624) {
            refreshData(data);
            index = 0;
          }

          var value = data[index];
          index = (index + 1) | 0;
          uses += 1;
          return temper(value) | 0;
        }
        next.getUseCount = function() {
          return uses;
        };
        next.discard = function (count) {
          uses += count;
          if ((index | 0) >= 624) {
            refreshData(data);
            index = 0;
          }
          while ((count - index) > 624) {
            count -= 624 - index;
            refreshData(data);
            index = 0;
          }
          index = (index + count) | 0;
          return next;
        };
        next.seed = function (initial) {
          var previous = 0;
          data[0] = previous = initial | 0;

          for (var i = 1; i < 624; i = (i + 1) | 0) {
            data[i] = previous = (imul((previous ^ (previous >>> 30)), 0x6c078965) + i) | 0;
          }
          index = 624;
          uses = 0;
          return next;
        };
        next.seedWithArray = function (source) {
          next.seed(0x012bd6aa);
          seedWithArray(data, source);
          return next;
        };
        next.autoSeed = function () {
          return next.seedWithArray(Random.generateEntropyArray());
        };
        return next;
      }

      return mt19937;
    }(typeof Int32Array === "function" ? Int32Array : Array)),
    browserCrypto: (typeof crypto !== "undefined" && typeof crypto.getRandomValues === "function" && typeof Int32Array === "function") ? (function () {
      var data = null;
      var index = 128;

      return function () {
        if (index >= 128) {
          if (data === null) {
            data = new Int32Array(128);
          }
          crypto.getRandomValues(data);
          index = 0;
        }

        return data[index++] | 0;
      };
    }()) : null
  };

  Random.generateEntropyArray = function () {
    var array = [];
    var engine = Random.engines.nativeMath;
    for (var i = 0; i < 16; ++i) {
      array[i] = engine() | 0;
    }
    array.push(new Date().getTime() | 0);
    return array;
  };

  function returnValue(value) {
    return function () {
      return value;
    };
  }

  // [-0x80000000, 0x7fffffff]
  Random.int32 = function (engine) {
    return engine() | 0;
  };
  proto.int32 = function () {
    return Random.int32(this.engine);
  };

  // [0, 0xffffffff]
  Random.uint32 = function (engine) {
    return engine() >>> 0;
  };
  proto.uint32 = function () {
    return Random.uint32(this.engine);
  };

  // [0, 0x1fffffffffffff]
  Random.uint53 = function (engine) {
    var high = engine() & 0x1fffff;
    var low = engine() >>> 0;
    return (high * 0x100000000) + low;
  };
  proto.uint53 = function () {
    return Random.uint53(this.engine);
  };

  // [0, 0x20000000000000]
  Random.uint53Full = function (engine) {
    while (true) {
      var high = engine() | 0;
      if (high & 0x200000) {
        if ((high & 0x3fffff) === 0x200000 && (engine() | 0) === 0) {
          return 0x20000000000000;
        }
      } else {
        var low = engine() >>> 0;
        return ((high & 0x1fffff) * 0x100000000) + low;
      }
    }
  };
  proto.uint53Full = function () {
    return Random.uint53Full(this.engine);
  };

  // [-0x20000000000000, 0x1fffffffffffff]
  Random.int53 = function (engine) {
    var high = engine() | 0;
    var low = engine() >>> 0;
    return ((high & 0x1fffff) * 0x100000000) + low + (high & 0x200000 ? -0x20000000000000 : 0);
  };
  proto.int53 = function () {
    return Random.int53(this.engine);
  };

  // [-0x20000000000000, 0x20000000000000]
  Random.int53Full = function (engine) {
    while (true) {
      var high = engine() | 0;
      if (high & 0x400000) {
        if ((high & 0x7fffff) === 0x400000 && (engine() | 0) === 0) {
          return 0x20000000000000;
        }
      } else {
        var low = engine() >>> 0;
        return ((high & 0x1fffff) * 0x100000000) + low + (high & 0x200000 ? -0x20000000000000 : 0);
      }
    }
  };
  proto.int53Full = function () {
    return Random.int53Full(this.engine);
  };

  function add(generate, addend) {
    if (addend === 0) {
      return generate;
    } else {
      return function (engine) {
        return generate(engine) + addend;
      };
    }
  }

  Random.integer = (function () {
    function isPowerOfTwoMinusOne(value) {
      return ((value + 1) & value) === 0;
    }

    function bitmask(masking) {
      return function (engine) {
        return engine() & masking;
      };
    }

    function downscaleToLoopCheckedRange(range) {
      var extendedRange = range + 1;
      var maximum = extendedRange * Math.floor(0x100000000 / extendedRange);
      return function (engine) {
        var value = 0;
        do {
          value = engine() >>> 0;
        } while (value >= maximum);
        return value % extendedRange;
      };
    }

    function downscaleToRange(range) {
      if (isPowerOfTwoMinusOne(range)) {
        return bitmask(range);
      } else {
        return downscaleToLoopCheckedRange(range);
      }
    }

    function isEvenlyDivisibleByMaxInt32(value) {
      return (value | 0) === 0;
    }

    function upscaleWithHighMasking(masking) {
      return function (engine) {
        var high = engine() & masking;
        var low = engine() >>> 0;
        return (high * 0x100000000) + low;
      };
    }

    function upscaleToLoopCheckedRange(extendedRange) {
      var maximum = extendedRange * Math.floor(0x20000000000000 / extendedRange);
      return function (engine) {
        var ret = 0;
        do {
          var high = engine() & 0x1fffff;
          var low = engine() >>> 0;
          ret = (high * 0x100000000) + low;
        } while (ret >= maximum);
        return ret % extendedRange;
      };
    }

    function upscaleWithinU53(range) {
      var extendedRange = range + 1;
      if (isEvenlyDivisibleByMaxInt32(extendedRange)) {
        var highRange = ((extendedRange / 0x100000000) | 0) - 1;
        if (isPowerOfTwoMinusOne(highRange)) {
          return upscaleWithHighMasking(highRange);
        }
      }
      return upscaleToLoopCheckedRange(extendedRange);
    }

    function upscaleWithinI53AndLoopCheck(min, max) {
      return function (engine) {
        var ret = 0;
        do {
          var high = engine() | 0;
          var low = engine() >>> 0;
          ret = ((high & 0x1fffff) * 0x100000000) + low + (high & 0x200000 ? -0x20000000000000 : 0);
        } while (ret < min || ret > max);
        return ret;
      };
    }

    return function (min, max) {
      min = Math.floor(min);
      max = Math.floor(max);
      if (min < -0x20000000000000 || !isFinite(min)) {
        throw new RangeError("Expected min to be at least " + (-0x20000000000000));
      } else if (max > 0x20000000000000 || !isFinite(max)) {
        throw new RangeError("Expected max to be at most " + 0x20000000000000);
      }

      var range = max - min;
      if (range <= 0 || !isFinite(range)) {
        return returnValue(min);
      } else if (range === 0xffffffff) {
        if (min === 0) {
          return Random.uint32;
        } else {
          return add(Random.int32, min + 0x80000000);
        }
      } else if (range < 0xffffffff) {
        return add(downscaleToRange(range), min);
      } else if (range === 0x1fffffffffffff) {
        return add(Random.uint53, min);
      } else if (range < 0x1fffffffffffff) {
        return add(upscaleWithinU53(range), min);
      } else if (max - 1 - min === 0x1fffffffffffff) {
        return add(Random.uint53Full, min);
      } else if (min === -0x20000000000000 && max === 0x20000000000000) {
        return Random.int53Full;
      } else if (min === -0x20000000000000 && max === 0x1fffffffffffff) {
        return Random.int53;
      } else if (min === -0x1fffffffffffff && max === 0x20000000000000) {
        return add(Random.int53, 1);
      } else if (max === 0x20000000000000) {
        return add(upscaleWithinI53AndLoopCheck(min - 1, max - 1), 1);
      } else {
        return upscaleWithinI53AndLoopCheck(min, max);
      }
    };
  }());
  proto.integer = function (min, max) {
    return Random.integer(min, max)(this.engine);
  };

  // [0, 1] (floating point)
  Random.realZeroToOneInclusive = function (engine) {
    return Random.uint53Full(engine) / 0x20000000000000;
  };
  proto.realZeroToOneInclusive = function () {
    return Random.realZeroToOneInclusive(this.engine);
  };

  // [0, 1) (floating point)
  Random.realZeroToOneExclusive = function (engine) {
    return Random.uint53(engine) / 0x20000000000000;
  };
  proto.realZeroToOneExclusive = function () {
    return Random.realZeroToOneExclusive(this.engine);
  };

  Random.real = (function () {
    function multiply(generate, multiplier) {
      if (multiplier === 1) {
        return generate;
      } else if (multiplier === 0) {
        return function () {
          return 0;
        };
      } else {
        return function (engine) {
          return generate(engine) * multiplier;
        };
      }
    }

    return function (left, right, inclusive) {
      if (!isFinite(left)) {
        throw new RangeError("Expected left to be a finite number");
      } else if (!isFinite(right)) {
        throw new RangeError("Expected right to be a finite number");
      }
      return add(
        multiply(
          inclusive ? Random.realZeroToOneInclusive : Random.realZeroToOneExclusive,
          right - left),
        left);
    };
  }());
  proto.real = function (min, max, inclusive) {
    return Random.real(min, max, inclusive)(this.engine);
  };

  Random.bool = (function () {
    function isLeastBitTrue(engine) {
      return (engine() & 1) === 1;
    }

    function lessThan(generate, value) {
      return function (engine) {
        return generate(engine) < value;
      };
    }

    function probability(percentage) {
      if (percentage <= 0) {
        return returnValue(false);
      } else if (percentage >= 1) {
        return returnValue(true);
      } else {
        var scaled = percentage * 0x100000000;
        if (scaled % 1 === 0) {
          return lessThan(Random.int32, (scaled - 0x80000000) | 0);
        } else {
          return lessThan(Random.uint53, Math.round(percentage * 0x20000000000000));
        }
      }
    }

    return function (numerator, denominator) {
      if (denominator == null) {
        if (numerator == null) {
          return isLeastBitTrue;
        }
        return probability(numerator);
      } else {
        if (numerator <= 0) {
          return returnValue(false);
        } else if (numerator >= denominator) {
          return returnValue(true);
        }
        return lessThan(Random.integer(0, denominator - 1), numerator);
      }
    };
  }());
  proto.bool = function (numerator, denominator) {
    return Random.bool(numerator, denominator)(this.engine);
  };

  function toInteger(value) {
    var number = +value;
    if (number < 0) {
      return Math.ceil(number);
    } else {
      return Math.floor(number);
    }
  }

  function convertSliceArgument(value, length) {
    if (value < 0) {
      return Math.max(value + length, 0);
    } else {
      return Math.min(value, length);
    }
  }
  Random.pick = function (engine, array, begin, end) {
    var length = array.length;
    var start = begin == null ? 0 : convertSliceArgument(toInteger(begin), length);
    var finish = end === void 0 ? length : convertSliceArgument(toInteger(end), length);
    if (start >= finish) {
      return void 0;
    }
    var distribution = Random.integer(start, finish - 1);
    return array[distribution(engine)];
  };
  proto.pick = function (array, begin, end) {
    return Random.pick(this.engine, array, begin, end);
  };

  function returnUndefined() {
    return void 0;
  }
  var slice = Array.prototype.slice;
  Random.picker = function (array, begin, end) {
    var clone = slice.call(array, begin, end);
    if (!clone.length) {
      return returnUndefined;
    }
    var distribution = Random.integer(0, clone.length - 1);
    return function (engine) {
      return clone[distribution(engine)];
    };
  };

  Random.shuffle = function (engine, array, downTo) {
    var length = array.length;
    if (length) {
      if (downTo == null) {
        downTo = 0;
      }
      for (var i = (length - 1) >>> 0; i > downTo; --i) {
        var distribution = Random.integer(0, i);
        var j = distribution(engine);
        if (i !== j) {
          var tmp = array[i];
          array[i] = array[j];
          array[j] = tmp;
        }
      }
    }
    return array;
  };
  proto.shuffle = function (array) {
    return Random.shuffle(this.engine, array);
  };

  Random.sample = function (engine, population, sampleSize) {
    if (sampleSize < 0 || sampleSize > population.length || !isFinite(sampleSize)) {
      throw new RangeError("Expected sampleSize to be within 0 and the length of the population");
    }

    if (sampleSize === 0) {
      return [];
    }

    var clone = slice.call(population);
    var length = clone.length;
    if (length === sampleSize) {
      return Random.shuffle(engine, clone, 0);
    }
    var tailLength = length - sampleSize;
    return Random.shuffle(engine, clone, tailLength - 1).slice(tailLength);
  };
  proto.sample = function (population, sampleSize) {
    return Random.sample(this.engine, population, sampleSize);
  };

  Random.die = function (sideCount) {
    return Random.integer(1, sideCount);
  };
  proto.die = function (sideCount) {
    return Random.die(sideCount)(this.engine);
  };

  Random.dice = function (sideCount, dieCount) {
    var distribution = Random.die(sideCount);
    return function (engine) {
      var result = [];
      result.length = dieCount;
      for (var i = 0; i < dieCount; ++i) {
        result[i] = distribution(engine);
      }
      return result;
    };
  };
  proto.dice = function (sideCount, dieCount) {
    return Random.dice(sideCount, dieCount)(this.engine);
  };

  // http://en.wikipedia.org/wiki/Universally_unique_identifier
  Random.uuid4 = (function () {
    function zeroPad(string, zeroCount) {
      return stringRepeat("0", zeroCount - string.length) + string;
    }

    return function (engine) {
      var a = engine() >>> 0;
      var b = engine() | 0;
      var c = engine() | 0;
      var d = engine() >>> 0;

      return (
        zeroPad(a.toString(16), 8) +
        "-" +
        zeroPad((b & 0xffff).toString(16), 4) +
        "-" +
        zeroPad((((b >> 4) & 0x0fff) | 0x4000).toString(16), 4) +
        "-" +
        zeroPad(((c & 0x3fff) | 0x8000).toString(16), 4) +
        "-" +
        zeroPad(((c >> 4) & 0xffff).toString(16), 4) +
        zeroPad(d.toString(16), 8));
    };
  }());
  proto.uuid4 = function () {
    return Random.uuid4(this.engine);
  };

  Random.string = (function () {
    // has 2**x chars, for faster uniform distribution
    var DEFAULT_STRING_POOL = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-";

    return function (pool) {
      if (pool == null) {
        pool = DEFAULT_STRING_POOL;
      }

      var length = pool.length;
      if (!length) {
        throw new Error("Expected pool not to be an empty string");
      }

      var distribution = Random.integer(0, length - 1);
      return function (engine, length) {
        var result = "";
        for (var i = 0; i < length; ++i) {
          var j = distribution(engine);
          result += pool.charAt(j);
        }
        return result;
      };
    };
  }());
  proto.string = function (length, pool) {
    return Random.string(pool)(this.engine, length);
  };

  Random.hex = (function () {
    var LOWER_HEX_POOL = "0123456789abcdef";
    var lowerHex = Random.string(LOWER_HEX_POOL);
    var upperHex = Random.string(LOWER_HEX_POOL.toUpperCase());

    return function (upper) {
      if (upper) {
        return upperHex;
      } else {
        return lowerHex;
      }
    };
  }());
  proto.hex = function (length, upper) {
    return Random.hex(upper)(this.engine, length);
  };

  Random.date = function (start, end) {
    if (!(start instanceof Date)) {
      throw new TypeError("Expected start to be a Date, got " + typeof start);
    } else if (!(end instanceof Date)) {
      throw new TypeError("Expected end to be a Date, got " + typeof end);
    }
    var distribution = Random.integer(start.getTime(), end.getTime());
    return function (engine) {
      return new Date(distribution(engine));
    };
  };
  proto.date = function (start, end) {
    return Random.date(start, end)(this.engine);
  };

  if (typeof define === "function" && define.amd) {
    define(function () {
      return Random;
    });
  } else if (typeof module !== "undefined" && typeof require === "function") {
    module.exports = Random;
  } else {
    (function () {
      var oldGlobal = root[GLOBAL_KEY];
      Random.noConflict = function () {
        root[GLOBAL_KEY] = oldGlobal;
        return this;
      };
    }());
    root[GLOBAL_KEY] = Random;
  }
}(this));
},{}]},{},[5])(5)
});