//
//  FindWholeAnimalTableViewController.swift
//  Team
//
//  Created by KPUGAME on 2020/06/04.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit

class FindWholeAnimalTableViewController: ParserViewController, UITableViewDataSource, UIPickerViewDelegate {
    
    var dataSource : [String] = []
    var apiController : GetAPI = GetAPI()
    
    // feed 데이터를 저장하는 mutable array
    var posts = NSMutableArray()
    // feed 데이터를 저장하는 mutable dictionary
    var elements = NSMutableDictionary()
    var element = NSString()
    // 저장 문자열 변수
    var date = NSMutableString()
    var age = NSMutableString()

    // 유기동물 사진
    var imageurl = NSMutableString()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "happenDt") as! NSString as String
        
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "age") as! NSString as String
        
        if let url = URL(string: (posts.object(at: indexPath.row) as AnyObject).value(forKey: "imageurl") as! NSString as String){
            if let data = try? Data(contentsOf: url){
                cell.imageView?.image = UIImage(data: data)
            }
        }
        return cell
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()

        beginParsing(wantURL: apiController.getFindWhole(wantURL: "유기동물 조회"), strings: "happenDt", "age")          // 품종, 나이  응답메세지
        // cluster에 가져올 코드들 쌓임
        if let cluster = valueCluster["age"]{
            for value in cluster{
                dataSource.append(value)
            }
        }
    }

    // MARK: - Table view data source

    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        element = elementName as NSString
        if(elementName as NSString).isEqual(to: "item"){
            elements = NSMutableDictionary()
            elements = [:]
            date = NSMutableString()
            date = ""
            age = NSMutableString()
            age = ""
            
            // 동물 사진
            imageurl = NSMutableString()
            imageurl = ""
        }
    }
    
    // 발견 날짜와 나이를 발견하면 date, age에 저장
    override func parser(_ parser: XMLParser, foundCharacters string: String){
        // 발견 날짜
        if element.isEqual(to: "happenDt"){
            date.append(string)
        }
        // 나이
        else if element.isEqual(to: "age"){
            age.append(string)
        }
        else if element.isEqual(to: "popfile"){
            imageurl.append(string)
        }

    }
    
    // element의 끝에서 feed 데이터를 dictionary에 저장
    override func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        if(elementName as NSString).isEqual(to: "item"){
            if !date.isEqual(nil){
                elements.setObject(date, forKey: "happenDt" as NSCopying)
            }
            if !age.isEqual(nil){
                elements.setObject(age, forKey: "age" as NSCopying)
            }
            if !imageurl.isEqual(nil){
                elements.setObject(imageurl, forKey: "imageurl" as NSCopying)
            }
            posts.add(elements)
        }
    }

   

}
