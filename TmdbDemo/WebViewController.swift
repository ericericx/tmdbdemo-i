//
//  WebViewController.swift
//  TmdbDemo
//
//  Created by EricChien on 2018/9/10.
//  Copyright © 2018年 Soul. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = URLRequest.init(url: URL.init(string: "https://www.cathaycineplexes.com.sg/")!)
        webview.loadRequest(request)
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reload(_ sender: Any) {
        webview.reload()
    }
    
    @IBAction func goForward(_ sender: Any) {
        webview.goForward()
    }
    
    @IBAction func goBack(_ sender: Any) {
        webview.goBack()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
