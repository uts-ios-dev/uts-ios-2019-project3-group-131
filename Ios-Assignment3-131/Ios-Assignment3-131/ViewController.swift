//
//  ViewController.swift
//  Ios-Assignment3-131
//
//  Created by Zhu Haochao on 20/5/19.
//

import UIKit

    class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
        
        var coinNames = ["Bitcoin", "Ethereum", "XRP","EOS","Litecoin","Binance Coin","Tether","Stellar","Cardano"]
        var coinPrice = ["$8622.54", "$269.52", "$0.438930","$7.98","$114.61","$33.52","$1","$0.135434","$0.089844"]
        lazy var coinIds: [String] = ["1", "1027", "52"]
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

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard indexPath.row < coinIds.count else {
                return
            }

            tableView.deselectRow(at: indexPath, animated: true)
            let chartVc = UIStoryboard.instantiate("Main", with: ChartsViewController.self)
            let coinID = coinIds[indexPath.row]
            chartVc.coinId = coinID
            chartVc.coinName = coinNames[indexPath.row]
            navigationController?.pushViewController(chartVc, animated: true)
        }
        
}

