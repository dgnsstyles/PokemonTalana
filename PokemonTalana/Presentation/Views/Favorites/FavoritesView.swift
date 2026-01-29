//
//  FavoritesView.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoritePokemon.addedAt, order: .reverse) private var favorites: [FavoritePokemon]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F5F5")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    
                    if favorites.isEmpty {
                        emptyState
                    } else {
                        favoritesList
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Favorites")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("\(favorites.count) Pokémon saved")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "heart.fill")
                .font(.system(size: 32))
                .foregroundColor(.red)
        }
        .padding()
        .background(Color(hex: "F5F5F5"))
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.3))
            
            Text("No favorites yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Text("Add Pokémon to your favorites to see them here!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.top, 100)
    }
    
    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(favorites) { favorite in
                    NavigationLink(destination: PokemonDetailView(
                        viewModel: DependencyContainer.shared.makePokemonDetailViewModel(pokemonId: favorite.id)
                    )) {
                        FavoriteCardView(pokemon: favorite)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
}

struct FavoriteCardView: View {
    let pokemon: FavoritePokemon
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemon.id).png")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                default:
                    ProgressView()
                        .frame(width: 80, height: 80)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pokemon.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(String(format: "#%03d", pokemon.id))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
