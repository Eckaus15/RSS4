//
//  SideBarTableViewController.swift
//  BlurSlider
//
//  Created by Austin Eckman on 1/21/15.
//  Copyright (c) 2015 Austin Eckman. All rights reserved.
//

import UIKit
import CoreData


protocol SideBarTableViewControllerDelegate{
    func sideBarControlDidSelectRow(indexPath:NSIndexPath)
}

class SideBarTableViewController: UITableViewController {
    
    var delegate:SideBarTableViewControllerDelegate?
    var tableData:Array<String> = []
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableData.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            // Configure the cell...
            
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.textColor = UIColor.darkTextColor()
            
           // let selectedView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            let selectedView:UIView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            
            selectedView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
            
            cell!.selectedBackgroundView = selectedView
        }
        
        
        cell?.textLabel?.text = tableData[indexPath.row]
        
        
        
        return cell!
    }
    
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.sideBarControlDidSelectRow(indexPath)
    }

    
    //Allowing to delete row in index table
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0{
            return false
        }else{
            return true
        }
    }
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {

                
                
            }
        
 
            }
        }


