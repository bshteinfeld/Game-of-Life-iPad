//
//  ColonyStore.swift
//  Game of Life iPad
//
//  Created by Ben Shteinfeld on 1/2/15.
//  Copyright (c) 2015 Ben Shteinfeld. All rights reserved.
//

import Foundation

// static instance of colony store
private let colonyStore = ColonyStore()

class ColonyStore: NSObject, NSCoding {
    
    // array of colonies
    private(set) var colonies = [Colony]()
    
    // shared singleton
    class var sharedColonyStore: ColonyStore {
        return colonyStore
    }
    
    // number of colonies
    var count: Int {
        return colonies.count
    }
    
    // provide designed initializer
    override init() {
        let basicT = Colony(numRows: 40, numCols: 40, name: "Basic-T")
        basicT.setCellAliveAtRow(5, col: 5)
        basicT.setCellAliveAtRow(5, col: 6)
        basicT.setCellAliveAtRow(5, col: 7)
        basicT.setCellAliveAtRow(6, col: 6)
        let glider = Colony(numRows: 40, numCols: 40, name: "Glider")
        glider.setCellAliveAtRow(5, col: 5)
        glider.setCellAliveAtRow(6, col: 6)
        glider.setCellAliveAtRow(7, col: 6)
        glider.setCellAliveAtRow(7, col: 5)
        glider.setCellAliveAtRow(7, col: 4)
        let gliderGun = Colony(numRows: 40, numCols: 40, name: "Glider Gun")
        gliderGun.setCellAliveAtRow(6, col: 2)
        gliderGun.setCellAliveAtRow(6, col: 3)
        gliderGun.setCellAliveAtRow(7, col: 2)
        gliderGun.setCellAliveAtRow(7, col: 3)
        gliderGun.setCellAliveAtRow(4, col: 14)
        gliderGun.setCellAliveAtRow(4, col: 15)
        gliderGun.setCellAliveAtRow(5, col: 13)
        gliderGun.setCellAliveAtRow(6, col: 18)
        gliderGun.setCellAliveAtRow(7, col: 12)
        gliderGun.setCellAliveAtRow(7, col: 16)
        gliderGun.setCellAliveAtRow(7, col: 18)
        gliderGun.setCellAliveAtRow(7, col: 19)
        gliderGun.setCellAliveAtRow(8, col: 12)
        gliderGun.setCellAliveAtRow(8, col: 18)
        gliderGun.setCellAliveAtRow(9, col: 13)
        gliderGun.setCellAliveAtRow(9, col: 17)
        gliderGun.setCellAliveAtRow(10, col: 14)
        gliderGun.setCellAliveAtRow(10, col: 15)
        gliderGun.setCellAliveAtRow(5, col: 17)
        gliderGun.setCellAliveAtRow(6, col: 12)
        gliderGun.setCellAliveAtRow(4, col: 22)
        gliderGun.setCellAliveAtRow(4, col: 23)
        gliderGun.setCellAliveAtRow(5, col:22)
        gliderGun.setCellAliveAtRow(5, col: 23)
        gliderGun.setCellAliveAtRow(6, col: 22)
        gliderGun.setCellAliveAtRow(6, col: 23)
        gliderGun.setCellAliveAtRow(3, col: 24)
        gliderGun.setCellAliveAtRow(3, col: 26)
        gliderGun.setCellAliveAtRow(2, col: 26)
        gliderGun.setCellAliveAtRow(7, col: 24)
        gliderGun.setCellAliveAtRow(7, col: 26)
        gliderGun.setCellAliveAtRow(8, col: 26)
        gliderGun.setCellAliveAtRow(4, col: 36)
        gliderGun.setCellAliveAtRow(4, col: 37)
        gliderGun.setCellAliveAtRow(5, col: 36)
        gliderGun.setCellAliveAtRow(5, col: 37)
        colonies = [basicT, glider, gliderGun]
    }
    
    // set store to array of new colonies - used for unarchiving from file
    func set(newColonies: [Colony]) {
        self.colonies = newColonies
    }
    
    // initialize colonies array
    required init(coder aDecoder: NSCoder) {
        colonies = aDecoder.decodeObjectForKey("colonies") as [Colony]
    }
    
    // encode colonies array
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(colonies, forKey: "colonies")
    }
    
    // insert colony at head of the array
    func addColony(colony: Colony) {
        colonies.insert(colony, atIndex: 0)
    }
    
    // remove colony at certain index
    func removeColonyAtIndex(index: Int) {
        colonies.removeAtIndex(index)
    }
    
    // define read-only subscript for accessing colonies
    subscript(index: Int) -> Colony {
        get {
            return colonies[index]
        }
    }
}