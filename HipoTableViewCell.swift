//
//  HipoTableViewCell.swift
//  HipoIntern
//
//  Created by tuğçe on 26/02/16.
//  Copyright © 2016 tuğçe. All rights reserved.
//

import UIKit
import Haneke
import Alamofire
import SwiftyJSON
class HipoTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var data : SwiftyJSON.JSON?{
        
        didSet
        {
            self.setupData()
        }
        
    }
   
    func setupData() {
    self.profileName.text = self.data?["user"]["full_name"].stringValue
        if let userImageViewString = self.data?["user"]["profile_picture"].stringValue {
            

            let url = NSURL(string: userImageViewString)
            
            self.profileImage.hnk_setImageFromURL(url!, placeholder: UIImage(named: "Blank_woman_placeholder"), format: nil, failure: nil, success: nil)
            
        }
        if let contentImageViewString = self.data?["images"]["standard_resolution"]["url"].stringValue {
            
            let url = NSURL(string: contentImageViewString)
            self.mainImage.hnk_setImageFromURL(url!, placeholder: UIImage(named: "placeholder1"), format: nil, failure: nil, success: nil)
        }
    }
    
    


}
