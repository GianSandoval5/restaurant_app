# Restaurant App - Flutter

Aplicación completa de restaurante desarrollada con Flutter y Firebase, siguiendo Clean Architecture y mejores prácticas de desarrollo.

## 🚀 Características

### Autenticación

- ✅ Login con email y contraseña
- ✅ Registro de nuevos usuarios
- ✅ Validaciones completas en formularios
- ✅ Manejo de errores con mensajes en español
- ✅ Recuperación de contraseña

### Funcionalidades Principales

- ✅ **Home**: Visualización de categorías y productos destacados
- ✅ **Favoritos**: Gestión de productos favoritos por usuario
- ✅ **Carrito**: Agregar productos, gestionar cantidades, realizar pedidos
- ✅ **Perfil**: Información del usuario y opciones de cuenta
- ✅ **Categorías**: Navegación por categorías de productos
- ✅ **Detalle de Producto**: Información completa con imágenes, precio, ingredientes, información nutricional

### Panel de Administración

- ✅ Gestión completa de **Categorías** (CRUD)
  - Crear, editar, eliminar categorías
  - Subir imágenes
  - Ordenamiento personalizado
- ✅ Gestión completa de **Productos** (CRUD)
  - Crear, editar, eliminar productos
  - **Múltiples imágenes por producto** (imageUrls - Lista de URLs)
  - Descuentos
  - Control de stock
  - Productos destacados
  - Tiempo de preparación
  - Ingredientes
  - Información nutricional

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture** con las siguientes capas:

```
lib/
├── core/
│   ├── constants/        # Colores y constantes
│   ├── theme/           # Tema de la aplicación
│   └── routes/          # Rutas de navegación
├── data/
│   ├── models/          # Modelos de datos
│   └── datasources/     # Fuentes de datos (Firebase)
└── presentation/
    ├── providers/       # State management con Provider
    ├── widgets/         # Widgets reutilizables
    └── pages/          # Pantallas de la aplicación
```

## 📦 Dependencias Principales

### Firebase

- **firebase_core**: Firebase initialization
- **firebase_auth**: Autenticación
- **cloud_firestore**: Base de datos
- **firebase_storage**: Almacenamiento de imágenes
- **firebase_app_check**: Seguridad y validación de apps

### State Management

- **provider**: State management

### Almacenamiento Local

- **hive**: Base de datos NoSQL local
- **hive_flutter**: Integración de Hive con Flutter
- Uso: Persistencia de carrito de compras y sesión de usuario

### Imágenes

- **image_picker**: Selección de imágenes
- **cached_network_image**: Caché de imágenes

### UI/UX

- **cached_network_image**: Caché de imágenes
- **animate_do**: Animaciones
- **intl**: Formateo de números y fechas

## 🎨 Diseño

- **Colores personalizados** definidos en `app_colors.dart`
- **Tema consistente** en toda la aplicación
- **Animaciones fluidas** usando animate_do
- **UI/UX profesional** con Material Design 3
- **Responsive design** adaptable a diferentes pantallas

## 🔐 Firebase Setup

El proyecto está configurado con Firebase. Para usarlo:

1. Asegúrate de tener los archivos de configuración:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
   - `macos/Runner/GoogleService-Info.plist`
   - `lib/firebase_options.dart`

2. Estructura de Firestore:

   ```
   users/
     - uid
       - email
       - name
       - isAdmin
       - createdAt

   categories/
     - id        # Lista de URLs de imágenes (múltiples imágenes)
       - isAvailable
       - isFeatured
       - stock
       - preparationTime
       - ingredients []
       - nutritionalInfo {}
       - discount
       - createdAt
       - updatedAt

   favorites/
     - id
       - userId
       - productId
       - createdAt
   ```

