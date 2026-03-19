//
//  FoodAPIService.swift
//  NutriTrack
//
//  Created by Baran on 19.03.2026.
//

import Foundation


class FoodAPIService{
    
    static let shared = FoodAPIService()
    
    private let baseURL = "https://world.openfoodfacts.org/cgi/search.pl"
    
    func searchFood(query: String) async -> [FoodItem] {
        guard !query.isEmpty else{ return [] }
        
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "search_terms", value: query),
            URLQueryItem(name: "search_simple", value: "1"),
            URLQueryItem(name: "action", value: "process"),
            URLQueryItem(name: "json", value: "1"),
            URLQueryItem(name: "page_size", value: "20"),
            URLQueryItem(name: "fields", value: "product_name,nutriments,serving_size")
        ]
        
        guard let url = components.url else { return  [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(OpenFoodFactsResponse.self, from: data)
            
            return response.products.compactMap { product in
                guard let name = product.product_name, !name.isEmpty,
                      let nutriments = product.nutriments else {  return nil }
                
                return FoodItem(
                    name: name, calories: nutriments.energy_kcal_100g ?? 0, protein: nutriments.proteins_100g ?? 0, carbohydrates: nutriments.carbohydrates_100g ?? 0, fat: nutriments.fat_100g ?? 0
                )
            }
        } catch {
            print("API hatası : \(error)")
            return []
        }
        
    }
    
}

struct OpenFoodFactsResponse : Codable {
    let products : [OpenFoodFactsProduct]
}

struct OpenFoodFactsProduct :Codable {
    let product_name : String?
    let nutriments : OpenFoodFactsNutriments?
}

struct OpenFoodFactsNutriments : Codable{
    let energy_kcal_100g: Double?
    let proteins_100g: Double?
    let carbohydrates_100g: Double?
    let fat_100g : Double?
    
    enum CodingKeys: String, CodingKey{
        case energy_kcal_100g = "energy-kcal_100g"
                case proteins_100g = "proteins_100g"
                case carbohydrates_100g = "carbohydrates_100g"
                case fat_100g = "fat_100g"
    }
    
}
