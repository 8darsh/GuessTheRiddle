//
//  ViewController.swift
//  Project8
//
//  Created by Adarsh Singh on 23/08/23.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAns: UITextField!
    var scoreLabel: UILabel!
    var letterBtn = [UIButton]()
    
    var activatedButton = [UIButton]()
    var solution = [String]()
    
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
       
        view.addSubview(cluesLabel)

        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAns = UITextField()
        currentAns.translatesAutoresizingMaskIntoConstraints = false
        currentAns.font = UIFont.systemFont(ofSize: 44)
        currentAns.textAlignment = .center
        currentAns.placeholder = "Tap Letter to guess"
        currentAns.isUserInteractionEnabled = false
        view.addSubview(currentAns)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("Submit", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
       
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("Clear", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
       
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),

            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
           
           
            
            currentAns.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAns.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAns.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAns.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)

            
        ])
        
        
        let width = 150
        let height = 80
        for row in 0..<4{
            for coloumn in 0..<5{
                let letterbtn = UIButton(type: .system)
                letterbtn.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterbtn.setTitle("WWW", for: .normal)
                letterbtn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let frame = CGRect(x: coloumn * width, y: row * height, width: width, height: height)
                
                letterbtn.frame = frame
                
                buttonsView.addSubview(letterbtn)
                
                
                letterBtn.append(letterbtn)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }
    
    @objc
    func letterTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text else {return}
        currentAns.text = currentAns.text?.appending(buttonTitle)
        
        activatedButton.append(sender)
        
        sender.isHidden = true
    }
    @objc
    func submitTapped(_ sender: UIButton){
        guard let ansText = currentAns.text else {return}
        
        if let solPosition = solution.firstIndex(of: ansText){
            activatedButton.removeAll()
            
            var splitAns = answersLabel.text?.components(separatedBy: "\n")
            splitAns?[solPosition] = ansText
            answersLabel.text = splitAns?.joined(separator: "\n")
            
            currentAns.text = ""
            
            score += 1
            
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well Done! Son", message: "Are U ready my friend for next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's Go", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
    }
    @objc
    func clearTapped(_ sender: UIButton){
        currentAns.text = ""
        for btn in activatedButton{
            btn.isHidden = false
        }
        
        activatedButton.removeAll()
    }
    
    func loadLevel(){
        
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let url = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContent = try? String(contentsOf: url){
                var lines = levelContent.components(separatedBy: "\n")
                lines.shuffle()
                
                for(index, line) in lines.enumerated(){
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1).  \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) Letters\n"
                    solution.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterBtn.count{
            for i in 0..<letterBtn.count{
                letterBtn[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction){
        level += 1
        
        solution.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in letterBtn{
            btn.isHidden = false
        }
        
    }
    


}

