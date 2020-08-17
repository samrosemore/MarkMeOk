//
//  Error.swift
//  ArtUOKV3
//
//  Created by Sam Rosemore on 5/24/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation

class CustomError: ObservableObject
{
    @Published var message:String
    
    init()
    {
        message = ""
    }
    
}
