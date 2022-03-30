//
//  AllTeamsTableViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 29/3/2022.
//

import UIKit

class AllTeamsTableViewController: UITableViewController, DatabaseListener {
    
    
    var listenerType: ListenerType = .team
    weak var databaseController: DatabaseProtocol?


    var teamName: String?
    var allTeams: [Team] = []

    let SECTION_TEAM = 0
    let SECTION_TEAM_TOTAL = 1
    
    let CELL_TEAM = "teamCell"
    let CELL_TOTAL = "totalTeamsCell"
    
    var selectedTeam: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
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
        
        //?
        
    }
    
    func onAllHeroesChange(change: DatabaseChange, heroes: [Superhero]) {
        // ?
    }
    
    func onTeamsChange(change: DatabaseChange, teams: [Team]) {
        allTeams = teams
        tableView.reloadData()
    }
    
    
    func displayMessage(title: String, message: String){
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil ))
         self.present(alertController, animated: true, completion: nil)
     }

        
    func addTeam(_ newTeam: String) -> Bool {
        if let teamObject = databaseController?.addTeam(teamName: newTeam) {
            tableView.performBatchUpdates({
                allTeams.append(teamObject)
                tableView.insertRows(at: [IndexPath(row: allTeams.count - 1, section:
            SECTION_TEAM)],
                    with: .automatic)
                tableView.reloadSections([SECTION_TEAM_TOTAL], with: .automatic) },completion: nil)
            return true
        }
        else {
            return false
        }

        
    }

        
    
    // MARK: - Table view data source
    
    @IBAction func addTeamAction(_ sender: Any) {
        
        
        var teamTextField = UITextField()
        var teamText = ""
        
        let alertController = UIAlertController(title: "Add a Team", message: "", preferredStyle: .alert)
        
        alertController.addTextField()
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> Void in
            
            teamTextField = alertController.textFields![0] as UITextField
            
            teamText = teamTextField.text!
            
            
            if self.addTeam(teamText) == false{
                self.displayMessage(title: "Error", message: "Maximum of 10 heroes allowed")
            }
                
        }
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            
        case SECTION_TEAM:
            return self.allTeams.count
        
        case SECTION_TEAM_TOTAL:
            return 1
            
        default:
            return 0
            
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == SECTION_TEAM {
            
            let teamCell = tableView.dequeueReusableCell(withIdentifier: CELL_TEAM, for: indexPath)
            
            var content = teamCell.defaultContentConfiguration()
            let team = self.allTeams[indexPath.row]
            
            content.text = team.name
            teamCell.contentConfiguration = content
                        
            return teamCell
            
            
        }
        
        
        else {
            
            
            let totalTeamCell = tableView.dequeueReusableCell(withIdentifier: CELL_TOTAL, for: indexPath)
            
            var content = totalTeamCell.defaultContentConfiguration()
            
            
            if allTeams.isEmpty{
                
                content.text = "No teams added. Press + to add some."
            }
            
            else {
                content.text = "\(self.allTeams.count)/10 Teams added"
            }
            
            totalTeamCell.contentConfiguration = content
            return totalTeamCell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        selectedTeam = allTeams[indexPath.row]
        self.databaseController?.currentTeam = selectedTeam
        self.performSegue(withIdentifier: "teamsToHeroesSegue", sender: nil)
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.section == SECTION_TEAM {
            self.databaseController?.deleteTeam(team: allTeams[indexPath.row])
            tableView.performBatchUpdates({
                self.allTeams.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadSections([SECTION_TEAM_TOTAL], with: .automatic)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let party = segue.destination as! CurrentPartyTableViewController
        party.currentTeam = selectedTeam
    }

}
