//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hangmanInputTextField: UITextField!
    @IBOutlet weak var incorrectLettersLabel: UILabel!
    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var hangmanWordLabel: UILabel!
    @IBOutlet weak var guessButton: UIButton!
    
    var correctWord: String!
    var wrongLetters: String!
    var inputLetter: String!
    var triedLetters: String!
    var correctLetterCount: Int = 0
    var currentLetterCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeView() {
        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        self.correctWord = phrase!.lowercased()
        self.wrongLetters = ""
        self.triedLetters = ""
        self.inputLetter = ""
        self.hangmanInputTextField.text = ""
        self.hangmanWordLabel.text = ""
        self.incorrectLettersLabel.text = ""
        setupHangmanWord(phrase!)
        
        hangmanInputTextField.delegate = self
        guessButton.addTarget(self, action: #selector(guessButtonPressed), for: .touchUpInside)
    }
    
    func setupHangmanWord (_ hangmanWord: String) {
        self.hangmanImage.image = UIImage(named: "hangman1.gif")
        
        self.correctLetterCount = hangmanWord.characters.count
        self.currentLetterCount = 0
        for i in 0..<hangmanWord.characters.count {
            if hangmanWord.substring(atIndex: i) == " " {
                self.hangmanWordLabel.text! += " "
                self.currentLetterCount += 1
            } else {
                self.hangmanWordLabel.text! += "-"
            }
        }
    }
    
    // MARK: UITextFieldDelegate
    // Only 1 letter allowed for input
    let TEXT_FIELD_LIMIT = 1
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let shouldShowLetter = ((textField.text?.characters.count ?? 0) + string.characters.count - range.length) <= TEXT_FIELD_LIMIT && string != " "
        if shouldShowLetter {
            inputLetter = string
        }
        return shouldShowLetter
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Guess button methods
    func guessButtonPressed() {
        self.checkHangmanLetter(inputLetter!)
        inputLetter = ""
        hangmanInputTextField.text = ""
    }
    
    // MARK: Alert views
    func winAlert() {
        alert("YOU WIN!")
    }
    
    func loseAlert() {
        alert("YOU LOSE")
    }
    
    func alert(_ alertTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: "The word was: \(self.correctWord!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.default, handler: {action in
                self.initializeView()
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Hangman methods
    func checkHangmanLetter (_ letterToCheck: String) {
        let letterToCheck = letterToCheck.lowercased()
        // Check if the character was already tried
        if (triedLetters.range(of: letterToCheck) != nil) {
            return
        }
        // If character was not already tried, then add it to string of already tried characters and proceed to try it
        triedLetters.append(letterToCheck)
        
        var isMatch = false
        
        for i in 0..<self.correctWord.characters.count {
            if (letterToCheck == correctWord.substring(atIndex: i)) {
                isMatch = true
                let start = hangmanWordLabel.text!.startIndex
                let index = hangmanWordLabel.text!.index(start, offsetBy: i)
                hangmanWordLabel.text!.replaceSubrange(index...index, with: letterToCheck)
                self.currentLetterCount += 1
            }
        }
        
        if (self.currentLetterCount == self.correctLetterCount) {
            self.winAlert()
            
        } else if (!isMatch) {
            if (self.wrongLetters.range(of: letterToCheck) == nil) {
                self.wrongLetters.append(letterToCheck)
                self.incorrectLettersLabel.text! = wrongLetters
            }
            
            switch(wrongLetters.characters.count) {
                case 1:
                    self.hangmanImage.image = UIImage(named: "hangman2.gif")
                case 2:
                    self.hangmanImage.image = UIImage(named: "hangman3.gif")
                case 3:
                    self.hangmanImage.image = UIImage(named: "hangman4.gif")
                case 4:
                    self.hangmanImage.image = UIImage(named: "hangman5.gif")
                case 5:
                    self.hangmanImage.image = UIImage(named: "hangman6.gif")
                case 6:
                    self.hangmanImage.image = UIImage(named: "hangman7.gif")
                    self.loseAlert()
                default:
                    break
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
