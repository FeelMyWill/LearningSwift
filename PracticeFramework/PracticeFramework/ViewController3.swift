//
//  ViewController3.swift
//  PracticeFramework
//
//  Created by Паша on 27.11.2022.
//

import UIKit

class ViewController3: UIViewController {
    
    
    @IBOutlet weak var secondPrevScreenButton: UIButton!
    @IBOutlet weak var thirdNextScreenButton: UIButton!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var returnTextButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        returnTextButton.isHidden = true
        returnTextButton.setTitle("Обновить и вернуть текст", for: .normal)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .gray
        
        textView.delegate = self
        textView.isHidden = true
        
        textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        textView.backgroundColor = self.view.backgroundColor
        textView.layer.cornerRadius = 10
        
        stepper.value = 17
        stepper.minimumValue = 10
        stepper.maximumValue = 25
        
        stepper.tintColor = .white
        stepper.backgroundColor = .gray
        stepper.layer.cornerRadius = 5
        
        progressView.setProgress(0, animated: true)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.progressView.progress != 1 {
                self.progressView.progress += 0.25
            } else {
                self.textView.isHidden = false
                self.progressView.isHidden = true
                self.returnTextButton.isHidden = false
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true) //Скрытие клавиатуры вызванной для любого объекта
        
        //        textView.resignFirstResponder() //Скрытие клавиатуры вызванной для конкретного объекта
    }
    
    @objc func updateTextView(notification: Notification) {
        
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0,
                                                 left: 0,
                                                 bottom: keyboardFrame.height - textViewBottomConstraint.constant,
                                                 right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
            textView.scrollRangeToVisible(textView.selectedRange)
        }
    }
    
    @IBAction func secondPreviousButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegue2", sender: nil)
        
    }
    
    @IBAction func thirdNextScreenButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToFourthScreen", sender: nil)
    }
    
    
    @IBAction func sizeFont(_ sender: UIStepper) {
        
        let font = textView.font?.fontName
        let fontSize = CGFloat(sender.value)
        
        textView.font = UIFont(name: font!, size: fontSize)
    }
    
    @IBAction func unwindToThirdVc(_ unwindSegue3: UIStoryboardSegue) {
        
    }
    
    @IBAction func returnTextButtonTapped(_ sender: UIButton) {
        
        self.activityIndicator.startAnimating()
        
        if self.progressView.progress == 1 {
            self.textView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 2.5, options: .curveEaseOut , animations: {
                self.textView.alpha = 1
            }) { (finished) in
                
                let txtView = "Manage the keyboard When the user taps in an editable text view, that text view becomes the first responder and automatically asks the system to display the associated keyboard. Because the appearance of the keyboard has the potential to obscure portions of your user interface, it’s up to you to make sure that doesn’t happen by repositioning any views that might be obscured. Some system views, like table views, help you by scrolling the first responder into view automatically. If the first responder is at the bottom of the scrolling region, however, you may still need to resize or reposition the scroll view itself to ensure the first responder is visible. It’s your application’s responsibility to dismiss the keyboard at the time of your choosing. You might dismiss the keyboard in response to a specific user action, such as the user tapping a particular button in your user interface. To dismiss the keyboard, send the resignFirstResponder() message to the text view that’s currently the first responder. Doing so causes the text view object to end the current editing session (with the delegate object’s consent) and hide the keyboard. The appearance of the keyboard itself can be customized using the properties provided by the UITextInputTraits protocol. Text view objects implement this protocol and support the properties it defines. You can use these properties to specify the type of keyboard (ASCII, Numbers, URL, Email, and others) to display. You can also configure the basic text entry behavior of the keyboard, such as whether it supports automatic capitalization and correction of the text."
               
                self.textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
                self.stepper.value = 17
                self.textView.text = txtView
                self.textView.isHidden = false
                
                UIActivityIndicatorView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.activityIndicator.stopAnimating()
                }) { (finished) in
                    
                }
                
            }
            
        }
    }
}

    extension ViewController3: UITextViewDelegate {
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.backgroundColor = .lightGray
            textView.textColor = .black
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            textView.backgroundColor = self.view.backgroundColor
            textView.textColor = .black
        }
    }
