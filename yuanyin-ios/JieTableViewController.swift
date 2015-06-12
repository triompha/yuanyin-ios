//
//  JieTableViewController.swift
//  JieTableView
//
//  Created by jiezhang on 14-10-5.
//  Copyright (c) 2014年 jiezhang. All rights reserved.
//

import UIKit

class JieTableViewController: UITableViewController {
    
    var listVideos : NSMutableArray!
    
    var listNews : NSMutableArray = ["11111","222222","3333333","4444444","55555555","6666666"];
    
    let service : NewsService = NewsService()
   
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var bundle = NSBundle.mainBundle()
        //get the data's file path
        let plistPath : String! = bundle.pathForResource("videos", ofType: "plist")
        
        
        listVideos = NSMutableArray(contentsOfFile: plistPath)
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem()
        //let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        
        listNews = service.listTopTitles()
        
        var one = service.get(1)
        
        println(one.content)
        
    }
    
    func insertNewObject(sender: AnyObject) {
       var item : NSDictionary = NSDictionary(objects:["http://c.hiphotos.baidu.com/video/pic/item/f703738da977391224eade15fb198618377ae2f2.jpg","新增数据", NSDate().description] , forKeys: ["video_img","video_title","video_subTitle"])
        listVideos.insertObject(item, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier : String = "videoItem"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! JieTableViewCell
        var row = indexPath.row
        //var rowDict : NSDictionary = listVideos.objectAtIndex(row) as! NSDictionary
        //let url : String = rowDict.objectForKey("video_img") as! String
        
        //let dataImg : NSData = NSData(contentsOfURL: NSURL(string : url)!)!
        //cell.JieVideoImg.image = UIImage(data: dataImg)
        //cell.JieVideoTitle.text = rowDict.objectForKey("video_title") as? String
        
        cell.JieVideoTitle.text = listNews[row] as? String
        
        //cell.JieVideoSubTitle.text = rowDict.objectForKey("video_subTitle") as? String
        return cell
        
    }
    
    // 支持单元格编辑功能
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            listNews.removeObjectAtIndex(indexPath.row)
            listVideos.removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if fromIndexPath != toIndexPath{
            var object: AnyObject = listVideos.objectAtIndex(fromIndexPath.row)
            listNews.removeObjectAtIndex(fromIndexPath.row)
            listVideos.removeObjectAtIndex(fromIndexPath.row)
            if toIndexPath.row > self.listVideos.count{
                self.listVideos.addObject(object)
                self.listNews.addObject(object as! String)
            }else{
                self.listVideos.insertObject(object, atIndex: toIndexPath.row)
                self.listNews.insertObject(object as! String, atIndex: toIndexPath.row)            }
        }
    }
    
    
    
    // Override to support conditional rearranging of the table view.
    //在编辑状态，可以拖动设置item位置
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    
    
    
    // MARK: - Navigation
    
    //给新进入的界面进行传值
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                let object : News = service.get(indexPath.row)
                
                (segue.destinationViewController as! JieDetailViewController).newsItem = object
            }
        }
    }
    
    
    
}