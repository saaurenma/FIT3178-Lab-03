//
//  CurrentPartyTableViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 17/3/2022.
//

import UIKit

class CurrentPartyTableViewController: UITableViewController, DatabaseListener {
    
    let SECTION_HERO = 0
    let SECTION_INFO = 1
    
    let CELL_HERO = "heroCell"
    let CELL_INFO = "partySizeCell"
    
    var currentParty: [Superhero] = []
    
    var listenerType: ListenerType = .team
    weak var databaseController: DatabaseProtocol?
    
    var currentTeam: Team?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // set databaseController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController

        
        if let currentTeam = currentTeam {
            self.title = "Current party: \(currentTeam.name!)"
        }
        
    }
    
    func onTeamChange(change: DatabaseChange, teamHeroes: [Superhero]) {
        currentParty = teamHeroes
        tableView.reloadData()
    }
    
    func onAllHeroesChange(change: DatabaseChange, heroes: [Superhero]) {
        // do nothing
    }
    
    func onTeamsChange(change: DatabaseChange, teams: [Team]) {
        // do nothing
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    
    func addSuperhero(_ newHero: Superhero) -> Bool {
        
        return databaseController?.addHeroToTeam(hero: newHero, team: databaseController!.currentTeam!) ?? false
        
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
            self.databaseController?.removeHeroFromTeam(hero: currentParty[indexPath.row], team: currentTeam!)
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }


}
