# CODEBASE - FocusMode

Este documento resume la estructura de vistas, clases y componentes principales del proyecto Flutter **FocusMode**.

## 1. Punto de entrada

### `lib/main.dart`
- Función `main()` inicia la app con `runApp(const MyApp())`.
- Clase `MyApp` (`StatelessWidget`) configura:
- `MaterialApp`
- `ThemeData(useMaterial3: true)`
- Tipografía global con `GoogleFonts.poppinsTextTheme()`
- Pantalla inicial: `Home`

## 2. Vistas de la aplicación

### `lib/view/Home.dart`
Clase: `Home` (`StatelessWidget`)

Responsabilidad:
- Pantalla de inicio (landing).
- Muestra logo y título de la app.
- Ofrece dos accesos: `Login` y `SignUp`.

Componentes usados:
- `Scaffold`, `Column`, `Expanded`, `Container`, `Padding`
- `Image.asset`, `Text`
- `ElevatedButton`, `OutlinedButton`
- Navegación con `Navigator.push` y `MaterialPageRoute`

### `lib/view/login.dart`
Clase: `Login` (`StatelessWidget`)

Responsabilidad:
- Interfaz de inicio de sesión.
- Navega hacia el flujo de permisos (`Permiso`).

Componentes usados:
- `Stack`, `Positioned`, `SafeArea`, `Row`, `Column`
- `TextField` (mediante método helper `buildTextField`)
- Botón principal con `Container + Material + InkWell`
- `TextButton` para acciones secundarias

Método relevante:
- `buildTextField(String hint, {bool isPassword = false})`

Navegación:
- Regresar: `Navigator.pop(context)`
- Continuar: `Navigator.push(... Permiso())`

### `lib/view/SignUp.dart`
Clase: `SignUp` (`StatelessWidget`)

Responsabilidad:
- Interfaz de registro de usuario.
- Permite ir a la pantalla de login.

Componentes usados:
- `Scaffold`, `SafeArea`, `Column`, `TextField`
- `ElevatedButton`, `TextButton`, `InkWell`

Método relevante:
- `buildTextField(String hint, {bool isPassword = false})`

Navegación:
- Regresar: `Navigator.pop(context)`
- Ir a login: `Navigator.push(... Login())`

### `lib/view/Permiso.dart`
Clase: `Permiso` (`StatelessWidget`)

Responsabilidad:
- Solicitar permisos de tiempo en pantalla (simulado en UI).
- Mostrar ventana emergente de confirmación.
- Si el usuario acepta, redirige a la pantalla principal.

Componentes usados:
- `Scaffold`, `Stack`, `SafeArea`, `Center`, `Column`
- `showDialog`, `Dialog`, `ElevatedButton`
- `GoogleFonts.poppins`

Método relevante:
- `VentanaEmergente(BuildContext context)`

Navegación:
- Aceptar: `Navigator.pushReplacement(... PantallaPrincipal())`
- Cancelar: `Navigator.pop(context)` (cierra diálogo)

### `lib/view/PantallaPrincipal.dart`
Clase: `PantallaPrincipal` (`StatefulWidget`)
Estado: `_PantallaPrincipalState`

Responsabilidad:
- Pantalla principal del enfoque.
- Gestionar apps restringidas.
- Permitir seleccionar tiempo límite por app.

Estado y lógica:
- `List<Modelo_App> appsRestringidas`
- `Timer? timer` con refresco cada segundo
- `initState()` inicia timer
- `dispose()` cancela timer
- `abrirAddApp()` abre selección de apps y sincroniza resultados

Componentes usados:
- `FloatingActionButton`
- `ListView.builder`
- `DropdownButton<int>` y `DropdownMenuItem`
- `Image.asset`, `Container`, `Row`, `Text`

### `lib/view/AddApp.dart`
Clase: `AddApp` (`StatefulWidget`)
Estado: `_AddAppState`

Responsabilidad:
- Mostrar catálogo de apps disponibles para restringir.
- Marcar/desmarcar selección con checkboxes.
- Devolver selección a la pantalla anterior.

Datos:
- Recibe `appsSeleccionadas` por constructor.
- Mantiene `todasLasApps` (TikTok, Instagram, WhatsApp, Facebook).

Componentes usados:
- `AppBar`, `ListView.builder`, `CheckboxListTile`
- `ElevatedButton`

