import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets
import std/math


proc part1 =
  let infile = open("data/day13.txt")
  defer: infile.close()

  var total = 0
  while true:
    let rawA = infile.readLine().parseInts()
    let rawB = infile.readLine().parseInts()
    let rawP = infile.readLine().parseInts()
    let aBtn = Point(x: rawA[0], y: rawA[1])
    let bBtn = Point(x: rawB[0], y: rawB[1])
    let prize = Point(x: rawP[0], y: rawP[1])

    var minTokens = high(int)
    for a in 0..100:
      for b in 0..100:
        if (a * aBtn) + (b * bBtn) == prize:
          let tokens = (3 * a) + b
          if tokens < minTokens:
            minTokens = tokens
    if minTokens == high(int):
      minTokens = 0
    total += minTokens
    if infile.endOfFile():
      break
    discard infile.readLine()
  echo(total)




proc find(aBtn, bBtn, prize: Point): int =
  var x = @[aBtn.x, bBtn.x, prize.x]
  var y = @[aBtn.y, bBtn.y, prize.y]

  var tmpRow = x.mapIt(it * (lcm(aBtn.x, aBtn.y) div aBtn.x))
  y = y.mapIt(it * (lcm(aBtn.x, aBtn.y) div aBtn.y))
  y = y.zip(tmpRow).mapIt(it[0] - it[1])
  y = y.mapIt(it div y[1])
  tmpRow = y.mapIt(it * x[1])
  x = x.zip(tmpRow).mapIt(it[0] - it[1])
  x = x.mapIt(it div x[0])

  let a = x[2]
  let b = y[2]

  result = 0
  if (a * aBtn) + (b * bBtn) == prize:
    result = (3 * a) + b

proc part2 =
  let infile = open("data/day13.txt")
  defer: infile.close()

  var total = 0
  while true:
    let rawA = infile.readLine().parseInts()
    let rawB = infile.readLine().parseInts()
    let rawP = infile.readLine().parseInts()
    let aBtn = Point(x: rawA[0], y: rawA[1])
    let bBtn = Point(x: rawB[0], y: rawB[1])
    let prize = Point(x: rawP[0] + 10000000000000, y: rawP[1] + 10000000000000)
    # let prize = Point(x: rawP[0], y: rawP[1])

    total += find(aBtn, bBtn, prize)

    if infile.endOfFile():
      break
    discard infile.readLine()
  echo(total)

when isMainModule:
  # part1()
  part2()
