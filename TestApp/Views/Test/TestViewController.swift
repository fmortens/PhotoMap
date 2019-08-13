//
//  TestViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 13/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class TestViewController: UITableViewController {
    
    var dummyDataList = ["one", "two", "three"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dummyDataList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "testCell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "testCell")
            }
            
            return cell
        }()
    
        cell.textLabel?.text = dummyDataList[indexPath.row]
    
        return cell
    }
    
}
