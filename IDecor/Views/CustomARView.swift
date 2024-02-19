//
//  CustomARView.swift
//  IDecor
//
//  Created by admin on 18.02.24.
//

import ARKit
import Combine
import RealityKit
import SwiftUI

class CustomARView: ARView {
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        self.session.run(config)
        
        subscribeToActionStream()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func subscribeToActionStream() {
        ARManager.shared
            .actionStream
            .sink { [weak self] action in
                switch action {
                    case .placeObject(let object, let scale):
                    self?.placeObject(object: object, scale: scale)
                    
                    case .removeAllAnchors:
                    self?.scene.anchors.removeAll()
                }
            }
            .store(in: &cancellables)
    }
    
    func placeObject(object: String, scale: Float) {
        guard let model = try? ModelEntity.loadModel(named: "Models.scnassets/" + object) else {return}
        model.generateCollisionShapes(recursive: true)
        model.scale *= scale
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(model)
        
        self.installGestures([.translation, .rotation],for: model as Entity & HasCollision)
        
        scene.addAnchor(anchor)
    }
    
}
