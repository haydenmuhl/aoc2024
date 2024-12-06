import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets

import typetraits


proc turn(dir: Point): Point =
    if dir == up:
      left
    elif dir == right:
      up
    elif dir == down:
      right
    elif dir == left:
      down
    else:
      raise newException(ValueError, "Invalid direction")

proc inBounds(field: seq[string], p: Point): bool =
  let width = field[0].len()
  let height = field.len()
  p.x >= 0 and p.x < width and p.y >= 0 and p.y < height

proc get(field: seq[string], p: Point): char =
  if inBounds(field, p):
    field[p.y][p.x]
  else:
    '.'

proc part1 =
  let infile = open("data/day06.txt")
  defer: infile.close()

  let field = infile.readLines()

  var path = initHashSet[Point]()
  let width = field[0].len()
  let height = field.len()

  var guard = Point(x: -1,y: -1)
  for y in 0 ..< height:
    for x in 0 ..< width:
      if field[y][x] == '^':
        guard = Point(x: x, y: y)
        break
    if guard.x != -1:
      break

  var dir = down
  while inBounds(field, guard):
    path.incl(guard)
    if field.get(guard + dir) == '#':
      dir = turn(dir)
    guard += dir
  echo(path.len())


proc makesLoop(field: seq[string], guard, stone: Point): bool =
  var guard = guard
  var path = initHashSet[(Point, Point)]()
  result = false
  var dir = down
  while true:
    # echo(fmt"{guard}, {dir}")
    if path.contains((guard, dir)):
      # echo("loop")
      result = true
      break
    path.incl((guard, dir))
    while field.get(guard + dir) == '#' or guard + dir == stone:
      dir = turn(dir)
    guard += dir
    if not inBounds(field, guard):
      # echo("out")
      break

proc part2 =
  let infile = open("data/day06.txt")
  defer: infile.close()

  let field = infile.readLines()

  var originalPath = initHashSet[Point]()
  let width = field[0].len()
  let height = field.len()

  var guard = Point(x: -1,y: -1)
  for y in 0 ..< height:
    for x in 0 ..< width:
      if field[y][x] == '^':
        guard = Point(x: x, y: y)
        break
    if guard.x != -1:
      break
  let originalGuard = guard

  var dir = down
  while true:
    if field.get(guard + dir) == '#':
      dir = turn(dir)
    guard += dir
    if not inBounds(field, guard):
      break
    originalPath.incl(guard)
  originalPath.excl(originalGuard)

  var total = 0
  for p in originalPath:
    #echo(fmt"Run {p}")
    #echo()
    if makesLoop(field, originalGuard, p):
      total += 1
    #echo()
  echo(total)


when isMainModule:
  # part1()
  part2()
