//
//  VisibilityStatus.swift
//  ArtUOKV3
//
//  Created by Josh Rosemore on 7/23/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

class VisibilityStatus:ObservableObject
{
    @Published var showCell:Bool?
    
    init()
    {
        self.showCell = false
    }
}
