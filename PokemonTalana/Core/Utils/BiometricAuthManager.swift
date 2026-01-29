//
//  BiometricAuthManager.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import LocalAuthentication
import Foundation

class BiometricAuthManager {
    static let shared = BiometricAuthManager()
    private init() {}
    
    func canUseBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        let reason = "Authenticate to access your Pokédex"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if success {
                    completion(true, nil)
                } else {
                    completion(false, error?.localizedDescription)
                }
            }
        }
    }
}
