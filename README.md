# Gestor de Agenda 📋

Aplicación móvil de agenda/gestión de tareas, desarrollada como proyecto académico. Permite a cada usuario registrarse, iniciar sesión y administrar sus propias tareas (crear, editar, eliminar, filtrar por estado) desde una app construida en Flutter, con un backend propio en Node.js + MongoDB Atlas.

## Tecnologías

**Frontend**
- Flutter / Dart

**Backend**
- Node.js + Express
- MongoDB Atlas (Mongoose)
- JWT (jsonwebtoken) para autenticación
- bcryptjs para el hash de contraseñas

## Funcionalidades

- Registro e inicio de sesión con JWT
- Recuperación de contraseña (flujo básico)
- Perfil de usuario conectado a la API
- Sesión persistente en el dispositivo (no es necesario volver a iniciar sesión cada vez)
- CRUD completo de tareas (crear, listar, editar, eliminar)
- Filtro de tareas por estado (Pendiente / En progreso / Completada)
- Navegación por pestañas (Agenda / Perfil) con barra flotante
- Cada usuario solo puede ver y administrar sus propias tareas

## Estructura del proyecto

```
gestor_agenda/
├── backend/
│   ├── app.js                     # Configuración de Express y rutas
│   ├── index.js                   # Punto de entrada: conecta DB y levanta el servidor
│   ├── config/
│   │   └── db.js                  # Conexión a MongoDB Atlas
│   ├── controllers/
│   │   ├── auth.controller.js     # Registro, login, recuperar contraseña, perfil
│   │   └── tarea.controller.js    # CRUD de tareas
│   ├── middlewares/
│   │   └── auth.middleware.js     # Verifica el JWT en rutas protegidas
│   ├── models/
│   │   ├── Usuario.model.js
│   │   └── Tarea.model.js
│   ├── routes/
│   │   ├── auth.routes.js
│   │   └── tarea.routes.js
│   ├── .env.example
│   └── package.json
│
└── lib/                           # Proyecto Flutter
    ├── core/
    │   ├── network/                # Servicios HTTP (auth, tareas, token, config de URL)
    │   ├── routes/                 # Rutas nombradas de la app
    │   ├── theme/                  # Colores y estilos
    │   └── widgets/                # Navegación principal (tab bar)
    └── features/
        ├── auth/                   # Login, registro, recuperar contraseña
        └── agenda/                 # Lista de tareas, formulario, perfil
```

## Cómo correrlo localmente

### 1. Backend

```bash
cd backend
npm install
```

Crea un archivo `.env` (usa `.env.example` como plantilla) con:

```dotenv
MONGO_URI=tu_cadena_de_conexión_de_MongoDB_Atlas
JWT_SECRET=un_texto_largo_y_aleatorio
PORT=3000
```

Levanta el servidor:

```bash
npm run dev
```

### 2. Frontend (Flutter)

```bash
flutter pub get
```

En `lib/core/network/api_config.dart`, ajusta `host` según dónde vayas a correr la app:

| Entorno | URL |
|---|---|
| Emulador Android | `http://10.0.2.2:3000` |
| Chrome / Windows / iOS simulator | `http://localhost:3000` |
| Celular físico (misma red wifi) | `http://TU_IP_LOCAL:3000` |

Corre la app:

```bash
flutter run
```

## Endpoints principales de la API

| Método | Ruta | Descripción | Protegida |
|---|---|---|---|
| POST | `/api/auth/register` | Crear cuenta | No |
| POST | `/api/auth/login` | Iniciar sesión | No |
| POST | `/api/auth/forgot-password` | Recuperar contraseña | No |
| GET | `/api/auth/perfil` | Datos del usuario autenticado | Sí |
| GET | `/api/tareas` | Listar tareas (filtro opcional `?estado=`) | Sí |
| POST | `/api/tareas` | Crear tarea | Sí |
| GET | `/api/tareas/:id` | Obtener una tarea | Sí |
| PUT | `/api/tareas/:id` | Actualizar una tarea | Sí |
| DELETE | `/api/tareas/:id` | Eliminar una tarea | Sí |

Las rutas protegidas requieren el header `Authorization: Bearer <token>`, obtenido al iniciar sesión.

## Autores

- Laura Sofía Ulloa Panesso
- Mariana Cardona Mazo