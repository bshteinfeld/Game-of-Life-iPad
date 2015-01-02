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

class Colony {
    // declare constants
    let size: Int
    let CELL_ALIVE = 1
    let CELL_DEAD = 0
    let name: String
    
    // declare properties
    var numGens = 0
    var cells: [Int]
    
    // number of colonies
    class var numColonies: Int {
        get {
            return _numColonies
        }
        
        set {
            _numColonies = newValue
        }
    }
    
    // constructor for Colony
    init(colonySize: Int) {
        size = colonySize
        // set memory of cells to 0, including "border of death"
        cells = [Int](count: ((size + 2)*(size + 2)), repeatedValue: CELL_DEAD)
        // increment number of colonies
        Colony.numColonies++
        // set name based on number
        name = "Colony #\(Colony.numColonies)"
    }
    
    // helper function to find virtual index in cells array
    private func index(row: Int, _ col: Int) -> Int {
        return (((size + 2) * (row + 1)) + (col + 1))
    }
    
    // helper functin to return value at coordinate
    private func getValueAtRow(row: Int, col: Int) -> Int {
        return cells[index(row, col)]
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
        for row in 0..<size {
            for col in 0..<size {
                if isCellAliveAtRow(row, col: col){
                    livingCells++
                }
            }
        }
        return livingCells
    }
    
    // count number of cells neighboring a cell
    private func countNeighbors(row: Int, col: Int) -> Int {
        // get the values at 8 neighboring cells and take sum
        return getValueAtRow(row + 1, col: col)
            + getValueAtRow(row - 1, col: col)
            + getValueAtRow(row, col: col + 1)
            + getValueAtRow(row, col: col - 1)
            + getValueAtRow(row + 1, col: col + 1)
            + getValueAtRow(row - 1, col: col - 1)
            + getValueAtRow(row + 1, col: col - 1)
            + getValueAtRow(row - 1, col: col + 1)
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
        var newCells = [Int](count: (size + 2) * (size + 2), repeatedValue: CELL_DEAD)
        
        // iterate through all cells and calculate evolved colony
        for row in 0..<size {
            for col in 0..<size {
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
    
    // return string representation of colony
    func description() -> String {
        // base string
        var stringColony = "Generation: \(numGens)\n"
        // iterate through all cells and append to stringColony
        for row in 0..<size {
            for col in 0..<size {
                if isCellAliveAtRow(row, col: col){
                    stringColony += "*"
                } else {
                    stringColony += " "
                }
            }
            stringColony += "\n"
        }
        return stringColony
    }
}