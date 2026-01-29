//
//  FirebaseAuthManager.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    
    private init() {}
    
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        // 1. Get client ID
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // 2. Create Google Sign In configuration
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // 3. Start the sign in flow
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = signInResult?.user,
                  let idToken = user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "FirebaseAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get ID token"])))
                return
            }
            
            let accessToken = user.accessToken.tokenString
            
            // 4. Create Firebase credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // 5. Sign in to Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let authResult = authResult else {
                    completion(.failure(NSError(domain: "FirebaseAuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Auth result is nil"])))
                    return
                }
                
                completion(.success(authResult))
            }
        }
    }
}
