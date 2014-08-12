//
//  ViewController.swift
//  MeetMeUp
//
//  Created by I-Horng Huang on 04/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableVIew: UITableView!

    var eventArray: NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()

        var url:NSURL = NSURL(string:"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=7e724634ce575b28182845f35447")
        var request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { response, data, error in
            let dict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: nil) as NSDictionary!

            self.eventArray = dict["results"] as NSArray
            self.myTableVIew.reloadData()
        }
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {

            var dic:NSDictionary = self.eventArray[indexPath.row] as NSDictionary
            var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellID") as UITableViewCell
            cell.textLabel.text = dic["name"] as String
            cell.detailTextLabel.text = dic["id"] as String
            return cell
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.eventArray.count
    }

    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "segue") {
            // pass data to next view
            let indexPath = self.myTableVIew.indexPathForSelectedRow()
            let dvc = segue.destinationViewController as DetailViewController
            let dictToPass = self.eventArray[indexPath.row] as NSDictionary
            dvc.detailVcDic = dictToPass
            //passing array of dictionaries
        }
    }
}
















