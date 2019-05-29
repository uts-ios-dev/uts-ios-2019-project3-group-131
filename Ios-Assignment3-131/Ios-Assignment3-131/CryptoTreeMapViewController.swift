//
//  CryptoTreeMapViewController.swift
//  Ios-Assignment3-131
//
//  Created by Julius Sky on 29/5/19.
//
// disclaimer: full credit of TreeMap and Container class
// goes to Aaron Vinh for his implementation of a TreeMap, in turn based on another implementation.
// i have used his code to implement this feature for our app in a short amount of time.
// his code is a free open source library available on github.
// https://github.com/AaronVinh/TreeMap
//
// this class uses crytocurrency data to display a treemapview to users of marketcap and value.
// Julius Sky


import Foundation


import UIKit

class CryptoTreeMapViewController: UIViewController {
    
    // crypto data is market cap data from www.coinmarketcap.com
    let cryptoMarketCapData = [153226925350.0,
                               28623380706.0,
                               18663205894.0,
                               7898936734.0,
                               7311677589.0,
                               7137427929.0,
                               4763572121.0,
                               3276030485,
                               3134341006]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var treeMap = TreeMap()
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        
        
        // make coords of treemap from crypto data
        var coords = treeMap.treemapCoords(data: cryptoMarketCapData,width: Double(screenSize.width),height: Double(screenSize.height),xOffset: 0,yOffset: 0)
        
        
        drawTreeMap(coordinates: coords)
        print("SOLUTION \(coords)")
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func drawTreeMap(coordinates: [[Double]]){
        
        let cryptoCodes = ["BTC", "ETH", "XRP", "BCC","EOS","LTC","BNC","BSV","USDT"]

        
        var index = 0
        var bgColor: CGColor

        for coords in coordinates{
            
            let x1 = coords[0]
            let y1 = coords[1]
            let x2 = coords[2]
            let y2 = coords[3]
            
            let width = x2 - x1
            let height = y2 - y1
            
            let myView = UIView(frame: CGRect(x: x1, y: y1, width: width, height: height))
            myView.layer.borderWidth = 1
            
            
//            let uiColors = cryptoData["colors"] as? [String: AnyObject]
//                (cryptoData.value(forKey: "color")! as AnyObject).valueForKey("BTC")
//            myView.layer.borderColor = UIColor.black.cgColor
//            myView.layer.borderColor = uiColors?["BTC"]?.cgColor
//            myView.layer.borderColor = getCryptoUIColor(cryptoCode: cryptoCodes[index]) as! CGColor
            bgColor = getCryptoUIColor(cryptoCode: cryptoCodes[index]).cgColor
            myView.layer.borderColor = bgColor
            myView.layer.backgroundColor = bgColor
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            //label.center = CGPointMake(160, 284)
            label.textAlignment = NSTextAlignment.center
            label.text =  cryptoCodes[index]
            label.adjustsFontSizeToFitWidth = true
            myView.addSubview(label)
            
            let datalabel = UILabel(frame: CGRect(x: 0, y: 50, width: 50, height: 50))
            datalabel.textAlignment = NSTextAlignment.center
            datalabel.text =  String(format: "%.2f", cryptoMarketCapData[index]/pow(10, 9))
            datalabel.adjustsFontSizeToFitWidth = true
            myView.addSubview(datalabel)

            index+=1
            
            
            self.view.addSubview(myView)
        }
    }
    
    func getCryptoUIColor(cryptoCode: String)-> UIColor{
        switch cryptoCode {
                    case "BTC","BCC":
                        return UIColor.orange
                    case "BSV":
                        return UIColor.yellow
                    case "ETH":
                        return UIColor.purple
                    case "LTC":
                        return UIColor.gray
                    case "XRP":
                        return UIColor.blue
                    case "EOS":
                        return UIColor.magenta
                    case "USDT":
                        return UIColor.green
                    default:
                        return UIColor.white
                    }

    }
    
}
