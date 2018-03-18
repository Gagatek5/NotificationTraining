//
//  ViewController.swift
//  Local notification
//
//  Created by Tom on 17/03/2018.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNServices.shared.authorize()
        CLServices.shared.authorize()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didEnterRegion),
                                               name: NSNotification.Name("internalNotification.enterRegion"),
                                               object: nil)
        //internalNotification.handleAction
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleAction(_:)),
                                               name: NSNotification.Name("internalNotification.handleAction"),
                                               object: nil)
        
    }

    @IBAction func onTimerTapped(){
        print("Timer")
        AlertServices.actionSheet(in: self, title: "5 second"){
        UNServices.shared.timerRequest(with: 5)
        }
    }
    @IBAction func onDateTapped(){
        print("Date")
        AlertServices.actionSheet(in: self, title: "Some future time"){
            var components = DateComponents()
            components.second = 0
            UNServices.shared.dateRequest(with: components)
        }

    }
    @IBAction func onLocationTapped(){
        print("Location")
        AlertServices.actionSheet(in: self, title: "future time"){
            CLServices.shared.updateLocation()
        }
    }
    @objc
    func didEnterRegion() {
        UNServices.shared.locationRequest()
    }
    @objc
    func handleAction(_ sender: Notification){
        guard let action = sender.object as? NotificationActionID else {return}
        switch action {
            case .timer: changeBackground()
            case .date: changeBackground()
            case .location: changeBackground()
            

        }
    }
    func changeBackground() {
        view.backgroundColor = .red
    }
}

