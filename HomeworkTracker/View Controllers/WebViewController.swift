//
//  WebViewController.swift
//  HomeworkTracker
//
//  Created by Parshant Juneja on 4/30/20.
//  Copyright © 2020 Parshant Juneja (Personal Team). All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlString!)
        
        let request = URLRequest(url: url!)
        
        webView.load(request)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
