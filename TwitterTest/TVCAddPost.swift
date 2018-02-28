//
//  TVCAddPost.swift
//  TwitterTest
//
//  Created by vigneswaran on 28/02/18.
//  Copyright © 2018 vigneswaran. All rights reserved.
//

import UIKit
import Firebase

class TVCAddPost: UITableViewCell,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var txtPostText: UITextView!
    var ref = DatabaseReference.init()
    var userUID:String?
    var imagePath:String = "No Image"
    var imagepicker:UIImagePickerController!
    var main: VCPosting?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func buAttachImage(_ sender: Any) {
        
        imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        
        main!.present(imagepicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            uploadUserImage(image: image)
            
        }
        imagepicker.dismiss(animated: true, completion: nil)
    }
    
    func uploadUserImage(image:UIImage){
        //upload image to firebase
        let storageRef = Storage.storage().reference(forURL : "gs://learningapps-b68f9.appspot.com")
        
        //creating data format for uploading image
        var data = NSData()
        data = UIImageJPEGRepresentation(image, 0.8) as! NSData   //setting the image picked with reference
        
        //setting up unique name for every image using time and user uid
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM_DD_YY_h_mm_a"
        let imageName = "\(self.userUID!)_\(dateFormat.string(from: NSDate() as Date))"  //complete firebase url for upload
        self.imagePath = "UserPosts/\(imageName).jpg"
        let childUserImage = storageRef.child(imagePath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        childUserImage.putData(data as Data, metadata: metaData) //uploading imagee
        
    }
    
    @IBAction func buPost(_ sender: Any) {
        
        ref = Database.database().reference()
        var postMsg = ["userUID":userUID!,
                       "text":txtPostText.text!,
                       "imagePath":imagePath,
                       "postDate":ServerValue.timestamp()] as [String:Any]
        ref.child("Posts").childByAutoId().setValue(postMsg )
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
