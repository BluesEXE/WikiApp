//
//  SecondViewController.swift
//  WikiApp
//
//  Created by Danny Ho on 2015-06-03.
//  Copyright (c) 2015 Danny Ho. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var favouritesTable: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    var favPages = [WikiPage]()
    var cellIdentifier = "TableCell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWikiPages()
        
        loadFavourites()
        
        configureTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshButton(sender: AnyObject) {
        
        loadFavourites()
        self.reloadTableViewContent()
    }
    
    func loadFavourites() {
        var newArray = [WikiPage]()
        if let array = loadWikiPages() {
            for page in array {
                newArray.append(page)
            }
            favPages = newArray
            
        }
    }
    
    func loadWikiPages() -> [WikiPage]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(WikiPage.ArchiveURL.path!) as? [WikiPage]
    }
    
    func configureTableView() {
        favouritesTable.rowHeight = UITableViewAutomaticDimension
        favouritesTable.estimatedRowHeight = 160.0
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        deselectAllRows()
    }
    
    func deselectAllRows() {
        if let selectedRows = favouritesTable.indexPathsForSelectedRows() as? [NSIndexPath] {
            for indexPath in selectedRows {
                favouritesTable.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }

    func reloadTableViewContent() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.favouritesTable.reloadData()
            self.favouritesTable.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellAtIndexPath(indexPath)
    }
    
    func setTitleForCell(cell:TableCell, indexPath:NSIndexPath) {
        let item = favPages[indexPath.row] as WikiPage
        cell.cellTitle.text = item.name ?? "[No Title]"
    }
    
    func cellAtIndexPath(indexPath:NSIndexPath) -> TableCell {
        let cell = self.favouritesTable.dequeueReusableCellWithIdentifier(cellIdentifier) as! TableCell
        setTitleForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favPages.count
    }
    
    func isLandscapeOrientation() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = favouritesTable.indexPathForSelectedRow()
        let item = favPages[indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.item = item
    }

}

