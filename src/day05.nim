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
  let infile = open("data/day05.txt")
  defer: infile.close()

  var rules = initTable[int, HashSet[int]]()

  for line in infile.lines():
    if line == "":
      break
    let fields = line.split("|").map(parseInt)
    if not rules.hasKey(fields[0]):
      rules[fields[0]] = initHashSet[int]()
    rules[fields[0]].incl(fields[1])

  var total = 0
  for line in infile.lines():
    let pages = line.split(",").map(parseInt)
    var valid = true
    for idx in 0 ..< len(pages):
      let earlier = pages[idx]
      for jdx in idx + 1 ..< len(pages):
        let later = pages[jdx]
        if not rules.hasKey(earlier) or not rules[earlier].contains(later):
          valid = false
    if valid:
      let midpoint = len(pages) div 2
      total += pages[midpoint]

  echo(total)

proc getMedian(pages: openArray[int], rules: Table[int, HashSet[int]]): int =
  var sorted = newSeq[int]()
  for page in pages:
    sorted.add(page)
    var idx = len(sorted) - 1
    while idx > 0:
      let left = sorted[idx - 1]
      let right = sorted[idx]
      if rules[right].contains(left):
        sorted[idx - 1] = right
        sorted[idx] = left
      idx -= 1
  return sorted[len(sorted) div 2]

proc part2 =
  let infile = open("data/day05.txt")
  defer: infile.close()

  var rules = initTable[int, HashSet[int]]()

  for line in infile.lines():
    if line == "":
      break
    let fields = line.split("|").map(parseInt)
    if not rules.hasKey(fields[0]):
      rules[fields[0]] = initHashSet[int]()
    rules[fields[0]].incl(fields[1])

  var total = 0
  for line in infile.lines():
    let pages = line.split(",").map(parseInt)
    var valid = true
    for idx in 0 ..< len(pages):
      let earlier = pages[idx]
      for jdx in idx + 1 ..< len(pages):
        let later = pages[jdx]
        if not rules.hasKey(earlier) or not rules[earlier].contains(later):
          valid = false
    if not valid:
      total += getMedian(pages, rules)

  echo(total)


when isMainModule:
  # part1()
  part2()
