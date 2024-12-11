import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets


proc score(field: seq[string], trailhead: Point): int =
  var now, next: ref HashSet[Point]

  now = HashSet[Point].new()
  now[].incl(trailhead)

  for target in '1'..'9':
    next = HashSet[Point].new()
    for loc in now[]:
      for p in loc.adjacent():
        if field.inBounds(p) and field.get(p) == target:
          next[].incl(p)
    now = next
    next = nil
  return now[].len()

proc part1 =
  let infile = open("data/day10.txt")
  defer: infile.close()

  let field = infile.readLines()

  var total = 0
  for y, line in field:
    for x, c in line:
      let here = Point(x: x, y: y)
      if field[y][x] == '0':
        total += score(field, here)
  echo(total)

proc rating(field: seq[string], trailhead: Point): int =
  var now, next: ref Table[Point, int]

  now = Table[Point, int].new()
  now[trailhead] = 1

  for target in '1'..'9':
    next = Table[Point, int].new()
    for loc in now[].keys():
      for p in loc.adjacent():
        if field.inBounds(p) and field.get(p) == target:
          if not next[].hasKey(p):
            next[p] = 0
          next[p] += now[loc]
    now = next
    next = nil
  for v in now[].values():
    result += v


proc part2 =
  let infile = open("data/day10.txt")
  defer: infile.close()

  let field = infile.readLines()

  var total = 0
  for y, line in field:
    for x, c in line:
      let here = Point(x: x, y: y)
      if field[y][x] == '0':
        total += rating(field, here)
  echo(total)


when isMainModule:
  # part1()
  part2()
