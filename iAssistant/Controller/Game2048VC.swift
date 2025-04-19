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
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    
    fileprivate func answerCorrect() {
        ProgressHUD.success("回答正确")
        // Remove least 2 and 4 from gameBoard
        for i in 0..<gameBoard.size {
            for j in 0..<gameBoard.size {
                if gameBoard.points[i][j] == 2 || gameBoard.points[i][j] == 4 {
                    gameBoard.points[i][j] = 0
                }
            }
        }
        answerView.isHidden = true
    }
    
    fileprivate func answerWrong() {
        ProgressHUD.error("回答错误\n游戏结束")
        // Update heighest score and save
        if gameBoard.score > gameBoard.heightScore {
            gameBoard.heightScore = gameBoard.score
            saveScore2048UsingUserDefaults(gameBoard.heightScore)
        }
        scoreLabel.text = gameBoard.score.description
        heighestScoreLabel.text = gameBoard.heightScore.description
        saveGameBoardUsingUserDefaults(GameBoard(size: 0))
        isOver = true
        answerView.isHidden = true
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        let answer = questions[questionIndex]["answer"]
        print(sender.tag)
        switch sender.tag {
        case 0:
            if answer == "A" {
                answerCorrect()
            } else {
                answerWrong()
            }
            break
        case 1:
            if answer == "B" {
                answerCorrect()
            } else {
                answerWrong()
            }
            break
        case 2:
            if answer == "C" {
                answerCorrect()
            } else {
                answerWrong()
            }
            break
        case 3:
            if answer == "D" {
                answerCorrect()
            } else {
                answerWrong()
            }
            break
        default:
            break
        }
        UpdatePoints()
        return
    }

    
    
    var gameBoard: GameBoard = GameBoard(size: 4)
    var isOver: Bool = false
    var difficulty: Difficulty = .General
    
    var questions: [[String: String]] = [
        [
            "question": "下列哪项是世界非物质文化遗产？",
            "options": "A. 京剧  B. 广场舞  C. 流行音乐  D. 电子游戏",
            "answer": "A"
        ],
        [
            "question": "端午节的传统习俗不包括以下哪项？",
            "options": "A. 吃粽子  B. 赛龙舟  C. 放鞭炮  D. 挂艾草",
            "answer": "C"
        ],
        [
            "question": "中国四大名绣不包括：",
            "options": "A. 苏绣  B. 湘绣  C. 蜀绣  D. 十字绣",
            "answer": "D"
        ],
        [
            "question": "二十四节气中，第一个节气是：",
            "options": "A. 立春  B. 雨水  C. 惊蛰  D. 春分",
            "answer": "A"
        ],
        [
            "question": "下列哪种乐器属于中国传统乐器？",
            "options": "A. 钢琴  B. 小提琴  C. 古筝  D. 萨克斯",
            "answer": "C"
        ],
        [
            "question": "中国传统医学\"望闻问切\"中的\"切\"是指：",
            "options": "A. 观察  B. 听声音  C. 询问  D. 把脉",
            "answer": "D"
        ],
        [
            "question": "下列哪项不是中国书法的主要书体？",
            "options": "A. 楷书  B. 行书  C. 草书  D. 印刷体",
            "answer": "D"
        ],
        [
            "question": "中国茶道文化中，下列哪种不是传统茶叶分类？",
            "options": "A. 绿茶  B. 红茶  C. 奶茶  D. 乌龙茶",
            "answer": "C"
        ],
        [
            "question": "中国传统节日中秋节的主要食品是：",
            "options": "A. 饺子  B. 汤圆  C. 月饼  D. 粽子",
            "answer": "C"
        ],
        [
            "question": "下列哪项不是中国非物质文化遗产？",
            "options": "A. 剪纸  B. 皮影戏  C. 太极拳  D. 智能手机",
            "answer": "D"
        ]
    ]
    var questionIndex = 0
    
    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyCommand.inputUpArrow, modifierFlags: [], action: #selector(handleUpArrow)),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow, modifierFlags: [], action: #selector(handleDownArrow)),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow, modifierFlags: [], action: #selector(handleLeftArrow)),
            UIKeyCommand(input: UIKeyCommand.inputRightArrow, modifierFlags: [], action: #selector(handleRightArrow))
        ]
    }
                         
     @objc func handleUpArrow() {
         gameBoard.move(direction: .up)
         gameBoard.addRandomNumber(count: 2)
         UpdatePoints()
         gameBoard.calculateTotalScore()
         if gameBoard.isOver() {
             questionIndex = Int.random(in: 0..<questions.count)
             gameOver(index: questionIndex)
         }
     }
    
    @objc func handleDownArrow() {
        gameBoard.move(direction: .down)
        gameBoard.addRandomNumber(count: 2)
        UpdatePoints()
        gameBoard.calculateTotalScore()
        if gameBoard.isOver() {
            questionIndex = Int.random(in: 0..<questions.count)
            gameOver(index: questionIndex)
        }
    }
    
    @objc func handleLeftArrow() {
        gameBoard.move(direction: .left)
        gameBoard.addRandomNumber(count: 2)
        UpdatePoints()
        gameBoard.calculateTotalScore()
        if gameBoard.isOver() {
            questionIndex = Int.random(in: 0..<questions.count)
            gameOver(index: questionIndex)
        }
    }
    
    @objc func handleRightArrow() {
        gameBoard.move(direction: .right)
        gameBoard.addRandomNumber(count: 2)
        UpdatePoints()
        gameBoard.calculateTotalScore()
        if gameBoard.isOver() {
            questionIndex = Int.random(in: 0..<questions.count)
            gameOver(index: questionIndex)
        }
    }
    
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
            questionIndex = Int.random(in: 0..<questions.count)
            gameOver(index: questionIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerView.isHidden = true
        answerView.layer.cornerRadius = 10
        
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
