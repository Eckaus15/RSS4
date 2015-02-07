//
//  TableTableViewController.swift
//  RSS
//
//  Created by Austin Eckman on 11/27/14.
//  Copyright (c) 2014 Austin Eckman. All rights reserved.
//
//      Notes:
//
//       NEED  1 Actuallly delete unwanted feeds
//       NEED  2 Add if read or not
//       NEED  3 Add Fav option
//       NEED  4 Add All feeds option 
//
//         5 Add number of how many unread articles are there
//         6 Add pictures next to article
//


import UIKit
import CoreData

class TableTableViewController: UITableViewController, NSXMLParserDelegate, SideBarDelegate {
    
    var parser = NSXMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var fdescription = NSMutableString()
    var sidebar = SideBar()
    var savedFeeds = [Feed]()
    var feedNames = [String]()
    var currentFeedTitle = String()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request(nil)
        loadSavedFeeds()
        

    }
    
    func request(urlString:String?){
        
        if urlString == nil{
            
            let url = NSURL(string: "http://feeds.nytimes.com/nyt/rss/Technology")
            self.title = "New York Times Technology"
            feeds = []
            parser = NSXMLParser(contentsOfURL: url)!
            parser.delegate = self
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = true
            parser.shouldResolveExternalEntities = true
            parser.parse()
        }else{
            
            let url = NSURL(string: urlString!)
            //Testing purposes
            self.title = currentFeedTitle
            println(urlString!)
            feeds = []
            parser = NSXMLParser(contentsOfURL: url)!
            parser.delegate = self
            parser.shouldProcessNamespaces = true
            parser.shouldReportNamespacePrefixes = true
            parser.shouldResolveExternalEntities = true
            parser.parse()
        }
        
        
    }


    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        element = elementName
        
        // feed properties
        if (element as NSString).isEqualToString("item"){
            //elements = NSMutableArray.alloc()
            elements = NSMutableDictionary.alloc()
            elements = [:]
            ftitle = NSMutableString.alloc()
            ftitle = ""
            link = NSMutableString.alloc()
            link = ""
            fdescription = NSMutableString.alloc()
            fdescription = ""


        }
        
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if (elementName as NSString).isEqualToString("item") {
            if ftitle != ""{
                elements.setObject(ftitle, forKey: "title")
            
        }
            if link != ""{
                elements.setObject(link, forKey: "link")
            
        }
            if fdescription != ""{
                elements.setObject(fdescription, forKey: "description")
            
        }
           
        feeds.addObject(elements)

    }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        
        if element.isEqualToString("title"){
            ftitle.appendString(string)
        } else if element.isEqualToString("link"){
            link.appendString(string)
        } else if element.isEqualToString("description"){
            fdescription.appendString(string)
        }
    
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSavedFeeds (){
        savedFeeds = [Feed]()
        feedNames = [String]()
        
        feedNames.append("Add Feed")
        
        
        let moc = SwiftCoreDataHelper.managedObjectContext()
        let results = SwiftCoreDataHelper.fetchEntities(NSStringFromClass(Feed), withPredicate: nil, managedObjectContext: moc)
        if results.count > 0 {
            for feed in results{
                let f = feed as Feed
                savedFeeds.append(f)
                feedNames.append(f.name)
                
            }
        }
        
        sidebar = SideBar(sourceView: self.navigationController!.view, menuItems: feedNames)
        sidebar.delegate = self
        
    }
    
    func sideBarDidSelectButtonAtIndex(index: Int) {
        if index == 0{ //Add feed button
            let alert = UIAlertController(title: "Create A New Feed", message: "Enter the name and URL of the feed", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler({ (textField:UITextField!) -> Void in
                textField.placeholder = "Feed Name"
            })
            alert.addTextFieldWithConfigurationHandler({ (textField:UITextField!) -> Void in
                textField.placeholder = "Feed URL"
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { (alertAction:UIAlertAction!) -> Void in
                let textFields = alert.textFields
                let feedNameTextField = textFields?.first as UITextField
                let feedURLTextField = textFields?.last as UITextField
                
                if feedNameTextField.text != "" && feedURLTextField.text != "" {
                    let moc = SwiftCoreDataHelper.managedObjectContext()
                    
                    let feed = SwiftCoreDataHelper.insertManagedObject(NSStringFromClass(Feed), managedObjectConect: moc) as Feed
                    feed.name = feedNameTextField.text
                    feed.url = feedURLTextField.text
                    
                    SwiftCoreDataHelper.saveManagedObjectContext(moc)
                    self.loadSavedFeeds()
                    
                    
                }
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            
            
        }else{
            //call new MOC
            let moc = SwiftCoreDataHelper.managedObjectContext()
            var selectedFeed = moc.existingObjectWithID(savedFeeds[index - 1].objectID, error: nil) as Feed
            //Set title
            currentFeedTitle = selectedFeed.name

            
            //set new url
            request(selectedFeed.url)
        }
        

        
    }
    
   
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return feeds.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
  
    cell.textLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("title") as? String
    cell.detailTextLabel?.numberOfLines = 3
    cell.detailTextLabel?.text = feeds.objectAtIndex(indexPath.row).objectForKey("description") as? String
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    cell.selectionStyle = UITableViewCellSelectionStyle.Blue
        
        /*checked or unchecked 2
    var rowData: NSMutableDictionary = feeds.objectAtIndex(indexPath.row) as NSMutableDictionary
    var readstate = Bool()
    readstate = rowData.setObject(indexPath.row, forKey: "readstate") as? Bool
        if (readstate){
            cell.accessoryType = UITableViewCellAccessoryType.None

        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None

        }
        
        checked or unchecked
        var rowData: NSMutableDictionary = feeds[indexPath.row] as NSMutableDictionary
        var readstate = String()
        readstate = rowData["readstate"] as String
       
        if (readstate == "true"){
            cell.accessoryType = UITableViewCellAccessoryType.None
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }*/
       
        
        return cell
    }
     override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var accessoryType: UITableViewCellAccessoryType;()
        //test
        var rowData: NSMutableDictionary = feeds.objectAtIndex(indexPath.row) as NSMutableDictionary
        var readstate = true


        ///Gets url from feed
        
        let selectedFURL: String = feeds[indexPath.row].objectForKey("link") as String
        println(selectedFURL) //For testing
        var con = KINWebBrowserViewController()
        //Cleans URL
        var dirty = selectedFURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var clean = dirty!.stringByReplacingOccurrencesOfString(
            "%0A",
            withString: "",
            options: .RegularExpressionSearch)
        //Creates usuable url
        var URL = NSURL(string: clean)
        //var url = nsurl(string: item.link)
        con.loadURL(URL!)
        self.navigationController?.pushViewController(con, animated: true)
    }
    


}
