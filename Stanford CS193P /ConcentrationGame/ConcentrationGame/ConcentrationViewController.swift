//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Паша on 01.12.2022.
//

import UIKit

class ConcentrationViewController: VCLLoggingViewController {
    
    override var vclLoggingName: String {
        return "Game"
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth : 5.0,
            .strokeColor : UIColor.black
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    lazy var visButtons = cardButtons.count
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var visibleButtonsLabel: UILabel!
    
    @IBOutlet private var cardButtons:   [UIButton]!
    
//    @IBOutlet private weak var startButton: UIButton!
//
//    @IBOutlet private weak var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//
//        flipCountLabel.isHidden = false
//        for button in cardButtons {
//            button.isHidden = true
//        }
//        visibleButtonsLabel.isHidden = true
//        restartButton.isHidden = true
//
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        
            if let cardNumber = cardButtons.firstIndex(of: sender) {
                game.chooseCard(at: cardNumber)
                updateViewFromModel()
                if sender.isHidden == false {
                        flipCount += 1
                }
            } else {
                print("chosen card was not in cardButtons")
            }
    }
    
    // MARK: TestingMark
    
    private func updateViewFromModel() {
        
        if cardButtons != nil {
            
            visibleButtonsLabel.text = "Visible Buttons: \(visButtons)"
            
            for index in cardButtons.indices {
                let button = cardButtons[index]
                let card = game.cards[index]
                
                if flipCount == 0 {
                    visButtons = cardButtons.count
                }
                if visButtons == 1 {
                    for button in cardButtons {
                        button.isHidden = true
                    }
                    visibleButtonsLabel.text = "Congratulations!"
                    flipCountLabel.text = ""
//                    restartButton.isHidden = false
                }
                if card.isFaceUp {
                    if (card.isMatched){
                        visButtons -= 1
                    }
                    button.setTitle(emoji(for: card), for: .normal)
                    button.backgroundColor = .lightGray
                } else {
                    button.setTitle("", for: .normal)
                    button.backgroundColor = card.isMatched ? .black : .blue
                    if button.backgroundColor == .black {
                        button.isHidden = true
                    }
                }
            }
        }
    }
    
//    private var emojiChoices = ["🎃", "👻", "😵", "☠️", "🤖", "👽", "🧌", "🦹‍♂️", "😱"]
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
    private var emojiChoices = ""
    private var emoji =  [Card:String]()
    
    private func emoji(for card: Card) -> String {
        
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
//    @IBAction private func startButtonTapped(_ sender: UIButton) {
//        startButton.isHidden = true
//        flipCountLabel.isHidden = false
//        for button in cardButtons {
//            button.isHidden = false
//        }
//        visibleButtonsLabel.isHidden = false
//    }
    
    //restart button
//    @IBAction private  func restartButtonTapped(_ sender: UIButton) {
//
//        game.restart()
//        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
//        restartButton.isHidden = true
//        flipCount = 0
//        emojiChoices = "🎃👻😵☠️🤖👽🧌🦹‍♂️😱"
//        for button in cardButtons {
//            button.isHidden = false
//            button.backgroundColor = .blue
//            button.setTitle("", for: .normal)
//        }
//        visibleButtonsLabel.text = "Visible Buttons: \(cardButtons.count)"
//        visButtons = cardButtons.count
//
//        //        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
//        //        for button in cardButtons {
//        //            button.isHidden = false
//        //        }
//        //        restartButton.isHidden = true
//        //        flipCount = 0
//        //        emojiChoices = ["🎃", "👻", "😵", "☠️", "🤖", "👽", "🧌", "🦹‍♂️", "😱"]
//        //        for button in cardButtons {
//        //            button.backgroundColor = .orange
//        //            button.setTitle("", for: .normal)
//        //        }
//        //        visibleButtonsLabel.text = "Visible Buttons: \(cardButtons.count)"
//    }
    
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

