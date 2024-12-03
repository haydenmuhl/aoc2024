import std/re
import std/sequtils
import std/strutils

proc part1 =
  let infile = readfile("data/day03.txt")

  let regex = re"mul\((\d+),(\d+)\)"

  var matches = infile.findAll(regex)

  echo(matches.map(proc(s: string): string = s[4..^2])
              .map(proc(s: string): seq[string] = s.split(","))
              .map(proc(a: seq[string]): seq[int] = a.map(parseInt))
              .foldl(a + (b[0] * b[1]), 0)
  )


proc part2bad =
  # let infile = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  let infile = readfile("data/day03.txt")
  let lines = infile.split("do()")
  echo(lines)
  let cleanLines = lines.map(proc(s: string): string = s.replace(re"don't\(\).*"))
  let newFile = cleanLines.join(" ")

  let regex = re"mul\((\d+),(\d+)\)"

  var matches = newFile.findAll(regex)

  echo(matches.map(proc(s: string): string = s[4..^2])
              .map(proc(s: string): seq[string] = s.split(","))
              .map(proc(a: seq[string]): seq[int] = a.map(parseInt))
              .foldl(a + (b[0] * b[1]), 0)
  )

proc parseMul(s: string): int =
  let values = s[4..^2].split(",").map(parseInt)
  return values[0] * values[1]

proc part2 =
  # let infile = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  let infile = readfile("data/day03.txt")

  let regex = re"(mul\(\d+,\d+\)|do\(\)|don't\(\))"

  var matches = infile.findAll(regex)

  var enabled = true
  var total = 0
  for match in matches:
    if match == "do()":
      enabled = true
    elif match == "don't()":
      enabled = false
    elif enabled:
      total += parseMul(match)
  echo(total)

when isMainModule:
  part2()
