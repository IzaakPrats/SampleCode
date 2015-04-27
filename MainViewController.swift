//
//  ViewController.swift
//  Stomy
//
//  Created by Izaak Prats on 3/21/15.
//  Copyright (c) 2015 IJVP. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // Dynamic UI Objects

    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    
    // UIButton Actions
    
    @IBAction func logOut() {
        
        // If the user is a parent, don't log out. Take them back to the student selection screen.
        
        if (userType! == "2") {
            
            var parentViewController: ParentViewController = self.storyboard!.instantiateViewControllerWithIdentifier("parentViewController") as! ParentViewController
            
            parentViewController.parentId = parentId!
            
            self.presentViewController(parentViewController, animated: true, completion: nil)
        
        } else {
        var loginViewController: LoginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
        
        
        self.presentViewController(loginViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func createAnAssignment() {

        var createAssnViewController: CreateAssnViewController = self.storyboard!.instantiateViewControllerWithIdentifier("createAssnViewController") as! CreateAssnViewController
        
        createAssnViewController.teacherId = userId!
        createAssnViewController.classList = tableData
        
        self.presentViewController(createAssnViewController, animated: true, completion: nil)
        
    }
    
    
    
    // Static UI Objects
    
    @IBOutlet weak var classList: UITableView!
    
    
    
    // Local scope variables
    
    var tableData = []
    var userId: String?
    var userType: String?
    var parentId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the user is a teacher. If not, don't show create button.
        
        if (userType! == "2"){
            logOutButton.setTitle("Back", forState: UIControlState.Normal)
        } else if (userType! == "0"){
            createButton.hidden = true
        }
        
        // Get user JSON data from API.
        getJSON(userId!, userType: userType!)
    }
    
    func getJSON(userID: String?, userType: String?) {
        
        // Determine which API URI to use based on teacher / student.
        
        if (userType! == "1") {
            getTeacherJSON(userID!)
        } else {
            getStudentJSON(userID!)
        }
        
    }
    
    
    
    // TODO: Abstract all JSON calls between NSMutDic and NSArray
    
    func getStudentJSON(studentID: NSString) {
        let baseURL = NSURL(string: "http://yetiagenda.com/api/GET/Students/")
        let studentURL = NSURL(string: "class.php?id=\(studentID)", relativeToURL: baseURL)
        // Do additional setup
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask:  NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(studentURL!, completionHandler: {(classList: NSURL!, response: NSURLResponse!,error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: classList)
                
                if (dataObject != nil) {
                    // Students/class.php/id is an array
                    let results: NSArray = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSArray
                    
                    dispatch_async(dispatch_get_main_queue(), {
                         UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.tableData = results
                        self.classList?.reloadData()
                        
                    })
                    
                    
                } else {
                    println(error)
                }
                
            }
        })
         UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        downloadTask.resume()
        
    }
    
    
    func getTeacherJSON(teacherID: NSString) {
        let baseURL = NSURL(string: "http://yetiagenda.com/api/GET/Teachers/")
        let studentURL = NSURL(string: "classes.php?tId=\(teacherID)", relativeToURL: baseURL)
        // Do any additional setup after loading the view, typically from a nib.
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask:  NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(studentURL!, completionHandler: {(classList: NSURL!, response: NSURLResponse!,error: NSError!) -> Void in
            
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: classList)
                
                if (dataObject != nil) {
                    let results: NSArray = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as! NSArray
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        self.tableData = results
                        self.classList?.reloadData()
                        
                    })
                    
                    
                } else {
                    println(error)
                }
                
            }
        })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        downloadTask.resume()
        
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
        
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // TODO : Move this into a deqeue reusable cell
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "resultCell")
        
        let className : NSMutableDictionary = self.tableData[indexPath.row] as! NSMutableDictionary
 
        // Text formatting
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont.systemFontOfSize(20.0)
        
        
        cell.textLabel?.text = className["name"] as? String

        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var detailViewController: DetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        let givenClass: NSMutableDictionary = self.tableData[indexPath.row] as! NSMutableDictionary
        
        detailViewController.name = givenClass["name"] as? String
        detailViewController.classID = givenClass["id"] as? String
        detailViewController.userID = userId!
        detailViewController.userType = userType!
        
        self.presentViewController(detailViewController, animated: true, completion: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
        
}



