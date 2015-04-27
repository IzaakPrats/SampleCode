//
//  ClassSelectViewController.swift
//  YA Alpha
//
//  Created by Izaak Prats on 3/30/15.
//  Copyright (c) 2015 IJVP. All rights reserved.
//
//  TODO
//
//  - Conversion from instantiateView to prepareForSegue ***
//

import UIKit

class ClassSelectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Static UI Objects
    
    @IBOutlet weak var classList: UITableView!
    
    // Static UI Actions
    
    @IBAction func backButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func assignButton() {

        if (cellArray!.count == 0) {
            println("You haven't selected anything.")
        } else {
        
            for classId in cellArray!
            {
                let baseURL = NSURL(string: "http://yetiagenda.com/api/POST/")
                
                var assignmentURLString: CFString = "assignment.php?cId=\(classId)&name=\(assnName!)&info=\(assnInfo!)&points=\(assnPoints!)&dueDate=\(assnDueDate!)" as CFString
                
                assignmentURLString = CFURLCreateStringByAddingPercentEscapes(nil, assignmentURLString, nil, nil, kCFStringEncodingASCII)
                
                let assignmentURL = NSURL(string: assignmentURLString as String, relativeToURL: baseURL)
                
                let task = NSURLSession.sharedSession().dataTaskWithURL(assignmentURL!)
                task.resume()

            }
            var mainViewController: MainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("mainViewController") as! MainViewController
        
            mainViewController.userType = "1"
            mainViewController.userId = teacherId!
            
            self.presentViewController(mainViewController, animated: true, completion: nil)
        }
        
    }
    
    // Local scope variables
    
    var classes: NSArray?
    var assnData: NSDictionary?
    var teacherId: String?
    var cellArray: NSMutableArray? = []
    var assnName: NSString?
    var assnInfo: NSString?
    var assnPoints: NSString?
    // temp date
    var assnDueDate: NSString? = "2015-4-16"


    override func viewDidLoad() {
        super.viewDidLoad()
        assnName = assnData!["name"] as? NSString
        assnInfo = assnData!["info"] as? NSString
        assnPoints = assnData!["points"] as? NSString
        NSDateToString(assnData!["dueDate"] as? NSDate)
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func NSDateToString(date: NSDate?) {
        
        // Convert JSON MySQL Date to NSDate to String
        
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        assnDueDate? = dateFormatter.stringFromDate(date!)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classes!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Change this to reuseable cell
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "classCell")
        
        let className : NSMutableDictionary = self.classes![indexPath.row] as! NSMutableDictionary
        
        // Text Formatting
        
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont.systemFontOfSize(20.0)
        
        cell.textLabel?.text = className["name"] as? String
        
        return cell
    }
    

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let classInfo : NSMutableDictionary = self.classes![indexPath.row] as! NSMutableDictionary
        
        // If the cell is not selected, add it to the array. Else - remove the cell from the array.
        
            if (selectedCell.accessoryType == .None) {
                selectedCell.accessoryType = .Checkmark
                cellArray?.addObject(classInfo["id"]!)
            } else {
                selectedCell.accessoryType = .None
                cellArray?.removeObject(classInfo["id"]!)
            }
 
         }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
