//
//  LoadingStatus.swift
//  ArtUOKV3
//
//  Created by Josh Rosemore on 7/30/20.
//  Copyright © 2020 Sam Rosemore. All rights reserved.
//

import Foundation
import SwiftUI


class LoadingStatus: ObservableObject
{
    @Published var isLoading:Bool = true
}
