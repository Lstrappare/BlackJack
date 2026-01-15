# ♠️ Blackjack iOS - Native App

> Una aplicación nativa de Blackjack desarrollada con SwiftUI, enfocada en la gestión de estado, arquitectura MVVM y experiencia de usuario con retroalimentación háptica.

<img width="1920" height="1440" alt="134_1x_shots_so" src="https://github.com/user-attachments/assets/915b9b53-2de1-46e7-92a0-4e9b9fb31d72" />

![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-2.0+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 📱 Descripción

Este proyecto es una recreación del clásico juego de cartas "21" (Blackjack). El objetivo principal fue profundizar en el desarrollo nativo para iOS, implementando una lógica de juego robusta separada de la interfaz de usuario.

La app permite al usuario jugar contra un Dealer automatizado que sigue las reglas estándar de casino (se planta en 17).

## ✨ Características Principales

* **Lógica de Juego Completa:** Manejo de mazo, barajado aleatorio y reparto de cartas.
* **Cálculo Dinámico de Ases:** Algoritmo inteligente que ajusta el valor del As (11 o 1) automáticamente para evitar que el jugador se "pase" (Bust).
* **Dealer Automatizado:** IA básica que toma decisiones de pedir o plantarse según las reglas oficiales.
* **Haptic Feedback (Vibración):** Integración con `Core Haptics` / `UINotificationFeedbackGenerator` para dar respuesta física al pedir carta, ganar o perder.
* **Interfaz Declarativa:** UI construida 100% con SwiftUI.

## 🛠 Stack Tecnológico y Arquitectura

El proyecto sigue el patrón de diseño **MVVM (Model-View-ViewModel)** para asegurar un código limpio y escalable:

* **Model:** Estructuras `Card`, `Deck` y Enums para `Rank` y `Suit`. Lógica pura de datos.
* **ViewModel:** Clase `GameViewModel` (`ObservableObject`) que maneja la lógica de negocio, puntuaciones y estado del juego.
* **View:** `ContentView` que reacciona a los cambios del ViewModel mediante `@StateObject` y `@Published`.
* **SwiftUI:** Para toda la interfaz visual y animaciones.

## 🧩 Fragmento de Código Destacado

Lógica para calcular el puntaje considerando que el As puede valer 1 u 11 dinámicamente:

```swift
func calculateScore(of hand: [Card]) -> Int {
    var score = 0
    var aceCount = 0
    
    // Suma inicial
    for card in hand {
        score += card.rank.value
        if card.rank == .ace { aceCount += 1 }
    }
    
    // Ajuste dinámico de Ases si nos pasamos de 21
    while score > 21 && aceCount > 0 {
        score -= 10
        aceCount -= 1
    }
    
    return score
}
```
🚀 Cómo ejecutarlo
Clona este repositorio.

Abre el archivo .xcodeproj en Xcode.

Selecciona un simulador (o tu iPhone físico) y presiona Cmd + R.

<div align="center"> Desarrollado por <a href="https://josecisneros.me">José Cisneros</a> </div>


