import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets
import std/heapqueue

type
  Node = ref NodeObj
  NodeObj = object
    loc: Point
    facing: Point
    score: int
    prev: Node

proc `<`(a, b: Node): bool = a.score < b.score
proc `$`(n: Node): string =
  if n == nil:
    return "..."
  return $n[]

let dirs = @[up, down, left, right]

proc part1 =
  let infile = open("data/day16.txt")
  defer: infile.close

  let field = infile.readLines()

  let height = field.len()
  let width = field[0].len()

  let mStart = Point(x: 1, y: height - 2)
  let mEnd = Point(x: width - 2, y: 1)

  var heads = initHeapQueue[Node]()
  var paths = initTable[Point, Table[Point, Node]]()
  for dir in dirs:
    paths[dir] = initTable[Point, Node]()
  var head = Node(loc: mStart, facing: right, score: 0, prev: nil)
  heads.push(head)
  paths[head.facing][head.loc] = head

  var minScore = high(int)

  while heads.len() > 0:
    head = heads.pop()
    let neighbors = head.loc.adjacent()

    let nextHeads = neighbors.filter(proc(p: Point): bool = field[p] != '#')
    for p in nextHeads:
      let facing = p - head.loc
      var nextScore = head.score
      if facing == head.facing * -1:
        continue
      elif facing == head.facing:
        nextScore += 1
      else:
        nextScore += 1001

      let nextHead = Node(loc: p, facing: facing, score: nextScore, prev: head)
      var pathNode: Node = nil
      if paths[nextHead.facing].hasKey(nextHead.loc):
        pathNode = paths[nextHead.facing][nextHead.loc]
      if pathNode == nil or pathNode.score > nextHead.score:
        paths[nextHead.facing][nextHead.loc] = nextHead
        if nextHead.score < minScore:
          if nextHead.loc == mEnd:
            minScore = nextHead.score
          else:
            heads.push(nextHead)
  echo(minScore)


proc part2 =
  let infile = open("data/day16.txt")
  defer: infile.close

  let field = infile.readLines()

  let height = field.len()
  let width = field[0].len()

  let mStart = Point(x: 1, y: height - 2)
  let mEnd = Point(x: width - 2, y: 1)

  var heads = initHeapQueue[Node]()
  var paths = initTable[Point, Table[Point, Node]]()
  for dir in dirs:
    paths[dir] = initTable[Point, Node]()
  var head = Node(loc: mStart, facing: right, score: 0, prev: nil)
  heads.push(head)
  paths[head.facing][head.loc] = head

  var solns = newSeq[Node]()

  while heads.len() > 0:
    head = heads.pop()
    let neighbors = head.loc.adjacent()

    let nextHeads = neighbors.filter(proc(p: Point): bool = field[p] != '#')
    for p in nextHeads:
      let facing = p - head.loc
      var nextScore = head.score
      if facing == head.facing * -1:
        continue
      elif facing == head.facing:
        nextScore += 1
      else:
        nextScore += 1001

      let nextHead = Node(loc: p, facing: facing, score: nextScore, prev: head)
      var pathNode: Node = nil
      if paths[nextHead.facing].hasKey(nextHead.loc):
        pathNode = paths[nextHead.facing][nextHead.loc]
      if pathNode == nil or pathNode.score >= nextHead.score:
        paths[nextHead.facing][nextHead.loc] = nextHead
        if nextHead.loc == mEnd:
          solns.add(nextHead)
        else:
          heads.push(nextHead)

  var pathSet = initSet[Point]()
  for soln in solns:
    var soln = soln
    while soln != nil:
      pathSet.incl(soln.loc)
      soln = soln.prev
  echo(pathSet.len())


when isMainModule:
  # part1()
  part2()
