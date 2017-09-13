//
//  ChooseCityViewController.swift
//  乐驾
//
//  Created by 王嘉宁 on 16/5/19.
//  Copyright © 2016年 Jianing. All rights reserved.
//

import UIKit

protocol ChooseCityProtocol {
    func didChooseCity(cityId:Int, cityName: String)
}

class ChooseCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    // MARK: - Properties
    var tableView: UITableView!
    
    var delegate: ChooseCityProtocol?
    
    var cityData: [ProvinceCityInfo] = []
    
    var _sections: [Section]?
    var sections: [Section] = []
    
    let collation = UILocalizedIndexedCollation.current() as UILocalizedIndexedCollation
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        sections = sectionsReloadData()
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Init
    
    func sectionsReloadData() -> [Section] {
        // create empty sections
        var sections1 = [Section]()
        for _ in 0..<self.collation.sectionIndexTitles.count {
            sections1.append(Section())
        }
        
        // put each user in a section
        for item in cityData {
            item.section = self.collation.section(for: item, collationStringSelector: Selector("provinceCity"))
            sections1[item.section!].addItem(item: item)
        }
        
        // sort each section
        for section in sections1 {
            section.items = self.collation.sortedArray(from: section.items, collationStringSelector: Selector("provinceCity")) as! [ProvinceCityInfo]
        }
        
        self._sections = sections1
        
        return self._sections!
    }
    
    //table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.sections[section].items.count)
        return self.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.sections[indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath as IndexPath)
        
        let provinceLabel = cell.viewWithTag(100) as! UILabel
        let cityLabel = cell.viewWithTag(101) as! UILabel
        let cityIdLabel = cell.viewWithTag(102) as! UILabel
        provinceLabel.text = item.province
        cityLabel.text = item.city
        cityIdLabel.text = item.id
        
        return cell
    }
    
    /* section headers
     appear above each `UITableView` section */
    //
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int)
        -> String? {
            // do not display empty `Section`s
            if !self.sections[section].items.isEmpty {
                return self.collation.sectionTitles[section] as String
            }
            return ""
    }
    
    /* section index titles
     displayed to the right of the `UITableView` */
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return self.collation.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return self.collation.section(forSectionIndexTitle: index)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        let cellCityIdLabel = cell?.viewWithTag(102) as! UILabel
        let cellCityLabel = cell?.viewWithTag(101) as! UILabel
        delegate?.didChooseCity(cityId: Int(cellCityIdLabel.text!)!, cityName: cellCityLabel.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
