//
//  MeTimetableVC.swift
//  UICPortal
//
//  Created by 高宇超 on 7/23/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import UIKit

class MeTimetableVC: UIViewController, UIWebViewDelegate {

    
    var userRealm: UserRealm!
    var webViewYc: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Timetable"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(MeTimetableVC.shareBtnPressed(_:)))
        tabBarController?.tabBar.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    func shareBtnPressed(_ sender: Any) {
        
    }

    @IBAction func refreshBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func saveToAlbumBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func saveChangesBtnPressed(_ sender: Any) {
        
    }
    
    // MARK: - WebView
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading {
            printit(webView.request?.url?.absoluteString)
        }
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "fromMeVCToMeTimeTableVC":
                break
            default:
                break
            }
        }
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
}
