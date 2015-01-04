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
    @IBOutlet weak var templatePicker: UIPickerView!
    @IBOutlet weak var coordinateText: UITextView!
    
    // template colonies that can chose in picker
    let templates = ["Basic-T", "Glider", "Glider-Gun", "Random"]
    // colony for which settings are displayed
    var colony: Colony?
    
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
            
            // TODO -- update list of coordinates
        }
    }
    
    // update colony with template
    @IBAction func templateChosen(sender: UIButton) {
    }
    
    // update colony with list of coordinates
    @IBAction func coordinateListChosen(sender: UIButton) {
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