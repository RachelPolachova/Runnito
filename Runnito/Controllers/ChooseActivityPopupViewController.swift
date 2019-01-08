//
//  ChooseActivityPopupViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 08/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ChooseActivityPopupViewController: UIViewController {

    @IBOutlet weak var activitiesTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        dismiss(animated: true)
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
