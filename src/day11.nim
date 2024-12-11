import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets


proc digits(i: int): int =
  var i = i
  while i > 0:
    i = i div 10
    result += 1

proc calc(stone: int): seq[int] =
  if stone == 0:
    result = @[1]
  else:
    let size = stone.digits()
    if size mod 2 == 0:
      var mask = 1
      for _ in 1..(size div 2):
        mask *= 10
      let left = stone div mask
      let right = stone mod mask
      result = @[left, right]
    else:
      result = @[stone * 2024]

proc blink(stones: seq[int]): seq[int] =
  for stone in stones:
    result.insert(calc(stone), result.len())

proc part1 =
  let infile = open("data/day11.txt")
  defer: infile.close()

  var stones = infile.readLine().split(" ").map(parseInt)

  for _ in 1..25:
    stones = blink(stones)
  echo(stones.len())

var cache = initTable[(int, int), int]()

proc findLength(stone, blinks: int): int =
  if blinks == 0:
    return 1
  if cache.hasKey((stone, blinks)):
    return cache[(stone, blinks)]

  let nextStones = calc(stone)
  for next in nextStones:
    result += findLength(next, blinks - 1)
  cache[(stone, blinks)] = result


proc part2 =
  let infile = open("data/day11.txt")
  defer: infile.close()

  var stones = infile.readLine().split(" ").map(parseInt)

  var total = 0
  for stone in stones:
    total += findLength(stone, 75)
  echo(total)

when isMainModule:
  # part1()
  part2()
