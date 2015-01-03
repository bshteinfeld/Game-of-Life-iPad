//
//  DetailViewController.swift
//  Game of Life iPad
//
//  Created by Ben Shteinfeld on 1/2/15.
//  Copyright (c) 2015 Ben Shteinfeld. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var colonyView: ColonyView!
    
    var detailItem: Colony?

    func configureView() {
        //colonyView = ColonyView()
        
        // Update the user interface for the detail item.
        if let colony: Colony = self.detailItem as Colony! {
            colonyView.colony = colony
            colonyView.setNeedsDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

