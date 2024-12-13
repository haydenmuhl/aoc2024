import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets


type Region = object
  points: HashSet[Point]
  perimeter: int
  name: char
  edges: int

proc add(region: var Region, candidate: Point, unclaimed: HashSet[Point], field: seq[string]): bool =
  if region.points.len() == 0:
    region.points.incl(candidate)
    region.perimeter = 4
    region.name = field.get(candidate)
    return true

  if region.points.contains(candidate):
    return false

  if field.get(candidate) != region.name:
    return false

  let neighbors = candidate.adjacent()
  for neighbor in neighbors:
    if region.points.contains(neighbor):
      region.points.incl(candidate)
      region.perimeter += 4
      for n in neighbors:
        if region.points.contains(n):
          region.perimeter -= 2
      return true
  return false


proc part1 =
  let infile = open("data/day12.txt")
  defer: infile.close()

  var unclaimed = initHashSet[Point]()
  let field = infile.readLines()
  for y, line in field:
    for x, _ in line:
      unClaimed.incl(Point(x: x, y: y))

  var regions = newSeq[Region]()
  while unclaimed.len() > 0:
    var candidates = initDeque[Point]()
    var region: Region
    let seed = unclaimed.pop()
    unclaimed.incl(seed)
    candidates.addLast(seed)
    while candidates.len() > 0:
      let candidate = candidates.popFirst()
      if unclaimed.contains(candidate):
        let added = region.add(candidate, unclaimed, field)
        if added:
          unclaimed.excl(candidate)
          for neighbor in candidate.adjacent():
            candidates.addLast(neighbor)
    regions.add(region)

  var total = 0
  for region in regions:
    total += region.points.len() * region.perimeter
  echo(total)


proc part2 =
  let infile = open("data/day12.txt")
  defer: infile.close()

  var unclaimed = initHashSet[Point]()
  let field = infile.readLines()
  for y, line in field:
    for x, _ in line:
      unClaimed.incl(Point(x: x, y: y))

  var regionTable = initTable[Point, ptr Region]()
  var regions = newSeq[Region]()
  while unclaimed.len() > 0:
    var candidates = initDeque[Point]()
    var region: Region
    let seed = unclaimed.pop()
    unclaimed.incl(seed)
    candidates.addLast(seed)
    while candidates.len() > 0:
      let candidate = candidates.popFirst()
      if unclaimed.contains(candidate):
        let added = region.add(candidate, unclaimed, field)
        if added:
          unclaimed.excl(candidate)
          for neighbor in candidate.adjacent():
            candidates.addLast(neighbor)
    regions.add(region)

  for region in regions:
    for p in region.points:
      regionTable[p] = addr region

  let height = field.len()
  let width = field[0].len()

  var currentRegion: ptr Region = nil
  var cursor: Point
  # y positive
  cursor = Point(x: 0, y: 0)
  while cursor.y < height:
    cursor.x = 0
    currentRegion = nil
    while cursor.x < width:
      var nextRegion = regionTable[cursor]
      if currentRegion != nextRegion:
        currentRegion = nextRegion
        let neighbor = field.get(cursor + down, '.')
        if neighbor != currentRegion.name:
          currentRegion.edges += 1
      else:
        let neighbor = field.get(cursor + down, '.')
        let diag = field.get(cursor + down + left, '.')
        if currentRegion.name == diag and currentRegion.name != neighbor:
          currentRegion.edges += 1
      cursor.x += 1
    cursor.y += 1

  # y negative
  cursor = Point(x: 0, y: height - 1)
  while cursor.y >= 0:
    cursor.x = 0
    currentRegion = nil
    while cursor.x < width:
      var nextRegion = regionTable[cursor]
      if currentRegion != nextRegion:
        currentRegion = nextRegion
        let neighbor = field.get(cursor + up, '.')
        if neighbor != currentRegion.name:
          currentRegion.edges += 1
      else:
        let neighbor = field.get(cursor + up, '.')
        let diag = field.get(cursor + up + left, '.')
        if currentRegion.name == diag and currentRegion.name != neighbor:
          currentRegion.edges += 1
      cursor.x += 1
    cursor.y -= 1

  # x positive
  cursor = Point(x: 0, y: 0)
  while cursor.x < width:
    cursor.y = 0
    currentRegion = nil
    while cursor.y < height:
      var nextRegion = regionTable[cursor]
      if currentRegion != nextRegion:
        currentRegion = nextRegion
        let neighbor = field.get(cursor + left, '.')
        if neighbor != currentRegion.name:
          currentRegion.edges += 1
      else:
        let neighbor = field.get(cursor + left, '.')
        let diag = field.get(cursor + left + down, '.')
        if currentRegion.name == diag and currentRegion.name != neighbor:
          currentRegion.edges += 1
      cursor.y += 1
    cursor.x += 1

  # x negative
  cursor = Point(x: width - 1, y: 0)
  while cursor.x >= 0:
    cursor.y = 0
    currentRegion = nil
    while cursor.y < height:
      var nextRegion = regionTable[cursor]
      if currentRegion != nextRegion:
        currentRegion = nextRegion
        let neighbor = field.get(cursor + right, '.')
        if neighbor != currentRegion.name:
          currentRegion.edges += 1
      else:
        let neighbor = field.get(cursor + right, '.')
        let diag = field.get(cursor + right + down, '.')
        if currentRegion.name == diag and currentRegion.name != neighbor:
          currentRegion.edges += 1
      cursor.y += 1
    cursor.x -= 1

  var total = 0
  for region in regions:
    total += region.points.len() * region.edges
  echo(total)


when isMainModule:
  # part1()
  part2()
