//
//  TableViewController.swift
//  Ios-Assignment3-131
//
//  Created by Zhu Haochao on 23/5/19.
//
import UIKit
struct CellData {
    let image: UIImage?
    let message: String?
}
class TableViewController: UITableViewController {
    
    var data = [CellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        data = [CellData.init(image: UIImage(named: "bitcoin"), message: "Log Scale Monthly Bitcoin Price Chart Suggests Bear Market Was an Uptrend Pullback"
),
                CellData.init(image: UIImage(named: "bitcoin"), message: "NYMEX Trader: Bitcoin Soon to Move Back to $7,000, Markets to Consolidate"
),
                CellData.init(image: UIImage(named: "bitcoin"), message: "Crypto Industry Celebrates Annual Bitcoin Pizza Day"
)]
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "custom")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "custom") as! CustomCell
        cell.mainImage = data[indexPath.row].image
        cell.message = data[indexPath.row].message
        cell.layoutSubviews()
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}

