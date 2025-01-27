//
//  SelectRegionViewController.swift
//  Team
//
//  Created by KPUGAME on 2020/06/04.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit

class SelectRegionViewController: ParserViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var regionPickerView: UIPickerView!
    
    // pickerView 테이터 배열
    var pickerDataSource : [String] = []
    var pickerOrgCdSource : [String] = []
    var apiController : GetAPI = GetAPI()
    
    // 디폴트 시구코드 서울특별시
    var orgCd : String = "6110000"
    var currentRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regionPickerView.delegate = self;
        self.regionPickerView.dataSource = self;
        
        beginParsing(wantURL: apiController.getURL(wantURLs: "시도"), strings: "orgCd", "orgdownNm")       // 시도코드,   시도명
        
        if let cluster = valueCluster["orgdownNm"]{
            for value in cluster{
                pickerDataSource.append(value)
            }
        }
        if let cluster = valueCluster["orgCd"]{
            for value in cluster{
                pickerOrgCdSource.append(value)
            }
        }
    }
    
    // 피커뷰의 컴포넌트 개수
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       // 피커뷰의 각 컴포넌트에 대한 row의 개수 = pickerDataSource 배열 원소 개수
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
           return pickerDataSource.count
       }

       // pickerView의 주어진 컴포넌트 row에 대한 데이터 = pickerDataSource 배열의 원소
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
           return pickerDataSource[row]
       }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        currentRow = row
        orgCd = pickerOrgCdSource[row]
    }
    
    // 각 지역 동물들을 찾기 위해 url을 준비해주는 작업
    // ShowRegionKindTableViewController에 url 정보를 전달하기 위해
    // UINav를 destination으로 설정 후 ShowRegionKindTableViewController를 선택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "CountyTableViewController"{
            if let targetView = segue.destination as? SelectCountyTableViewController{
                targetView.navTitle.title = pickerDataSource[currentRow]
                targetView.upperCd = pickerOrgCdSource[currentRow]
            }
        }
    }
     

}
