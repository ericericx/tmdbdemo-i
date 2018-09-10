//
//  SignViewController.swift
//  TmdbDemo
//
//  Created by EricChien on 2018/9/6.
//  Copyright © 2018年 Soul. All rights reserved.
//

import UIKit

struct GlobleVariables {
    static var apiKey = ""
    static let imageDomain = "https://image.tmdb.org/t/p/w500"
    static let listDomain = "http://api.themoviedb.org/3/discover/movie"
    static let detailDomain = "http://api.themoviedb.org/3/movie/"
}

extension SignViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        signBtn.isEnabled = (textField.text?.count)! > 0
    }
}

class SignViewController: UIViewController {

    @IBOutlet weak var apiTxtf: UITextField!
    
    @IBOutlet weak var signBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiTxtf.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }

    @IBAction func signIn(_ sender: Any) {
        guard let apiKey = apiTxtf.text else { return }
        GlobleVariables.apiKey = apiKey
        
        guard let window = UIApplication.shared.keyWindow else { return }
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTabbarViewCtrl")
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: {
            UIApplication.shared.keyWindow?.rootViewController = vc
        }, completion: nil)
    }
    
    @IBAction func useDefaultKey(_ sender: Any) {
        apiTxtf.text = "cfeda99212927f2fb741170496b2b9f0"
        textFieldDidChanged(apiTxtf)
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
