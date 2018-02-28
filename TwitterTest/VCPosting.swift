//
//  VCPosting.swift
//  TwitterTest
//
//  Created by vigneswaran on 27/02/18.
//  Copyright © 2018 vigneswaran. All rights reserved.
//

import UIKit
import Firebase

class VCPosting: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var userUID:String?
    var listOfPodt = [Post]()
    var ref = DatabaseReference.init()
    @IBOutlet weak var tvListPodt: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        // Do any additional setup after loading the view.
        print("User uid is \(userUID!)")
        
        listOfPodt.append(Post(postText:"",userUID:"@#$2@",postDate:"",postImage:""))
        tvListPodt.delegate = self
        tvListPodt.dataSource = self
        loadPostFromFirebase()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPodt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = listOfPodt[indexPath.row]
        
        if(post.userUID == "@#$2@"){
            let cellAdd = tableView.dequeueReusableCell(withIdentifier: "cellAddPost", for: indexPath) as! TVCAddPost
            cellAdd.userUID = self.userUID
            cellAdd.main = self
            
            return cellAdd
        }else{
            let cellWithoutImage = tableView.dequeueReusableCell(withIdentifier: "cellWithoutPost", for: indexPath) as! TVCPostWithoutImage
            cellWithoutImage.setText(postText: post.postText!)
            return cellWithoutImage
        }
    }
    
    func loadPostFromFirebase(){
        self.ref.child("Posts").queryOrdered(byChild: "postDate").observe(.value, with: {
            (snapshot) in
            self.listOfPodt.removeAll()
            self.listOfPodt.append(Post(postText:"",userUID:"@#$2@",postDate:"",postImage:""))
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let postDic = snap.value as? [String:Any]{
                        
                        var postText:String?
                        if let postTextF = postDic["text"] as? String{
                            postText = postTextF
                        }
                        
                        var userUID:String?
                        if let userUIDF = postDic["userUID"] as? String{
                            userUID = userUIDF
                        }
                        
                        var postDate:String?
                        if let postDateF = postDic["postDate"] as? String{
                            postDate = postDateF
                        }
                        
                        var postImage:String?
                        if let postImageF = postDic["imagePath"] as? String{
                            postImage = postImageF
                        }
                        self.listOfPodt.append(Post(postText:postText!,userUID:userUID!,postDate:"",postImage:postImage!))
                    }
                }
                self.tvListPodt.reloadData()
            }
        })
    }

}
