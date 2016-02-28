//
//  ImageDetailViewController.swift
//  HipoIntern
//
//  Created by tuğçe on 26/02/16.
//  Copyright © 2016 tuğçe. All rights reserved.
//

import UIKit
import Haneke

class ImageDetailViewController: UIViewController {
    var imageURL = ""
    @IBOutlet weak var detailImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImage.hnk_setImageFromURL(NSURL(string: imageURL)!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
