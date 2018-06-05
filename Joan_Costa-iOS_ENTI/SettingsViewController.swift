//
//  ViewController.swift
//  Joan_Costa-iOS_ENTI
//
//  Created by joan costa on 05/03/2018.
//  Copyright © 2018 Joan-ENTI. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var customName: UITextField!
    // segment bar
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // Switch Music
   
    @IBOutlet weak var switchMusic: UISwitch!
    // Switch Effect
    @IBOutlet weak var switchEffect: UISwitch!
    
    
    
     let notification = NotificationCenter.default
    
    
    /* functions of segment and switch*/
    // Change difficulty level
    @IBAction func levelChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            UserDefaults.standard.set("easy", forKey:"gameLevel")
        case 1:
            UserDefaults.standard.set("medium", forKey:"gameLevel")
        default:
            break
        }
    }
    
    // Switch ON/OFF the Music sound
    @IBAction func musicSwitched(_ sender: Any) {
        if switchMusic.isOn {
            UserDefaults.standard.set("OFF", forKey:"musicSound")
            switchMusic.setOn(false, animated:true)
            notification.post(name: Notification.Name("StopMusic"), object: nil)
            
        } else {
            UserDefaults.standard.set("ON", forKey:"musicSound")
            switchMusic.setOn(true, animated:true)
            notification.post(name: Notification.Name("PlayMusic"), object: nil)
        }
    }
    
    
    // Switch ON/OFF the effect sound
    @IBAction func effectSwitched(_ sender: Any) {
        if switchEffect.isOn {
            UserDefaults.standard.set("OFF", forKey:"effectSound")
            switchEffect.setOn(false, animated:true)
        } else {
            UserDefaults.standard.set("ON", forKey:"effectSound")
            switchEffect.setOn(true, animated:true)
        }
    }
    
    
    //Changes the profile game
    @IBAction func nameChanged(_ sender: Any) {
        UserDefaults.standard.set(customName.text, forKey:"userName")
        let userName = UserDefaults.standard.string(forKey: "userName")
        customName.text = userName
    }
        
  
    
    //Hides keyboard by click and by tap//
    func textFieldShouldReturn(_ customName: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //End Hides keyboard//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAllSettings()
        customName.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //sets up all the settings
    func setUpAllSettings(){
        let userName = UserDefaults.standard.string(forKey: "userName")
        customName.text = userName
        
        if UserDefaults.standard.string(forKey: "effectSound") == "OFF"{
            switchEffect.setOn(false, animated:true)
        }
        if UserDefaults.standard.string(forKey: "musicSound") == "OFF"{
            switchMusic.setOn(false, animated:true)
        }
        switch UserDefaults.standard.string(forKey: "gameLevel") {
        case "easy":
            segmentedControl.selectedSegmentIndex = 0
        case "medium":
            segmentedControl.selectedSegmentIndex = 1
        default:
            break

        }
    }
    
}
