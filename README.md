# NutriTrack 🥗

A modern iOS nutrition and calorie tracking app built with SwiftUI, HealthKit, and CoreData.

## Screenshots
> Coming soon

## Features
- 📊 Daily calorie and macro tracking (protein, carbs, fat)
- 🔍 Food search powered by OpenFoodFacts API (500,000+ products)
- 💾 Persistent data storage with CoreData
- 🏥 Apple Health integration via HealthKit
- 🍽️ Meal categorization (Breakfast, Lunch, Dinner, Snack)
- 📈 Daily progress tracking with visual indicators

## Tech Stack
- **SwiftUI** — Modern declarative UI
- **HealthKit** — Apple Health sync
- **CoreData** — Local persistent storage
- **OpenFoodFacts API** — Real food database
- **MVVM Architecture** — Clean, testable code structure
- **Swift Concurrency** — async/await for API calls

## Architecture
```
NutriTrack/
├── Models/
│   ├── FoodItem.swift
│   └── MealEntry.swift
├── ViewModels/
│   └── NutritionViewModel.swift
├── Views/
│   ├── HomeView.swift
│   └── FoodSearchView.swift
├── Services/
│   ├── HealthKitManager.swift
│   └── FoodAPIService.swift
└── CoreData/
    └── CoreDataManager.swift
```

## Requirements
- iOS 17+
- Xcode 15+
- Swift 5.9+

## Installation
1. Clone the repo
```bash
   git clone https://github.com/52BaranHaydar/NutriTrack.git
```
2. Open `NutriTrack.xcodeproj` in Xcode
3. Build and run on simulator or device

## Author
**Baran Haydar** — Computer Engineering Student  
[LinkedIn](https://www.linkedin.com/in/baranhaydar) · [GitHub](https://github.com/52BaranHaydar)
