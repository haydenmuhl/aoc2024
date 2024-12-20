import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets

proc valid1(towel: string, tokens: HashSet[string]): bool =
  var substrings = initTable[(int, int), bool]()

  for length in 1 .. towel.len():
    for start in 0 .. towel.len() - length:
      let substring = towel[start ..< start + length]
      if tokens.contains(substring):
        substrings[(start, start + length)] = true
      else:
        substrings[(start, start + length)] = false
        for divider in 1 ..< length:
          let left = substrings[(start, start + divider)]
          let right = substrings[(start + divider, start + length)]
          if left and right:
            substrings[(start, start + length)] = true
            break
  return substrings[(0, towel.len())]


proc part1 =
  let infile = open("data/day19.txt")
  defer: infile.close()

  let tokens = infile.readLine().split(", ").toSet()
  discard infile.readLine()

  var total = 0
  for towel in infile.lines():
    if valid1(towel, tokens):
      total += 1
  echo(total)

proc valid2(towel: string, tokens: HashSet[string]): int =
  var substrings = initTable[(int, int), bool]()

  substrings[(0, 0)] = true
  for length in 1 .. towel.len():
    for start in 0 .. towel.len() - length:
      let substring = towel[start ..< start + length]
      substrings[(start, start + length)] = false
      if tokens.contains(substring):
        substrings[(start, start + length)] = true

  var paths = newSeq[int]()
  paths.add(1)
  for length in 1 .. towel.len():
    paths.add(0)
    for divider in 0 .. length - 1:
      if substrings[(divider, length)]:
        paths[length] += paths[divider]
  return paths[towel.len()]

proc part2 =
  let infile = open("data/day19.txt")
  defer: infile.close()

  let tokens = infile.readLine().split(", ").toSet()
  discard infile.readLine()

  var total = 0
  for towel in infile.lines():
    total += valid2(towel, tokens)
  echo(total)

when isMainModule:
  # part1()
  part2()
