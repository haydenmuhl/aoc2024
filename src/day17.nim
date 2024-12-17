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

type Computer = object
  a: int
  b: int
  c: int
  ctr: int
  program: seq[int]
  output: seq[int]


proc combo(self: Computer, operand: int): int =
  case operand:
    of 0..3:
      operand
    of 4:
      self.a
    of 5:
      self.b
    of 6:
      self.c
    else:
      echo("Bad operand: ", operand)
      echo(self)
      quit(0)

proc dv(self: var Computer, operand: int): int =
  let numerator = self.a
  var denominator = 1
  for _ in 1 .. self.combo(operand):
    denominator *= 2
  result = numerator div denominator

proc adv(self: var Computer, operand: int) =
  self.a = self.dv(operand)

proc bxl(self: var Computer, operand: int) =
  self.b = bitxor(self.b, operand)

proc bst(self: var Computer, operand: int) =
  self.b = self.combo(operand) mod 8

proc jnz(self: var Computer, operand: int) =
  if self.a == 0:
    return
  self.ctr = operand

proc bxc(self: var Computer, _: int) =
  self.b = bitxor(self.c, self.b)

proc write(self: var Computer, operand: int) =
  self.output.add(self.combo(operand) mod 8)

proc bdv(self: var Computer, operand: int) =
  self.b = self.dv(operand)

proc cdv(self: var Computer, operand: int) =
  self.c = self.dv(operand)

proc tick(self: var Computer): bool =
  if self.ctr >= self.program.len():
    return false

  let opcode = self.program[self.ctr]
  self.ctr += 1
  let operand = self.program[self.ctr]
  self.ctr += 1

  case opcode:
    of 0:
      self.adv(operand)
    of 1:
      self.bxl(operand)
    of 2:
      self.bst(operand)
    of 3:
      self.jnz(operand)
    of 4:
      self.bxc(operand)
    of 5:
      self.write(operand)
    of 6:
      self.bdv(operand)
    of 7:
      self.cdv(operand)
    else:
      echo("Bad opcode: ", opcode)
      echo(self)
      quit(1)

  return true

proc tick2(self: var Computer): bool =
  result = self.tick()
  if result:
    let idx = self.output.len() - 1
    if idx >= 0 and self.output[idx] != self.program[idx]:
      result = false

proc init(self: var Computer, a: int) =
  self.a = a
  self.b = 0
  self.c = 0
  self.ctr = 0
  self.output.setLen(0)

proc run(self: var Computer) =
  while self.tick():
    discard

proc part1 =
  let infile = open("data/day17.txt")
  defer: infile.close()

  var computer: Computer
  computer.a = infile.readLine().parseInts()[0]
  computer.b = infile.readLine().parseInts()[0]
  computer.c = infile.readLine().parseInts()[0]

  discard infile.readLine()
  computer.program = infile.readLine().parseInts()
  computer.ctr = 0

  while computer.tick():
    discard
  echo(computer.output.join(","))

proc validTail(self: Computer): bool = self.output == self.program[^self.output.len() .. ^1]

proc part2 =
  let infile = open("data/day17.txt")
  defer: infile.close()

  var computer: Computer
  discard infile.readLine().parseInts()[0]
  let b = infile.readLine().parseInts()[0]
  let c = infile.readLine().parseInts()[0]

  discard infile.readLine()
  computer.program = infile.readLine().parseInts()

  var stack = @[0]
  while stack.len() > 0:
    var a = 0
    for n in stack:
      a = (a * 8) + n
    computer.init(a)
    computer.run()
    if computer.output == computer.program:
      echo(a)
      quit(0)
    if computer.validTail():
      stack.add(0)
    else:
      stack[^1] += 1
      while stack.len() > 0 and stack[^1] > 7:
        discard stack.pop()
        stack[^1] += 1
  echo("Didn't find it")


when isMainModule:
  # part1()
  part2()
