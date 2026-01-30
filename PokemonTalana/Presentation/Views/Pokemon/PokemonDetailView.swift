//
//  PokemonDetailView.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import SwiftUI
import SwiftData

struct PokemonDetailView: View {
    @StateObject private var viewModel: PokemonDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoritePokemon]
    
    private var isFavorite: Bool {
        favorites.contains { $0.id == viewModel.pokemonId }
    }
    
    init(viewModel: PokemonDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if let pokemon = viewModel.pokemonDetail {
                ScrollView {
                    VStack(spacing: 0) {
                        headerSection(pokemon: pokemon)
                        
                        VStack(spacing: 24) {
                            typesSection(pokemon: pokemon)
                            aboutSection(pokemon: pokemon)
                            statsSection(pokemon: pokemon)
                            abilitiesSection(pokemon: pokemon)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30, corners: [.topLeft, .topRight])
                        .offset(y: -30)
                    }
                }
                .ignoresSafeArea()
                .navigationBarHidden(true)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.pokemonType(pokemon.types.first?.type.name ?? "normal"),
                            Color.pokemonType(pokemon.types.first?.type.name ?? "normal").opacity(0.6)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            } else if viewModel.isLoading {
                ProgressView()
            }
        }
        .overlay(alignment: .topTrailing) {
            favoriteButton
        }
        .overlay(alignment: .topLeading) {
            backButton
        }
    }
    
    private var favoriteButton: some View {
        Button(action: {
            toggleFavorite()
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title2)
                .foregroundColor(isFavorite ? .red : .white)
                .padding()
                .background(Color.black.opacity(0.2))
                .clipShape(Circle())
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.favoriteStarButton)
        .padding()
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.2))
                .clipShape(Circle())
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.backButton)
        .padding()
    }
    
    private func headerSection(pokemon: PokemonDetail) -> some View {
        VStack(spacing: 16) {
            HStack {
                Text(pokemon.name.capitalized)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .accessibilityIdentifier(AccessibilityIdentifiers.pokemonDetailName)
                
                Spacer()
                
                Text(pokemon.formattedID)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.8))
                    .accessibilityIdentifier(AccessibilityIdentifiers.pokemonDetailID)
            }
            .padding(.horizontal)
            .padding(.top, 60)
            
            AsyncImage(url: URL(string: pokemon.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                default:
                    ProgressView()
                        .frame(height: 200)
                }
            }
            .padding(.bottom, 40)
        }
    }
    
    private func typesSection(pokemon: PokemonDetail) -> some View {
        HStack(spacing: 12) {
            ForEach(pokemon.types) { type in
                Text(type.type.name.capitalized)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.pokemonType(type.type.name))
                    .cornerRadius(20)
            }
        }
    }
    
    private func aboutSection(pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About")
                .font(.title3)
                .fontWeight(.bold)
            
            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.up.and.down")
                            .foregroundColor(.gray)
                        Text(pokemon.heightInMeters)
                            .fontWeight(.medium)
                    }
                    Text("Height")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "scalemass")
                            .foregroundColor(.gray)
                        Text(pokemon.weightInKg)
                            .fontWeight(.medium)
                    }
                    Text("Weight")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func statsSection(pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Base Stats")
                .font(.title3)
                .fontWeight(.bold)
            
            ForEach(pokemon.stats) { stat in
                HStack(spacing: 16) {
                    Text(stat.stat.name.capitalized.replacingOccurrences(of: "-", with: " "))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(width: 100, alignment: .leading)
                    
                    Text("\(stat.baseStat)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 30)
                    
                    ProgressView(value: Double(stat.baseStat), total: 255)
                        .tint(Color.pokemonType(pokemon.types.first?.type.name ?? "normal"))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func abilitiesSection(pokemon: PokemonDetail) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Abilities")
                .font(.title3)
                .fontWeight(.bold)
            
            ForEach(pokemon.abilities) { ability in
                HStack {
                    Text(ability.ability.name.capitalized.replacingOccurrences(of: "-", with: " "))
                        .font(.subheadline)
                    
                    if ability.isHidden {
                        Text("(Hidden)")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .italic()
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(hex: "F5F5F5"))
                .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func toggleFavorite() {
        if isFavorite {
            if let favorite = favorites.first(where: { $0.id == viewModel.pokemonId }) {
                modelContext.delete(favorite)
            }
        } else if let pokemon = viewModel.pokemonDetail {
            let favorite = FavoritePokemon(
                id: pokemon.id,
                name: pokemon.name,
                url: pokemon.imageURL
            )
            modelContext.insert(favorite)
        }
    }
}
