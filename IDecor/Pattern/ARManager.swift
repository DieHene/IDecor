//
//  ARManager.swift
//  IDecor
//
//  Created by admin on 18.02.24.
//

import Combine

class ARManager {
    static let shared = ARManager()
    private init() {}
    
    var actionStream = PassthroughSubject<ARAction, Never>()
}
