//
//  ViewController4.swift
//  PracticeFramework
//
//  Created by Паша on 30.11.2022.
//

import UIKit

class ViewController4: UIViewController {
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var trackTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = UIImage(named: trackTitle)
        titleLabel.text = trackTitle
        titleLabel.numberOfLines = 0
        
    }
        
    }