3. Almacenamiento Local (Hive):

   ```
   userBox:
     - userId
     - email
     - name
     - isAdmin

   cartBox:
     - items []
       - productId
       - productName
       - productPrice
       - productImage
       - quantity []
       - isAvailable
       - isFeatured
       - stock
       - preparationTime
       - ingredients []
       - nutritionalInfo {}
       - discount

   favorites/
     - id
       - userId
       - productId
       - createdAt
   ```

## 📱 Permisos (Android)

El AndroidManifest incluye los siguientes permisos:

- INTERNET
- ACCESS_NETWORK_STATE
- READ_EXTERNAL_STORAGE
- WRITE_EXTERNAL_STORAGE
- CAMERA
- READ_MEDIA_IMAGES

## 🚦 Cómo Ejecutar

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Build para producción
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

- `CartProvider`: Gestión del carrito de compras (con persistencia en Hive)

## 💾 Persistencia Local con Hive

La aplicación utiliza **Hive** para almacenamiento local:

### Datos Almacenados

1. **Sesión de Usuario** (`userBox`):
   - userId, email, name, isAdmin
   - Mantiene la sesión activa entre reinicios

2. \*\*Carrito de Compras con badge en carrito

- Grids de productos
- Carousels de categorías
- Detalle de producto con slider de imágenes múltiples
- Carrito de compras con gestión de cantidad

### Ventajas de Hive

- ⚡ Base de datos NoSQL extremadamente rápida
- 📦 Sin dependencias nativas
- 🔒 Encriptación opcional
- 🎯 Type-safe
- 💪 Alto rendimiento

## 👨‍💼 Crear Usuario Administrador

Para tener acceso al panel de administración, necesitas establecer el campo `isAdmin: true` en Firestore para un usuario específico.

1. Crea una cuenta normal desde la app
2. Ve a Firebase Console → Firestore
3. Busca el usuario en la colección `users`
4. Edita el documento y establece `isAdmin: true`

## 📋 Validaciones

Todos los formularios incluyen validaciones:

- Email válido
- Contraseña mínimo 6 caracteres
- Campos requeridos
- Números válidos
- Números positivos

## 🎯 State Management

Se utiliza **Provider** con **Streams** para:

- Actualización en tiempo real de datos
- Gestión eficiente del estado
- Separación de lógica de negocio

Providers incluidos:

- `AuthProvider`: Autenticación y usuario actual
- `CategoryProvider`: Gestión de categorías
- `ProductProvider`: Gestión de productos
- `FavoriteProvider`: Gestión de favoritos

## 🔄 Streams vs Futures

- **Streams**: Para obtener datos en tiempo real (categorías, productos, favoritos)
- **Futures**: Para operaciones de escritura (crear, actualizar, eliminar)

## 📸 Screenshots

La aplicación incluye:

- Splash screen animado
- Login/Register con validaciones
- Bottom Navigation Bar
- Grids de productos
- Carousels de categorías
- Detalle de producto con slider de imágenes
- Panel admin con gestión completa

## 🛠️ Widgets Reutilizables

- `CustomTextField`: Campo de texto personalizado con validaciones
- `CustomButton`: Botón con estados de carga
- `ProductCard`: Tarjeta de producto
- `CategoryCard`: Tarjeta de categoría
- `LoadingWidget`: Indicador de carga
- `EmptyWidget`: Estado vacío
- `ErrorWidget`: Estado de error

## 📝 Notas Adicionales

- Todos los mensajes de error están en español
- La app maneja correctamente los estados de carga y error
- Implementa caché de imágenes para mejor rendimiento
- Incluye animaciones en todas las pantallas
- Diseño responsivo y adaptable

## 👨‍💻 Autor

**GianSandoval5**

- GitHub: [@GianSandoval5](https://github.com/GianSandoval5)

## 🤝 Contribuciones

Este es un proyecto educativo que demuestra las mejores prácticas de desarrollo Flutter con Firebase y Clean Architecture.

Desarrollado por [GianSandoval5](https://github.com/GianSandoval5)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

Copyright (c) 2026 GianSandoval5
