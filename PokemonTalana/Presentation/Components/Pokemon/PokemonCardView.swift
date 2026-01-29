//
//  PokemonCardView.swift
//  PokemonTalana
//
//  Created by David Goren on 29-01-26.
//

import SwiftUI

struct PokemonCardView: View {
    let pokemon: Pokemon
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.6),
                    Color.blue.opacity(0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            HStack(spacing: 16) {
                AsyncImage(url: URL(string: pokemon.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    case .failure:
                        Image(systemName: "photo.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(pokemon.formattedID)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text(pokemon.name.capitalized)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.vertical, 8)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.title3)
            }
            .padding()
        }
        .frame(height: 120)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
