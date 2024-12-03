import std/re
import std/strutils
import std/strformat

let intsRegex = re(r"(0|-?[1-9][0-9]*)")

proc parseInts*(line: string): seq[int] =
  let substrings = findAll(line, intsRegex)
  for s in substrings:
    result.add(s.parseInt())

proc peek*[T](a: openArray[T]): T =
  a[a.len() - 1]

# 2D point
type Point* = object
  x*: int
  y*: int

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
