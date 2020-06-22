//
//  ShowRegionKindTableViewController.swift
//  Team
//
//  Created by KPUGAME on 2020/06/09.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit

class showKindTableViewController: ParserTableViewController {
    
    @IBOutlet weak var livestockCell: UITableViewCell!
    @IBOutlet weak var breedKindCell: UITableViewCell!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var currentLivestockCode : String = ""
    var currentLivestock : String = ""
    var currentBreedKindCode : String = ""
    var currentBreedKind : String = ""
    
    // SelectCountyTableViewController로 부터 segue를 통해 전해받은 정보
    @IBAction func showRegionKind(segue: UIStoryboardSegue){
        if let livestockView = segue.source as? SelectLivestockTableController{
            livestockCell.textLabel?.text = livestockView.currentChar
            currentLivestock = livestockView.currentChar!
            if livestockView.currentChar != "축종"{
                breedKindCell.isUserInteractionEnabled = true
                breedKindCell.textLabel?.text = "품종"
                currentLivestockCode = String(livestockView.currentData!)
            }
        }
        if let breedKindView = segue.source as? SelectBreedKindTableController{
            breedKindCell.textLabel?.text = breedKindView.currentBreedKind
            currentBreedKind = breedKindView.currentBreedKind
            searchButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if livestockCell.textLabel?.text == "축종"{
            breedKindCell.isUserInteractionEnabled = false
            breedKindCell.textLabel?.text = "축종을 선택해주세요."
            searchButton.isEnabled = false
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "pickLivestock"{             // LiveStock
            if let livestock = segue.destination as? SelectLivestockTableController{
                livestock.currentChar = livestockCell.textLabel?.text
            }
        }
        if segue.identifier == "pickBreedKind"{
            if let breedKind = segue.destination as? SelectBreedKindTableController{
                breedKind.currentLivestock = currentLivestock
                breedKind.currentLivestockCode = currentLivestockCode
                breedKind.currentBreedKind = currentBreedKind
            }
        }
        if segue.identifier == "searchPetWithShowKind"{
            if let searchPet = segue.destination as? searchPetWithShowKindTableViewController{
                searchPet.breedKindCode = currentBreedKindCode
                searchPet.livestockCode = currentLivestockCode
            }
        }
            
    }
  
}
