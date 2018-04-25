//
//  ScoreViewController.swift
//  Joan_Costa-iOS_ENTI
//
//  Created by joan costa on 24/04/2018.
//  Copyright © 2018 Joan-ENTI. All rights reserved.
//

import Foundation
import UIKit
import Firebase



class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    @IBOutlet weak var RankingTableView: UITableView!
 
    
   
   
   
    var newPlayer: [GamePlayer] = []
    
    var refPlayers : DatabaseReference!
    
    var refRanking : DatabaseReference!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
        refPlayers = Database.database().reference().child("Ranking");
        refRanking = Database.database().reference().child("Ranking");
       
        
        // Exemple de com llegir local data
        let savedData = (UserDefaults.standard.string(forKey: "Key")) as String?
        print("The key is...", savedData!)

         // Exemple de com llegir local data
        
        //addPlayer()
        getPlayer()
        
        RankingTableView.dataSource = self
        RankingTableView.delegate = self

    }
    
    
    
    // reads all the database
    func getPlayer(){
        refRanking.observe(.value, with: { snapshot in
            if snapshot.childrenCount > 0 {
                self.newPlayer.removeAll()
                for players in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let playersObject = players.value as? [String: AnyObject]
                    let playersName  = playersObject?["NameID"]
                    let playersScore = playersObject?["Score"]
                    let playersId  = playersObject?["id"]
                    
                    
                    //creating gamePlayer object with model and fetched values
                    let gamePlayer = GamePlayer(_Name: playersName as! String, _Score: playersScore as! Int, _ID: playersId as! String)
                    
                    //appending it to list
                    self.newPlayer.append(gamePlayer)
                    self.newPlayer.sort(by: {$0.Score > $1.Score})
                }
               
                
                
                self.RankingTableView.reloadData()
                self.RankingTableView.isHidden = false
                
            }
            
        })
        
    }
    
    

    // Function to add one player
    func addPlayer(){
        //generating a new key
        //and also getting the generated key
        let key = refPlayers.childByAutoId().key
        
        //creating artist with the given values
        let player = ["id":key,
                      "NameID": "Joan",
                      "Score": 1000,
                      ] as [String : Any]
        
        //adding the player inside the generated unique key
        refPlayers.childByAutoId().setValue(player)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newPlayer.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerRankTableViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = String(indexPath.item + 1) + ". " + newPlayer[indexPath.item].Name
        cell.detailTextLabel?.text = String(newPlayer[indexPath.item].Score)
        return cell
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
}
