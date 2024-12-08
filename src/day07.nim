import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/math

proc canMake(target: int, terms: openArray[int]): bool =
  let limit = 1 shl terms.len() - 1

  for ops in 0 ..< limit:
    var acc = terms[0]
    var ops = ops
    for idx in 1 ..< terms.len():
      let op = ops mod 2
      ops = ops div 2
      if op == 0:
        acc *= terms[idx]
      else:
        acc += terms[idx]
    if acc == target:
      return true
  return false

proc part1 =
  let infile = open("data/day07.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines():
    let nums = parseInts(line)
    let target = nums[0]
    let terms = nums[1 ..^ 1]
    if canMake(target, terms):
      total += target

  echo(total)

proc catInt(a, b: int): int =
  var coefficient = 10
  while coefficient <= b:
    coefficient *= 10
  return (coefficient * a) + b


proc canMake2(target: int, terms: openArray[int]): bool =
  let limit = 3 ^ terms.len() - 1

  for ops in 0 ..< limit:
    var acc = terms[0]
    var ops = ops
    for idx in 1 ..< terms.len():
      let op = ops mod 3
      ops = ops div 3
      case op:
        of 0:
          acc *= terms[idx]
        of 1:
          acc += terms[idx]
        of 2:
          acc = catInt(acc, terms[idx])
        else:
          discard
      if acc > target:
        break
    if acc == target:
      return true
  return false

proc part2 =
  let infile = open("data/day07.txt")
  defer: infile.close()

  var total = 0
  for line in infile.lines():
    let nums = parseInts(line)
    let target = nums[0]
    let terms = nums[1 ..^ 1]
    if canMake2(target, terms):
      total += target

  echo(total)

when isMainModule:
  # part1()
  part2()
