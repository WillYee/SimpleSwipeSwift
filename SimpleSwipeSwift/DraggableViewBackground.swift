//
//  DraggableViewBackground.swift
//  SimpleSwipeSwift
//
//  Created by Yan Yu on 6/10/15.
//  Copyright © 2015 Yan Yu. All rights reserved.
//

import UIKit

class DraggableViewBackground: UIView, DraggableViewDelegate
{
    let cardLabels: Array<String> = ["first", "second", "third", "fourth", "last"] // example data
    
    var currentCardIndex = 0 // the index of the card you have loaded into the loadedCards array last
    var loadedCards      = Array<DraggableView>() // the array of card loaded (change max_buffer_size to increase or decrease the number of cards this holds)
    var allCards         = Array<DraggableView>() // all the cards

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        currentCardIndex = 0
        self.loadCards()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // action called when the card goes to the left.
    // This should be customized with your own action
    func cardSwipedLeft(cardview: UIView) {
        
        //do whatever you want with the card that was swiped
        // var card: DraggableView = cardView as! DraggableView
        
        if (loadedCards.count > 0) {
            
            loadedCards.removeAtIndex(0)
            if (currentCardIndex < allCards.count) {
                
                loadedCards.append(allCards[currentCardIndex])
                currentCardIndex++
                self.insertSubview(loadedCards[Globals.MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[Globals.MAX_BUFFER_SIZE - 2])
            }
        }
    }
    
    // action called when the card goes to the right.
    // This should be customized with your own action
    func cardSwipedRight(cardView: UIView) {

        //do whatever you want with the card that was swiped
        // var card: DraggableView = cardView as! DraggableView
        
        if (loadedCards.count > 0) {
            
            
            loadedCards.removeAtIndex(0)
            if (currentCardIndex < allCards.count) {
                loadedCards.append(allCards[currentCardIndex])
                currentCardIndex++
                self.insertSubview(loadedCards[Globals.MAX_BUFFER_SIZE - 1], belowSubview: loadedCards[Globals.MAX_BUFFER_SIZE - 2])
            }
        }
    }
    
    private func setupView() -> Void {
        self.backgroundColor = UIColor(colorLiteralRed: 0.92, green: 0.93, blue: 0.95, alpha: 1)
    }
    
    // loads all the cards and puts the first x in the "loaded cards" array
    private func loadCards() -> Void {
        if (cardLabels.count > 0) {
            
            // if the buffer size is greater than the data size, there will be an array error, so this makes sure that doesn't happen
            let numLoadedCap = min(Globals.MAX_BUFFER_SIZE, cardLabels.count)
            
            // loops through the exampleCardsLabels array to create a card for each label.  This should be customized by removing "cardLabels" with your own array of data
            for (index, _) in cardLabels.enumerate() {
                let newCard = createDraggableViewWithDataAtIndex(index)
                
                guard let newCardValidated = newCard else {
                    print("Card creation failed, bailing out")
                    return
                }
                
                allCards.append(newCardValidated)
                
                if (index < numLoadedCap) {
                    // adds a small number of cards to be loaded
                    loadedCards.append(newCardValidated)
                }
            }
            
            // displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
            // are showing at once and clogging a ton of data
            for (index, card) in loadedCards.enumerate() {
                
                guard let cardViewValidated:DraggableView = card else {
                    print("card is not valid, bailout now")
                    return
                }
                
                if (index > 0) {
                    self.insertSubview(cardViewValidated, aboveSubview: loadedCards[index - 1])
                }
                else {
                    self.addSubview(cardViewValidated)
                }
                currentCardIndex++ // we loaded a card into loaded cards, so we have to increment
            }
        }
    }
    
    // creates a card and returns it.  This should be customized to fit your needs.
    // use "index" to indicate where the information should be pulled.  If this doesn't apply to you, feel free
    // to get rid of it (eg: if you are building cards from data from the internet)
    private func createDraggableViewWithDataAtIndex(index: Int) -> DraggableView? {
        let frame = CGRectMake((self.frame.size.width - Globals.CARD_WDITH)/2, (self.frame.size.height - Globals.CARD_HEIGHT)/2, Globals.CARD_WDITH, Globals.CARD_HEIGHT)
        let view = DraggableView(frame: frame)
        
        guard let viewInfo = view.information else {
            print("View creation failed!")
            return nil
        }

        viewInfo.text = cardLabels[index]
        view.delegate = self
        return view
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    //    override func drawRect(rect: CGRect) {
    //        // Drawing code
    //    }

}