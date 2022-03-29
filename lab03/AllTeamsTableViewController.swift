//
//  AllTeamsTableViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 29/3/2022.
//

import UIKit

class AllTeamsTableViewController: UITableViewController {

    var teamName: String?
    var allTeams: [String] = []

    let SECTION_TEAM = 0
    let SECTION_TEAM_TOTAL = 1
    
    let CELL_TEAM = "teamCell"
    let CELL_TOTAL = "totalTeamsCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func getTeamName() -> String? {
        

        let alertController = UIAlertController(title: "Add a Team", message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) -> String in
            
            let x = alertController.textFields![0].text
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
        
    }
    
    
    // MARK: - Table view data source


    @IBAction func addTeamAction(_ sender: Any) {
        

        
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
            
            content.text = team
            teamCell.contentConfiguration = content
            
            print(self.allTeams.count)
            
            return teamCell
            
            
        }
        
        
        else {
            
            
            let totalTeamCell = tableView.dequeueReusableCell(withIdentifier: CELL_TOTAL, for: indexPath)
            
            var content = totalTeamCell.defaultContentConfiguration()
            
            if self.allTeams.isEmpty{
                
                content.text = "No teams added. Press + to add some."
            }
            
            else {
                content.text = "\(self.allTeams.count)/10 Teams added"
            }
            
            totalTeamCell.contentConfiguration = content
            return totalTeamCell
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
