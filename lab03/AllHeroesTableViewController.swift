//
//  AllHeroesTableViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 17/3/2022.
//

import UIKit

class AllHeroesTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener {

    
    
    let SECTION_HERO = 0
    let SECTION_INFO = 1
    
    let CELL_HERO = "heroCell"
    let CELL_INFO = "totalCell"
    
    
    var allHeroes: [Superhero] = []
    
    var filteredHeroes: [Superhero] = []
    
    weak var superHeroDelegate: AddSuperHeroDelegate?
    
    
    var listenerType = ListenerType.heroes
    weak var databaseController: DatabaseProtocol?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set databaseController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
        filteredHeroes = allHeroes
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search All Heroes"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }

    
    func onTeamChange(change: DatabaseChange, teamHeroes: [Superhero]) {
        // do nothing
    }
    
    func onAllHeroesChange(change: DatabaseChange, heroes: [Superhero]) {
        allHeroes = heroes
        updateSearchResults(for: navigationItem.searchController!)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {
            return
        }
        
        if searchText.count > 0 {
            filteredHeroes = allHeroes.filter({(hero:Superhero) -> Bool in return (hero.name?.lowercased().contains(searchText) ?? false)
                
            })
            
        } else {
            filteredHeroes = allHeroes
        }
        
        tableView.reloadData()
    }
    
    
    func displayMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil ))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // 2 sections in table view
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case SECTION_HERO:
            return filteredHeroes.count
        
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
            let hero = filteredHeroes[indexPath.row]
            content.text = hero.name
            content.secondaryText = hero.abilities
            heroCell.contentConfiguration = content
            
            return heroCell
        }
        
        else {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath) as! HeroCountTableViewCell
            infoCell.totalLabel?.text = "\(filteredHeroes.count) heroes in the database"
            
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
            
            let hero = filteredHeroes[indexPath.row]
            databaseController?.deleteSuperhero(hero: hero)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = filteredHeroes[indexPath.row]
        let heroAdded = databaseController?.addHeroToTeam(hero: hero, team: databaseController!.defaultTeam) ?? false

        if heroAdded {
            navigationController?.popViewController(animated: false)
            return
        }
        
        displayMessage(title: "Party Full", message: "Unable to add more members to party")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
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
