//
//  ViewController.swift
//  Ios-Assignment3-131
//
//  Created by Zhu Haochao on 20/5/19.
//

import UIKit

    class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
        
        var coinNames = ["BTC", "ETH", "LTC"]
        var coinPrice = ["$ 8000", "$ 200", "$ 98"]
        var coinCell = ["CellBtc","CellEtc","CellLtc"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // 1
            return  coinNames.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
            UITableViewCell {
                // 2
                let cellIdentifier = "Cell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                         for: indexPath)
                // 3
                cell.textLabel?.text = coinNames[indexPath.row]
                cell.detailTextLabel?.text = coinPrice[indexPath.row]
                return cell
        }
}

