//
//  MainTabView.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            PokemonListView(
                viewModel: DependencyContainer.shared.makePokemonListViewModel()
            )
            .tabItem {
                Label("Pokédex", systemImage: "circle.circle.fill")
            }
            
            FavoritesView()
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            
            // Add Profile or Settings tab if needed later
        }
        .tint(.red)
    }
}
