//
//  CurrentPartyTableViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 17/3/2022.
//

import UIKit

class CurrentPartyTableViewController: UITableViewController, AddSuperHeroDelegate {

    
    
    let SECTION_MARVEL = 0
    let SECTION_DC = 1
    
    let SECTION_HERO = 0
    let SECTION_INFO = 1
    
    let CELL_HERO = "heroCell"
    let CELL_INFO = "partySizeCell"
    
    var currentParty: [[Superhero]] = [[], []]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //testHeroes()
    }

    
    func addSuperhero(_ newHero: Superhero) -> Bool {
        
        if currentParty[SECTION_MARVEL].count + currentParty[SECTION_DC].count >= 6 {
            return false
        }
        
        let marvelHeroNames = currentParty[SECTION_MARVEL].filter({$0.name == newHero.name})
        let DCHeroNames = currentParty[SECTION_DC].filter({$0.name == newHero.name})

        tableView.performBatchUpdates({
            if marvelHeroNames == [] && DCHeroNames == []{
                
                if newHero.universe?.rawValue == SECTION_MARVEL {
                    currentParty[SECTION_MARVEL].append(newHero)
                }
                
                else if newHero.universe?.rawValue == SECTION_DC {
                    currentParty[SECTION_DC].append(newHero)
                }
                
            tableView.insertRows(at: [IndexPath(row: (currentParty[SECTION_MARVEL].count + currentParty[SECTION_DC].count) - 1, section:
        SECTION_HERO)],
                with: .automatic)
                tableView.reloadSections([SECTION_INFO], with: .automatic) }},completion: nil)
        return true
    }
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case SECTION_HERO:
            return currentParty[SECTION_MARVEL].count + currentParty[SECTION_DC].count
        
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
            let marvelHero = currentParty[SECTION_MARVEL][indexPath.row]
//            let DCHero = currentParty[SECTION_DC][indexPath.row]
            
            
            
            content.text = marvelHero.name
            content.secondaryText = marvelHero.abilities
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
                content.text = "\(currentParty[SECTION_MARVEL].count + currentParty[SECTION_DC].count)/6 Heroes in Party"
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        if section == SECTION_MARVEL {
            return "Marvel"
        }
        
        else if section == SECTION_DC {
            return "DC"
        }
        
        return ""
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allHeroesSegue" {
            let destination = segue.destination as! AllHeroesTableViewController
            destination.superHeroDelegate = self
            
        }
        
    }


}
