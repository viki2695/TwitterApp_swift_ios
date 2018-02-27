//
//  ViewController.swift
//  TwitterTest
//
//  Created by vigneswaran on 27/02/18.
//  Copyright © 2018 vigneswaran. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var ivUserImage: UIImageView!
    var imagepicker:UIImagePickerController!
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        self.ref = Database.database().reference()
    }
    
    @IBAction func buPickImage(_ sender: Any) {
        present(imagepicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            ivUserImage.image = image
        }
        imagepicker.dismiss(animated: true, completion: nil)
    }
    
    var userUID:String?
    @IBAction func buLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: txtEmail.text!, password: txtPassword.text!){
            (user,error) in
            
            if let error = error{
                print(error)
            }else{
                print("Login is successfull \(user?.email)")
                self.userUID = user!.uid
                self.goToPosting()
            }
        }
    }
    
    @IBAction func buRegister(_ sender: Any) {
        Auth.auth().createUser(withEmail: txtEmail.text!, password: txtPassword.text!){
            (user,error) in
            
            if let error = error{
                print(error)
            }else{
                print("Registration sucessfull \(user?.email)")
                self.userUID = user!.uid
                
                self.uploadUserImage()
                self.goToPosting()
            }
        }
    }
   
    
    func uploadUserImage(){
        //upload image to firebase
        let storageRef = Storage.storage().reference(forURL : "gs://learningapps-b68f9.appspot.com")
        let image:UIImage = ivUserImage.image!
        //creating data format for uploading image
        var data = NSData()
        data = UIImageJPEGRepresentation(image, 0.8) as! NSData   //setting the image picked with reference
        
        //setting up unique name for every image using time and user uid
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM_DD_YY_h_mm_a"
        let imageName = "\(self.userUID!)_\(dateFormat.string(from: NSDate() as Date))"  //complete firebase url for upload
        let imagepath = "UserImages/\(imageName).jpg"
        let childUserImage = storageRef.child(imagepath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        childUserImage.putData(data as Data, metadata: metaData) //uploading imagee
        
        //save to database
        saveToFirebaseDatabase(UserImagePath: imagepath, UserName: txtFullName.text!)
        
    }
    
    func saveToFirebaseDatabase(UserImagePath:String, UserName:String){
        
        let msg = ["fullname" : UserName,
                   "UserImagePath" : UserImagePath]
        self.ref.child("Users").child(self.userUID!).setValue(msg)
    }
    
    func goToPosting(){
        performSegue(withIdentifier: "ShowPost", sender: self.userUID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPost" {
            if let vcPosting = segue.destination as? VCPosting{
                if let userUID = sender as? String {
                    vcPosting.userUID = userUID
                }
            }
        }
    }
    
}

