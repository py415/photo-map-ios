//
//  FullImageViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var pickedImageView: UIImageView!
    
    // MARK: - Properties
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set pickedImageView as pickedImage
        pickedImageView.image = pickedImage

    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

}
