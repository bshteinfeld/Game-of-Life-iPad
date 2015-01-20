//
//  DetailViewController.swift
//  Game of Life iPad
//
//  Created by Ben Shteinfeld on 1/2/15.
//  Copyright (c) 2015 Ben Shteinfeld. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // graphics outlets
    @IBOutlet weak var colonyView: ColonyView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var wrapSwitch: UISwitch!
    @IBOutlet weak var genLabel: UILabel!
    @IBOutlet weak var cellsAliveLabel: UILabel!
    
    // timer used or delay between evolves
    var timer: NSTimer = NSTimer()
    // colony
    var detailItem: Colony?
    // counter for quick evolve buttons
    var quickEvolveCounter = 0
    
    // called each time slider is moved
    @IBAction func speedChanged(sender: UISlider) {
        // kill old timer
        timer.invalidate()
        
        // initialize new timer with delay based on slider value
        if(sender.value != 0.0) {
            timer = NSTimer.scheduledTimerWithTimeInterval(Double(1/sender.value), target: self, selector: "updateView", userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
        }
    }
    
    // evolve the colony once and update the view
    func updateView() {
        if let colony: Colony = self.detailItem as Colony! {
            // check if quick evolve is over
            if quickEvolveCounter == 0 {
                // reset timer and slider
                timer.invalidate()
                slider.value = 0.0
            }
            // decrement counter
            quickEvolveCounter--
            // evolve once and update views
            colony.evolve()
            colonyView.setNeedsDisplay()
            updateDataLabels()
        }
    }
    
    // update label which display data about the colony
    func updateDataLabels() {
        if let colony: Colony = self.detailItem as Colony! {
            genLabel.text = "\(colony.numGens)"
            cellsAliveLabel.text = "\(colony.getNumberLivingCells())"
        }
    }
    
    // toggle wrapping mode
    @IBAction func wrapToggled(sender: UISwitch) {
        if let colony: Colony = self.detailItem as Colony! {
            colony.wrap = sender.on
        }
    }
    
    // event handler for quick evolve buttons
    @IBAction func evolveXTimes(send: UIButton) {
        // stop current timer
        if timer.valid {
            timer.invalidate()
        }
        let c = colonyView.colony
        
        // initialize counter according to which quick evolve button was pressed
        quickEvolveCounter = send.tag
        // change slider value
        slider.value = slider.maximumValue / 2
        // initialize new timer
        timer = NSTimer.scheduledTimerWithTimeInterval(Double(1/slider.value), target: self, selector: "updateView", userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // configure view
        if let colony: Colony = self.detailItem as Colony! {
            colonyView.colony = colony
            wrapSwitch.on = colony.wrap
            colonyView.viewController = self
            colonyView.setNeedsDisplay()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        if timer.valid {
            timer.invalidate()
        }
        quickEvolveCounter = 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSettings" {
            let controller = segue.destinationViewController as SettingsViewController
            //println("\(segue.destinationViewController.dynamicType.description())")
            if let colony: Colony = detailItem as Colony! {
                controller.colony = colony
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

