//
//  ViewController.swift
//  project 7-9
//
//  Created by Diego Sebastián Monteagudo Díaz on 8/24/20.
//  Copyright © 2020 Diego Sebastián Monteagudo Díaz. All rights reserved.
//

import UIKit

class game: UIViewController {
    var word = ""
    var allWords: [String] = []
    var usedLetters : [String] = []
    var wrongAnswer = 0
    var score = 0
    var prompt = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLetter))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        self.title = "Points " + String(score)
        performSelector(inBackground: #selector(getData), with: nil)
        // Do any additional setup after loading the view.
        
        
        
        prompt.translatesAutoresizingMaskIntoConstraints = false
        prompt.backgroundColor = .green
        prompt.isUserInteractionEnabled = false
        
        view.addSubview(prompt)
        NSLayoutConstraint.activate([
            prompt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        prompt.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        prompt.widthAnchor.constraint(equalToConstant: 100),
        prompt.heightAnchor.constraint(equalToConstant: 20)])
        
        
        
        
    }
    
    @objc func refresh () {
        usedLetters.removeAll()
        getData()
        verify()
    }

    @objc func getData() {
       if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl ) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        guard let word = allWords.randomElement() else {return}
        self.word = word
        verify()
    }
    
    func verify () {
        var promptWord = ""
        for letter in word {
            let strLetter = String(letter)
            
            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        if !promptWord.contains("?"){
            let alert = UIAlertController(title: "WINNER", message: "YOU ARE THE BEST", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Play Againt", style: .destructive, handler: { (UIAlertAction) in
                self.refresh()
            }))
            self.present(alert, animated: true, completion: nil)
            self.score += 1
            self.title = "Points " + String(self.score)
        }
        DispatchQueue.main.async {
            self.prompt.text = promptWord
        }
    }
    
    @objc func addLetter () {
        let ac = UIAlertController(title: "Select a letter", message: "write a letter", preferredStyle: .alert)
        ac.addTextField {(textField) in
            textField.placeholder = "Enter a letter"
        }
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            action in
            if let text = ac.textFields?[0].text {
                if text.count > 1 || text.count == 0 {
                  return
               } else {
                    self.usedLetters.append(text)
                    if !self.word.lowercased().contains(text) {
                        self.wrongAnswer += 1
                    }
                    if self.wrongAnswer == 7 {
                        let alert = UIAlertController(title: "YOU LOST", message: "TRY AGAIN", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Play Again", style: .destructive) { (UIAlertAction) in
                            self.refresh()
                            self.score = 0
                            self.title = "Points " + String(self.score)
                        }
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
            }
            self.verify()
        }))
        present(ac, animated: true)
    }
}

