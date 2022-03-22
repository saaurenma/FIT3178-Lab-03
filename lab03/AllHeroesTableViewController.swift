//
//  AllHeroesTableViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 17/3/2022.
//

import UIKit

class AllHeroesTableViewController: UITableViewController {
    
    let SECTION_HERO = 0
    let SECTION_INFO = 1
    
    let CELL_HERO = "heroCell"
    let CELL_INFO = "heroCell"
    
    var allHeroes: [Superhero] = []
    
    weak var superHeroDelegate: AddSuperHeroDelegate?
    
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDefaultHeroes()
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
            return allHeroes.count
        
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
            let hero = allHeroes[indexPath.row]
            content.text = hero.name
            content.secondaryText = hero.abilities
            heroCell.contentConfiguration = content
            
            return heroCell
        }
        
        else {
            let infoCell = tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath) as! HeroCountTableViewCell
            infoCell.totalLabel?.text = "\(allHeroes.count) heroes in the database"
            
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
                self.allHeroes.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_INFO], with: .automatic)
            }, completion:nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let superHeroDelegate = superHeroDelegate {
            if superHeroDelegate.addSuperhero(allHeroes[indexPath.row]) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
