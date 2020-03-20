//
//  QRCodeStatusViewController.swift
//  BookRoom
//
//  Created by Gulati, Mauli on 20/3/20.
//  Copyright © 2020 Gulati, Mauli. All rights reserved.
//

import UIKit

class QRCodeStatusViewController: UIViewController {

    @IBOutlet weak var backToHomeButton: UIButton!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomLevelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backToHomeButton.layer.cornerRadius = 15.0
    }
    
    @IBAction func backToHomeButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
