//
//  NewsService.swift
//  yuanyin-ios
//
//  Created by triompha on 11/6/15.
//  Copyright (c) 2015 triompha. All rights reserved.
//

import SQLite

class NewsService {
    
    var db :Database
    var users :Query
    let id = Expression<Int64>("id")
    let sid = Expression<Int64>("sid")
    let title = Expression<String?>("title")
    let content = Expression<String>("content")
    
    func loadNewData(){
        requestUrl("http://www.triompha.com:8080/r/news/top/10")
    }
    func requestUrl(urlString: String){
        
        var url: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{
            (response, data, error) -> Void in
            
            if (error != nil) {
                //Handle Error here
            }else{
                var err: NSError?
                var jsonResult:NSArray = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: &err) as! NSArray
                
                for var i = 0 ; i<jsonResult.count ;i++ {
                    let data1 = jsonResult.objectAtIndex(i)as! NSMutableDictionary
                    
                    let ssid:Int64 = (data1.objectForKey("srcId") as! NSNumber).longLongValue
                    let stitle:String = data1.objectForKey("title") as! String;
                    let scontent:String = data1.objectForKey("content") as! String
                    
                    if let rowid = self.users.insert(self.sid<-ssid,self.title<-stitle,self.content<-scontent).rowid {
                        println("inserted id: \(rowid)")
                    }
                    
                }
                
            }
            
        })
    }
    
    func listTopTitles()->NSMutableArray{
        loadNewData()
        
        let titles :NSMutableArray = NSMutableArray()
        
        for row in getTitleQuryCursor(0, size: 20){
            titles.addObject(row[0] as! NSString)
            println("title: \(row[0] as! NSString)")
        }
        return titles        
    }
    
    func get(position:Int)->News{
        var raw = users.order(sid.desc).limit(1, offset: position).first
        //let raw = getQuryCursor(position,size:1);
        let result:News = News()        
        result.sid = raw?.get(sid)
        result.title=raw?.get(title)
        result.content=raw?.get(content)
        return result
    }
    
    
    func getTitleQuryCursor(from:Int,size:Int)->Statement{
        return db.prepare("SELECT title FROM news order by sid desc limit \(from),\(size)")
    }
    func getQuryCursor(from:Int,size:Int)->Statement{
        return db.prepare("SELECT sid,title,content FROM news order by sid desc limit \(from),\(size)")
    }
    
     internal init() {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        let dbPath = "\(path)/news.sqlite3" as String
        println(dbPath)
        db = Database(dbPath)
        db.execute("CREATE TABLE IF NOT EXISTS news" +
            "('id' INTEGER PRIMARY KEY AUTOINCREMENT, 'sid' INTEGER UNIQUE, 'title' VARCHAR, 'content' TEXT)")
        
        users = db["news"]

    }
    
}

