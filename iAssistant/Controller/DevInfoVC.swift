//
//  DevInfoVC.swift
//  iAssistant
//
//  Created by Meyer Chen on 2025/3/25.
//

import UIKit

class DevInfoVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var githubLinkLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let name = "陈赞"
    let university = "东北大学"
    let school = "软件学院"
    let className = "软件2301"
    let githubLink = "https://github.com/2504824765"
    let email = "cz2504824765@outlook.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Set slide back enabeld
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        // test git
        logoImage.layer.cornerRadius = 10
        logoImage.layer.masksToBounds = true
        nameLabel.text = name
        universityLabel.text = university
        schoolLabel.text = school
        classLabel.text = className
        githubLinkLabel.text = githubLink
        emailLabel.text = email
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
