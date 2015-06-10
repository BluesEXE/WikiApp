//
//  WikiPage.swift
//  WikiApp
//
//  Created by Danny Ho on 2015-06-04.
//  Copyright (c) 2015 Danny Ho. All rights reserved.
//

import Foundation

class WikiPage: NSObject, NSCoding, Printable{
    let name: String
    let body: String
    let url: String
    
    override var description: String {
        return "Name: \(name), Description: \(body)\n, URL: \(url)"
    }
    
    init(name: String?, body: String?, url: String?) {
        self.name = name ?? ""
        self.body = body ?? ""
        self.url = url ?? ""
    }
    
    required init(coder decoder: NSCoder) {
        //Error here "missing argument for parameter name in call
        self.name = decoder.decodeObjectForKey("name") as! String
        self.body = decoder.decodeObjectForKey("body")as! String
        self.url = decoder.decodeObjectForKey("url") as! String
        super.init()
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.name, forKey: "name")
        coder.encodeObject(self.body, forKey: "body")
        coder.encodeObject(self.url, forKey: "url")
    }
    
    static let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("wikiPages")
    
    
}