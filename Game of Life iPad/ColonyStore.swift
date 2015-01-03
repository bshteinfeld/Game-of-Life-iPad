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
    override init() { }
    
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