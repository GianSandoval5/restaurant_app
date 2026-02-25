# Estructura del Proyecto - Restaurant App

## 📁 Organización de Carpetas

```
lib/
├── core/                          # Núcleo de la aplicación
│   ├── constants/
│   │   └── app_colors.dart       # Paleta de colores
│   ├── theme/
│   │   └── app_theme.dart        # Tema Material Design
│   └── routes/
│       └── app_routes.dart       # Rutas de navegación
│
├── data/                          # Capa de datos
│   ├── models/                    # Modelos de datos
│   │   ├── user_model.dart
│   │   ├── category_model.dart
│   │   ├── product_model.dart
│   │   └── favorite_model.dart
│   └── datasources/               # Fuentes de datos (Firebase)
│       ├── auth_datasource.dart
│       ├── category_datasource.dart
│       ├── product_datasource.dart
│       └── favorite_datasource.dart
│
└── presentation/                  # Capa de presentación
    ├── providers/                 # State management
    │   ├── auth_provider.dart
    │   ├── category_provider.dart
    │   ├── product_provider.dart
    │   └── favorite_provider.dart
    │
    ├── widgets/                   # Widgets reutilizables
    │   ├── custom_text_field.dart
    │   ├── custom_button.dart
    │   ├── product_card.dart
    │   ├── category_card.dart
    │   └── common_widgets.dart
    │
    └── pages/                     # Pantallas
        ├── splash/
        │   └── splash_page.dart
        ├── auth/
        │   ├── login_page.dart
        │   └── register_page.dart
        ├── main/
        │   ├── main_page.dart
        │   ├── home_page.dart
        │   ├── favorites_page.dart
        │   └── profile_page.dart
        ├── product/
        │   ├── product_detail_page.dart
        │   └── category_products_page.dart
        └── admin/
            ├── admin_panel_page.dart
            ├── category/
            │   ├── admin_categories_page.dart
            │   └── admin_category_form_page.dart
            └── product/
                ├── admin_products_page.dart
                └── admin_product_form_page.dart
```

## 🔄 Flujo de Datos

### Clean Architecture Flow

```
UI (Pages)
    ↓
Providers (State Management)
    ↓
DataSources (Firebase)
    ↓
Models (Data)
    ↓
UI (Updated)
```

## 📦 Modelos de Datos

### UserModel

```dart
- uid: String
- email: String
- name: String
- isAdmin: bool
- createdAt: DateTime
- photoUrl: String?
```

### CategoryModel

```dart
- id: String
- name: String
- description: String
- imageUrl: String
- order: int
- createdAt: DateTime
- updatedAt: DateTime
- isActive: bool
```

### ProductModel

```dart
- id: String
- name: String
- description: String
- price: double
- categoryId: String
- imageUrls: List<String>
- isAvailable: bool
- isFeatured: bool
- createdAt: DateTime
- updatedAt: DateTime
- stock: int
- preparationTime: String?
- ingredients: List<String>?
- nutritionalInfo: Map<String, dynamic>?
- discount: double?
```

### FavoriteModel

```dart
- id: String
- userId: String
- productId: String
- createdAt: DateTime
```

## 🎯 Providers

### AuthProvider

**Responsabilidades:**

- Autenticación de usuarios
- Registro de nuevos usuarios
- Gestión de sesión
- Recuperación de contraseña
- Actualización de perfil

**Métodos principales:**

- `login()` - Iniciar sesión
- `register()` - Registrar usuario
- `logout()` - Cerrar sesión
- `resetPassword()` - Recuperar contraseña
- `updateProfile()` - Actualizar perfil

**Streams:**

- `authStateChanges` - Estado de autenticación
- `getUserStream()` - Datos del usuario

### CategoryProvider

**Responsabilidades:**

- CRUD de categorías
- Gestión de imágenes
- Ordenamiento de categorías

**Métodos principales:**

- `createCategory()` - Crear categoría
- `updateCategory()` - Actualizar categoría
- `deleteCategory()` - Eliminar categoría

**Streams:**

- `categoriesStream` - Categorías activas
- `allCategoriesStream` - Todas las categorías
- `getCategoryByIdStream()` - Categoría específica

### ProductProvider

**Responsabilidades:**

- CRUD de productos
- Gestión de múltiples imágenes
- Filtrado por categoría

**Métodos principales:**

