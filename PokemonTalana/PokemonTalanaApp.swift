//
//  PokemonTalanaApp.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import SwiftUI
import SwiftData
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }

  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}

@main
struct PokemonTalanaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            FavoritePokemon.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
                    LoginView(
                        viewModel: DependencyContainer.shared.makeLoginViewModel()
                    )
                }
        .modelContainer(sharedModelContainer)
    }
}
