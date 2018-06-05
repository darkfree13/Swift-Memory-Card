//
//  GameViewController.swift
//  Joan_Costa-iOS_ENTI
//
//  Created by joan costa on 1/04/2018.
//  Copyright © 2018 Joan-ENTI. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

class GameViewController: UIViewController {
    var refPlayers : DatabaseReference!
    
    //Timer
    @IBOutlet weak var timerLabel: UILabel!
    var countdownTimer: Timer!
    var totalTime = 120
    
    // Cards
    @IBOutlet var cardImage: [UIImageView]!
    
    //Score
    var score: Float = 0
    @IBOutlet weak var ScoreText: UILabel!
    var onFire: Float = 1
    
    let Deck = DeckData().getAllCards()
    var newCheck: Int = -5
    var lastCheck: Int = -5
    var comparing = false
    
    //Sound
    var audioPlayer: AVAudioPlayer?
    var isEffectOn: String = ""
    
    //Level
    var levelPlaying: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        // Do any additional setup after loading the view, typically from a nib.
        refPlayers = Database.database().reference().child("Ranking")
        startTimer()
        flipSound()
        
        
        if let savedEffect = userDefaults.string(forKey: "effectSound"){
            if savedEffect == "ON"{
                isEffectOn = "ON"
            }
        }
        if let savedLevel = userDefaults.string(forKey: "gameLevel"){
            if savedLevel == "medium"{
                levelPlaying = "medium"
            }else{
                levelPlaying = "easy"
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func CardPressed(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        if(!comparing){ // si no esta aun haciendo la visualizacion de la jugada anterior, gira carta nueva
            if(Deck[button.tag].status == "i"){ // miramos si el estado de la carta es el inicial
                newCheck = button.tag // Guardamos la carta que se ha selecionado
                Deck[button.tag].status = "g" // Cambiamos el estado de la carta
                changeFront(idCard: Deck[newCheck].value) // Giramos la carta
                
                if(lastCheck == -5){ // Miramos si es la primera o la segunda seleccion
                    lastCheck = newCheck
                }else{
                    if(Deck[lastCheck].value == Deck[newCheck].value){ // Si son iguales, hacemos match y las dejamos cara arriba
                        Deck[lastCheck].status = "M"
                        Deck[newCheck].status = "M"
                        
                        score = score + (100 * onFire)
                        ScoreText.text = String(format: " %.0f", score)
                        onFire = onFire + 0.2
                        
                        cardImage[lastCheck].backgroundColor = UIColor.green
                        cardImage[newCheck].backgroundColor = UIColor.green
                        lastCheck = -5
                        newCheck = -5
                    }else{ // Si son distintas las mostramos y las recolocamos
                        
                        
                        score = score - 25
                        if(score < 0){score = 0}
                        onFire = 1
                        ScoreText.text = String(format: "%.0f", score)
                        
                        comparing = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // change 0.7 to desired number of seconds, hace una pequeña pausa para que se puedan visualizar las cartas
                            self.Deck[self.lastCheck].status = "i"
                            self.Deck[self.newCheck].status = "i"
                            self.cardImage[self.lastCheck].image = UIImage(named: "cardBackground")
                            self.cardImage[self.newCheck].image = UIImage(named: "cardBackground")
                            
                            
                            
                            self.lastCheck = -5
                            self.newCheck = -5
                            self.comparing = false
                            
                        }
                    }
                }
            }
        }
        
        if (winCondition()){
            if (levelPlaying == "medium"){
                let highestScore:Int = UserDefaults.standard.integer(forKey: "highestScore")
                if (Int(score) > highestScore){
                    UserDefaults.standard.set(Int(score),forKey:"highestScore")
                    addPlayer()
                }
            }
            gameFinished()
        }
        
    }
    
    
    
    //Game has finished?
    func winCondition() -> Bool{
        var finish = true
        for i in 0...Deck.count-1{
            if(Deck[i].status != "M"){
                finish = false
            }
        }
        return finish
    }
    
    
    // Sends new result to firebase//
    
    func addPlayer(){
        let uName = UserDefaults.standard.string(forKey: "userName")
        let key = refPlayers.childByAutoId().key
        
        //creating artist with the given values
        let player = ["id":key,
                      "NameID": uName!,
                      "Score": score,
                      ] as [String : Any]
        
        //adding the artist inside the generated unique key
        refPlayers.childByAutoId().setValue(player)
        
    }
    
    
    func changeFront(idCard: Int) { // Depende del valos de cada carta se muestra un dorso u otro
        
        //Effect Sound check
        if isEffectOn == "ON"{
            audioPlayer?.play()
        }
        
        
        switch idCard {
        case 0:
            cardImage[newCheck].image = UIImage(named: "card1")
        case 1:
            cardImage[newCheck].image = UIImage(named: "card2")
        case 2:
            cardImage[newCheck].image = UIImage(named: "card3")
        case 3:
            cardImage[newCheck].image = UIImage(named: "card4")
        case 4:
            cardImage[newCheck].image = UIImage(named: "card5")
        case 5:
            cardImage[newCheck].image = UIImage(named: "card6")
        case 6:
            cardImage[newCheck].image = UIImage(named: "card7")
        case 7:
            cardImage[newCheck].image = UIImage(named: "card8")
        default:
            cardImage[newCheck].image = UIImage(named: "cardBackground")
        }
        
    }
    
    
    //Timer Part
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        //timerLabel.text = "\(timeFormatted(totalTime))"
        timerLabel.text = String(totalTime)
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        gameFinished()
        
    }
    
    //Back to Menu
    func gameFinished(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { // change 0.7 to desired number of seconds
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainMenu")
            self.present(newViewController, animated: true, completion: nil)
            
        }
    }

    //Setting flip sound effect
    func flipSound(){
        do {
            if let fileURL = Bundle.main.path(forResource: "flipCard", ofType: "wav") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
    }
    

}
