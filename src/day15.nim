import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets

let zero = Point(x: 0, y: 0)

proc moveBox(field: var seq[string], dir: Point, box: Point): Point =
  let obj = field.get(box)
  if obj == '#':
    return zero
  if obj == 'O':
    let movement = moveBox(field, dir, box + dir)
    if movement == zero:
      return zero
    let newPos = box + movement
    field[newPos.y][newPos.x] = 'O'
    field[box.y][box.x] = '.'
  return dir

proc move(field: var seq[string], dir: Point, robot: var Point) =
  robot += moveBox(field, dir, robot + dir)

proc getDir(command: char): Point =
  case command:
    of '>':
      right
    of '<':
      left
    of '^':
      down
    of 'v':
      up
    else:
      echo("Oops, bad command: ", command)
      quit(1)

proc score(field: seq[string]): int =
  for y, line in field:
    for x, ch in line:
      if ch == 'O':
        result += (y * 100) + x

proc part1 =
  let infile = open("data/day15.txt")
  defer: infile.close()

  var field = newSeq[string]()
  for line in infile.lines():
    if line == "":
      break
    field.add(line)

  var commandLines = newSeq[string]()
  for line in infile.lines():
    commandLines.add(line)
  let commands = commandLines.join("")

  let width = field[0].len()
  let height = field.len()

  var robot: Point
  for y in 0 ..< height:
    for x in 0 ..< width:
      if field[y][x] == '@':
        robot.x = x
        robot.y = y
        field[y][x] = '.'
        break

  for command in commands:
    move(field, getDir(command), robot)

  echo(score(field))

proc canMoveVer(field: seq[string], dir: Point, boxPos: Point): Point =
  let obj = field.get(boxPos)
  if obj == '#':
    return zero
  elif obj == '.':
    return dir

  var box: array[0..1, Point]
  if obj == '[':
    box = [boxPos, boxPos + right]
  elif obj == ']':
    box = [boxPos + left, boxPos]

  let movement = box.mapIt(canMoveVer(field, dir, it + dir))
  if movement[0] == zero or movement[1] == zero:
    return zero
  return dir

proc moveVer(field: var seq[string], dir: Point, boxPos: Point): Point =
  let obj = field.get(boxPos)
  if obj == '#':
    echo("Oops, can't move ", boxPos)
  if obj == '.':
    return dir

  var box: array[0..1, Point]
  if obj == '[':
    box = [boxPos, boxPos + right]
  elif obj == ']':
    box = [boxPos + left, boxPos]

  for pos in box:
    let newPos = pos + dir
    discard moveVer(field, dir, newPos)
    field[newPos.y][newPos.x] = field.get(pos)
    field[pos.y][pos.x] = '.'

  return dir

proc moveHor(field: var seq[string], dir: Point, box: Point): Point =
  let obj = field.get(box)
  if obj == '#':
    return zero
  if obj == '[' or obj == ']':
    let movement = moveHor(field, dir, box + dir)
    if movement == zero:
      return zero
    let newPos = box + movement
    field[newPos.y][newPos.x] = obj
    field[box.y][box.x] = '.'
  return dir

proc moveRobot(field: var seq[string], dir: Point, robot: var Point) =
  if dir == up or dir == down:
    let canMove = canMoveVer(field, dir, robot + dir)
    if canMove != zero:
      robot += moveVer(field, dir, robot + dir)
  elif dir == left or dir == right:
    robot += moveHor(field, dir, robot + dir)

proc score2(field: seq[string]): int =
  for y, line in field:
    for x, ch in line:
      if ch == '[':
        result += (y * 100) + x


proc part2 =
  let infile = open("data/day15.txt")
  defer: infile.close()

  var field = newSeq[string]()
  for line in infile.lines():
    if line == "":
      break
    var row = newSeq[char]()
    for ch in line:
      if ch == '#':
        row.add('#')
        row.add('#')
      elif ch == '.':
        row.add('.')
        row.add('.')
      elif ch == '@':
        row.add('@')
        row.add('.')
      elif ch == 'O':
        row.add('[')
        row.add(']')
      else:
        echo("Oops, bad map: ", ch)
        quit(2)
    field.add(row.join(""))

  var commandLines = newSeq[string]()
  for line in infile.lines():
    commandLines.add(line)
  let commands = commandLines.join("")

  let width = field[0].len()
  let height = field.len()

  var robot: Point
  for y in 0 ..< height:
    for x in 0 ..< width:
      if field[y][x] == '@':
        robot.x = x
        robot.y = y
        field[y][x] = '.'
        break

  echo()
  for command in commands:
    moveRobot(field, getDir(command), robot)
    # for line in field:
    #   echo(line)
  echo(score2(field))


when isMainModule:
  # part1()
  part2()
