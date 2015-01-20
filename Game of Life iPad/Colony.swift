//
//  Colony.swift
//  Game of Life iPad
//
//  Created by Ben Shteinfeld on 1/2/15.
//  Copyright (c) 2015 Ben Shteinfeld. All rights reserved.
//

import Foundation

// class variable workaround
private var _numColonies = 0

class Colony: NSObject, NSCoding {
    // declare constants
    let CELL_ALIVE = 1
    let CELL_DEAD = 0
    
    // declare properties
    var rows: Int
    var cols: Int
    var numGens = 0
    var wrap = true
    var cells: [Int]
    var name: String
    
    // number of colonies
    class var numColonies: Int {
        get {
            return _numColonies
        }
        
        set {
            _numColonies = newValue
        }
    }
    
    // placeholder constructor for Colony, doesn't change numColonies
    override init() {
        rows = 1
        cols = 1
        cells = [Int](count: 9, repeatedValue: CELL_DEAD)
        name = ""
    }
    
    // constructor for Colony
    init(numRows: Int, numCols: Int) {
        rows = numRows
        cols = numCols
        // set memory of cells to 0, including "border of death"
        cells = [Int](count: ((rows + 2)*(cols + 2)), repeatedValue: CELL_DEAD)
        // increment number of colonies
        Colony.numColonies++
        // set name based on number
        name = "Colony #\(Colony.numColonies)"
    }
    
    // constructor with name, does not count for colony count
    init(numRows: Int, numCols: Int, name: String) {
        rows = numRows
        cols = numCols
        // set memory of cells to 0, including "border of death"
        cells = [Int](count: ((rows + 2)*(cols + 2)), repeatedValue: CELL_DEAD)
        self.name = name
    }
    
    // initalize colony from disk
    required init(coder aDecoder: NSCoder) {
        cells = aDecoder.decodeObjectForKey("cells") as [Int]
        name = aDecoder.decodeObjectForKey("name") as String
        rows = aDecoder.decodeIntegerForKey("rows") as Int
        cols = aDecoder.decodeIntegerForKey("cols") as Int
        numGens = aDecoder.decodeIntegerForKey("numGens") as Int
        Colony.numColonies = aDecoder.decodeIntegerForKey("numColonies") as Int
    }
    
