import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets
import std/bitops


proc nextRand(r: int): int =
  result = r
  result = bitxor(result, result shl 6) mod 16777216
  result = bitxor(result, result shr 5) mod 16777216
  result = bitxor(result, result shl 11) mod 16777216

proc part1 =
  let infile = open("data/day22.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines():
    var rand = line.parseInt()
    for _ in 1..2000:
      rand = nextRand(rand)
    total += rand
  echo(total)



proc part2 =
  let infile = open("data/day22.txt")
  defer: infile.close()

  var globalTotals = initTable[int, int]()
  for line in infile.lines():
    var totals = initTable[int, int]()
    var rand = line.parseInt()
    var diffs = 0
    for n in 1..2000:
      let next = nextRand(rand)
      let diff = (next mod 10) - (rand mod 10)
      # This next line is a really opaque optimization
      # There are 19 possible diffs, -9 through 9
      # These can be kept track as digits of a "base 19" number
      # Map -9 through 9 to 0 through 18 by adding 9
      # Shift left by multiplying by 19
      # Trim the number to for digits with mod 19 ^ 4, i.e. 130321
      diffs = ((diffs * 19) + (diff + 9)) mod 130321
      rand = next
      if n >= 4:
        if not totals.hasKey(diffs):
          totals[diffs] = rand mod 10
    for k, v in totals:
      if not globalTotals.hasKey(k):
        globalTotals[k] = 0
      globalTotals[k] = globalTotals[k] + v
  # (0, 1582)
  echo(globalTotals.values().toSeq().minmax()[1])

when isMainModule:
  # part1()
  part2()
