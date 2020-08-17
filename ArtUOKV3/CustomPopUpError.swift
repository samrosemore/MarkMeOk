//
//  CustomPopUpError.swift
//  ArtUOKV3
//
//  Created by Josh Rosemore on 8/11/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI

class CustomPopUpError
{
    var title:String
    var msg:String
    var justMsg:Bool
    
    var first:Bool
    var secound:Bool
    
    init(title:String, msg:String, justMsg:Bool)
    {
        self.title = title
        self.msg = msg
        self.justMsg = justMsg
        first = false
        secound = false
    }
}
