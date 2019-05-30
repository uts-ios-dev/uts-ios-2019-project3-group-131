//
//  TableViewController.swift
//  Ios-Assignment3-131
//
//  Created by Zhu Haochao on 23/5/19.
//
import UIKit
class NewsViewController: UITableViewController, XMLParserDelegate {
    var myFeed : NSArray = []
    var feedImgs: [AnyObject] = []
    var url: URL!
    
    @IBAction func refreshButton(_ sender: Any) {
        loadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140
        tableView.backgroundColor = UIColor.black
//        tableView.backgroundColor = UIColorFromRGB(rgbValue: 0xdf4926)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        loadData()
    }
    
    func loadData() {
        url = URL(string: "https://cointelegraph.com/feed")!
        loadRss(url);
    }
    
    func loadRss(_ data: URL) {
        
        // initialize XML parser
        let myParser : XMLHandler = XMLHandler().initParser(data) as! XMLHandler
        
        // Fetch data from XML parser
        feedImgs = myParser.img as [AnyObject]
        myFeed = myParser.newsFeeds
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "redirect" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let selectedFURL: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "link") as! String
            // pass url to destination view controller
            let dest: NewsDetailViewController = segue.destination as! NewsDetailViewController
            dest.selectedFeedURL = selectedFURL as String
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(white: 1, alpha: 0)
        } else {
            cell.backgroundColor = UIColor(white: 1, alpha: 0)
        }
        
        // Load feed image.
        let url = NSURL(string:feedImgs[indexPath.row] as! String)
        let data = NSData(contentsOf:url! as URL)
        var image = UIImage(data:data! as Data)
        
        image = resizeImage(image: image!, toTheSize: CGSize(width: 70, height: 70))
        
        let cellImageLayer: CALayer?  = cell.imageView?.layer
        
        cellImageLayer!.cornerRadius = 35
        cellImageLayer!.masksToBounds = true
        
        cell.imageView?.image = image
        cell.textLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.detailTextLabel?.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "pubDate") as? String
        cell.detailTextLabel?.textColor = UIColor.white
        
        return cell
    }
        
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
}
