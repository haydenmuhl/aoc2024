import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques


proc matches(a, b: string): int =
  var total = 0
  if a == b:
    total += 1
  if a == b.reversed():
    total += 1
  return total

proc part1 =
  let infile = open("data/day04.txt")
  defer: infile.close()

  let needle = "XMAS"

  let lines = infile.lines().toSeq()
  let width = len(lines[0])
  let height = len(lines)

  var total = 0
  var p = Point(x: 0, y: 0)
  while p.y < height:
    p.x = 0
    while p.x < width:
      let widthOk = p.x <= width - 4
      let heightOk = p.y <= height - 4

      if widthOk:
        let candidate = @[lines[p.y][p.x],lines[p.y][p.x + 1],lines[p.y][p.x + 2],lines[p.y][p.x + 3]].toSeq().join("")
        total += matches(candidate, needle)
      if heightOk:
        let candidate = @[lines[p.y][p.x],lines[p.y + 1][p.x],lines[p.y + 2][p.x],lines[p.y + 3][p.x]].toSeq().join("")
        total += matches(candidate, needle)
      if widthOk and heightOk:
        let candidateForward = @[lines[p.y + 3][p.x], lines[p.y + 2][p.x + 1], lines[p.y + 1][p.x + 2], lines[p.y][p.x + 3]].toSeq().join("")
        total += matches(candidateForward, needle)
        let candidateBack = @[lines[p.y][p.x], lines[p.y + 1][p.x + 1], lines[p.y + 2][p.x + 2], lines[p.y + 3][p.x + 3]].toSeq().join("")
        total += matches(candidateBack, needle)

      p.x += 1
    p.y += 1
  echo(total)


proc part2 =
  let infile = open("data/day04.txt")
  defer: infile.close()

  let needle = "MAS"

  let lines = infile.lines().toSeq()
  let width = len(lines[0])
  let height = len(lines)

  var total = 0
  var p = Point(x: 1, y: 1)
  while p.y < height - 1:
    p.x = 1
    while p.x < width - 1:
      if lines[p.y][p.x] == 'A':
        let forward = @[lines[p.y - 1][p.x + 1], lines[p.y][p.x], lines[p.y + 1][p.x - 1]].toSeq().join("")
        let back = @[lines[p.y - 1][p.x - 1], lines[p.y][p.x], lines[p.y + 1][p.x + 1]].toSeq().join("")
        if (forward == needle or forward == needle.reversed()) and
           (back == needle or back == needle.reversed()):
          total += 1
      p.x += 1
    p.y += 1
  echo(total)

when isMainModule:
  # part1()
  part2()
