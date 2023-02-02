//
//  ViewController2.swift
//  PracticeFramework
//
//  Created by Паша on 24.11.2022.
//

import UIKit

class ViewController2: UIViewController{

    var uiElementsVC2 = [
        "UIDatePicker",
        "UISwitch",
        "UIDateLabel",
        "UIPrevScreenButton",
        "Показать все элементы"
    ]
    
    var selectedElement: String?
    
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var firstPrevScreen: UIButton!
    @IBOutlet weak var secondNextScreenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchLabel.text = "Скрыть все объекты"

        datePicker.locale = Locale(identifier: "ru_RU")
        
        choiceUIElement()
        createToolBar()
    }
    
    func hideAllElements() {
        datePicker.isHidden = true
        `switch`.isHidden = true
        dateLabel.isHidden = true
        firstPrevScreen.isHidden = true
    }
    
    func choiceUIElement() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        
        textField2.inputView = elementPicker
        
        //Customization
        elementPicker.backgroundColor = .brown
    }

    func createToolBar() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain,
            target: self,
            action: #selector(dismissKeyboard))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        textField2.inputAccessoryView = toolbar
        
        // Customization
        toolbar.tintColor = .white
        toolbar.barTintColor = .brown
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func changeDate(_ sender: UIDatePicker) {
//        dateLabel.text = String?(sender.date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        let dateValue = dateFormatter.string(from: sender.date)
        dateLabel.text = dateValue
    }

    @IBAction func firsPreviousButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegue", sender: nil)
    }
    
   
    @IBAction func switchAction(_ sender: UISwitch) {
        dateLabel.isHidden = !dateLabel.isHidden
        datePicker.isHidden = !datePicker.isHidden
                
                if sender.isOn {
                    switchLabel.text = "Отобразить все объекты"
                } else {
                    switchLabel.text = "Скрыть все объекты"
                }
    }
    
    @IBAction func secondNextScreenButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToThirdScreen", sender: nil)
    }
    
    @IBAction func unwindToSecondVc(_ unwindSegue2: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }
    
}

extension ViewController2: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return uiElementsVC2.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return uiElementsVC2[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        selectedElement = uiElementsVC2[row]
        textField2.text = selectedElement
        
        switch row {
        case 0:
            hideAllElements()
            datePicker.isHidden = false
        case 1:
            hideAllElements()
            `switch`.isHidden = false
        case 2:
            hideAllElements()
            dateLabel.isHidden = false
        case 3:
            hideAllElements()
            firstPrevScreen.isHidden = false
        case 4:
            datePicker.isHidden = false
            `switch`.isHidden = false
            dateLabel.isHidden = false
            firstPrevScreen.isHidden = false
        default:
            hideAllElements()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerViewLabel = UILabel()
        
        if let currentLabel = view as? UILabel {
            pickerViewLabel = currentLabel
        } else {
            pickerViewLabel = UILabel()
        }
        
        pickerViewLabel.textColor = .white
        pickerViewLabel.textAlignment = .center
        pickerViewLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 23)
        pickerViewLabel.text = uiElementsVC2[row]
        
        return pickerViewLabel
    }
}
