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
        }else if(post.postImage == "No Image"){
            let cellWithoutImage = tableView.dequeueReusableCell(withIdentifier: "cellWithoutPost", for: indexPath) as! TVCPostWithoutImage
            cellWithoutImage.setText(post: post)
            return cellWithoutImage
        }else{
            let cellWithImage = tableView.dequeueReusableCell(withIdentifier: "cellWithImage", for: indexPath) as! TVCPostWithText
            cellWithImage.setText(post: post)
            return cellWithImage
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
                        
                        var postDate:CLong?
                        if let postDateF = postDic["postDate"] as? CLong{
                            postDate = postDateF
                        }
                        
                        var postImage:String?
                        if let postImageF = postDic["imagePath"] as? String{
                            postImage = postImageF
                        }
                        self.listOfPodt.append(Post(postText:postText!,userUID:userUID!,postDate: " \(postDate!)",postImage:postImage!))
                    }
                }
                self.tvListPodt.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = listOfPodt[indexPath.row]
        
        if(post.userUID == "@#$2@"){
            
            return 169
        }else if(post.postImage == "No Image"){
            
            return 144
        }else{
            
            return 231
        }
    }

}
