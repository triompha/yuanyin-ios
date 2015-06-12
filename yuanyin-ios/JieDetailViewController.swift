//
//  JieDetailViewController.swift
//  JieTableView
//
//  Created by jiezhang on 14-10-5.
//  Copyright (c) 2014年 jiezhang. All rights reserved.
//

import UIKit

class JieDetailViewController: UIViewController {
    
    
//    @IBOutlet var big_video_img: UIImageView!
    //接受传进来的值
    var newsItem: News?
    
    @IBOutlet weak var content : UITextView!
    
    
    func configureView() {
        
        if let detail : News = self.newsItem {
            self.title = detail.title

            //detail.content = "Homebrew是Mac OS上一套流行的软件包管理工具，可以通过命令行搜索、安装、卸载软件包。近日，其作者在进入Google的面试中，因解不出一个二叉树翻转的问题，直接被Google拒绝。 \n<br /> \n<br />Max Howell在Twitter上推文大意如下： \n<br />\n<div class=\"quote_title\">\n 引用\n</div>\n<div class=\"quote_div\">\n Google：虽然我们90%的工程师都在用你写的Homebrew，但这也并没有什么卵用，你连二叉树翻转都写不出，直接滚蛋吧！\n</div><img width='100%' src=\"http://dl2.iteye.com/upload/attachment/0109/4336/a5034117-4cc8-3f6c-aab1-d9ffed1fd328.png\" /> 原推文地址：\n<a target=\"_blank\" href=\"https://twitter.com/mxcl/status/608682016205344768\">https://twitter.com/mxcl/status/608682016205344768</a>"
            
            
            
            var replaced = detail.content?.stringByReplacingOccurrencesOfString("text-align: center;", withString: "")
            
            var data = replaced!.dataUsingEncoding(NSUTF32StringEncoding, allowLossyConversion: true)
            var textatrr1 = NSMutableAttributedString(data: data!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil, error: nil)
            self.content.attributedText = textatrr1
             
           // self.content.text = detail.content
            
            self.content.editable = false
            //self.content.selectable = false
        }
        
    }
    
    override func viewDidLoad() {
        configureView()
        super.viewDidLoad()
        //configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
    }
    
}