//
//  CurrentPartyTableViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 17/3/2022.
//

import UIKit

class CurrentPartyTableViewController: UITableViewController {
    
    let SECTION_HERO = 0
    let SECTION_INFO = 1
    
    let CELL_HERO = "heroCell"
    let CELL_INFO = "partySizeCell"
    
    var currentParty: [Superhero] = []
    
    
    func testHeroes(){
        currentParty.append(Superhero(newName:"Superman",newAbilities:"Super Powered Alien",  newUniverse:.dc))
        print(currentParty)

        currentParty.append(Superhero(newName:"Wonder Woman",newAbilities:"Goddess",  newUniverse:.dc))
        currentParty.append(Superhero(newName:"The Flash",newAbilities:"Speed",  newUniverse:.dc))
        currentParty.append(Superhero(newName:"Green Lantern",newAbilities:"Power Ring",  newUniverse:.dc))
        currentParty.append(Superhero(newName:"Cyborg",newAbilities:"Robot Beep Beep",  newUniverse:.dc))
        currentParty.append(Superhero(newName:"Aquaman",newAbilities:"Atlantian",  newUniverse:.dc))
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        testHeroes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case SECTION_HERO:
            return currentParty.count
        
        case SECTION_INFO:
            return 1
            
        default:
            return 0
            
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_HERO {
            
            let heroCell = tableView.dequeueReusableCell(withIdentifier: CELL_HERO, for: indexPath)
            
            var content = heroCell.defaultContentConfiguration()
            let hero = currentParty[indexPath.row]
            
            content.text = hero.name
            content.secondaryText = hero.abilities
            heroCell.contentConfiguration = content
            
            return heroCell
            
            
        }
        
        
        else {
            
            
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath)
            
            var content = infoCell.defaultContentConfiguration()
            
            if currentParty.isEmpty{
                
                content.text = "No heroes in Party. Tap + to add some."
            }
            
            else {
                content.text = "\(currentParty.count)/6 Heroes in Party"
            }
            infoCell.contentConfiguration = content
            return infoCell
        }
        
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
        if indexPath.section == SECTION_HERO {
            return true
        }
        
        return false
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete && indexPath.section == SECTION_HERO {
            tableView.performBatchUpdates({
                self.currentParty.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_INFO], with: .automatic)
            }, completion:nil)
        }
        
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
