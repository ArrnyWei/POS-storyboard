//
//  ViewController.swift
//  POS-storyboard
//
//  Created by Wei Shih Chi on 2020/1/9.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard));
        self.view.addGestureRecognizer(tapRecognizer)
        
        if let account = UserDefaults.standard.value(forKey: "account") as? String{
            self.accountTextField.text = account
        }
        
        if let password = UserDefaults.standard.value(forKey: "password") as? String{
            self.passwordTextField.text = password
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.isNavigationBarHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func loginClick(_ sender: UIButton) {
        if !accountTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            let alertController = UIAlertController(title: "登入中", message: nil, preferredStyle: UIAlertController.Style.alert)
            self.present(alertController, animated: true) {
                HttpRequestTools.sharedInstance.postDataByJSON("login", data: ["account":self.accountTextField.text!,"password":self.passwordTextField.text!]) { (result, error) in
                    if error == nil {
                        if result!["result"] as! Bool == true {
                            UserDefaults.standard.setValue(result!["account"], forKey: "account")
                            UserDefaults.standard.setValue(result!["password"], forKey: "password")
                            
                            OpenParameter.shared.store_id = result!["store_Id"] as! String
                            OpenParameter.shared.store_name = result!["name"] as! String
                            
                            DispatchQueue.main.sync {
                                self.dismiss(animated: true) {
                                    self.performSegue(withIdentifier: "loginToMain", sender: nil)
                                }
                                
                            }
                            
                        }
                        else {
                            DispatchQueue.main.sync {
                                
                                self.dismiss(animated: true) {
                                    let alertContoller = UIAlertController(title: "錯誤", message: "帳號密碼不正確", preferredStyle: UIAlertController.Style.alert)
                                    
                                    alertContoller.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil));
                                    self.present(alertContoller, animated: true, completion: nil);
                                }
                                
                                
                            }
                        }
                    }
                    else{
                        DispatchQueue.main.sync {
                            self.dismiss(animated: true) {
                                let alertContoller = UIAlertController(title: "錯誤", message: "網路連線不佳，如有問題請洽服務人員", preferredStyle: UIAlertController.Style.alert)
                                
                                alertContoller.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil));
                                self.present(alertContoller, animated: true, completion: nil);
                            }
                            
                        }
                    }
                }
            }
            
        }
        else {
            let alertController = UIAlertController(title: "錯誤", message: "請輸入完整資訊", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @objc func keyboard(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    @objc func dismissKeyboard() {
        self.accountTextField.resignFirstResponder();
        self.passwordTextField.resignFirstResponder();
    }
}

