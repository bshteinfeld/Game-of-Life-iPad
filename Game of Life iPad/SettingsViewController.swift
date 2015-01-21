//
//  SettingsViewController.swift
//  Game of Life iPad
//
//  Created by Ben Shteinfeld on 1/3/15.
//  Copyright (c) 2015 Ben Shteinfeld. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // graphical outlets
    @IBOutlet weak var colonyView: ColonyView!
    @IBOutlet weak var oldColonyView: ColonyView!
    @IBOutlet weak var templatePicker: UIPickerView!
    @IBOutlet weak var coordinateText: UITextView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var generationLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    
    // template colonies that can chose in picker
    let templates = ["Basic-T", "Glider", "Glider-Gun", "Random"]
    // colony for which settings are displayed
    var colony: Colony?
    // old colony
    var originalColony: Colony!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure template delegate and datasource
        templatePicker.delegate = self
        templatePicker.dataSource = self
        
        // retrieve colony
        if let c: Colony = colony as Colony! {
            // give colony view a colony model
            colonyView.colony = c
            colonyView.setNeedsDisplay()
            // disable user interaction -- touch delegate methods no longer called
            colonyView.userInteractionEnabled = false
            
            // get copy of colony
            originalColony = c.copyColony()
            // assign old colony to oldColonyView and update view
            oldColonyView.colony = originalColony
            oldColonyView.setNeedsDisplay()
            // disable interaction
            oldColonyView.userInteractionEnabled = false
            
            // display colony name
            nameField.text = c.name
            nameField.textAlignment = .Center
            // disable editing
            nameField.userInteractionEnabled = false
            
            // update list of coordinates
            coordinateText.text = c.description()
            // update info labels
            generationLabel.text = "\(c.getGenerationNumber())"
            percentLabel.text = "\(Float(c.getNumberLivingCells()*100) / Float(c.rows*c.cols)) %"
        }
    }
    
    // update colony with template
    @IBAction func templateChosen(sender: UIButton) {
        if let c: Colony = colony as Colony! {
            c.resetCells()
            switch templatePicker.selectedRowInComponent(0) {
            case 0:
                c.setCellAliveAtRow(5, col: 5)
                c.setCellAliveAtRow(5, col: 6)
                c.setCellAliveAtRow(5, col: 7)
                c.setCellAliveAtRow(6, col: 6)
            case 1:
                c.setCellAliveAtRow(5, col: 5)
                c.setCellAliveAtRow(6, col: 6)
                c.setCellAliveAtRow(7, col: 6)
                c.setCellAliveAtRow(7, col: 5)
                c.setCellAliveAtRow(7, col: 4)
            case 2:
                c.setCellAliveAtRow(6, col: 2)
                c.setCellAliveAtRow(6, col: 3)
                c.setCellAliveAtRow(7, col: 2)
                c.setCellAliveAtRow(7, col: 3)
                c.setCellAliveAtRow(4, col: 14)
                c.setCellAliveAtRow(4, col: 15)
                c.setCellAliveAtRow(5, col: 13)
                c.setCellAliveAtRow(6, col: 18)
                c.setCellAliveAtRow(7, col: 12)
                c.setCellAliveAtRow(7, col: 16)
                c.setCellAliveAtRow(7, col: 18)
                c.setCellAliveAtRow(7, col: 19)
                c.setCellAliveAtRow(8, col: 12)
                c.setCellAliveAtRow(8, col: 18)
                c.setCellAliveAtRow(9, col: 13)
                c.setCellAliveAtRow(9, col: 17)
                c.setCellAliveAtRow(10, col: 14)
                c.setCellAliveAtRow(10, col: 15)
                c.setCellAliveAtRow(5, col: 17)
                c.setCellAliveAtRow(6, col: 12)
                c.setCellAliveAtRow(4, col: 22)
                c.setCellAliveAtRow(4, col: 23)
                c.setCellAliveAtRow(5, col:22)
                c.setCellAliveAtRow(5, col: 23)
                c.setCellAliveAtRow(6, col: 22)
                c.setCellAliveAtRow(6, col: 23)
                c.setCellAliveAtRow(3, col: 24)
                c.setCellAliveAtRow(3, col: 26)
                c.setCellAliveAtRow(2, col: 26)
                c.setCellAliveAtRow(7, col: 24)
                c.setCellAliveAtRow(7, col: 26)
                c.setCellAliveAtRow(8, col: 26)
                c.setCellAliveAtRow(4, col: 36)
                c.setCellAliveAtRow(4, col: 37)
                c.setCellAliveAtRow(5, col: 36)
                c.setCellAliveAtRow(5, col: 37)
            case 3:
                for row in 0..<c.rows {
                    for col in 0..<c.cols {
                        if Float(drand48()) < 0.6 {
                            c.setCellAliveAtRow(row, col: col)
                        }
                    }
                }
            default:
                break
            }
            colonyView.setNeedsDisplay()
            coordinateText.text = c.description()
            percentLabel.text = "\(Float(c.getNumberLivingCells()*100) / Float(c.rows*c.cols)) %"
        }
    }
    
    // update colony with list of coordinates
    @IBAction func coordinateListChosen(sender: UIButton) {
        if let c: Colony = colony as Colony! {
            // attempt to load cells to colony
            // if cells loaded succesfully, update display, else display error alert
            if c.loadCellsFromList(coordinateText.text) {
                colonyView.setNeedsDisplay()
                percentLabel.text = "\(Float(c.getNumberLivingCells()*100) / Float(c.rows*c.cols)) %"
            } else {
                // create and display alert
                var alert = UIAlertController(title: "Error Loading Cells", message: "Invalid coordinate entered", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func revertChanges(sender: UIButton) {
        // copy cells from originalColony
        colonyView.colony.cells = originalColony.cells
        
        // update views
        colonyView.setNeedsDisplay()
        coordinateText.text = colonyView.colony.description()
        percentLabel.text = "\(Float(colonyView.colony.getNumberLivingCells()*100) / Float(colonyView.colony.rows*colonyView.colony.cols)) %"
    }
    
    // update colony name
    @IBAction func colonyNameChanged(sender: UITextField) {
        //ColonyStore.sharedColonyStore[0].name = sender.text
    }
    
    // MARK: Picker Data Source Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return templates.count
    }
    
    // MARK: Picker Delegate Methods
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return templates[row]
    }
}