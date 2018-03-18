//
//  AlertServices.swift
//  Local notification
//
//  Created by Tom on 17/03/2018.
//  Copyright © 2018 Tom. All rights reserved.
//

import UIKit

class AlertServices {
    
    private init() {}
    
    static func actionSheet(in vc: UIViewController, title: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: title, style: .default) { (_) in
            completion()
            
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
        
        }
}
