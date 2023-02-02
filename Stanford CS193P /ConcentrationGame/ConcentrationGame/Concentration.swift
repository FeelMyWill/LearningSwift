//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by Паша on 02.12.2022.
//
 
import Foundation

struct Concentration
{
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            return faceUpCardIndicies.count == 1 ? faceUpCardIndicies.first : nil
//            var foundindex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundindex == nil {
//                        foundindex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundindex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                //check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
        
    }
    
//    mutating func restart() {
//        cards.removeAll()
//        indexOfOneAndOnlyFaceUpCard = nil
//    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(at: \(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        // TODO: Shuffle the cards
        cards.shuffle()
    }
    
}

extension Collection {
    var oneAndOnly : Element? {
        return count == 1 ? first : nil
    }
}
