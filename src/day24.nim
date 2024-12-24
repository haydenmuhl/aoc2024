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

type Statement = object
  a: string
  b: string
  op: string

proc eval(name: string, statements: Table[string, Statement], cache: var Table[string, bool]): bool =
  if not cache.hasKey(name):
    let s = statements[name]
    let a = eval(s.a, statements, cache)
    let b = eval(s.b, statements, cache)
    case s.op
      of "AND":
        cache[name] = a and b
      of "OR":
        cache[name] = a or b
      of "XOR":
        cache[name] = a xor b
      else:
        echo("Oops: ", s)
        quit(1)
  return cache[name]

proc part1 =
  let infile = open("data/day24.txt")
  defer: infile.close()

  var results = initTable[string, bool]()
  for line in infile.lines():
    if line == "":
      break
    let fields = line.split(": ")
    results[fields[0]] = (fields[1] == "1")

  var statements = initTable[string, Statement]()
  for line in infile.lines():
    let fields = line.split(" ")
    let statement = Statement(a: fields[0], op: fields[1], b: fields[2])
    statements[fields[4]] = statement

  var i = 0
  var mask = 1
  var total = 0
  while true:
    let name = fmt"z{i:02}"
    if not statements.hasKey(name):
      break
    let z = eval(name, statements, results)
    if z:
      total = bitxor(total, mask)
    mask = mask shl 1
    i += 1
  echo(total)



proc part2 =
  # Solved manually
  discard

when isMainModule:
  part1()
  # part2()
