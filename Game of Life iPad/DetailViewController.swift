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
    @IBOutlet weak var genLabel: UILabel!
    @IBOutlet weak var cellsAliveLabel: UILabel!
    
    // timer used or delay between evolves
    var timer: NSTimer = NSTimer()
    // colony
    var detailItem: Colony?

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
            colony.evolve()
            colonyView.setNeedsDisplay()
        }
    }
    
    @IBAction func wrapToggled(sender: UISwitch) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // configure view
        if let colony: Colony = self.detailItem as Colony! {
            colonyView.colony = colony
            colonyView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

