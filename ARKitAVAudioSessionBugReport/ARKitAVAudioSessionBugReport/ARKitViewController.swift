//
//  ARKitViewController.swift
//  ARKitAVAudioSessionBugReport
//
//  Created by Miran Brajsa on 10/10/2019.
//  Copyright © 2019 Miran Brajsa. All rights reserved.
//

import ARKit
import AVFoundation
import SceneKit
import UIKit

// Positional audio code below is taken from Apple's example named
// "Creating an Immersive AR Experience with Audio" for simplicity
// found at https://developer.apple.com/documentation/arkit/creating_an_immersive_ar_experience_with_audio.
class ARKitViewController: UIViewController {

    private let audioSession = AVAudioSession.sharedInstance()

    @IBOutlet private var sceneView: ARSCNView!
    
    private var audioSource: SCNAudioSource!
    private var fireplaceAudioNode: SCNNode!
    
    var scenarioType: ScenarioType = .arSessionAutoAVAudioSession

    override func viewDidLoad() {
        super.viewDidLoad()

        fireplaceAudioNode = SCNNode()
        setUpAudio()
        setUpCamera()

        if scenarioType != .arSessionAutoAVAudioSession {
            configureAVAudioSession()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if scenarioType != .arSessionAutoAVAudioSession {
            startAVAudioSession()
        }
        startARSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sceneView.pointOfView?.addChildNode(fireplaceAudioNode)
        playSound()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        fireplaceAudioNode.removeAllAudioPlayers()
        fireplaceAudioNode.removeFromParentNode()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if scenarioType == .arSessionManualAVAudioSession {
            pauseAVAudioSession()
        }
        pauseARSession()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension ARKitViewController {

    private func configureAVAudioSession() {
        do {
            try audioSession.setCategory(.playAndRecord)
            try audioSession.setMode(.videoRecording)
        }
        catch {
            print("AVAudioSession initialization error: \(error)")
        }
    }
    
    private func startAVAudioSession() {
        do {
            try audioSession.setActive(true, options: [])
        }
        catch {
            print("AVAudioSession activation error: \(error)")
        }
    }
    
    private func pauseAVAudioSession() {
        do {
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        }
        catch {
            print("AVAudioSession deactivation error: \(error)")
        }
    }
    
    private func startARSession() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        if scenarioType == .arSessionAutoAVAudioSession {
            configuration.providesAudioData = true
        }
        configuration.worldAlignment = .gravity
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    private func pauseARSession() {
        sceneView.session.pause()
    }

    private func setUpCamera() {
        guard let camera = sceneView.pointOfView?.camera else {
            fatalError("Expected a valid `pointOfView` from the scene.")
        }
        // Enable HDR camera settings for the most realistic appearance
        // with environmental lighting and physically based materials.
        camera.wantsHDR = true
        camera.exposureOffset = -1
        camera.minimumExposure = -1
        camera.maximumExposure = 3
    }

    private func setUpAudio() {
        // Instantiate the audio source
        audioSource = SCNAudioSource(fileNamed: "fireplace.mp3")!
        // As an environmental sound layer, audio should play indefinitely
        audioSource.loops = true
        audioSource.shouldStream = false
        audioSource.isPositional = true
        // Decode the audio from disk ahead of time to prevent a delay in playback
        audioSource.load()
    }

    private func playSound() {
        // Ensure there is only one audio player
        fireplaceAudioNode.removeAllAudioPlayers()
        // Create a player from the source and add it to `objectNode`
        fireplaceAudioNode.addAudioPlayer(SCNAudioPlayer(source: audioSource))
    }

}
