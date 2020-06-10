//
//  SelectLivestockTableController.swift
//  Team
//
//  Created by kpugame on 2020/06/11.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit

class SelectLivestockTableController: UITableViewController {

    
    let datas : [Int] = [417000, 422400, 429900]
    let chars : [String] = ["개", "고양이", "기타"]
    // 개, 고양이, 기타
    
    var currentData : Int?
    var currentChar : String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "LivestockCell", for: indexPath)
        cell.textLabel?.text = chars[indexPath.row]
        if currentChar == chars[indexPath.row]{
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentData = datas[indexPath.row]
        currentChar = chars[indexPath.row]
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveLivestock" {
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row{
                    currentData = datas[index]
                    currentChar = chars[index]
                }
            }
        }
    }
}
