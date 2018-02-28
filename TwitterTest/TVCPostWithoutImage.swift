//
//  TVCPostWithoutImage.swift
//  TwitterTest
//
//  Created by vigneswaran on 28/02/18.
//  Copyright © 2018 vigneswaran. All rights reserved.
//

import UIKit

class TVCPostWithoutImage: UITableViewCell {

    
    @IBOutlet weak var txtPostText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setText(postText:String){
        txtPostText.text = postText
    }

}
