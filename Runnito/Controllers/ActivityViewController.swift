//
//  ActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 07/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var chooseActivityButton: UIButton!
    @IBOutlet weak var notifierButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func chooseActivityButtonPressed(_ sender: Any) {
    }
    @IBAction func notifierButtonPressed(_ sender: Any) {
    }
    @IBAction func startButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "activityStarted", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //prepare segue
    }
    
    func setUI() {
        chooseActivityButton.layer.cornerRadius = 0
        chooseActivityButton.layer.borderWidth = 1
        chooseActivityButton.layer.borderColor = UIColor(hexString: "F25652").cgColor
        
        notifierButton.layer.cornerRadius = 0
        notifierButton.layer.borderWidth = 1
        notifierButton.layer.borderColor = UIColor(hexString: "F25652").cgColor
        
        startButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        startButton.layer.shadowOpacity = 1

    }
    
}
