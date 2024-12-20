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
  let infile = open("data/day18.txt")
  defer: infile.close()

  let size = 70
  let corrupted = 1024

  var mines = initHashSet[Point]()
  var idx = 0
  for line in infile.lines():
    if idx == corrupted:
      break
    let ints = line.parseInts()
    mines.incl(Point(x: ints[0], y: ints[1]))
    idx += 1
  echo(mines)

  var tail = initHashSet[Point]()
  var heads = initHashSet[Point]()
  heads.incl(Point(x: 0, y: 0))
  var length = 1
  while true:
    var nextHeads = initHashSet[Point]()
    for head in heads:
      tail.incl(head)
      let neighbors = head.adjacent()
      for n in neighbors:
        nextHeads.incl(n)
    var headSeq = nextHeads.toSeq()
    headSeq = headSeq.filter(proc(p: Point): bool = p.x >= 0)
    headSeq = headSeq.filter(proc(p: Point): bool = p.y >= 0)
    headSeq = headSeq.filter(proc(p: Point): bool = p.x <= size)
    headSeq = headSeq.filter(proc(p: Point): bool = p.y <= size)
    headSeq = headSeq.filter(proc(p: Point): bool = not tail.contains(p))
    headSeq = headSeq.filter(proc(p: Point): bool = not mines.contains(p))
    echo(headSeq)
    # discard stdin.readLine()
    heads = headSeq.toHashSet()
    if heads.contains(Point(x: size, y: size)):
      break
    length += 1

  echo(length)


proc part2 =
  let infile = open("data/day18.txt")
  defer: infile.close()

  let size = 70
  let corrupted = 1024

  var mines = initHashSet[Point]()
  var idx = 0
  for line in infile.lines():
    if idx == corrupted:
      break
    let ints = line.parseInts()
    mines.incl(Point(x: ints[0], y: ints[1]))
    idx += 1
  echo(mines)

  for line in infile.lines():
    let ints = line.parseInts()
    let newMine = Point(x: ints[0], y: ints[1])
    mines.incl(newMine)
    echo(newMine)
    var tail = initHashSet[Point]()
    var heads = initHashSet[Point]()
    heads.incl(Point(x: 0, y: 0))
    var length = 1
    while true:
      var nextHeads = initHashSet[Point]()
      for head in heads:
        tail.incl(head)
        let neighbors = head.adjacent()
        for n in neighbors:
          nextHeads.incl(n)
      var headSeq = nextHeads.toSeq()
      headSeq = headSeq.filter(proc(p: Point): bool = p.x >= 0)
      headSeq = headSeq.filter(proc(p: Point): bool = p.y >= 0)
      headSeq = headSeq.filter(proc(p: Point): bool = p.x <= size)
      headSeq = headSeq.filter(proc(p: Point): bool = p.y <= size)
      headSeq = headSeq.filter(proc(p: Point): bool = not tail.contains(p))
      headSeq = headSeq.filter(proc(p: Point): bool = not mines.contains(p))
      # discard stdin.readLine()
      heads = headSeq.toHashSet()
      if heads.len() == 0:
        echo(line)
        quit(0)
      if heads.contains(Point(x: size, y: size)):
        break
      length += 1



when isMainModule:
  # part1()
  part2()
