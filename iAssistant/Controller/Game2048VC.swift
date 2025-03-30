//
//  Game2048VC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/29.
//

import UIKit

class Game2048VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let gameBoard = GameBoard(size: 4)
        gameBoard.addRandomNumber(count: 10)
        gameBoard.printBoard()
        gameBoard.move(direction: .down)
        gameBoard.printBoard()
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
