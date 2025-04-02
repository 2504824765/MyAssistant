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
        print(difficulty)
    }
    
    @IBAction func newGameButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "提示", message: "确定要开始新游戏吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { _ in
            self.gameBoard = GameBoard()
            self.gameBoard.addRandomNumber(count: 10)
            self.setupGame()
            self.isOver = false
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
        }))
        self.present(alert, animated: true)
    }
    
    fileprivate func color4Value(_ value: Int) -> UIColor {
        switch value {
        case 0: return UIColor(red: 238/255, green: 228/255, blue: 218/255, alpha: 1)
        case 2: return UIColor(red: 238/255, green: 228/255, blue: 218/255, alpha: 1)
        case 4: return UIColor(red: 237/255, green: 224/255, blue: 200/255, alpha: 1)
        case 8: return UIColor(red: 242/255, green: 177/255, blue: 121/255, alpha: 1)
        case 16: return UIColor(red: 245/255, green: 149/255, blue: 99/255, alpha: 1)
        case 32: return UIColor(red: 246/255, green: 124/255, blue: 95/255, alpha: 1)
        case 64: return UIColor(red: 246/255, green: 94/255, blue: 59/255, alpha: 1)
        case 128: return UIColor(red: 237/255, green: 207/255, blue: 114/255, alpha: 1)
        case 256: return UIColor(red: 237/255, green: 204/255, blue: 97/255, alpha: 1)
        case 512: return UIColor(red: 237/255, green: 200/255, blue: 80/255, alpha: 1)
        case 1024: return UIColor(red: 237/255, green: 197/255, blue: 63/255, alpha: 1)
        case 2048: return UIColor(red: 237/255, green: 194/255, blue: 46/255, alpha: 1)
        default: return .black
        }
    }
    
    fileprivate func UpdatePoints() {
        // Update points
        for i in 0..<gameBoard.size {
            for j in 0..<gameBoard.size {
                if let point = self.value(forKey: "point\(i+1)\(j+1)") as? UILabel {
                    if gameBoard.points[i][j] != 0 {
                        point.text = gameBoard.points[i][j].description
                    } else {
                        point.text = ""
                    }
                    point.superview?.backgroundColor = color4Value(gameBoard.points[i][j])

                }
            }
        }
        scoreLabel.text = gameBoard.score.description
        stepLabel.text = gameBoard.step.description
        if gameBoard.score > gameBoard.heightScore {
            gameBoard.heightScore = gameBoard.score
            heighestScoreLabel.text = gameBoard.heightScore.description
        }
    }
    
    func setupSwipeGestures() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            gesture.direction = direction
            boardView.addGestureRecognizer(gesture)
        }
    }
    
    fileprivate func gameOver() {
        // Update heighest score and save
        if gameBoard.score > gameBoard.heightScore {
            gameBoard.heightScore = gameBoard.score
            saveScore2048UsingUserDefaults(gameBoard.heightScore)
        }
        scoreLabel.text = gameBoard.score.description
        heighestScoreLabel.text = gameBoard.heightScore.description
        saveGameBoardUsingUserDefaults(GameBoard(size: 0))
        isOver = true
        let alert = UIAlertController(title: "提示", message: "游戏结束\n总得分：\(gameBoard.score)", preferredStyle: .alert)
        // Add Confirm Button
        alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .default, handler: { _ in

        }))
        self.present(alert, animated: true, completion: nil)
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
    
    fileprivate func setupGame() {
        UpdatePoints()
        gameBoard.calculateTotalScore()
        scoreLabel.text = gameBoard.score.description
        gameBoard.heightScore = readScore2048UsingUserDefaults()
        heighestScoreLabel.text = gameBoard.heightScore.description
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        boardView.layer.cornerRadius = 5
        for i in 0..<gameBoard.size {
            for j in 0..<gameBoard.size {
                if let point = self.value(forKey: "point\(i+1)\(j+1)") as? UILabel {
                    point.superview?.layer.cornerRadius = 5
                    point.font = UIFont.boldSystemFont(ofSize: 35)
                    point.textColor = .gray
                }
            }
        }
        scoreLabel.superview?.layer.cornerRadius = 5
        heighestScoreLabel.superview?.layer.cornerRadius = 5
        stepLabel.superview?.layer.cornerRadius = 5
        setupSwipeGestures()
        // If there's an old game
        if readGameBoardUsingUserDefaults().size != 0 {
            let alert = UIAlertController(title: "提示", message: "要继续之前的游戏吗？", preferredStyle: .alert)
            // Add Confirm Button
            alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: "Default action"), style: .default, handler: { _ in
                self.gameBoard = readGameBoardUsingUserDefaults()
                self.setupGame()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("开始新游戏", comment: "Cancel action"), style: .cancel, handler: { _ in
                self.gameBoard.addRandomNumber(count: 10)
                self.setupGame()
            }))
            self.present(alert, animated: true, completion: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
