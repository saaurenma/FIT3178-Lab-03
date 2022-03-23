//
//  AllHeroesTableViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 17/3/2022.
//

import UIKit

class AllHeroesTableViewController: UITableViewController, UISearchResultsUpdating, AddSuperHeroDelegate {
    

    
    
    let SECTION_HERO = 0
    let SECTION_INFO = 1
    
    let CELL_HERO = "heroCell"
    let CELL_INFO = "totalCell"
    
    
    var allHeroes: [Superhero] = []
    
    var filteredHeroes: [Superhero] = []
    
    weak var superHeroDelegate: AddSuperHeroDelegate?
    
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDefaultHeroes()
        filteredHeroes = allHeroes
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search All Heroes"
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
    }
    
    
    func addSuperhero(_ newHero: Superhero) -> Bool {
        tableView.performBatchUpdates({
            allHeroes.append(newHero)
            filteredHeroes.append(newHero)
            
            tableView.insertRows(at: [IndexPath(row: filteredHeroes.count - 1, section:SECTION_HERO)], with: .automatic)
            tableView.reloadSections([SECTION_INFO], with: .automatic)
        }, completion: nil)
        
        return true
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
    
    func createDefaultHeroes() {
        
        allHeroes.append(Superhero(newName:"Bruce Wayne",newAbilities:"Money",  newUniverse:.dc))
        allHeroes.append(Superhero(newName:"Superman",newAbilities:"Super Powered Alien",  newUniverse:.dc))
        allHeroes.append(Superhero(newName:"Wonder Woman",newAbilities:"Goddess",  newUniverse:.dc))
        allHeroes.append(Superhero(newName:"The Flash",newAbilities:"Speed",  newUniverse:.dc))
        allHeroes.append(Superhero(newName:"Green Lantern",newAbilities:"Power Ring",  newUniverse:.dc))
        allHeroes.append(Superhero(newName:"Cyborg",newAbilities:"Atlantian",  newUniverse:.dc))
        allHeroes.append(Superhero(newName:"Aquaman",newAbilities:"Atlantian",  newUniverse:.dc))

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
            tableView.performBatchUpdates({

                if let index = self.allHeroes.firstIndex(of: filteredHeroes[indexPath.row]){
                    self.allHeroes.remove(at: index)
                }
                
                self.filteredHeroes.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_INFO], with: .automatic)
            }, completion:nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let superHeroDelegate = superHeroDelegate {
            if superHeroDelegate.addSuperhero(filteredHeroes[indexPath.row]) {
                navigationController?.popViewController(animated: false)
                return
            }
            else {
                displayMessage(title: "Party Full", message: "Unable to add more members to party")
            }
        }
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
        if segue.identifier == "createHeroSegue" {
            let destination = segue.destination as! CreateHeroViewController
            destination.superHeroDelegate = self
            
        }
    }

}
