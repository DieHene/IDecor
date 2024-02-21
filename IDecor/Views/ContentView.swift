//
//  ContentView.swift
//  IDecor
//
//  Created by admin on 18.02.24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var objects: [ARModel] = [ARModel(id: "chair", sysName: "chair", scale: 0.6),
                                             ARModel(id: "flower", sysName: "camera.macro", scale: 0.5),
                                             ARModel(id: "tv", sysName: "tv", scale: 0.5),
                                             ARModel(id: "gramophone", sysName: "music.quarternote.3", scale: 0.6)]
    
    var body: some View {
        CustomARViewRepresentable()
            .ignoresSafeArea()
            .overlay (alignment: .bottom) {
                ScrollView(.horizontal) {
                    HStack {
                        Button {
                            ARManager.shared.actionStream.send(.removeAllAnchors)
                        } label: {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(.regularMaterial)
                        }
                        
                        ForEach(objects, id: \.self) { object in
                            Button {
                                ARManager.shared.actionStream.send(.placeObject(object: object.id, scale: object.scale))
                            } label: {
                                Image(systemName: object.sysName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .background(.regularMaterial)
                            }
                        }
                    }
                    .padding()
                }
            }
    }
}