    // encode colony to disk
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(cells, forKey: "cells")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeInteger(rows, forKey: "rows")
        aCoder.encodeInteger(cols, forKey: "cols")
        aCoder.encodeInteger(numGens, forKey: "numGens")
        aCoder.encodeInteger(Colony.numColonies, forKey: "numColonies")
    }
    
    // return a copy of the current colony
    func copyColony() -> Colony {
        let newColony = Colony(numRows: rows, numCols: cols, name: name)
        newColony.cells = self.cells
        return newColony
    }
    
    // helper function to find virtual index in cells array
    private func index(row: Int, _ col: Int) -> Int {
        return (((cols + 2) * (row + 1)) + (col + 1))
    }
    
    // helper function to return value at coordinate
    private func getValueAtRow(row: Int, col: Int) -> Int {
        return cells[index(row, col)]
    }
    
    // helper function to get value at coordinate which may be wrapped
    // works with and without wrapping enabled
    private func getWrappedValueAtRow(row: Int, col: Int) -> Int {
        // new row and col which correspond an out-of-bounds index to a valid wrapped one
        var n_row = row, n_col = col
        
        // find new wrapped row location if applicable
        if wrap {
            if row < 0 {
                n_row = rows + row
            }
            if row >= rows {
                n_row = row - rows
            }
        }
        
        // find new wrapped col location if applicable
        if wrap {
            if col < 0 {
                n_col = cols + col
            }
            if col >= cols {
                n_col = col - cols
            }
        }
        
        // return value at valid wrapped location
        return getValueAtRow(n_row, col: n_col)
    }
    
    // sets cell alive at coordinate
    func setCellAliveAtRow(row: Int, col: Int) {
        cells[index(row, col)] = CELL_ALIVE
    }
    
    // set cell dead at coordinate
    func setCellDeadAtRow(row: Int, col: Int) {
        cells[index(row, col)] = CELL_DEAD
    }
    
    // returns true if cell is alive at coordinate, else false
    func isCellAliveAtRow(row: Int, col: Int) -> Bool {
        if getValueAtRow(row, col: col) == CELL_ALIVE {
            return true
        }
        return false
    }
    
    // returns number of generations evolved
    func getGenerationNumber() -> Int {
        return numGens;
    }
    
    // calculates the number of alive cells
    func getNumberLivingCells() -> Int {
        // counter
        var livingCells = 0
        // iterate through all cells and check if they are alive
        for row in 0..<rows {
            for col in 0..<cols {
                if isCellAliveAtRow(row, col: col){
                    livingCells++
                }
            }
        }
        return livingCells
    }
    
    // count number of cells neighboring a cell
    private func countNeighbors(row: Int, col: Int) -> Int {
        // get the values at 8 neighboring cells and return their sum
        return getWrappedValueAtRow(row + 1, col: col)
            + getWrappedValueAtRow(row - 1, col: col)
            + getWrappedValueAtRow(row, col: col + 1)
            + getWrappedValueAtRow(row, col: col - 1)
            + getWrappedValueAtRow(row + 1, col: col + 1)
            + getWrappedValueAtRow(row - 1, col: col - 1)
            + getWrappedValueAtRow(row + 1, col: col - 1)
            + getWrappedValueAtRow(row - 1, col: col + 1)
    }
    
    // apply rules of Game of Life
    private func rules(curCell: Int, numSur: Int) -> Int {
        if numSur == 3 {
            return CELL_ALIVE
        } else if numSur > 3 || numSur < 2 {
            return CELL_DEAD
        } else {
            return curCell
        }
    }
    
    // evole the colony once
    func evolve() {
        numGens++
        var numSur = 0
        var curCell = CELL_DEAD
        var newCells = [Int](count: (rows + 2) * (cols + 2), repeatedValue: CELL_DEAD)
        
        // iterate through all cells and calculate evolved colony
        for row in 0..<rows {
            for col in 0..<cols {
                if isCellAliveAtRow(row, col: col) {
                    newCells[index(row, col)] = CELL_ALIVE
                }
                numSur = countNeighbors(row, col: col)
                curCell = getValueAtRow(row, col: col)
                newCells[index(row, col)] = rules(curCell, numSur: numSur)
            }
        }
        // copy evolved array into current array
        cells = newCells
    }
    
    // determines if a cell is valid
    func isValidCell(row: Int, col: Int) -> Bool {
        if (0..<rows).contains(row) && (0..<cols).contains(col) {
            return true
        }
        return false
    }
    
    // clear cells array
    func resetCells() {
        for row in 0..<rows {
            for col in 0..<cols {
                setCellDeadAtRow(row, col: col)
            }
        }
    }
    
    // given a list of coordinates, return an optional array of tuples of coordinates
    func extractCellsFromString(colonyString: String) -> [(Int, Int)]? {
        // holds cells to return
        var rcells = [(Int, Int)]()
        
        // split string into an array of string, each element representating one coordinate
        let newCells = split(colonyString) {
            $0 == "\n"
        }
        
        // iterate over all coordinate
        for cell in newCells {
            // split each coordinate into row and col
            let coor = split(cell) {
                $0 == " "
            }
            
            // extract row and col with error checking
            if coor.count == 2 {
                if let row = coor[0].toInt() {
                    if let col = coor[1].toInt() {
                        if isValidCell(row, col: col) {
                            rcells.append( (row, col) )
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
            
        }
        
        return rcells
    }
    
    // given a list of coordinate, set them alive
    func loadCellsFromList(colonyString: String) -> Bool {
        // clear current cells
        resetCells()
        
        // if string is valid, set all given cells alive
        if let newCells = extractCellsFromString(colonyString) {
            for (row, col) in newCells {
                setCellAliveAtRow(row, col: col)
            }
        } else {
            return false
        }
        return true
    }
    
    // return string representation of colony
    func description() -> String {
        // base string
        var stringColony = ""
        // iterate through all cells and append to stringColony
        for row in 0..<rows {
            for col in 0..<cols {
                if isCellAliveAtRow(row, col: col){
                    stringColony += "\(row) \(col)\n"
                }
            }
        }
        return stringColony
    }
}