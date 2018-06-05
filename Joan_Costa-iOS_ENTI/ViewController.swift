//
//  ViewController.swift
//  Joan_Costa-iOS_ENTI
//
//  Created by joan costa on 05/03/2018.
//  Copyright © 2018 Joan-ENTI. All rights reserved.

import UIKit
import CoreLocation
import AVFoundation

import UserNotifications

class ViewController: UIViewController,CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var BackgroundImage: UIImageView!
    
    @IBOutlet weak var LocationIntro: UILabel!
    let locationManager = CLLocationManager()
    
    var backgroundMusic: AVAudioPlayer?
    let ncObserver = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Observer from settings
        ncObserver.addObserver(self, selector: #selector(self.stopMusic), name: Notification.Name("StopMusic"), object: nil)
        
        ncObserver.addObserver(self, selector: #selector(self.playMusic), name: Notification.Name("PlayMusic"), object: nil)

    //Calls function for parallax effect
        parallaxConfig()
       
        
    // Location Request
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    //requesting for authorization
        initNotificationSetupCheck()
        UNUserNotificationCenter.current().delegate = self
        notificationInfo()
        
        backgroundSound()
        settingsInit()
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func StartGame(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        if let savedLevel = userDefaults.string(forKey: "gameLevel"){
            if (savedLevel == "medium"){
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Game_Medium")
                self.present(newViewController, animated: true, completion: nil)
            }else{
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Game_Easy")
                self.present(newViewController, animated: true, completion: nil)
            }
        } else {
            userDefaults.set("medium", forKey: "gameLevel")
        }
    }
    
    // Local Notification Settings  START//
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    

    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
    
    func notificationInfo(){
        let notification = UNMutableNotificationContent()
        notification.title = "Awesome"
        notification.subtitle = "Memory Card"
        notification.body = "Play and beat your friends"
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    // Local Notification Settings  END //
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Location Settings  START //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //gets the current country
        let location = locations[0]
        reverseGeocode(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // Return the current country , location
    func reverseGeocode(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks, let placemark = placemarks.first {
            
                if placemark.isoCountryCode != nil {
                    self.LocationIntro.text = "Welcome to " + placemark.locality!
                }
                //if placemark.isoCountryCode == "ES" {
                if (UIImage(named: "Menu"+placemark.isoCountryCode!+"background") != nil) {
                    self.BackgroundImage.image = UIImage(named: "Menu"+placemark.isoCountryCode!+"background")
                }else{
                    self.BackgroundImage.image = UIImage(named: "Sky")
                }
            
            }
        }
    }
    // Location Settings  END //
    
    
    
    //Config Background Music
    func backgroundSound(){
        let userDefaults = UserDefaults.standard
        var isMusicPlayerCreated : String = "NO"
        if let mPlayerCreated = userDefaults.string(forKey: "mPlayerCreated"){
            isMusicPlayerCreated = mPlayerCreated
        } else {
            userDefaults.set("NO", forKey: "mPlayerCreated")
            isMusicPlayerCreated = "NO"
        }
        if isMusicPlayerCreated == "NO" {
            do {
                if let fileURL = Bundle.main.path(forResource: "CasinoLoop", ofType: "mp3") {
                    backgroundMusic = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                    backgroundMusic?.numberOfLoops = -1
                    userDefaults.set("YES", forKey: "mPlayerCreated")
                } else {
                    print("No file with specified name exists")
                }
            } catch let error {
                print("Can't play the audio file failed with an error \(error.localizedDescription)")
            }
        }
    }

    
    
    
    //Inicialitzation START
    func settingsInit(){
        let userDefaults = UserDefaults.standard
        
    //Inicializa el username
        if let savedValue = userDefaults.string(forKey: "userName"){
            print("username = " + savedValue)
        } else {
            userDefaults.set(UIDevice.current.name, forKey: "userName")
        }
        
    // Inicializa el nivel
        if let savedLevel = userDefaults.string(forKey: "gameLevel"){
            print("Level = " + savedLevel)
        } else {
            userDefaults.set("medium", forKey: "gameLevel")
        }
        
    // Inicializa la musica
        if let savedMusic = userDefaults.string(forKey: "musicSound"){
            print("Music = " + savedMusic)
            
            if (savedMusic == "ON"){
                backgroundMusic?.play()
            } else{
                backgroundMusic?.stop()
            }
        } else {
            userDefaults.set("ON", forKey: "musicSound")
            backgroundMusic?.play()
        }
        
        
    //Inicialitza els efectes
        if let savedEffect = userDefaults.string(forKey: "effectSound"){
            print("Effects = " + savedEffect)
        } else {
            userDefaults.set("ON", forKey: "effectSound")
        }
    }
    //Inicialitzation END
    
    // Parallax effect on background image
    func parallaxConfig(){
        let min = CGFloat(-30)
        let max = CGFloat(30)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = min
        yMotion.maximumRelativeValue = max
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        
        BackgroundImage.addMotionEffect(motionEffectGroup)
    }
    
    
    // funciones que se llaman desde setting.swift
    @objc func stopMusic() {
        
        backgroundMusic?.stop()
        print("notification observed - music stopped")
    }
    
    @objc func playMusic() {
        
        backgroundMusic?.play()
        print("notification observed - music plays")
    }
    
  

}

