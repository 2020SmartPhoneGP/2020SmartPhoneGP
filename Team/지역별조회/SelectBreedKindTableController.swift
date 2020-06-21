//
//  SelectBreedKindTableController.swift
//  Team
//
//  Created by kpugame on 2020/06/11.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit

class SelectBreedKindTableController: ParserTableViewController {

    @IBOutlet var tbData: UITableView!
    var currentLivestock : String = "축종"
    var currentLivestockCode : String = ""
    var apiController : GetAPI = GetAPI()
    
    var currentBreedKind : String = ""
    var currentBreedKindCode : String = ""
    
    var KNm : [String] = []
    var bKCd : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentLivestock != "축종"{
            beginParsing(wantURL: apiController.getBreedKind(wantURL: "품종", upKindCd: currentLivestockCode), strings: "KNm", "kindCd")
        }
        
        if let cluster = valueCluster["KNm"]{
            KNm = cluster
        }
        if let cluster = valueCluster["kindCd"]{
            bKCd = cluster
        }
        tbData.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return KNm.count
    }
    
    override func tableView(_ tableView : UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "breedKindCell", for: indexPath)
        cell.textLabel?.text = KNm[indexPath.row]
        if currentBreedKind == KNm[indexPath.row]{
             cell.accessoryType = .checkmark
         }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentBreedKind = KNm[indexPath.row]
        currentBreedKindCode = bKCd[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveBreedKind" {
            if let cell = sender as? UITableViewCell{
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row{
                    currentBreedKind = KNm[index]
                    currentBreedKindCode = bKCd[index]
                }
                
            }
            if let showRegionKindTableViewController = segue.destination as? ShowRegionKindTableViewController{
                showRegionKindTableViewController.currentBreedKindCode = currentBreedKindCode
            }
        }
    }
}
