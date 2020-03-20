//
//  SortViewController.swift
//  BookRoom
//
//  Created by Gulati, Mauli on 18/3/20.
//  Copyright © 2020 Gulati, Mauli. All rights reserved.
//

import UIKit
import DLRadioButton

protocol SelectedSortDelegate : class {
    func applySelectedSort(sortId: Int)
}

class SortViewController: UIViewController {

    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var locationRadioButton: DLRadioButton!
    @IBOutlet weak var capacityRadioButton: DLRadioButton!
    @IBOutlet weak var availabilityRadioButton: DLRadioButton!
    
    var sortSelection = Int()
    weak var delegate: SelectedSortDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // corner radius
        sortView.layer.cornerRadius = 5.0
        resetButton.layer.cornerRadius = 15.0
        applyButton.layer.cornerRadius = 15.0

        // shadow for SortView
        sortView.layer.shadowColor = UIColor.black.cgColor
        sortView.layer.shadowOffset = CGSize(width: 3, height: 3)
        sortView.layer.shadowOpacity = 0.7
        sortView.layer.shadowRadius = 4.0
        
        //Swipe Gesture
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipeGesture() {
        removeAnimate()
    }
    
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        delegate?.applySelectedSort(sortId: sortSelection)
        removeAnimate()
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        locationRadioButton.isSelected = false
        capacityRadioButton.isSelected = false
        availabilityRadioButton.isSelected = false
        sortSelection = 0
    }
        
    @IBAction func radioButtonPressed(_ sender: DLRadioButton) {
        sortSelection = sender.tag
    }
}
