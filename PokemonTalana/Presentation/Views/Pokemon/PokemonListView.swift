//
//  PokemonListView.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import SwiftUI

struct PokemonListView: View {
    @StateObject private var viewModel: PokemonListViewModel
    @State private var searchText = ""
    
    init(viewModel: PokemonListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F5F5")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    headerView
                    searchBar
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.pokemons) { pokemon in
                                NavigationLink(destination: PokemonDetailView(
                                    viewModel: DependencyContainer.shared.makePokemonDetailViewModel(pokemonId: pokemon.id)
                                )) {
                                    PokemonCardView(pokemon: pokemon)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .accessibilityIdentifier("\(AccessibilityIdentifiers.pokemonCard)\(pokemon.id)")
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(currentPokemon: pokemon)
                                }
                            }
                            
                            if viewModel.isLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .accessibilityIdentifier(AccessibilityIdentifiers.pokemonList)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Pokédex")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("\(viewModel.pokemons.count) Pokémon")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier(AccessibilityIdentifiers.pokemonListTitle)
            }
            
            Spacer()
            
            Image(systemName: "circle.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
        }
        .padding()
        .background(Color(hex: "F5F5F5"))
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search Pokémon", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .accessibilityIdentifier(AccessibilityIdentifiers.searchField)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
