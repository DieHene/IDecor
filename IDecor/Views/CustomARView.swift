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
        
        self.automaticallyConfigureSession = false
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        config.isLightEstimationEnabled = false
        
        self.session.run(config)
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panRecognizer)))
        
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
        
        self.installGestures([.rotation],for: model as Entity & HasCollision)
        
        scene.anchors.append(anchor)
    }
    
    @objc func panRecognizer(_ sender: UITapGestureRecognizer){
        let raycast = raycast(from: sender.location(in: self), allowing: .estimatedPlane, alignment: .horizontal)
        guard !raycast.isEmpty, let rayResult = raycast.first else {return}
        
        if let hitEnt = self.entity(at: sender.location(in: self)) {
            let translation = simd_float4x4(
                simd_float4(1, 0, 0, 0),
                simd_float4(0, 1, 0, 0),
                simd_float4(0, 0, 1, 0),
                rayResult.worldTransform.columns.3
            )
            
            hitEnt.anchor?.reanchor(.world(transform: translation), preservingWorldTransform: false)
        }
        
    }
}
