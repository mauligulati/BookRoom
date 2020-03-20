//
//  BookRoomViewController.swift
//  BookRoom
//
//  Created by Gulati, Mauli on 17/3/20.
//  Copyright © 2020 Gulati, Mauli. All rights reserved.
//

import UIKit
import SVProgressHUD

//class ButtonWithImage: UIButton {
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        if imageView != nil {
//            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 200), bottom: 5, right: 5)
//            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
//        }
//    }
//}

class BookRoomViewController: UIViewController, URLSessionDelegate, SelectedSortDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var roomDetailsTableView: UITableView!

    let errorMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "Apologies something went wrong"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let datePicker = UIDatePicker()
    let timePicker = UIPickerView()
    let timePickerArray = ["08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30"]
    var roomDetails = [RoomDetails]()
    var timeIn24HourFormat = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//    sortButton.setImage(UIImage(named: "sort.png"), for: .normal)
//        //sortButton.titleEdgeInsets = UIEdgeInsets(top: 70.0, left: -80.0, bottom: 5.0, right: 5.0)
//        sortButton.setTitle("Sort", for: .normal)

        drawBorderForTextField(textField: dateTextField)
        drawBorderForTextField(textField: timeTextField)
        
        dateTextField.delegate = self
        timeTextField.delegate = self
        timePicker.delegate = self
        timePicker.delegate?.pickerView?(timePicker, didSelectRow: 0, inComponent: 0)
        
        roomDetailsTableView.register(UINib(nibName: "RoomDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "roomDetailsCell")
        roomDetailsTableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Display Current Date and Time
        timeTextField.text = Date().toAmPMTimeString()
        dateTextField.text = Date().dateToString(date: Date())
        
        timeIn24HourFormat = Date().to24HourTimeString()
        getRoomAvailability()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        if textField.tag == 0 {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
            toolbar.setItems([doneBtn], animated: true)
            dateTextField.inputAccessoryView = toolbar
            dateTextField.inputView = datePicker
            datePicker.datePickerMode = .date
        }
        else {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timeDonePressed))
            toolbar.setItems([doneBtn], animated: true)
            timeTextField.inputAccessoryView = toolbar
            timeTextField.inputView = timePicker
            datePicker.datePickerMode = .time
        }
    }
    
    @objc func timeDonePressed() {
        switch timeIn24HourFormat {
        case "08:00", "08:30", "09:00", "09:30", "10:30", "11:00", "11:30":
            timeTextField.text = "\(timeIn24HourFormat) AM"
            break
        default:
            timeTextField.text = "\(timeIn24HourFormat) PM"
            break
        }
        self.view.endEditing(true)
        getRoomAvailability()
    }
    
    @objc func dateDonePressed() {
        dateTextField.text = (datePicker.date).dateToString(date: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func sortButtonPressed(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SortViewController") as! SortViewController
        popOverVC.delegate = self
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.bounds
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    func applySelectedSort(sortId: Int) {
        print(sortId)
        switch sortId {
        case 1:
            roomDetails = roomDetails.sorted {$0.capacity.localizedStandardCompare($1.capacity) == .orderedAscending}
        case 2:
            var availableRoomDetails = [RoomDetails]()
            var notAvailableRoomDetails = [RoomDetails]()
            for room in roomDetails {
                for (time,available) in room.availability {
                    if time == timeIn24HourFormat {
                        if available == "1"
                        {
                            availableRoomDetails.append(room)
                        }
                        else {
                            notAvailableRoomDetails.append(room)
                        }
                    }
                }
            }
            availableRoomDetails.append(contentsOf: notAvailableRoomDetails)
            if availableRoomDetails.isEmpty {
                roomDetails = roomDetails.sorted {$0.level.localizedStandardCompare($1.level) == .orderedAscending}
            }
            else {
                roomDetails = availableRoomDetails
            }
        default:
            roomDetails = roomDetails.sorted {$0.level.localizedStandardCompare($1.level) == .orderedAscending}
            break
        }
        roomDetailsTableView.reloadData()
    }
    
    func getRoomAvailability() {
        SVProgressHUD.show()
        let jsonUrlString = Constants.URLS.base + Constants.URLS.RoomAvailability
        guard let url = URL(string: jsonUrlString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        task.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                let httpResponseCode = httpResponse.statusCode
                switch httpResponseCode {
                case 200:
                    guard let data = data else {
                        return
                    }
                    do {
                        self.roomDetails = try JSONDecoder().decode([RoomDetails].self, from: data)
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.roomDetailsTableView.reloadData()
                        }
                    }
                    catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                    }
                    break
                default:
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        let noDataImageView = UIImageView(image: UIImage(named: "no_notification"))
                        self.setNoDataImage(imageView: noDataImageView, tableView: self.roomDetailsTableView)
                    }
                    break
                }
            }
        }.resume()
    }
    
    func setNoDataImage(imageView: UIImageView, tableView: UITableView) {
        //Add imageview as a subview before you can add constraint to it.
        tableView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let _ = challenge.protectionSpace.serverTrust!
        }
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential.init(trust: challenge.protectionSpace.serverTrust!))
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeReaderViewController") as? QRCodeReaderViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension BookRoomViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timePickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timePickerArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timeIn24HourFormat =  timePickerArray[row]
    }
}

extension BookRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roomDetailsCell", for: indexPath) as! RoomDetailsTableViewCell
        cell.roomNameLabel.text = roomDetails[indexPath.row].name
        cell.levelLabel.text = "Level \(roomDetails[indexPath.row].level)"
        cell.capacityLabel.text = "\(roomDetails[indexPath.row].capacity) Pax"
        
        for (time,available) in roomDetails[indexPath.row].availability {
            if time == timeIn24HourFormat {
                if available == "1" {
                    cell.availabilityLabel.text = "Available"
                    cell.availabilityLabel.textColor = Constants.Color.greenColor
                    break
                }
                else {
                    cell.availabilityLabel.text = "Not Available"
                    cell.availabilityLabel.textColor = UIColor.lightGray
                    break
                }
            }
        }
        cell.availabilityLabel.font = Constants.Font.cellFont
        return cell
    }
}

