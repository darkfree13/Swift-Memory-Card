//
//  ViewController.swift
//  Joan_Costa-iOS_ENTI
//
//  Created by joan costa on 05/03/2018.
//  Copyright © 2018 Joan-ENTI. All rights reserved.

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        
        userDefaults.set("afkPlayer", forKey: "Key")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

