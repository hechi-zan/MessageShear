//
//  FeedViewController.swift
//  ShindanMaker
//
//  Created by HechiZan on 2021/08/23.
//

import UIKit
import BubbleTransition
import Firebase
import SDWebImage
import ViewAnimator
import FirebaseFirestore


class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
 
    
   
    
    

    var interactiveTransition:BubbleInteractiveTransition?
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var feeds:[Feeds] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを1つ
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "feedCell")
        tableView.separatorStyle = .none
        
        loadData()
    
        
    }
   
    func loadData(){
        
        //投稿されたものを受信する
        db.collection("feed").order(by: "createdAt").addSnapshotListener { (snapShot,error) in
            
            self.feeds = []
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if let snapShotDoc = snapShot?.documents{
                
                for doc in snapShotDoc{
                    
                    let data = doc.data()
                    if let userName = data["userName"] as? String,let quote = data["quote"] as? String,let photoURL = data["photoURL"] as? String{
                        
                        
                        let newFeeds = Feeds(userName: userName, quote: quote, profileURL: photoURL)
                        
                        self.feeds.append(newFeeds)
                        self.feeds.reverse()
                        DispatchQueue.main.async {
                            
                        
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                        }
                        
                    }
                }
                
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        interactiveTransition?.finish()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        //cell.userNameLabel.text = "\(feeds[indexPath.row].userName)さんを表す名言"
        cell.quoteLabel.text = "\(feeds[indexPath.row].userName)さんを表す名言" + "\n" + feeds[indexPath.row].quote
        cell.profileImageView.sd_setImage(with: URL(string: feeds[indexPath.row].profileURL), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feeds.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return view.frame.size.height/10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear
        return marginView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return .leastNonzeroMagnitude
    }
    
    
}
