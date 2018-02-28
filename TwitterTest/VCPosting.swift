//
//  VCPosting.swift
//  TwitterTest
//
//  Created by vigneswaran on 27/02/18.
//  Copyright © 2018 vigneswaran. All rights reserved.
//

import UIKit

class VCPosting: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    var userUID:String?
    var listOfPodt = [Post]()
    
    @IBOutlet weak var tvListPodt: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("User uid is \(userUID!)")
        
        listOfPodt.append(Post(postText:"",userUID:"@#$2@",postDate:"",postImage:""))
        tvListPodt.delegate = self
        tvListPodt.dataSource = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPodt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellAdd = tableView.dequeueReusableCell(withIdentifier: "cellAddPost", for: indexPath) as! TVCAddPost
        cellAdd.userUID = self.userUID
        cellAdd.main = self
        return cellAdd
    }

}
