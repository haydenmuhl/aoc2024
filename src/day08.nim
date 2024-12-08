import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets


proc part1 =
  let infile = open("data/day08.txt")
  defer: infile.close()

  var antennas = initTable[char, seq[Point]]()
  var y = 0
  let lines = infile.readLines()
  for line in lines:
    var x = 0
    for c in line:
      if c != '.':
        if not antennas.hasKey(c):
          antennas[c] = newSeq[Point]()
        antennas[c].add(Point(x: x, y: y))
      x += 1
    y += 1
  let width = lines[0].len()
  let height = lines.len()

  var antinodes = initHashSet[Point]()
  for key in antennas.keys():
    var aIdx = 0
    while aIdx < antennas[key].len() - 1:
      let a = antennas[key][aIdx]
      var bIdx = aIdx + 1
      while bIdx < antennas[key].len():
        let b = antennas[key][bIdx]
        let diff = a - b
        let antinodeA = a + diff
        let antinodeB = b - diff
        if antinodeA.x >= 0 and antinodeA.x < width and antinodeA.y >= 0 and antinodeA.y < height:
          antinodes.incl(antinodeA)
        if antinodeB.x >= 0 and antinodeB.x < width and antinodeB.y >= 0 and antinodeB.y < height:
          antinodes.incl(antinodeB)
        bIdx += 1
      aIdx += 1
  # echo(antennas)
  # echo(antinodes)
  echo(antinodes.len())


proc part2 =
  let infile = open("data/day08.txt")
  defer: infile.close()

  var antennas = initTable[char, seq[Point]]()
  var y = 0
  let lines = infile.readLines()
  for line in lines:
    var x = 0
    for c in line:
      if c != '.':
        if not antennas.hasKey(c):
          antennas[c] = newSeq[Point]()
        antennas[c].add(Point(x: x, y: y))
      x += 1
    y += 1
  let width = lines[0].len()
  let height = lines.len()

  var antinodes = initHashSet[Point]()
  for key in antennas.keys():
    var aIdx = 0
    while aIdx < antennas[key].len() - 1:
      let a = antennas[key][aIdx]
      var bIdx = aIdx + 1
      while bIdx < antennas[key].len():
        let b = antennas[key][bIdx]
        let diff = a - b
        var antinodeA = a + diff
        var antinodeB = b - diff
        antinodes.incl(a)
        antinodes.incl(b)
        while antinodeA.x >= 0 and antinodeA.x < width and antinodeA.y >= 0 and antinodeA.y < height:
          antinodes.incl(antinodeA)
          antinodeA += diff
        while antinodeB.x >= 0 and antinodeB.x < width and antinodeB.y >= 0 and antinodeB.y < height:
          antinodes.incl(antinodeB)
          antinodeB -= diff
        bIdx += 1
      aIdx += 1
  echo(antennas)
  echo(antinodes)
  echo(antinodes.len())

when isMainModule:
  # part1()
  part2()
