//
//  Game3DSceneView.swift
//  Connect4D
//
//  Created by Andreas Pelczer on 25.02.26.
//


import SwiftUI
import SceneKit

struct Game3DSceneView: UIViewRepresentable {
    let viewModel: GameViewModel3D
    let theme: GameTheme
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = createScene()
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = false
        scnView.backgroundColor = UIColor(theme.backgroundColor)
        
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        scnView.addGestureRecognizer(tapGesture)
        
        return scnView
    }
    
    func updateUIView(_ scnView: SCNView, context: Context) {
        guard let scene = scnView.scene else { return }
        scnView.backgroundColor = UIColor(theme.backgroundColor)
        
        // Alte Steine entfernen
        scene.rootNode.childNodes
            .filter { $0.name?.starts(with: "piece_") == true }
            .forEach { $0.removeFromParentNode() }
        
        // Aktuelle Steine setzen
        for idx in 0..<(Board3D.size * Board3D.size) {
            let coords = Board3D.coordinates(from: idx)
            let stack = viewModel.board.stacks[idx]
            
            for (y, cellState) in stack.enumerated() {
                guard case .occupied(let player) = cellState else { continue }
                
                let isWinning = viewModel.winningCells?.contains {
                    $0.x == coords.x && $0.y == y && $0.z == coords.z
                } ?? false
                
                let piece = createPiece(
                    player: player,
                    isWinning: isWinning,
                    at: SCNVector3(
                        Float(coords.x) - 1.5,
                        Float(y) * 0.4 + 0.2,
                        Float(coords.z) - 1.5
                    )
                )
                piece.name = "piece_\(coords.x)_\(y)_\(coords.z)"
                scene.rootNode.addChildNode(piece)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    // MARK: - Scene erstellen
    
    private func createScene() -> SCNScene {
        let scene = SCNScene()
        
        // Kamera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 5, 7)
        cameraNode.look(at: SCNVector3(0, 1, 0))
        scene.rootNode.addChildNode(cameraNode)
        
        // Licht
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.light?.intensity = 1000
        lightNode.position = SCNVector3(3, 8, 5)
        scene.rootNode.addChildNode(lightNode)
        
        let ambientNode = SCNNode()
        ambientNode.light = SCNLight()
        ambientNode.light?.type = .ambient
        ambientNode.light?.intensity = 400
        ambientNode.light?.color = UIColor.white
        scene.rootNode.addChildNode(ambientNode)
        
        // Bodenplatte
        let baseGeometry = SCNBox(width: 4.5, height: 0.15, length: 4.5, chamferRadius: 0.05)
        let baseMaterial = SCNMaterial()
        baseMaterial.diffuse.contents = UIColor(theme.boardColor)
        baseGeometry.materials = [baseMaterial]
        let baseNode = SCNNode(geometry: baseGeometry)
        baseNode.position = SCNVector3(0, -0.075, 0)
        scene.rootNode.addChildNode(baseNode)
        
        // 16 Stangen
        for x in 0..<Board3D.size {
            for z in 0..<Board3D.size {
                let rod = SCNCylinder(radius: 0.04, height: 1.8)
                let rodMaterial = SCNMaterial()
                rodMaterial.diffuse.contents = UIColor(theme.boardBorder)
                rodMaterial.metalness.contents = 0.8
                rod.materials = [rodMaterial]
                
                let rodNode = SCNNode(geometry: rod)
                rodNode.position = SCNVector3(
                    Float(x) - 1.5,
                    0.9,
                    Float(z) - 1.5
                )
                rodNode.name = "rod_\(x)_\(z)"
                scene.rootNode.addChildNode(rodNode)
            }
        }
        
        return scene
    }
    
    // MARK: - Spielstein erstellen
    
    private func createPiece(player: Player, isWinning: Bool, at position: SCNVector3) -> SCNNode {
        // Torus (Ring mit Loch = Spielstein mit Loch für die Stange)
        let piece = SCNTorus(ringRadius: 0.3, pipeRadius: 0.1)
        let material = SCNMaterial()
        
        if player == .black {
            material.diffuse.contents = UIColor(theme.blackPiece)
        } else {
            material.diffuse.contents = UIColor(theme.whitePiece)
        }
        material.metalness.contents = 0.3
        material.roughness.contents = 0.4
        
        if isWinning {
            material.emission.contents = UIColor(theme.winHighlight)
            material.emission.intensity = 0.5
        }
        
        piece.materials = [material]
        let node = SCNNode(geometry: piece)
        node.position = position
        return node
    }
    
    // MARK: - Coordinator für Tap
    
    class Coordinator: NSObject {
        let viewModel: GameViewModel3D
        
        init(viewModel: GameViewModel3D) {
            self.viewModel = viewModel
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let scnView = gesture.view as? SCNView else { return }
            let location = gesture.location(in: scnView)
            let hitResults = scnView.hitTest(location, options: [
                .searchMode: SCNHitTestSearchMode.all.rawValue
            ])
            
            // Suche nach getroffener Stange
            for result in hitResults {
                if let name = result.node.name, name.starts(with: "rod_") {
                    let parts = name.split(separator: "_")
                    if parts.count == 3,
                       let x = Int(parts[1]),
                       let z = Int(parts[2]) {
                        viewModel.dropPiece(x: x, z: z)
                        return
                    }
                }
            }
            
            // Fallback: Bodenplatte getroffen → nächste Stange berechnen
            for result in hitResults {
                let pos = result.worldCoordinates
                let x = Int(round(pos.x + 1.5))
                let z = Int(round(pos.z + 1.5))
                if x >= 0, x < Board3D.size, z >= 0, z < Board3D.size {
                    viewModel.dropPiece(x: x, z: z)
                    return
                }
            }
        }
    }
}