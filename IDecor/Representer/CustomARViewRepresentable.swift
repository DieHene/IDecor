//
//  CustomARViewRepresentable.swift
//  IDecor
//
//  Created by admin on 18.02.24.
//

import SwiftUI

struct CustomARViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomARView {
        return CustomARView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
