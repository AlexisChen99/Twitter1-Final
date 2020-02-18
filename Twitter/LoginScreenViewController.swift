//
//  LoginScreenViewController.swift
//  Twitter
//
//  Created by Alexis Chen on 2/11/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class LoginScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //this function checks if user has logged in before,
    //if yes, just login already
    override func viewDidAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    //exacute when the button is taped
    @IBAction func tapLoginButton(_ sender: Any) {
        
        let myURL = "https://api.twitter.com/oauth/request_token" //this is the twiiter ul
        //call the twitter api
        TwitterAPICaller.client?.login(url: myURL, success: {
            //stay log in for a while, before switching to loginToHome, it checks the value first
            UserDefaults.standard.set(true, forKey: "userLoggedIn")//forkey is the value of this log in
            //when we succeed, switch to loginToHome
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("could not login in")
        })
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
