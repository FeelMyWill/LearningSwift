//
//  ViewController.swift
//  NamesCompApp
//
//  Created by Паша on 20.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var yourNameTF: UITextField!
    
    @IBOutlet weak var partnerNameTF: UITextField!
    
    @IBOutlet weak var lastComp: UILabel!
    
    @IBOutlet weak var previousResult: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastComp.text = ""
        previousResult.text = ""
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? ResultViewController else {return}
        destinationVC.firstName = yourNameTF.text
        destinationVC.secondName = partnerNameTF.text
    }
    
    
    @IBAction func resultButtonTapped() {
        guard let firstName = yourNameTF.text, let secondName = partnerNameTF.text else {return}
        if firstName.isEmpty || secondName.isEmpty {
            showAlert(
                title: "Names are missing",
                message: "Please enter both names ☺️"
            )
        }
        performSegue(withIdentifier: "goToResult", sender: nil)
    }
    
    @IBAction func unwindSegueToFirstVC(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegue" else { return }
        yourNameTF.text = ""
        partnerNameTF.text = ""
        
        guard let sourceVC = segue.source as? ResultViewController else {return}
        lastComp.text = "Last Result"
        
        previousResult.text = "\(sourceVC.namesLabel.text ?? "") with \( sourceVC.resultLabel.text ?? "")"
        
        
    }
}

extension ViewController {
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == yourNameTF {
            partnerNameTF.becomeFirstResponder()
        } else {
            resultButtonTapped()
        }
        return true
    }
    
}
