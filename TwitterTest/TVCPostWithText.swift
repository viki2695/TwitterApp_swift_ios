//
//  TVCPostWithText.swift
//  TwitterTest
//
//  Created by vigneswaran on 01/03/18.
//  Copyright © 2018 vigneswaran. All rights reserved.
//

import UIKit
import Firebase

class TVCPostWithText: UITableViewCell {

    @IBOutlet weak var txtPostText: UITextView!
    @IBOutlet weak var iv_postImage: UIImageView!
    @IBOutlet weak var ivPersonImage: UIImageView!
    @IBOutlet weak var txtPersonName: UILabel!
    @IBOutlet weak var txtPostDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(post:Post){
        txtPostText.text = post.postText!
        txtPostDate.text = post.postDate!
        setImage(url: post.postImage!)
        loadPostFromFirebase(userUID:post.userUID!)
    }
    
    func setImage(url:String){
        let storageRef = Storage.storage().reference(forURL: "gs://learningapps-b68f9.appspot.com")   //creating reference for firebase storage
        let postImageRef = storageRef.child(url)  //setting posts folder image with reference
        postImageRef.getData(maxSize: 8 * 1024 * 1024){
            data, error in
            
            if let error = error {
                print("Cannot show post images due to error")
            }else{
                self.iv_postImage.image = UIImage(data: data!)
            }
        }
    }
    
    var ref = DatabaseReference.init()
    func loadPostFromFirebase(userUID:String){
        self.ref = Database.database().reference()
        self.ref.child("Users").child(userUID).observe(.value, with: {
            (snapshot) in
            
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let postKey = snap.key as? String{
                        
                        if postKey == "fullname" {
                            let fullName = snap.value as? String
                            
                            self.txtPersonName.text = fullName
                        }
                        
                        if postKey == "UserImagePath" {
                            let UserImagePath = snap.value as? String
                            self.setUserImage(url:UserImagePath!)
                        }
                    }
                }
            }
        })
    }
    
    func setUserImage(url:String){
        let storageRef = Storage.storage().reference(forURL: "gs://learningapps-b68f9.appspot.com")   //creating reference for firebase storage
        let postImageRef = storageRef.child(url)  //setting posts folder image with reference
        postImageRef.getData(maxSize: 8 * 1024 * 1024){
            data, error in
            
            if let error = error {
                print("Cannot show post images due to error")
            }else{
                self.ivPersonImage.image = UIImage(data: data!)
            }
        }
    }
}
