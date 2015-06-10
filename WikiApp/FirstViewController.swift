//
//  FirstViewController.swift
//  WikiApp
//
//  Created by Danny Ho on 2015-06-03.
//  Copyright (c) 2015 Danny Ho. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let WIKIURL = "http://en.wikipedia.org/w/api.php"
    
    var searchArray = [WikiPage]()
    var cellIdentifier = "TableCell"
    
    var url: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        //refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        deselectAllRows()
    }
    
    func refreshData() {
        searchField.resignFirstResponder()
        parseForQuery(searchField.text)
    }
    
    func deselectAllRows() {
        if let selectedRows = tableView.indexPathsForSelectedRows() as? [NSIndexPath] {
            for indexPath in selectedRows {
                tableView.deselectRowAtIndexPath(indexPath, animated: false)
            }
        }
    }
    
    func parseForQuery(query: String?) {
        searchArray = [WikiPage]()
        
        url = WIKIURL + "?action=opensearch&format=json&search=" + query! + "&limit=10&namespace=0&format=json"
        
        DataManager.loadDataFromURL(NSURL(string: url)!, completion:{(wikiData, error) -> Void in
            let json = JSON(data: wikiData!)

            if let wikiDict = json.array {
                //println(wikiDict.count)
                let wikiTitles = wikiDict[1].array
                let wikiDescs = wikiDict[2].array
                let wikiURLs = wikiDict[3].array
                
                for var index = 0; index < wikiTitles!.count; ++index {
                    var wikiTitle: String? = wikiTitles![index].string
                    var wikiBody: String? = wikiDescs![index].string
                    var wikiURL: String? = wikiURLs![index].string
                    
                    var page = WikiPage(name: wikiTitle, body: wikiBody, url: wikiURL)
                    
                    self.searchArray.append(page)
                }
                
                self.reloadTableViewContent()
            }
            
        })
    }
    
    func reloadTableViewContent() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
            self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        refreshData()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return cellAtIndexPath(indexPath)
    }
    
    func setTitleForCell(cell:TableCell, indexPath:NSIndexPath) {
        let item = searchArray[indexPath.row] as WikiPage
        cell.cellTitle.text = item.name ?? "[No Title]"
    }
    
    func cellAtIndexPath(indexPath:NSIndexPath) -> TableCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! TableCell
        setTitleForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func isLandscapeOrientation() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        refreshData()
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForSelectedRow()
        let item = searchArray[indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.item = item
    }
}

