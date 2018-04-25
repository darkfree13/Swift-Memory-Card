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

class GameViewController: UIViewController {
    var refPlayers : DatabaseReference!
    
    
    @IBOutlet var cardImage: [UIImageView]!
    
    
    let Deck = DeckData().getAllCards()
    var newCheck: Int = -5
    var lastCheck: Int = -5
    var comparing = false
    var front: String = "9"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refPlayers = Database.database().reference().child("Ranking")
        addPlayer()
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
                        
                        cardImage[lastCheck].backgroundColor = UIColor.green
                        cardImage[newCheck].backgroundColor = UIColor.green
                        lastCheck = -5
                        newCheck = -5
                    }else{ // Si son distintas las mostramos y las recolocamos
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
    }
    
    
    // Sends new result to firebase//
    func addPlayer(){
        let key = refPlayers.childByAutoId().key
        
        //creating artist with the given values
        let player = ["id":key,
                      "NameID": "DK13",
                      "Score": 90,
                      ] as [String : Any]
        
        //adding the artist inside the generated unique key
        refPlayers.childByAutoId().setValue(player)
        
    }
    
    
    func changeFront(idCard: Int) { // Depende del valos de cada carta se muestra un dorso u otro
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
    
}
