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
    var correctWord: String!
    var wrongLetters: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        self.correctWord = phrase
        setupHangmanWord(phrase!)
        hangmanInputTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    // Only 1 letter allowed for input
    let TEXT_FIELD_LIMIT = 1
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return ((textField.text?.characters.count ?? 0) + string.characters.count - range.length) <= TEXT_FIELD_LIMIT && string != " "
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        self.checkHangmanLetter(textField.text!)
        return true
    }
  
    // MARK: Hangman methods
    func checkHangmanLetter (_ letterToCheck: String) {
        var isMatch = false
        
        for i in 0..<self.correctWord.characters.count {
            if (letterToCheck == correctWord.lowercased().substring(atIndex: i)
                || letterToCheck == correctWord.uppercased().substring(atIndex: i)) {
                
                isMatch = true
                let start = hangmanWordLabel.text!.startIndex
                let index = hangmanWordLabel.text!.index(start, offsetBy: i)
                hangmanWordLabel.text!.replaceSubrange(index...index, with: letterToCheck)
            }
        }
        print(isMatch)
        if (!isMatch) {
            if self.wrongLetters.lowercased().range(of: letterToCheck) == nil
                && self.wrongLetters.uppercased().range(of: letterToCheck) == nil {
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
                default:
                    self.setupHangmanWord(self.correctWord)
            }
        }
    }
    
    func setupHangmanWord (_ hangmanWord: String) {
        self.wrongLetters = ""
        self.hangmanWordLabel.text = ""
        self.hangmanImage.image = UIImage(named: "hangman1.gif")
        
        for i in 0..<hangmanWord.characters.count {
            if hangmanWord.substring(atIndex: i) == " " {
                self.hangmanWordLabel.text! += " "
            }
            self.hangmanWordLabel.text! += "-"
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
