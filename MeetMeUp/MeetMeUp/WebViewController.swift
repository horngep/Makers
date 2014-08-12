//
//  WebViewController.swift
//  MeetMeUp
//
//  Created by I-Horng Huang on 04/08/2014.
//  Copyright (c) 2014 Ren. All rights reserved.
//

import Foundation
import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    var urlString:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url)
        myWebView.loadRequest(request)
    }

}