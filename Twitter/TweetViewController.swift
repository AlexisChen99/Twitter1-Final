//
//  TweetViewController.swift
//  Twitter
//
//  Created by Alexis Chen on 2/17/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show the place to enter the tweet
        textView.becomeFirstResponder()

        // Do any additional setup after loading the view.
    }
    
    //when the users press cancel
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //when the user presses tweet
    @IBAction func tweet(_ sender: Any) {
        //if the text is not null
        if !textView.text.isEmpty{
            //success, call the function
            TwitterAPICaller.client?.postTweet(tweetString: textView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (Error) in
                //print the Error
                print ("error posting tweet \(Error)")
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
            print ("the text is empty")
            self.dismiss(animated: true, completion: nil)
        }
        
        
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
