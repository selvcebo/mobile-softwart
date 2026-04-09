# SoftwArt — Mobile

> Ver también `../CLAUDE.md` para arquitectura general, auth y flujo de negocio.

## Propósito

App móvil de **consulta y seguimiento** para Admin/Empleado. No reemplaza el panel web — es una herramienta de revisión rápida desde el celular. El CRUD completo vive en el frontend web.

## Módulos disponibles

| Módulo | Acciones |
|---|---|
| Auth | Login, Logout |
| Dashboard | KPIs: ventas del mes, citas de hoy, servicios pendientes, pagos pendientes |
| Citas | Listar, buscar, filtrar por estado, ver detalle, cambiar estado |
| Servicios | Listar, buscar, filtrar por estado, ver detalle, cambiar estado |
| Ventas | Listar, buscar, filtrar por estado, ver detalle, ver plan de abonos |
| Pagos | Listar, buscar, filtrar por estado, ver detalle, cambiar estado |
| Clientes | Listar, buscar, ver detalle (solo consulta) |

---

## Stack

- **Flutter + Dart**
- **provider** — manejo de estado (ChangeNotifier)
- **http** — consumo de API REST
- **shared_preferences** — persistencia del token JWT

### pubspec.yaml (dependencias principales)

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  http: ^1.2.1
  shared_preferences: ^2.2.3
dev_dependencies:
  flutter_launcher_icons: ^0.14.3
flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/images/softwart-logo.png"
  adaptive_icon_background: "#002926"
  adaptive_icon_foreground: "assets/images/softwart-logo.png"
flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

---

## Arquitectura — Clean Architecture modular

```
mobile/lib/
  core/
    constants/
      api_constants.dart     — BASE_URL + todos los endpoints
    errors/
      exceptions.dart
    theme/
      app_theme.dart         — AppColors
    utils/
      token_storage.dart     — guardar/leer/borrar token
      formatters.dart        — formatFecha(), formatHora(), formatCOP()
  data/
    datasources/             — auth, citas, pedidos, ventas, clientes, dashboard, pagos
    models/                  — usuario, cita, pedido, venta, cliente, dashboard, pago
    repositories/            — implementaciones de los repositorios del dominio
  domain/
    entities/                — usuario, cita, pedido, venta, cliente, dashboard_stats, pago
    repositories/            — interfaces (contratos)
    usecases/
      auth/     login_usecase.dart  logout_usecase.dart
      citas/    get_citas_usecase.dart  cambiar_estado_cita_usecase.dart
      pedidos/  get_pedidos_usecase.dart  cambiar_estado_pedido_usecase.dart
      ventas/   get_ventas_usecase.dart  get_estado_pagos_usecase.dart
      clientes/ get_clientes_usecase.dart
      dashboard/get_dashboard_usecase.dart
      pagos/    get_pagos_usecase.dart  cambiar_estado_pago_usecase.dart
  presentation/
    providers/               — auth, citas, pedidos, ventas, clientes, dashboard, pagos
    pages/
      auth/        login_page.dart
      main_shell.dart
      dashboard/   dashboard_page.dart
      citas/       citas_page.dart  cita_detalle_page.dart
      pedidos/     pedidos_page.dart  pedido_detalle_page.dart
      ventas/      ventas_page.dart  venta_detalle_page.dart
      clientes/    clientes_page.dart  cliente_detalle_page.dart
      pagos/       pagos_page.dart  pago_detalle_page.dart
    widgets/
      user_menu_button.dart   — CircleAvatar con inicial + popup logout
      filtro_menu_button.dart — popover de filtros (punto indicador si activo)
      kpi_card.dart
      estado_badge.dart
      loading_widget.dart
      app_error_widget.dart   — clase AppErrorWidget (no ErrorWidget — conflicto con Flutter)
  main.dart
```

### Flujo de datos

```
Page → Provider (ChangeNotifier) → UseCase → Repository (interface)
                                                  ↓
                                       RepositoryImpl → DataSource → http
```

---

## Navegación

- **`MainShell`** con `Drawer` lateral + `IndexedStack` de 6 tabs: Dashboard → Citas → Servicios → Ventas → Pagos → Clientes.
- Drawer con fondo `Color(0xFF002926)` — cabecera con logo + nombre + ítem activo resaltado.
- `MainShell.scaffoldKey` — `GlobalKey<ScaffoldState>` estático; cada página lo usa para abrir el drawer desde su botón hamburguesa.
- **`UserMenuButton`** en el AppBar: muestra la inicial del usuario; tap → nombre + correo + "Cerrar sesión".
- Rutas nombradas: solo `/login` y `/home` (MainShell). Las páginas de detalle usan `MaterialPageRoute`.

