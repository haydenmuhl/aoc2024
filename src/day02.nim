import lib

import system/iterators

import std/sequtils

proc sameSign(arr: openArray[int]): bool =
  let expectedSign = if arr[0] < 0:
    -1
  elif arr[0] > 0:
    1
  else:
    return false

  for val in arr:
    let sign = if arr[0] < 0:
      -1
    elif arr[0] > 0:
      1
    else:
      0
    if sign != expectedSign:
      return false

  return true

proc inRange(arr: openArray[int]): bool =
  let sign = if arr[0] < 0: -1 else: 1

  for val in arr:
    let positiveValue = sign * val
    if positiveValue < 1 or positiveValue > 3:
      return false

  return true


proc part1 =
  let infile = open("data/day02.txt")
  defer: infile.close()

  var safeCount = 0
  for line in infile.lines():
    let values = line.parseInts()
    var diffs = newSeq[int]()
    var idx = 0
    while idx < len(values) - 1:
      diffs.add(values[idx] - values[idx + 1])
      idx += 1
    if not sameSign(diffs):
      continue
    if not inRange(diffs):
      continue
    safeCount += 1
  echo(safeCount)

proc part2 =
  let infile = open("data/day02.txt")
  defer: infile.close()

  var safeCount = 0
  for line in infile.lines():
    let rawValues = line.parseInts()
    for toDelete in 0 ..< len(rawValues):
      var values = rawValues[0..<len(rawValues)]
      values.delete(toDelete, toDelete)

      var diffs = newSeq[int]()
      var idx = 0
      while idx < len(values) - 1:
        diffs.add(values[idx] - values[idx + 1])
        idx += 1

      if not sameSign(diffs):
        continue
      if not inRange(diffs):
        continue
      safeCount += 1
      break
  echo(safeCount)

when isMainModule:
  part2()
