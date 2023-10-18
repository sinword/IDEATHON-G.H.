    //
    //  ViewController.swift
    //  PictureRelacement
    //
    //  Created by 新翌王 on 2023/10/18.
    //

    import UIKit
    import SceneKit
    import ARKit

    class ViewController: UIViewController, ARSCNViewDelegate {

        @IBOutlet var sceneView: ARSCNView!
        var futureScenes = [String: FutureScene]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the view's delegate
            sceneView.delegate = self
            
            loadData()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Create a session configuration
            let configuration = ARImageTrackingConfiguration()
            
            guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "before", bundle: nil) else {
                fatalError("Couldn't load tracking images")
            }
            
            configuration.trackingImages = trackingImages
            
            // Run the view's session
            sceneView.session.run(configuration)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // Pause the view's session
            sceneView.session.pause()
        }
        
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
            guard let place = imageAnchor.referenceImage.name else { return nil }
            guard let futureScene = futureScenes[place] else { return nil }
            
            print(futureScene.place)
            print(futureScene.intro)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
//            plane.firstMaterial?.diffuse.contents = UIColor.clear
//            let words = place.components(separatedBy: " ")
//            var afterName = ""
//            
//            for word in words {
//                afterName += word
//            }
//            
//            afterName += "After"
            
            let newPlace = place.replacingOccurrences(of: "Before", with: "After")
            print(newPlace)
            
            let image = UIImage(named: newPlace)
            plane.firstMaterial?.diffuse.contents = image
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            let node = SCNNode()
            node.addChildNode(planeNode)
            
            let spacing: Float = 0.005
            
            // Title
            let titleNode = textNode(futureScene.place, font: UIFont.boldSystemFont(ofSize: 10))
            titleNode.pivotOnTopLeft()
            
            titleNode.position.x += Float(plane.width / 2) + spacing
            titleNode.position.y += Float(plane.height / 2)
            
            planeNode.addChildNode(titleNode)
            
            let bioNode = textNode(futureScene.intro, font: UIFont.systemFont(ofSize: 4), maxWidth: 100)
            bioNode.pivotOnTopLeft()
            
            bioNode.position.x += Float(plane.width / 2) + spacing
            bioNode.position.y = titleNode.position.y - titleNode.height - spacing
            planeNode.addChildNode(bioNode)
            
            // Flag
//            let flag = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.width / 8 * 5)
//            // This is where I can manipulate later
//            // replace to another image
//            flag.firstMaterial?.diffuse.contents = UIImage(named: scientist.country)
//
//            let flagNode = SCNNode(geometry: flag)
//            flagNode.pivotOnTopCenter()
//            
//            flagNode.position.y -= Float(plane.height / 2) + spacing
//            planeNode.addChildNode(flagNode)
            
            return node
        }
        
        func loadData() {
            guard let url = Bundle.main.url(forResource: "futurescenes", withExtension: "json") else {
                fatalError("Unable to find JSON in bundle")
            }
            
            guard let data = try? Data(contentsOf: url) else {
                fatalError("Unable to load JSON")
            }
            
            let decoder = JSONDecoder()
            
            guard let loadedFutureScenes = try? decoder.decode([String: FutureScene].self, from: data) else {
                fatalError("Unable to parse JSON")
            }
            
            futureScenes = loadedFutureScenes
        }
        
        func textNode(_ str: String, font: UIFont, maxWidth: Int? = nil) -> SCNNode {
            let text = SCNText(string: str, extrusionDepth: 0)
            
            text.flatness = 0.1
            text.font = font
            
            if let maxWidth = maxWidth {
                text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
                text.isWrapped = true
            }
            
            let textNode = SCNNode(geometry: text)
            textNode.scale = SCNVector3(x: 0.002, y: 0.002, z: 0.002)
            
            return textNode
        }
    }

    // Essentail for almost every single ARKit project
    extension SCNNode {
        var width: Float {
            return (boundingBox.max.x - boundingBox.min.x) * scale.x
        }
        var height: Float {
            return (boundingBox.max.y - boundingBox.min.y) * scale.y
        }
        
        func pivotOnTopLeft() {
            let (min, max) = boundingBox
            pivot = SCNMatrix4MakeTranslation(min.x, (max.y - min.y) + min.y, 0)
        }
        
        func pivotOnTopCenter() {
            let (min, max) = boundingBox
            pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) + min.y, 0)
        }
    }
