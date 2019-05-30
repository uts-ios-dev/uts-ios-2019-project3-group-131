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
//protocol AdditiveArithmetic

import UIKit

class CryptoTreeMapViewController: UIViewController {
    
    // crypto data is market cap data from www.coinmarketcap.com
    var cryptoMarketCapData = [153226925350.0,
                               28623380706.0,
                               18663205894.0,
                               7898936734.0,
                               7311677589.0,
                               7137427929.0,
                               4763572121.0,
                               3276030485,
                               3134341006]
    
    var totalMarketVolume: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Market Cap";

        
        totalMarketVolume = sum(array: cryptoMarketCapData)
        
        
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
            
            print("index",index)
//            let uiColors = cryptoData["colors"] as? [String: AnyObject]
//                (cryptoData.value(forKey: "color")! as AnyObject).valueForKey("BTC")
//            myView.layer.borderColor = UIColor.black.cgColor
//            myView.layer.borderColor = uiColors?["BTC"]?.cgColor
//            myView.layer.borderColor = getCryptoUIColor(cryptoCode: cryptoCodes[index]) as! CGColor
            bgColor = getCryptoUIColor(cryptoCode: cryptoCodes[index]).cgColor
            myView.layer.borderColor = bgColor
            myView.layer.backgroundColor = bgColor
            
            var label = UILabel(frame: CGRect(x: 0, y: myView.frame.height*0.10, width: myView.frame.width*0.50, height: myView.frame.width*0.30))
            //label.center = CGPointMake(160, 284)
            label.textAlignment = NSTextAlignment.center
            label.text =  cryptoCodes[index]
            label.adjustsFontSizeToFitWidth = true
            myView.addSubview(label)
            
            var datalabel = UILabel(frame: CGRect(x: 0, y: myView.frame.height*0.30, width:  myView.frame.width*0.50, height: 50))
            datalabel.textAlignment = NSTextAlignment.center
            datalabel.text =  String(format: "%.2f", cryptoMarketCapData[index]/pow(10, 9))+"B"
            datalabel.adjustsFontSizeToFitWidth = true
            myView.addSubview(datalabel)
            
            
            var percentLabelXPos: CGFloat = 0
            var percentLabelYPos: CGFloat = 0
            
            if(myView.frame.height>myView.frame.width){
                percentLabelXPos = 0.00
                percentLabelYPos = myView.frame.height*0.5

            }
            else{
                percentLabelYPos = myView.frame.height*0.30
                percentLabelXPos = myView.frame.height*0.7
            }
            
            var percentlabel = UILabel(frame: CGRect(x: percentLabelXPos, y: percentLabelYPos, width: myView.frame.width*0.50, height: 50))
            percentlabel.textAlignment = NSTextAlignment.center
            percentlabel.text =  String(format: "%.2f", (cryptoMarketCapData[index]/pow(10, 9)) / (totalMarketVolume / pow(10, 9)) * 100)+"%"
            percentlabel.adjustsFontSizeToFitWidth = true
            myView.addSubview(percentlabel)

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
    
    func sum(array: Array<Double>)-> Double{
        
        var runningTotal: Double = 0
        
        for double in array{
            runningTotal += double
        }
        return runningTotal
        
    }
    
    
}

//extension Sequence where Element: AdditiveArithmetic {
//    func sum() -> Element {
//        return reduce(0, +)
//    }
//}
