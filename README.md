# 🍽️ QuickChef AI

**QuickChef AI** is a professional, AI-powered **Flutter Web application** that helps users turn the ingredients they already have into practical, healthy, and time-efficient meals. The project focuses on **clean architecture, real-world AI usage, and academic-grade software design**.

---

## 🚀 Project Overview

Many people struggle with deciding what to cook using available ingredients, often leading to food waste, unhealthy choices, or excessive time spent searching for recipes. **QuickChef AI** addresses this problem by using a Large Language Model (LLM) to generate **ingredient-based recipes**, estimate **nutritional values**, and automatically create a **smart shopping list**.

This project is intentionally designed as a **text-first, logic-driven application**. Images are excluded to avoid misleading representations of AI-generated recipes and to keep the focus on reasoning, data flow, and system design.

---

## 🎯 Key Features

* Ingredient-based AI recipe generation
* Time-based smart meal suggestions (e.g., quick meals)
* AI-powered nutrition and calorie estimation
* Automatic smart shopping list generation
* Clean, consistent Material 3 UI
* Firebase Authentication and Firestore integration
* Web-only deployment (Google Chrome)

---

## 🧠 AI Modules Used

QuickChef AI uses a single LLM (via the Groq API) to implement **four logically distinct AI modules**:

1. **Ingredient-Based Recipe Generator**
   Generates complete recipes based on user-provided ingredients.

2. **Time-Based Meal Suggestion Module**
   Filters and generates recipes based on cooking time constraints.

3. **Nutrition & Calorie Estimation Module**
   Provides approximate nutritional values such as calories, protein, carbs, and fats.

4. **Smart Shopping List Generator**
   Identifies missing ingredients by comparing required and available items.

These modules are separated by responsibility, even though they are powered by the same AI model.

---

## 🏗️ Technical Architecture

### Frontend

* **Flutter Web (Dart only)**
* Material 3 design system
* Clean widget-based architecture
* Reusable UI components

### Backend / AI Layer

* **Groq API (LLaMA model)**
* Structured prompt design for predictable outputs
* No hardcoded API keys (placeholder-based configuration)

### Database

* **Firebase Firestore (NoSQL)**
* **Firebase Authentication (Email/Password)**

---

## 🗄️ Database Design

The database is intentionally kept minimal and professional, using **only three collections**:

### 1. `users`

Stores authenticated user information.

### 2. `saved_recipes`

Stores AI-generated recipes that users choose to save, including instructions, nutrition data, and metadata.

### 3. `shopping_list`

Stores missing ingredients identified by the AI for each user.

This structure avoids redundancy while supporting all core features.

---

## 📁 Project Structure (Simplified)

```
lib/
 ├── config/        # App constants, colors, typography
 ├── widgets/       # Reusable UI components
 ├── screens/       # Application screens
 ├── services/      # Firebase & AI services
 ├── models/        # Data models
 └── main.dart      # Application entry point
```

The project follows **separation of concerns** and **maintainable code practices**.

---

## 🎨 UI/UX Philosophy

* Text-first interface (no images)
* Consistent typography and spacing
* Clear visual hierarchy
* Professional color palette
* Minimal yet functional design

This approach ensures clarity, performance, and ease of maintenance.

---

## 🔐 Security Considerations

* No sensitive keys are hardcoded
* API keys are managed via placeholders and environment configuration
* Firebase Authentication ensures secure user access
* Firestore rules restrict data access by user ownership

---

## 🧪 How to Run the Project (Web Only)

1. Enable Flutter Web on your system
2. Configure Firebase for **Web only**
3. Add your Groq API key in the configuration file
4. Run the project using:

```bash
flutter run -d chrome
```

---

## 📘 Academic & Professional Value

This project demonstrates:

* Practical use of Generative AI
* Clean and scalable Flutter Web architecture
* Proper database modeling
* Real-world problem solving
* Clear separation between AI logic and UI

---
