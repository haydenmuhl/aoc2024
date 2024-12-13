import std/hashes
import std/re
import std/strutils
import std/strformat

# 2D point
type Point* = object
  x*: int
  y*: int

let intsRegex = re(r"(0|-?[1-9][0-9]*)")

proc parseInts*(line: string): seq[int] =
  let substrings = findAll(line, intsRegex)
  for s in substrings:
    result.add(s.parseInt())

proc readLines*(f: File): seq[string] =
  for line in f.lines():
    result.add(line)

proc get*(field: seq[string], p: Point): char = field[p.y][p.x]
proc get*[T](field: seq[seq[T]], p: Point): T = field[p.y][p.x]

proc get*(field: seq[string], p: Point, default: char): char =
  if p.y < 0 or p.y >= field.len() or p.x < 0 or p.x >= field[0].len():
    return default
  field[p.y][p.x]

proc inBounds*(field: openArray[string], p: Point): bool =
  p.x >= 0 and p.x < field[0].len() and p.y >= 0 and p.y < field.len()

proc peek*[T](a: openArray[T]): T =
  a[a.len() - 1]

const right* = Point(x: 1, y: 0)
const left* = Point(x: -1, y: 0)
const up* = Point(x: 0, y: 1)
const down* = POint(x: 0, y: -1)

proc `+`*(self, other: Point): Point =
  Point(x: self.x + other.x, y: self.y + other.y)

proc `-`*(self, other: Point): Point =
  Point(x: self.x - other.x, y: self.y - other.y)

proc `==`*(self, other: Point): bool =
  self.x == other.x and self.y == other.y

proc `!=`*(self, other: Point): bool =
  not (self == other)

proc abs*(self: Point): Point =
  Point(x: abs(self.x), y: abs(self.y))

proc `$`*(self: Point): string =
  fmt"Point({self.x}, {self.y})"

proc `+=`*(self: var Point, other: Point) =
  self = self + other

proc `-=`*(self: var Point, other: Point) =
  self = self - other

proc hash*(self: Point): Hash =
  result = self.x.hash !& self.y.hash
  result = !$ result

proc adjacent*(p: Point): seq[Point] =
  @[p + up, p + right, p + down, p + left]
