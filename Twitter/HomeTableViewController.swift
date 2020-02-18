//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Alexis Chen on 2/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    //var changes; let does not change
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    //refresh control
    let myRefreshControl = UIRefreshControl()
    
    //this runs when the view load the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        //this load the tweet when the user opens the app
        loadTweets()
        
        //reload the tweet when the user pulls it
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    //overrid the viewDidAppear
    //this is called every time the screen appears while viewDidLoad only get called when the app get loaded
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }

    // MARK: - Table view data source
    
    //this func will load the info from tweet
    @objc func loadTweets(){
        //variable
        numberOfTweet = 20
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet]
        
        //pull the dictionaries from the url
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            //clean the array before append to it
            self.tweetArray.removeAll()
        
            //is this a for each loop?
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            //reload the tableview
            self.tableView.reloadData()
            
            //stop reload
            //FIXME why do we have this line here instead of in viewDidLoad
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("could not retreive tweets")
        })
    }
    
    //this func loads more tweet
    func loadMoreTweets(){
        //variable
        numberOfTweet += 20 //number of tweet increment
        let myURL = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweet]
        
        //pull the dictionaries from the url
        TwitterAPICaller.client?.getDictionariesRequest(url: myURL, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
            
            //clean the array before append to it
            self.tweetArray.removeAll()
        
            //is this a for each loop?
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            //reload the tableview
            self.tableView.reloadData()
            
            //stop reload
            //FIXME why do we have this line here instead of in viewDidLoad
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("could not retreive tweets")
        })
    }

    //this calls laodMoreTweets when the user scrolls to the bottom
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    
    
    //logout when the button is pressed
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //the cell would be the tweetCelltableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCellTableViewCell
        //the dictonary of the user
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        //assign cell items
        cell.userNamelabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        //assign the image
        //FIXME why do we jave imageData
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImage.image = UIImage(data: imageData)
        }
        
        
        return cell
    }
    
    //number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

}
