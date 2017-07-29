//
//  UIWebView+Extension.swift
//  UICPortal
//
//  Created by 高宇超 on 7/17/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import UIKit

// MARK :- WebView, grab information from html
extension UIWebView {
    
    func loadHTML(html: String) {
        guard let url = URL(string: html.percentEncoding()) else { return }
        let request = URLRequest(url: url)
        self.loadRequest(request)
    }
    
    func doLogin(username: String, pwd: String) {
        stringByEvaluatingJavaScript(from: "var script = document.createElement('script');script.type = 'text/javascript';script.text = function ycDoLogin() { var username = document.getElementById('username'); var pwd = document.getElementsByName('password')[0]; username.value = '\(username)@student'; pwd.value = '\(pwd)'; var form = document.getElementsByName('login_form')[0]; form.submit(); };document.getElementsByTagName('head')[0].appendChild(script);")
        stringByEvaluatingJavaScript(from: "ycDoLogin();")
    }
    
    func doLogout() {
        stringByEvaluatingJavaScript(from: "logout();")
    }
    
    func goToMIS() {
        stringByEvaluatingJavaScript(from: "login(mis);")
    }
    
    func goToiSpace() {
        stringByEvaluatingJavaScript(from: "login(iSpace);")
    }
    
    func rtrvProfile(byClassName className: String) -> String {
        stringByEvaluatingJavaScript(from: "var script = document.createElement('script');script.type = 'text/javascript';script.text = function rtrvProfile() { var profile = document.getElementsByClassName('\(className)')[0]; var item = profile.getElementsByTagName('span')[0]; return item.innerText; }; document.getElementsByTagName('head')[0].appendChild(script);")
        guard let name = self.stringByEvaluatingJavaScript(from: "rtrvProfile();") else { return "" }
        return name
    }
    
    func rtrvGender() -> String {
        stringByEvaluatingJavaScript(from: "var script = document.createElement('script');script.type = 'text/javascript';script.text = function rtrvGender() { var table = document.getElementsByClassName('border1')[0]; var td = table.getElementsByTagName('tr')[1].getElementsByTagName('td')[3]; return td.innerText; }; document.getElementsByTagName('head')[0].appendChild(script);")
        guard let gender = self.stringByEvaluatingJavaScript(from: "rtrvGender();") else { return "" }
        return gender == "M" ? "Male" : "Female"
    }
    
    func rtrvOtherProfile(index: Int) -> String {
        stringByEvaluatingJavaScript(from: "var script = document.createElement('script');script.type = 'text/javascript';script.text = function rtrvOtherProfile() { var profile = document.getElementsByClassName('other')[\(index)]; var item = profile.getElementsByTagName('span')[0]; return item.innerText; }; document.getElementsByTagName('head')[0].appendChild(script);")
        guard let other = self.stringByEvaluatingJavaScript(from: "rtrvOtherProfile();") else { return "" }
        return other
    }
    
    
}


