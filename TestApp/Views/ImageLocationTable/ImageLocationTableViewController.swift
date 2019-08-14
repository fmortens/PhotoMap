//
//  ImageLocationTableViewController.swift
//  TestApp
//
//  Created by Frank Mortensen on 14/08/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import UIKit

class ImageLocationTableViewController: UITableViewController {
        
    
    
        var dummyDataList = ["one", "two", "three"]
        
        override func viewDidLoad() {
            view.backgroundColor = .clear
        }
        
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
        
        override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.backgroundColor = .clear
        }
        
    

    
    
}