- `createProduct()` - Crear producto
- `updateProduct()` - Actualizar producto
- `deleteProduct()` - Eliminar producto
- `deleteProductImage()` - Eliminar imagen

**Streams:**

- `productsStream` - Productos disponibles
- `allProductsStream` - Todos los productos
- `getProductsByCategoryStream()` - Por categoría
- `featuredProductsStream` - Productos destacados
- `getProductByIdStream()` - Producto específico

### FavoriteProvider

**Responsabilidades:**

- Gestión de favoritos por usuario
- Toggle de favoritos
- Consulta de productos favoritos

**Métodos principales:**

- `toggleFavorite()` - Agregar/quitar favorito
- `addToFavorites()` - Agregar a favoritos
- `removeFromFavorites()` - Quitar de favoritos
- `isFavorite()` - Verificar si es favorito

**Streams:**

- `favoriteProductIdsStream` - IDs de favoritos
- `favoriteProductsStream` - Productos favoritos completos

## 🎨 Widgets Reutilizables

### CustomTextField

Campo de texto personalizado con:

- Validaciones integradas
- Iconos personalizables
- Soporte para contraseñas
- Estilos consistentes

### CustomButton

Botón personalizado con:

- Estados de carga
- Variantes (filled/outlined)
- Iconos opcionales
- Colores personalizables

### ProductCard

Tarjeta de producto con:

- Imagen con caché
- Precio (con descuento)
- Badge de descuento
- Botón de favorito
- Animaciones

### CategoryCard

Tarjeta de categoría con:

- Imagen con caché
- Nombre
- Diseño horizontal
- Animaciones

### CommonWidgets

- `LoadingWidget` - Indicador de carga
- `EmptyWidget` - Estado vacío
- `ErrorWidget` - Estado de error

## 🔐 Seguridad

### Validaciones

Todas las validaciones están centralizadas en `Validators`:

- `email()` - Validar email
- `password()` - Validar contraseña
- `required()` - Campo requerido
- `number()` - Número válido
- `positiveNumber()` - Número positivo

### Permisos de Usuario

- Usuario normal: Ver productos, agregar favoritos
- Admin: Acceso completo al panel de administración

## 🎨 Diseño

### Paleta de Colores

- **Primary**: Naranja (#FF6B35)
- **Secondary**: Azul oscuro (#2C3E50)
- **Accent**: Amarillo (#F39C12)
- **Success**: Verde (#27AE60)
- **Error**: Rojo (#E74C3C)
- **Info**: Azul (#3498DB)

### Tipografía

- Display Large: 32px, Bold
- Display Medium: 28px, Bold
- Display Small: 24px, SemiBold
- Headline: 20px, SemiBold
- Title: 16px, SemiBold
- Body: 14-16px, Regular
- Label: 12-14px, Medium

## 📱 Navegación

### Rutas Principales

- `/` - Splash Screen
- `/login` - Login
- `/register` - Registro
- `/main` - Pantalla principal con BottomNav
- `/product-detail` - Detalle de producto
- `/category-products` - Productos por categoría
- `/admin-panel` - Panel de administración
- `/admin-categories` - Gestión de categorías
- `/admin-products` - Gestión de productos

### Bottom Navigation

1. **Home** - Inicio con categorías y productos
2. **Favoritos** - Productos favoritos del usuario
3. **Perfil** - Información y opciones del usuario

## 🔄 Estados de la UI

### Loading States

- Splash screen con animación
- Indicadores de carga en botones
- Skeletons en listas (CircularProgressIndicator)

### Empty States

- Mensajes personalizados
- Iconos representativos
- Botones de acción opcionales

### Error States

- Mensajes de error claros
- Opción de reintentar
- Iconos de error

## 🚀 Optimizaciones

### Performance

- Uso de `const` constructors
- Caché de imágenes con `cached_network_image`
- Streams para actualizaciones en tiempo real
- Lazy loading en listas

### Code Quality

- Clean Architecture
- Separación de responsabilidades
- Código reutilizable
- Nombres descriptivos
- Comentarios donde es necesario

---

Esta estructura sigue las mejores prácticas de Flutter y permite:

- ✅ Escalabilidad
- ✅ Mantenibilidad
- ✅ Testabilidad
- ✅ Reutilización de código
- ✅ Separación clara de responsabilidades
