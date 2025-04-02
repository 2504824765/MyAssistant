//
//  Game2048VC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/29.
//

import UIKit

enum Difficulty {
    case Easy
    case General
    case Difficult
}

class Game2048VC: UIViewController {
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var point11: UILabel!
    @IBOutlet weak var point12: UILabel!
    @IBOutlet weak var point13: UILabel!
    @IBOutlet weak var point14: UILabel!
    @IBOutlet weak var point21: UILabel!
    @IBOutlet weak var point22: UILabel!
    @IBOutlet weak var point23: UILabel!
    @IBOutlet weak var point24: UILabel!
    @IBOutlet weak var point31: UILabel!
    @IBOutlet weak var point32: UILabel!
    @IBOutlet weak var point33: UILabel!
    @IBOutlet weak var point34: UILabel!
    @IBOutlet weak var point41: UILabel!
    @IBOutlet weak var point42: UILabel!
    @IBOutlet weak var point43: UILabel!
    @IBOutlet weak var point44: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var heighestScoreLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var difficultyButton: UIButton!
    
    var gameBoard: GameBoard = GameBoard(size: 4)
    var isOver: Bool = false
    var difficulty: Difficulty = .General
    
    @IBAction func difficultyOption(_ sender: UIMenuElement) {
        difficultyButton.setTitle(sender.title, for: .normal)
        if sender.title == "简单" {
            difficulty = .Easy
        } else if sender.title == "一般" {
            difficulty = .General
        } else if sender.title == "困难" {
            difficulty = .Difficult
        }
    }
    
    func afterPressConfirm() {
        self.gameBoard = GameBoard()
        self.gameBoard.addRandomNumber(count: 10)
        self.setupGame()
        self.isOver = false
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        alert_AreYouSureToStartNewGame {
            self.gameBoard = GameBoard()
            self.gameBoard.addRandomNumber(count: 10)
            self.setupGame()
            self.isOver = false
        }
    }
    
    @objc func handleSwipe (_ gesture: UISwipeGestureRecognizer) {
        var count: Int
        switch difficulty {
        case .Easy:
            // 简单难度：每走一步增加一个
            count = 1
        case .General:
            // 一般难度：两个一个交替增加
            if gameBoard.step % 2 == 1 {
                count = 2
            } else {
                count = 1
            }
        case .Difficult:
            // 困难难度：每走一步增加两个
            count = 2
        }
        switch gesture.direction {
        case .up:
            gameBoard.move(direction: .up)
            break
        case .down:
            gameBoard.move(direction: .down)
            break
        case .left:
            gameBoard.move(direction: .left)
            break
        case .right:
            gameBoard.move(direction: .right)
            break
        default:
            print("ERROR: Cannot recognize swipe direction")
            break
        }
        gameBoard.addRandomNumber(count: count)
        UpdatePoints()
        gameBoard.calculateTotalScore()
        if gameBoard.isOver() {
            gameOver()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // If there's an old game
        if readGameBoardUsingUserDefaults().size != 0 {
            alert_AreYouSure2ContinueOlderGame {
                self.gameBoard = readGameBoardUsingUserDefaults()
                self.setupGame()
            } cancelAction: {
                self.gameBoard.addRandomNumber(count: 10)
                self.setupGame()
            }

        } else {
            gameBoard.addRandomNumber(count: 10)
            setupGame()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isOver {
            saveGameBoardUsingUserDefaults(gameBoard)
        }
    }
}
