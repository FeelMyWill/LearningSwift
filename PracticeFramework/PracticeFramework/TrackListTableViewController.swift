//
//  TrackListTableViewController.swift
//  PracticeFramework
//
//  Created by Паша on 30.11.2022.
//

import UIKit

class TrackListTableViewController: UITableViewController {
    
    let imageNameArray = ["Alberto Ruiz - 7 Elements (Original Mix)",
                              "Dave Wincent - Red Eye (Original Mix)",
                              "E-Spectro - End Station (Original Mix)",
                              "Edna Ann - Phasma (Konstantin Yoodza Remix)",
                              "Ilija Djokovic - Delusion (Original Mix)",
                              "John Baptiste - Mycelium (Original Mix)",
                              "Lane 8 - Fingerprint (Original Mix)",
                              "Mac Vaughn - Pink Is My Favorite Color (Alex Stein Remix)",
                              "Metodi Hristov, Gallya - Badmash (Original Mix)",
                              "Veerus, Maxie Devine - Nightmare (Original Mix)"]
    
    @IBOutlet weak var thirdPrevScreenButton: UIButton!
    
    @IBOutlet weak var fourthNextScreenButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return imageNameArray.count
    }
    
    @IBAction func secondPreviousButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegue3", sender: nil)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Title", for: indexPath)

        cell.imageView?.image = UIImage(named: imageNameArray[indexPath.row])
        cell.textLabel?.text = imageNameArray[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let ViewController4 = segue.destination as! ViewController4
                ViewController4.trackTitle = imageNameArray[indexPath.row]
            }
        }
    }

    @IBAction func fiveNextButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFifthScreen", sender: nil)
    }
    
}
