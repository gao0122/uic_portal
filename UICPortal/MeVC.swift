//
//  FirstViewController.swift
//  UICPortal
//
//  Created by 高宇超 on 7/17/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import UIKit
import RealmSwift
import GPUImage

let TEST = false // UserDefaults.standard TODO remember login state

class MeVC: UIViewController, UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var portalTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var meView: UIView!
    @IBOutlet weak var graduateLeftLabel: UILabel!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelLoadingBtn: UIButton!
    
    var userRealm: UserRealm!
    var webViewYc = UIWebView()
    
    var loginState: LoginState = .checking
    var action: Action = .check
    
    var meTableViewCellList: [Int: [String]] = meTableCellItems
    var meTimetableVC: MeTimetableVC!
    
    var originLoginViewY: CGFloat = 0
    var shouldUpdateMe = false // in case that update button is pressed but the login session has been expired.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webViewYc.delegate = self
        webViewYc.tag = 0
        
        initViews()
        
        if let user = RealmHelper.retrieveLastUser() {
            self.meTableViewCellList = meTableCellItems
            self.tableView.reloadData()
            self.userRealm = user
            self.setStuInfo()
            self.usernameTextField.text = user.username
            self.pwdTextField.text = user.password
            if connectedToNetwork() {
                animateIndicator()
                webViewYc.loadHTML(html: .meURL)
            } else {
                // TODO
                
            }
        } else {
            loginView.alpha = 1
            meTableViewCellList = loginTableCellItems
            tableView.reloadData()
            loginState = .loggedOut
            action = .none
            if TEST {
                usernameTextField.text = testUser
                pwdTextField.text = testPwd
                loginBtnPressed(self)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewDeselection()
    }
    
    func initViews() {
        // crop image view to round corner
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = photoImageView.frame.width * (1 - 0.618)
        photoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MeVC.photoImageViewTapped(_:))))
        loginView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MeVC.dismissKeyboard(_:))))
        loginView.alpha = 0
        indicatorView.isHidden = true
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 10))
        loginBtn.layer.masksToBounds = true
        loginBtn.layer.cornerRadius = 4
        meTimetableVC = storyboard?.instantiateViewController(withIdentifier: "meTimetableVC") as! MeTimetableVC
        
        originLoginViewY = loginView.frame.origin.y
    }
    
    func photoImageViewTapped(_ sender: UITapGestureRecognizer) {
        // TODO: - random filter
    }
    
    func dismissKeyboard(_ sender: Any) {
        if !(usernameTextField.isEditing || pwdTextField.isEditing) {
            hideLoginViewAni()
        }
        usernameTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    
    func setStuInfo() {
        navigationItem.title = userRealm.name
        nameLabel.text = userRealm.nameEng
        if let data = userRealm.photoData { photoImageView.image = UIImage(data: data) }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+8")
        let startYear = Int(userRealm.stuID.substring(from: 0, to: 1))!
        let startDate = dateFormatter.date(from: "20\(startYear + 4)-06-01")!
        let differentDays = Date().daysBetweenFromDate(toDate: startDate)
        let text = differentDays > 0 ? "离毕业还有 \(differentDays) 天。" : "🎉🎉🎉恭喜毕业！"
        graduateLeftLabel.text = text
        portalTitleLabel.alpha = 0
    }
    
    func resetStuInfo() {
        navigationItem.title = ""
        nameLabel.text = ""
        photoImageView.image = nil
        graduateLeftLabel.text = ""
        portalTitleLabel.alpha = 1
    }
    
    func doLogin() {
        webViewYc.loadHTML(html: .portalURL)
        loginState = .loggingIn
        action = .login
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let nameText = usernameTextField.text else {
            shakeViewInLogin(usernameTextField)
            return
        }
        guard let pwdText = pwdTextField.text else {
            shakeViewInLogin(pwdTextField)
            return
        }
        if nameText.characters.count == 0 {
            shakeViewInLogin(usernameTextField)
            return
        }
        if pwdText.characters.count == 0 {
            shakeViewInLogin(pwdTextField)
            return
        }
        if connectedToNetwork() {
            animateIndicator()
            dismissKeyboard(self)
            resetStuInfo()
            doLogin()
        } else {
            shakeViewInLogin(loginBtn)
        }
    }
    
    @IBAction func cancelLoadingBtnPressed(_ sender: Any) {
        stopAnimateIndicator()
        switch loginState {
        case .loggingIn, .checking, .loggingOut:
            loggedOutActions()
            return
        default:
            break
        }
        action = .none
    }
    
    func logoutBtnPressed(_ sender: Any) {
        if connectedToNetwork() {
            animateIndicator()
            webViewYc.loadHTML(html: .logoutURL)
            action = .logout
        }
        RealmHelper.logoutLastUser(userRealm)
        loggedOutActions()
    }
    
    func updateTimetableBtnPressed(_ sender: Any) {
        
    }
    
    func updateProfileBtnPressed(_ sender: Any) {
        self.webViewYc.loadHTML(html: .meURL)
        self.action = .updateMe
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier {
            switch id {
            case "fromMeVCToMeTimeTableVC":
                meTimetableVC.userRealm = self.userRealm
                meTimetableVC.webViewYc = self.webViewYc
                show(meTimetableVC, sender: sender)
            default:
                break
            }
        }
    }
    
    
    // MARK: - WebView
    func webViewDidStartLoad(_ webView: UIWebView) {
        if let url = webView.request?.url?.absoluteString {
            switch url {
            case String.portalURL:
                loginView.alpha = 0
            default:
                break
            }
        }
    }
 
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if !webView.isLoading {
        
            if (loginState == .loggedOut || loginState == .loggingIn) && action == .login  {
                let username = usernameTextField.text ?? ""
                let pwd = pwdTextField.text ?? ""
                webView.doLogin(username: username, pwd: pwd)
                loginState = .loggingIn
            }

            // handle results
            if let url = webView.request?.url?.absoluteString {
                switch url {
                case String.mainURL:
                    switch action {
                    default:
                        if loginState == .loggingIn {
                            loginState = .loggedIn
                            action = .none
                            webViewYc.loadHTML(html: .meURL)
                            printit("logged in")
                        }
                    }
                case url where url.contains(.loggedOut):
                    switch action {
                    case .check:
                        if loginState == .loggedOut || loginState == .checking {
                            doLogin()
                        }
                    case .logout:
                        printit("logged out")
                        loggedOutActions()
                    case .login:
                        printit("login failed")
                        action = .none
                        loginState = .loggedOut
                        stopAnimateIndicator()
                        showLoginView()
                        shakeViewInLogin(loginBtn)
                    case .updateMe:
                        doLogin()
                        shouldUpdateMe = true
                    default:
                        loginState = .loggedOut
                        if loginState == .loggedIn {
                            // login again
                            doLogin()
                        }
                    }
                case String.meURL:
                    switch action {
                    case .check:
                        if loginState == .checking {
                            loginState = .loggedIn
                            action = .none
                            printit("logged in after checking")
                            hideLoginViewsAndIndicatorAfterLogin()
                        }
                    case .none:
                        if loginState == .loggedIn {
                            // update user after it logged in
                            printit("logged in me profile")
                            if userRealm == nil || shouldUpdateMe {
                                // only update after login manually
                                updateUserInfo()
                            } else {
                                self.setStuInfo()
                                self.hideLoginViewsAndIndicatorAfterLogin()
                            }
                        }
                    case .updateMe:
                        if loginState == .loggedIn {
                            updateUserInfo()
                        }
                    default:
                        break
                    }
                case String.gradeReportURL:
                    switch action {
                    default:
                        break
                    }
                case url where url.contains(.misURL):
                    switch action {
                    default:
                        break
                    }
                default:
                    break
                }
            }
        }
    }
    
    func loggedOutActions() {
        usernameTextField.text = ""
        pwdTextField.text = ""
        loginState = .loggedOut
        action = .none
        meTableViewCellList = loginTableCellItems
        tableView.reloadData()
        resetStuInfo()
        stopAnimateIndicator()
    }
    
    func hideLoginViewsAndIndicatorAfterLogin() {
        hideLoginViewAni()
        meTableViewCellList = meTableCellItems
        tableView.reloadData()
        stopAnimateIndicator()
    }
    
    func stopAnimateIndicator() {
        indicator.stopAnimating()
        indicatorView.isHidden = true
    }
    
    func animateIndicator() {
        indicatorView.isHidden = false
        indicator.startAnimating()
    }
    
    func showLoginView() {
        loggedOutActions()
        loginView.alpha = 1
        loginView.transform = CGAffineTransform.identity
    }
    
    func updateUserInfo() {
        shouldUpdateMe = false
        
        let username = usernameTextField.text!
        let pwd = pwdTextField.text!
        let sid = webViewYc.rtrvProfile(byClassName: .sidClassMe)
        let nameEng = getStuName()[0]
        let name = getStuName()[1]
        let program = webViewYc.rtrvProfile(byClassName: .programClassMe)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0")
        let birthDateStr = webViewYc.rtrvOtherProfile(index: 0)
        let birthDate = dateFormatter.date(from: birthDateStr)!
        let idCardNo = webViewYc.rtrvOtherProfile(index: 1)
        let mobile = webViewYc.rtrvOtherProfile(index: 2)
        let homePhone = webViewYc.rtrvOtherProfile(index: 3)
        let address = webViewYc.rtrvOtherProfile(index: 4)
        let postcode = webViewYc.rtrvOtherProfile(index: 5)
        var photoData = Data()
        if let url = URL(string: .photoURL) {
            photoData = try! Data(contentsOf: url)
        }
        
        if let user = RealmHelper.retrieveLastUser() {
            RealmHelper.updateStu(user, name: name, stuID: sid, nameEng: nameEng, program: program, address: address, birthDate: birthDate, mobilePhone: mobile, homePhone: homePhone, postcode: postcode, idCardNo: idCardNo, photoData: photoData)
            RealmHelper.updatePassword(user, newPassword: pwd)
            self.userRealm = user
        } else {
            if let user = RealmHelper.retrieveUser(byUsername: username) {
                RealmHelper.updateStu(user, name: name, stuID: sid, nameEng: nameEng, program: program, address: address, birthDate: birthDate, mobilePhone: mobile, homePhone: homePhone, postcode: postcode, idCardNo: idCardNo, photoData: photoData)
                RealmHelper.updatePassword(user, newPassword: pwd)
                self.userRealm = user
            } else {
                let user = UserRealm()
                user.username = username
                RealmHelper.addUser(user)
                RealmHelper.updateStu(user, name: name, stuID: sid, nameEng: nameEng, program: program, address: address, birthDate: birthDate, mobilePhone: mobile, homePhone: homePhone, postcode: postcode, idCardNo: idCardNo, photoData: photoData)
                RealmHelper.updatePassword(user, newPassword: pwd)
                self.userRealm = user
            }
        }
        self.setStuInfo()
        self.hideLoginViewsAndIndicatorAfterLogin()
        
    }
    
    func getStuName() -> [String] {
        return webViewYc.rtrvProfile(byClassName: .nameClassMe).components(separatedBy: CharacterSet.newlines)
    }


    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return meTableViewCellList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meTableViewCellList[section]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "meTableCell") as! MeTableCell
        cell.yuchao.text = meTableViewCellList[indexPath.section]![indexPath.row]
        cell.tableView = self.tableView
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        switch section {
        case 0:
            switch row {
            case 0:
                if meTableViewCellList.count == loginTableCellItems.count {
                    showLoginViewAni()
                } else {

                }
            case 1:
                updateProfileBtnPressed(self)
            default:
                break
            }
        case 1:
            switch row {
            case 0:
                self.prepare(for: UIStoryboardSegue(identifier: "fromMeVCToMeTimeTableVC", source: self, destination: meTimetableVC), sender: self)
            default:
                break
            }
        case 2:
            switch row {
            case 0:
                logoutBtnPressed(self)
            default:
                break
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == meTableViewCellList.count - 1 ? 15 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableViewDeselection() {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    
    // MARK: - TextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseInOut], animations: {
            self.loginView.frame.origin.y = self.originLoginViewY * 0.618
            self.portalTitleLabel.alpha = 0
        }, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseInOut], animations: {
            self.loginView.frame.origin.y = self.originLoginViewY
            self.portalTitleLabel.alpha = 1
        }, completion: nil)
    }
    
    @IBAction func userNameTextFieldEditingChanged(_ sender: Any) {
        if let text = usernameTextField.text {
            if text.characters.count == 10 && checkIsStudentOrTeacher(withUsername: text) {
                pwdTextField.becomeFirstResponder()
            }
        }
    }
    
    
    // MARK: - Animation
    func showLoginViewAni() {
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseInOut], animations: {
            self.loginView.alpha = 1
            self.loginView.transform = CGAffineTransform.identity
        }, completion: {
            finished in
            self.tableViewDeselection()
        })
    }
    
    func hideLoginViewAni() {
        tableViewDeselection()
        UIView.animate(withDuration: 0.24, delay: 0, options: [.curveEaseInOut], animations: {
            self.loginView.alpha = 0
            self.loginView.transform = CGAffineTransform(translationX: 0, y: -self.loginView.frame.height).concatenating(CGAffineTransform(scaleX: 1, y: 0.3))
        }, completion: nil)
    }
    
    func shakeViewInLogin(_ shakingView: UIView) {
        self.loginView.isUserInteractionEnabled = false
        shakingView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.06, delay: 0, options: [.curveEaseInOut], animations: {
            shakingView.transform = CGAffineTransform(translationX: -10, y: 0)
        }, completion: {
            finished in
            UIView.animate(withDuration: 0.06, delay: 0, options: [.curveEaseInOut], animations: {
                shakingView.transform = CGAffineTransform(translationX: 18, y: 0)
            }, completion: {
                finished in
                UIView.animate(withDuration: 0.06, delay: 0, options: [.curveEaseInOut], animations: {
                    shakingView.transform = CGAffineTransform(translationX: -16, y: 0)
                }, completion: {
                    finished in
                    UIView.animate(withDuration: 0.06, delay: 0, options: [.curveEaseInOut], animations: {
                        shakingView.transform = CGAffineTransform(translationX: 14, y: 0)
                    }, completion: {
                        finished in
                        UIView.animate(withDuration: 0.06, delay: 0, options: [.curveEaseInOut], animations: {
                            shakingView.transform = CGAffineTransform(translationX: -12, y: 0)
                        }, completion: {
                            finished in
                            UIView.animate(withDuration: 0.06, delay: 0, options: [.curveEaseInOut], animations: {
                                shakingView.transform = CGAffineTransform.identity
                            }, completion: {
                                finished in
                                shakingView.isUserInteractionEnabled = true
                                self.loginView.isUserInteractionEnabled = true
                            })
                        })
                    })
                })
            })
        })
    }
    
    
}

let meTableCellItems: [Int: [String]] = [
    0: ["Update timetable", "Update profile"],
    1: ["My Timetable"],
    2: ["Logout"]
]

let loginTableCellItems: [Int: [String]] = [
    0: ["Login"]
]
