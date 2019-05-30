//
//  XMLHandler.swift
//  Ios-Assignment3-131
//
//  Created by Zhu Haochao on 28/5/19.
//

import Foundation

class XMLHandler: NSObject, XMLParserDelegate {
    var parser = XMLParser()
    var newsFeeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var feedTitle = NSMutableString()
    var link = NSMutableString()
    var img:  [AnyObject] = []
    var feedDescription = NSMutableString()
    var feedDate = NSMutableString()
    
    func initParser(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL) {
        newsFeeds = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allFeeds() -> NSMutableArray {
        return newsFeeds
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (element as NSString).isEqual(to: "item") {
            elements =  NSMutableDictionary()
            elements = [:]
            feedTitle = NSMutableString()
            feedTitle = ""
            link = NSMutableString()
            link = ""
            feedDescription = NSMutableString()
            feedDescription = ""
            feedDate = NSMutableString()
            feedDate = ""
        } else if (element as NSString).isEqual(to: "enclosure") {
            if let urlString = attributeDict["url"] {
                img.append(urlString as AnyObject)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName as NSString).isEqual(to: "item") {
            if feedTitle != "" {
                elements.setObject(feedTitle, forKey: "title" as NSCopying)
            }
            if link != "" {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            if feedDescription != "" {
                elements.setObject(feedDescription, forKey: "description" as NSCopying)
            }
            if feedDate != "" {
                elements.setObject(feedDate, forKey: "pubDate" as NSCopying)
            }
            newsFeeds.add(elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "link") {
            link.append(string)
        } else if element.isEqual(to: "title") {
            feedTitle.append(string)
        } else if element.isEqual(to: "description") {
            feedDescription.append(string)
        } else if element.isEqual(to: "pubDate") {
            feedDate.append(string)
        }
    }
}
