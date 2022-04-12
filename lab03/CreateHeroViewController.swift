//
//  CreateHeroViewController.swift
//  lab03
//
//  Created by Saauren Mankad on 23/3/2022.
//

import UIKit

class CreateHeroViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var abilitiesTextField: UITextField!
    @IBOutlet weak var universeSegmentedControl: UISegmentedControl!
    
    weak var superHeroDelegate: AddSuperHeroDelegate?
    
    weak var databaseController: DatabaseProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
        
    }
    
    
    func displayMessage(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default,handler: nil ))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func createHero(_ sender: Any) {
        
        guard let name = nameTextField.text, let abilities = abilitiesTextField.text, let universe = Universe(rawValue: Int(universeSegmentedControl.selectedSegmentIndex)) else {
            return
        }
        
        if name.isEmpty || abilities.isEmpty {
        
            var errorMsg = "Please ensure all fields are filled:\n"
            
            if name.isEmpty {
                errorMsg += "- Must provide abilities"
            }
            
            displayMessage(title: "Not all fields filled", message: errorMsg)
            return
        }
        
        let _ = databaseController?.addSuperhero(name: name, abilities: abilities, universe: universe)
        
        navigationController?.popViewController(animated: true)
        
        

        
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
