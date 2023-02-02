//
//  ViewController.swift
//  PracticeFramework
//
//  Created by Паша on 23.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    //Label and Buttons
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet var actionButtons: [UIButton]!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    
    // SegmentedControl
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //TextField
    @IBOutlet weak var textField: UITextField!
    
    //Slider
    
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.isHidden = true
        label.alpha = 0
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0, delay: 3, options: .curveEaseIn, animations: {
            self.label.alpha = 1

        }) { (finished) in
            self.activityIndicator.stopAnimating()
            self.label.isHidden = false

        }
        
        actionButtons[2].setTitle("Clear", for: .normal)
        slider.value = 1
        
        label.font = label.font.withSize(35)
        
        for button in actionButtons {
            button.setTitleColor(.blue, for: .normal)
            button.backgroundColor = .green
        }
        
        actionButtons[2].backgroundColor = .red
        
        // SegmentedControl
        label.font = label.font.withSize(35)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        segmentedControl.insertSegment(withTitle: "Third", at: 2, animated: true)
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.minimumTrackTintColor = .yellow
        slider.maximumTrackTintColor = .red
        slider.thumbTintColor = .blue
        
    }
    
    
    
    @IBAction func pressedButton(_ sender: UIButton) {
        label.isHidden = false
        button.isHidden = false
        
        if sender.tag == 0 {
            label.text = "Hello, World!"
            label.textColor = .red
        } else if sender.tag == 1 {
            label.text = "Hi there!"
            label.textColor = .blue
        } else if sender.tag == 2 {
            label.text = nil
        }
    }
    
    @IBAction func choiceSegment(_ sender: UISegmentedControl) {
        
        label.isHidden = false
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            label.text = "The first segment is selected"
            label.textColor = .red
        case 1:
            label.text = "The second segment is selected"
            label.textColor = .blue
        case 2:
            label.text = "The third segment is selected"
            label.textColor = .yellow
        default:
            print("Something wrong!")
        }
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        
        label.text = String(slider.value)
        
        let backgroundColor = self.view.backgroundColor
        self.view.backgroundColor = backgroundColor?.withAlphaComponent(CGFloat(sender.value))
        
        if sender.value >= 0.5 {
            button.backgroundColor = .black.withAlphaComponent(CGFloat(sender.value))
            button.titleLabel?.textColor = .white
        }
        
        if sender.value < 0.5 {
            button.backgroundColor = .white.withAlphaComponent(1 - CGFloat(sender.value))
            button.titleLabel?.textColor = .black
        }
    }
    
    @IBAction func textViewButton(_ sender: UIButton) {
        
        func hasNumber (_ string:String!) -> Bool {
            for character in textField.text! {
                if character.isLetter == false {
                    return true
                }
                
            }
            return false
        }
        
        guard textField.text?.isEmpty == false else { return }
        if hasNumber(textField.text) == true {
            
            let alert = UIAlertController(title: "Wrong format", message: "Please enter your name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            print("Name format is wrong")
            textField.text = nil
        } else {
            label.text = textField.text
            
        }
    }
    
    //Next Screen
    
    
    @IBAction func firstNextScreenTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSecondScreen", sender: nil)
    }
    
    
    @IBAction func unwindToFirstVc(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
        
        
        
    }
