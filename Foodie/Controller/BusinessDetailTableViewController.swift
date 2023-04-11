//
//  BusinessDetailTableViewController.swift
//  Foodie
//
//  Created by Luis Calvillo on 4/9/23.
//

import UIKit

class BusinessDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var name = ""
    var address = ""
    var distance = 0.0
    var latitude = 0.0
    var longitude = 0.0
    var imageUrl = ""
    var isClosed = false
    
    var currentLocation = [0.0, 0.0]
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        print("BusinessDetailTableViewController")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

 

}
