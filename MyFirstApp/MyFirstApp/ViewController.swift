//
//  ViewController.swift
//  MyFirstApp
//
//  Created by Паша on 19.11.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
// @IBOutlet weak var resultButton: UIButton!
    private var numberOfDays = ""
    var buttonVariable: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //resultButton.layer.cornerRadius = 12
    }

    @IBAction func datePicker(_ sender: UIDatePicker) {
        if sender.date < Date.now {
            let range = sender.date..<Date.now
            numberOfDays = range.formatted(.components(style: .wide, fields: [.day]))
            buttonVariable = 1
        }
            if numberOfDays == "0 дней" {
                buttonVariable = 0
            }
            
            if sender.date > Date.now {
                let range = Date.now..<sender.date
                numberOfDays = range.formatted(.components(style: .wide, fields: [.day]))
                buttonVariable = 2
                
            }
        }
    
    @IBAction func resultButtonTapped() {
        
        switch buttonVariable {
        case 1:
            infoLabel.text = "Ты наслаждаешься жизнью уже \(numberOfDays)"
            break
        case 2:
            infoLabel.text = "До наслаждения жизнью осталось: \(numberOfDays)"
            break
        case 0:
            infoLabel.text = "Поздравляем с рождением!"
            break
        default:
            infoLabel.text = "Поздравляем с рождением!"
        }
        }
    }
