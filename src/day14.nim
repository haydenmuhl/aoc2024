import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets

let height = 103
let width = 101
# let height = 7
# let width = 11

type Robot = object
  location: Point
  velocity: Point

proc step(self: var Robot) =
  self.location += self.velocity
  self.location.x = (self.location.x + width) mod width
  self.location.y = (self.location.y + height) mod height

proc part1 =
  let infile = open("data/day14.txt")
  defer: infile.close()

  var robots = newSeq[Robot]()
  for line in infile.lines():
    let ints = line.parseInts()
    robots.add(Robot(location: Point(x: ints[0], y: ints[1]), velocity: Point(x: ints[2], y: ints[3])))

  var quadrants = [0, 0, 0, 0]
  for _ in 1..100:
    robots.apply(step)

  for robot in robots:
    if robot.location.x < width div 2:
      if robot.location.y < height div 2:
        quadrants[0] += 1
      if robot.location.y > height div 2:
        quadrants[1] += 1
    if robot.location.x > width div 2:
      if robot.location.y < height div 2:
        quadrants[2] += 1
      if robot.location.y > height div 2:
        quadrants[3] += 1
  echo(quadrants.foldl(a * b, 1))

proc print(robots: seq[Robot]) =
  let points = robots.mapIt(it.location).toHashSet()

  for y in 0 ..< height:
    for x in 0 ..< width:
      if points.contains(Point(x: x, y: y)):
        stdout.write('#')
      else:
        stdout.write('.')
    echo()

# Not a fully programatic solution
# There is a vertical bot cluster at second 69
# The next vertical bot cluster is 101 seconds later
# Only print out every 101th iteration, and look for the tree in the output
proc part2 =
  let infile = open("data/day14.txt")
  defer: infile.close()

  var robots = newSeq[Robot]()
  for line in infile.lines():
    let ints = line.parseInts()
    robots.add(Robot(location: Point(x: ints[0], y: ints[1]), velocity: Point(x: ints[2], y: ints[3])))

  var seconds = 0
  for _ in 1..69:
    robots.apply(step)
  seconds = 69
  echo(seconds)
  print(robots)
  for _ in 1..103:
    for _ in 1..101:
      robots.apply(step)
    seconds += 101
    echo(seconds)
    print(robots)


when isMainModule:
  # part1()
  part2()
