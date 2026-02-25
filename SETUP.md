# Guía de Configuración - Restaurant App

## 🔥 Configuración de Firebase

### 1. Crear Proyecto en Firebase

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita los siguientes servicios:
   - **Authentication** → Email/Password
   - **Cloud Firestore** → Modo producción
   - **Storage** → Modo producción

### 2. Configurar Reglas de Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users collection
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }

    // Categories collection
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if request.auth != null &&
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }

    // Products collection
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null &&
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }

    // Favorites collection
    match /favorites/{favoriteId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && request.resource.data.userId == request.auth.uid;
      allow delete: if request.auth != null && resource.data.userId == request.auth.uid;
    }
  }
}
```

### 3. Configurar Reglas de Storage

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /categories/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 4. Configurar la App

Ya ejecutaste `flutterfire configure`, los archivos necesarios ya están creados:

- `lib/firebase_options.dart`
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `macos/Runner/GoogleService-Info.plist`

## 👨‍💼 Crear Usuario Administrador

### Opción 1: Manualmente desde Firebase Console

1. Registra un usuario desde la app
2. Ve a Firebase Console → Authentication
3. Copia el UID del usuario
4. Ve a Firestore Database
5. Encuentra el documento del usuario en la colección `users`
6. Edita el campo `isAdmin` a `true`

### Opción 2: Usando Firebase CLI (Avanzado)

```javascript
// En Firebase Functions o desde la consola de Firestore
db.collection("users").doc("USER_UID_AQUI").update({
  isAdmin: true,
});
```

## 📊 Estructura de Datos Inicial

### Crear Categorías de Ejemplo

Ve a Firestore y crea documentos en la colección `categories`:

```json
{
  "name": "Pizzas",
  "description": "Deliciosas pizzas artesanales",
  "imageUrl": "URL_DE_IMAGEN",
  "order": 1,
  "isActive": true,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

### Crear Productos de Ejemplo

```json
{
  "name": "Pizza Margherita",
  "description": "Pizza clásica con tomate, mozzarella y albahaca",
  "price": 12.99,
  "categoryId": "ID_DE_CATEGORIA",
  "imageUrls": ["URL_IMAGEN_1", "URL_IMAGEN_2"],
  "isAvailable": true,
  "isFeatured": true,
  "stock": 50,
  "preparationTime": "15-20 min",
  "ingredients": ["Tomate", "Mozzarella", "Albahaca", "Aceite de oliva"],
  "nutritionalInfo": {
    "calories": "250 kcal",
    "protein": "12g",
    "carbs": "30g",
    "fat": "8g"
  },
  "discount": 10,
  "createdAt": "2024-01-01T00:00:00.000Z",
  "updatedAt": "2024-01-01T00:00:00.000Z"
}
```

## 🎨 Personalización

### Cambiar Colores

Edita `lib/core/constants/app_colors.dart`:

```dart
static const Color primary = Color(0xFFFF6B35); // Tu color primario
static const Color secondary = Color(0xFF2C3E50); // Tu color secundario
```

### Cambiar Nombre de la App

1. **Android**: `android/app/src/main/AndroidManifest.xml`

   ```xml
   android:label="Tu Nombre de App"
   ```

2. **iOS**: `ios/Runner/Info.plist`
   ```xml
   <key>CFBundleName</key>
   <string>Tu Nombre de App</string>
   ```

### Cambiar Icono de la App

Usa [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons):

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
```

Luego ejecuta:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## 🐛 Solución de Problemas

### Error de Gradle (Android)

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Error de Pods (iOS)

```bash
cd ios
pod deinstall
pod install
cd ..
flutter clean
flutter pub get
```

### Error de Firebase

- Verifica que los archivos de configuración estén en su lugar
- Asegúrate de que el package name coincida en Firebase Console y tu proyecto
- Revisa que Firebase esté habilitado para las plataformas que usas

## 🚀 Comandos Útiles

```bash
# Limpiar proyecto
flutter clean

# Obtener dependencias
flutter pub get

# Verificar problemas
flutter doctor

# Ejecutar en dispositivo
flutter run

# Build para Android
flutter build apk --release

# Build para iOS
flutter build ios --release

# Ver logs
flutter logs
```

## 📱 Testing en Dispositivos

### Android

- Habilita "Depuración USB" en opciones de desarrollo
- Conecta el dispositivo y ejecuta `flutter devices`
- Ejecuta `flutter run`

### iOS (requiere Mac)

- Abre Xcode
- Configura tu equipo de desarrollo
- Selecciona un dispositivo o simulador
- Ejecuta desde Xcode o con `flutter run`

## ⚡ Optimización

### Para mejor rendimiento:

1. Usa `const` constructors donde sea posible
2. Implementa lazy loading para listas grandes
3. Optimiza imágenes antes de subirlas
4. Usa índices en Firestore para queries complejas

## 📞 Soporte

Si encuentras problemas:

1. Revisa la documentación de [Flutter](https://flutter.dev/docs)
2. Consulta la documentación de [Firebase](https://firebase.google.com/docs)
3. Verifica los issues en el repositorio

---

¡Disfruta desarrollando con Restaurant App! 🎉
