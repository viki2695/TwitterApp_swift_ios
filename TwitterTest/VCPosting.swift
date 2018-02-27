//
//  VCPosting.swift
//  TwitterTest
//
//  Created by vigneswaran on 27/02/18.
//  Copyright © 2018 vigneswaran. All rights reserved.
//

import UIKit

class VCPosting: UIViewController {

    
    var userUID:String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("User uid is \(userUID!)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
