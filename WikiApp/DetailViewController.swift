//
//  DetailViewController.swift
//  WikiApp
//
//  Created by Danny Ho on 2015-06-08.
//  Copyright (c) 2015 Danny Ho. All rights reserved.
//

import Foundation
import UIKit

let FavouritesKey = "Favourites"

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailBody: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var item: WikiPage = WikiPage(name:"", body: "", url: "")
    var favPages = [WikiPage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitleLabelText()
        setBodyText()
        
        loadWikiPages()
        
        if let array = loadWikiPages() {
            for page in array {
                if page.name == item.name {
                    favButton.selected = true
                }
                favPages.append(page)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func saveWikiPages() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favPages, toFile: WikiPage.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save page")
        }
    }
    
    func loadWikiPages() -> [WikiPage]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(WikiPage.ArchiveURL.path!) as? [WikiPage]
    }
    
    @IBAction func linkButton(sender: AnyObject) {
        if let link = NSURL(string: item.url) {
            UIApplication.sharedApplication().openURL(link)
        }
    }
    
    @IBAction func favButtonHighlighted(sender: AnyObject) {
        favButton.highlighted = true
    }
    
    @IBAction func favButtonSelected(sender: AnyObject) {
        if favButton.selected == true {
            favButton.selected = false

            for var index = 0; index < favPages.count; ++index {
                if favPages[index].name == item.name {
                    favPages.removeAtIndex(index)
                }
            }
            
        } else {
            favButton.selected = true
            favPages.append(item)
        }
        
        saveWikiPages()
    }
    
    @IBAction func backButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func setTitleLabelText() {
        
        var title = item.name
        
        if item.name == "" {
            title = NSLocalizedString("[No Title]", comment: "")
        } else {
            detailTitle.text = title
        }
    }
    
    func setBodyText() {
        
        var body = item.body
        
        if body == "" {
            detailBody.text = "No description available"
        } else {
            detailBody.text = body
        }
        
        
    }
    
}
