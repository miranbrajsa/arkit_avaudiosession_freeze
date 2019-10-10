//
//  ViewController.swift
//  ARKitAVAudioSessionBugReport
//
//  Created by Miran Brajsa on 10/10/2019.
//  Copyright © 2019 Miran Brajsa. All rights reserved.
//

import UIKit

enum ScenarioType: String, CaseIterable, Equatable {
    case arSessionAutoAVAudioSession
    case arSessionManualAVAudioSession
    case arSessionManualAVAudioSessionWithoutAVAudioSessionDeactivation

    static func ==(lhs: ScenarioType, rhs: ScenarioType) -> Bool {
        switch (lhs, rhs) {
        case (.arSessionAutoAVAudioSession, .arSessionAutoAVAudioSession),
             (.arSessionManualAVAudioSession, .arSessionManualAVAudioSession),
             (.arSessionManualAVAudioSessionWithoutAVAudioSessionDeactivation, .arSessionManualAVAudioSessionWithoutAVAudioSessionDeactivation):
            return true
        default:
            return false
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.isIdleTimerDisabled = true
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let arKitViewController = storyboard.instantiateViewController(withIdentifier: "arKitViewController") as! ARKitViewController
        arKitViewController.scenarioType = ScenarioType.allCases[indexPath.row]
        present(arKitViewController, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ScenarioType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScenarioType.allCases[indexPath.row].rawValue, for: indexPath)
        return cell
    }
}
