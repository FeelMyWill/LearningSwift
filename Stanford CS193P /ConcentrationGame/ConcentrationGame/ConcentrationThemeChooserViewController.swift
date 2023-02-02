//
//  ConcentrationThemeChooserViewController.swift
//  ConcentrationGame
//
//  Created by Паша on 16.12.2022.
//

import UIKit

class ConcentrationThemeChooserViewController: VCLLoggingViewController, UISplitViewControllerDelegate {
    
    override var vclLoggingName: String {
        return "ThemeChooser"
    }
    
    let themes = [
        "Sports":"⚽️🏀⚾️🥊🏓⛸🏸🏒♟🏆🏂🥋",
        "Animals":"🐶🐯🐒🐷🐸🦅🐗🐺🐔🐰🐈🐿",
        "Faces":"😂😇😍🤓😎😋🥵🥺🤭🤢🤔🤡"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib() 
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
            }
        return false
        }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else {
            performSegue(withIdentifier: "ChooseTheme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseTheme" {
                if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                    if let cvc = segue.destination as? ConcentrationViewController {
                        cvc.theme = theme
                    }
                    }
                }
            }
            
        }


    
