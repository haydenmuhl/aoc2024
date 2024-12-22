import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets

type TileType = enum
  Start,
  Finish,
  Track,
  Wall

type Tile = object
  tileType: TileType
  distance: int
  location: Point

proc toTileType(ch: char): TileType =
  case ch:
    of '.':
      return Track
    of '#':
      return Wall
    of 'S':
      return Start
    of 'E':
      return Finish
    else:
      echo("Oops: ", ch)
      quit(1)

proc get(track: Table[Point, Tile], key: Point): Tile =
  if track.hasKey(key):
    return track[key]
  else:
    return Tile(
      tileType: Wall,
      distance: low(int),
      location: Point(x: -1, y: -1)
    )

proc cheat(track: Table[Point, Tile], here: Tile, dir: Point): int =
  let wall = track.get(here.location + dir)
  let space = track.get(here.location + dir + dir)
  if wall.tileType != Wall:
    return 0
  if space.tileType == Wall:
    return 0
  return space.distance - (here.distance + 2)

proc next(track: Table[Point, Tile], here: Tile): Tile =
  let neighbors = here.location.adjacent().mapIt(track.get(it))
  for n in neighbors:
    if n.tileType == Wall:
      continue
    if n.distance == here.distance + 1:
      return n
  return here

proc part1 =
  let infile = open("data/day20.txt")
  defer: infile.close()

  var track = initTable[Point, Tile]()
  var start: Tile
  var finish: Tile
  var y = 0
  for line in infile.lines():
    for x, ch in line:
      let here = Point(x: x, y: y)
      track[here] = Tile(
        tileType: ch.toTileType(),
        distance: -1,
        location: here
      )
      if track[here].tileType == Start:
        start = track[here]
      if track[here].tileType == Finish:
        finish = track[here]
    y += 1

  var here = start
  start.distance = 0
  var distance = 0
  while true:
    distance += 1
    let neighbors = here.location.adjacent()
    for pt in neighbors:
      let neighbor = track[pt]
      case neighbor.tileType:
        of Track, Finish:
          if neighbor.distance == -1:
            track[pt].distance = distance
            here = track[pt]
            break
        else:
          discard
    if here.tileType == Finish:
      break

  var total = 0
  here = start
  while here.location != finish.location:
    echo(here)
    echo(finish)
    # discard stdin.readLine()
    for dir in [up, down, left, right]:
      let advantage = cheat(track, here, dir)
      echo(dir)
      echo(advantage)
      if advantage >= 100:
        total += 1
    here = track.next(here)
  echo(total)


proc magnitude(a: Point): int =
  result = 0
  if a.x > 0:
    result += a.x
  else:
    result -= a.x

  if a.y > 0:
    result += a.y
  else:
    result -= a.y


proc superCheat(track: Table[Point, Tile], here: Tile): int =
  for x in -20..20:
    for y in -20..20:
      let dir = Point(x: x, y: y)
      if magnitude(dir) > 20:
        continue
      let destination = track.get(here.location + dir)
      if destination.tileType == Wall:
        continue
      let advantage = destination.distance - (here.distance + magnitude(dir))
      # echo(destination)
      # echo(advantage)
      if advantage >= 100:
        result += 1


proc part2 =
  let infile = open("data/day20.txt")
  defer: infile.close()

  var track = initTable[Point, Tile]()
  var start: Tile
  var finish: Tile
  var y = 0
  for line in infile.lines():
    for x, ch in line:
      let here = Point(x: x, y: y)
      track[here] = Tile(
        tileType: ch.toTileType(),
        distance: -1,
        location: here
      )
      if track[here].tileType == Start:
        start = track[here]
      if track[here].tileType == Finish:
        finish = track[here]
    y += 1

  var here = start
  start.distance = 0
  var distance = 0
  while true:
    distance += 1
    let neighbors = here.location.adjacent()
    for pt in neighbors:
      let neighbor = track[pt]
      case neighbor.tileType:
        of Track, Finish:
          if neighbor.distance == -1:
            track[pt].distance = distance
            here = track[pt]
            break
        else:
          discard
    if here.tileType == Finish:
      break

  var total = 0
  here = start
  while here.location != finish.location:
    # echo(here)
    total += superCheat(track, here)
    # discard stdin.readLine()
    here = track.next(here)
  echo(total)



when isMainModule:
  # part1()
  part2()