---

## Splash screen (`main.dart → _Splash`)

- Gradiente oscuro idéntico al login + logo + "Iniciando..." + spinner.
- En `initState` lanza un warmup ping (`http.get(...).ignore()`) al endpoint `/api/dashboard` para despertar el servidor de Render antes de que el usuario llegue al login.
- Verifica el token local en paralelo y redirige a `/home` o `/login`.

---

## Selector de estado (chips animados)

En `cita_detalle_page.dart`, `pedido_detalle_page.dart` y `pago_detalle_page.dart` el cambio de estado usa chips `AnimatedContainer`:

- Seleccionado: fondo `AppColors.primary`, texto blanco, borde grueso.
- No seleccionado: fondo blanco, borde `AppColors.border`.

---

## Theme

```dart
class AppColors {
  static const primary     = Color(0xFF8B5A3C); // sienna
  static const secondary   = Color(0xFF2D4A47); // dark teal
  static const accent      = Color(0xFFD4B896); // warm tan
  static const background  = Color(0xFFFAFAFA);
  static const card        = Color(0xFFFFFFFF);
  static const border      = Color(0xFFE5E7EB);
  static const muted       = Color(0xFF6B7280);
  static const foreground  = Color(0xFF111827);
  static const destructive = Color(0xFFEF4444);
}
```

---

## Formatters (`core/utils/formatters.dart`)

```dart
formatFecha("2025-03-15")   // → "15 mar 2025"   (soporta ISO con T)
formatHora("14:00:00")      // → "2:00 PM"
formatCOP(150000)           // → "$150.000"
```

---

## Conexión con el backend

### Base URL (`api_constants.dart`)

```dart
static const String baseUrl = 'https://softwart-backend.onrender.com/api'; // Producción
// static const String baseUrl = 'http://10.0.2.2:3001/api'; // Android emulator local
// static const String baseUrl = 'http://localhost:3001/api'; // Web/iOS local
```

### Endpoints consumidos

```
POST  /api/auth/login
GET   /api/dashboard
GET   /api/appointments?limit=500
PATCH /api/appointment-status/cita/:id/estado   body: { id_estado_cita }
GET   /api/sale-details?limit=500
PATCH /api/service-status/detalle/:id/estado    body: { id_estado }
GET   /api/sales?limit=500
GET   /api/sales/:id/payment-plan
GET   /api/clients?limit=500
GET   /api/payments?limit=500
PUT   /api/payments/:id                         body: { id_estado_pago }
```

---

## Convenciones Dart/Flutter

- Archivos: `snake_case.dart` | Clases: `PascalCase` | Variables: `camelCase`
- Cada UseCase tiene `call()` como método principal.
- Providers exponen `isLoading`, `error`, datos y métodos de carga/acción.
- Comentarios en español.
- El widget de error custom se llama `AppErrorWidget` para evitar conflicto con `ErrorWidget` de Flutter.

---

## Configuración Android

### `android/app/build.gradle.kts`

| Campo | Valor |
|---|---|
| `namespace` | `"com.softwart.app"` |
| `applicationId` | `"com.softwart.app"` |
| SDK versions | Delegadas a Flutter (`flutter.compileSdkVersion`, etc.) |
| `signingConfig` (release) | Debug keys — válido para distribución académica; producción requiere keystore propio |

### `android/app/src/main/kotlin/…/MainActivity.kt`

```kotlin
package com.softwart.app   // debe coincidir con applicationId
import io.flutter.embedding.android.FlutterActivity
class MainActivity : FlutterActivity()
```

### `android/app/src/main/AndroidManifest.xml`

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

`android:label="SoftwArt"` — nombre visible en el launcher del dispositivo.

### Iconos adaptativos

```bash
dart run flutter_launcher_icons
```

Genera todas las resoluciones (`mipmap-hdpi/xhdpi/xxhdpi/xxxhdpi`) desde `assets/images/softwart-logo.png`. El `adaptive_icon_background: "#002926"` aplica el fondo verde oscuro corporativo en Android 8+.

---

## Generación del APK

```bash
cd mobile-softwart
flutter pub get
dart run flutter_launcher_icons   # solo si se actualiza el logo
flutter build apk --release
# APK: build/app/outputs/flutter-apk/app-release.apk  (~49 MB)
```

La URL de producción está configurada en `api_constants.dart`. No se requiere configuración adicional para el build.
