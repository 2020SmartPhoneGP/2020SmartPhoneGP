//
//  ShowRegionKindTableViewController.swift
//  Team
//
//  Created by KPUGAME on 2020/06/09.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit

class ShowRegionKindTableViewController: UITableViewController {

    @IBOutlet var tbData: UITableView!
    
    // SelectRegionViewController로 부터 segue를 통해 전해받은 OpenAPI url 주소
    var url : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

  
}
