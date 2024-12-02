import std/sequtils
import std/strutils
import std/algorithm
import std/tables

proc part1 =
  let infile = open("data/day01.txt")
  defer: infile.close()

  var total = 0
  var listA: seq[int] = newSeq[int]()
  var listB: seq[int] = newSeq[int]()
  for line in infile.lines:
    let a = line[0 ..< 5].parseInt()
    listA.add(a)
    let b = line[8 ..< 13].parseInt()
    listB.add(b)
  listA.sort()
  listB.sort()

  while len(listA) > 0:
    let a = listA.pop()
    let b = listB.pop()
    let diff = a - b
    let sign = if diff >= 0: 1 else: -1
    total += diff * sign
  echo(total)


proc part2 =
  let infile = open("data/day01.txt")
  defer: infile.close()

  var total = 0
  var listA: seq[int] = newSeq[int]()
  var listB: seq[int] = newSeq[int]()
  for line in infile.lines:
    let a = line[0 ..< 5].parseInt()
    listA.add(a)
    let b = line[8 ..< 13].parseInt()
    listB.add(b)

  var histogram = initTable[int, int]()
  for key in listA:
    histogram[key] = 0
  for key in listB:
    if histogram.hasKey(key):
      histogram[key] += 1

  for key, value in histogram:
    total += key * value
  echo(total)


when isMainModule:
  part2()
