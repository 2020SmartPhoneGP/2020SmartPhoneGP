//
//  ParserTableViewController.swift
//  Team
//
//  Created by kpugame on 2020/06/10.
//  Copyright © 2020 KPUGAME. All rights reserved.
//

import UIKit

class ParserTableViewController: UITableViewController, XMLParserDelegate {

    var parser = XMLParser()
    var texts : [String] = []
    var valueCluster : [String : [String]] = [:]
    var currentElement : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func beginParsing(wantURL : String, strings : String...){
        texts.removeAll()
        for text in strings{
            texts.append(text)
            valueCluster[text] = []
        }       // 찾을 원소들
        parser = XMLParser(contentsOf: (URL(string : wantURL))!)!
        parser.delegate = self
        parser.parse()
        
    }
    
    //override
    func parser (_ parser: XMLParser, didStartElement elementName: String, namespaceURI : String?, qualifiedName qName : String?, attributes attributeDict: [String : String]){
        currentElement = elementName
    }
    func parser(_ parser: XMLParser, foundCharacters string: String){
        for text in texts{
            if text == currentElement {
                valueCluster[text]?.append(string)
            }
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName : String, namespaceURI: String?, qualifiedName qName : String?){
        
    }

}
