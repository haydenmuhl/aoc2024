import lib

import std/re
import std/algorithm
import std/strformat
import std/strutils
import std/tables
import std/sequtils
import std/deques
import std/sets
import std/heapqueue


proc part1 =
  let infile = open("data/day09.txt")
  defer: infile.close()

  let diskMap = infile.readLine()

  var blocks = newSeq[int]()

  var fileId = 0
  var isFile = true
  for c in diskMap:
    let size = c.ord - '0'.ord
    for _ in 0 ..< size:
      if isFile:
        blocks.add(fileId)
      else:
        blocks.add(-1)
    isFile = not isFile
    if isFile:
      fileId += 1

  var nilCursor = 0
  var blockCursor = blocks.len() - 1
  while true:
    while nilCursor < blocks.len() and blocks[nilCursor] != -1:
      nilCursor += 1
    if nilCursor >= blocks.len():
      break
    let blockValue = blocks[blockCursor]
    blocks.del(blockCursor)
    blockCursor -= 1
    blocks[nilCursor] = blockValue

  var total = 0
  for idx, fileId in blocks:
    total += idx * fileId
  echo(total)

type FileRec = object
  loc: int
  size: int

proc `<`(a, b: FileRec): bool =
  a.loc < b.loc

proc part2 =
  let infile = open("data/day09.txt")
  defer: infile.close()

  let diskMap = infile.readLine()

  var files = newSeq[FileRec]()
  var freeSpace = initTable[int, HeapQueue[FileRec]]()
  for size in 1..9:
    freeSpace[size] = initHeapQueue[FileRec]()

  var fileId = 0
  var loc = 0
  var isFile = true
  for c in diskMap:
    let size = c.ord - '0'.ord
    if isFile:
      files.add(FileRec(loc: loc, size: size))
      fileId += 1
    elif size > 0:
      freeSpace[size].push(FileRec(loc: loc, size: size))
    isFile = not isFile
    loc += size

  fileId = files.len() - 1
  while fileId >= 0:
    let fileRec = files[fileId]
    var selectedSpace = FileRec(loc: high(int), size: 0)
    for freeSize in 1..9:
      if freeSize < fileRec.size:
        continue
      if freeSpace[freeSize].len() == 0:
        continue
      if freeSpace[freeSize][0].loc < selectedSpace.loc:
        selectedSpace = freeSpace[freeSize][0]
    if selectedSpace.size >= fileRec.size and selectedSpace.loc < fileRec.loc:
      selectedSpace = freeSpace[selectedSpace.size].pop()
      files[fileId].loc = selectedSpace.loc
      selectedSpace.loc += files[fileId].size
      selectedSpace.size -= files[fileId].size
      if selectedSpace.size > 0:
        freeSpace[selectedSpace.size].push(selectedSpace)
    fileId -= 1

  var total = 0
  for idx, file in files:
    for offset in 0 ..< file.size:
      total += idx * (file.loc + offset)
  echo(total)





when isMainModule:
  # part1()
  part2()
