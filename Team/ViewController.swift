//
//  ViewController.swift
//  HospitalMap
//
//  Created by KPUGAME on 2020/05/18.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit
// 아무일도 안함.
class ViewController: UIViewController {

 
    
    // Done 버튼을 누르면 동작하는 unwind 메소드
    // 아무 동작도 하지 않지만 이 메소드가 있어야지 TableViewCOntroller에서 unwind 연결이 가능
    @IBAction func doneToMainViewController(segue: UIStoryboardSegue){}
    
    
    var url : String = ""

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "segueTo"{              // identifier 안정함

            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

