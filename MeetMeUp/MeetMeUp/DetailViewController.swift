//
//  detailViewController.swift
//  MeetMeUp
//
//  Created by I-Horng Huang on 04/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var detailVcDic:NSDictionary = Dictionary<String, String>()

    @IBOutlet weak var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = detailVcDic["name"] as String
    }
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        let wvc = segue.destinationViewController as WebViewController
        wvc.urlString = detailVcDic["event_url"] as String

    }
}