Métodos relevantes:
- `initState()` sincroniza selección previa
- `guardar()` devuelve selección con `Navigator.pop(context, seleccionadas)`

## 3. Modelo de datos

### `lib/view/Modelo_App.dart`
Clase: `Modelo_App`

Campos:
- `nombre` (String)
- `icono` (String)
- `seleccionada` (bool)
- `minutos` (int)
- `tiempoInicio` (DateTime?)

Lógica importante:
- Getter `estaActiva`
- Calcula si la restricción sigue activa comparando `DateTime.now()` con `tiempoInicio`.

## 4. Flujo de navegación general

1. `MyApp` -> `Home`
2. `Home` -> `Login` o `SignUp`
3. `Login` -> `Permiso`
4. `Permiso` -> `PantallaPrincipal` (si acepta)
5. `PantallaPrincipal` -> `AddApp` (FAB)
6. `AddApp` retorna selección a `PantallaPrincipal`

### 4.1 Flujo entre vistas (actual)

```text
MyApp
  -> Home
	-> (Boton Login) -> Login
		-> (Sign Up) -> Permiso
			-> (Conceder permisos -> Continuar) -> PantallaPrincipal
			-> (No permitir) -> Permiso
		-> (Back) -> Home
	-> (Boton Sign up) -> SignUp
		-> (Already have an account? Login) -> Login
		-> (Back) -> Home

PantallaPrincipal
  -> (FAB +) -> AddApp
	  -> (Guardar cambios) -> PantallaPrincipal (con lista seleccionada)
	  -> (Back del AppBar) -> PantallaPrincipal (sin cambios)
```

### 4.2 Acciones y resultado por vista

- `Home`
- `Login`: `Navigator.push(... Login())`
- `Sign up`: `Navigator.push(... SignUp())`

- `Login`
- `Back`: `Navigator.pop(context)`
- `Sign Up` (boton principal): `Navigator.push(... Permiso())`

- `SignUp`
- `Back`: `Navigator.pop(context)`
- `Already have an account? Login`: `Navigator.push(... Login())`

- `Permiso`
- `Back`: `Navigator.pop(context)`
- `CONCEDER PERMISOS` + `CONTINUAR`: `Navigator.pushReplacement(... PantallaPrincipal())`
- `NO PERMITIR`: se cierra dialogo y permanece en `Permiso`

- `PantallaPrincipal`
- `FAB (+)`: abre `AddApp`
- `Perfil`: actualmente solo imprime en consola (`print("Abrir perfil")`)

- `AddApp`
- `Guardar cambios`: `Navigator.pop(context, seleccionadas)`
- `Back` AppBar: `Navigator.pop(context)`

## 5. Componentes y clases Flutter usados en el proyecto

Estructura:
- `MaterialApp`, `Scaffold`, `AppBar`, `SafeArea`

Layout:
- `Column`, `Row`, `Expanded`, `Container`, `Padding`, `SizedBox`, `Stack`, `Positioned`, `Center`

UI y estilo:
- `Text`, `Image.asset`, `Icon`
- `BoxDecoration`, `BorderRadius`, `LinearGradient`, `BoxShadow`

Entrada e interacción:
- `TextField`, `CheckboxListTile`, `DropdownButton`, `DropdownMenuItem`
- `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`, `InkWell`, `FloatingActionButton`

Listas y modales:
- `ListView.builder`, `showDialog`, `Dialog`

Navegación:
- `Navigator.push`, `Navigator.pop`, `Navigator.pushReplacement`, `MaterialPageRoute`

Estado y ciclo de vida:
- `StatelessWidget`, `StatefulWidget`, `initState`, `dispose`, `setState`
- `Timer` (`dart:async`)

Tipografía externa:
- `google_fonts` -> `GoogleFonts.poppins`

## 6. Observaciones técnicas actuales

- Existe inconsistencia de mayúsculas/minúsculas en imports de archivos (`login.dart`/`Login.dart`, `SignUp.dart`/`signup.dart`) que puede fallar en sistemas sensibles a case.
- Posible inconsistencia de nombre de asset: `whatsapp.png` en `pubspec.yaml` vs `Whatsapp.png` en `AddApp.dart`.
- `test/widget_test.dart` aún contiene la prueba de contador por defecto y no valida las vistas reales de FocusMode.

