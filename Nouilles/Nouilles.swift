//
//  Nouilles.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class Nouilles: NSObject {

    // MARK: - properties
    var listeDeNouilles = [Nouille]()
    
    // MARK: - Singleton
    class func sharedInstance() -> Nouilles {
        struct Singleton {
            static var sharedInstance = Nouilles()
        }
        return Singleton.sharedInstance
    }

    
}
