//
//  CheckInStatus.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 7/22/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class CheckInStatus: ObservableObject
{
    @Published var isCheckedIn:Bool = false
    
    init(status: Bool)
    {
        self.isCheckedIn = status
    }
}
