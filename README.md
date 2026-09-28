# ⚙️ PuvloBuilder Backend API

Servidor y API REST modular multi-tenant para **PuvloBuilder**.

## 🚀 Tecnologías

- **Node.js** + **Fastify 5**
- **TypeScript**
- **Prisma ORM** + **MariaDB**
- **JWT** (Autenticación de 2 niveles: SuperAdmin y Sub-Admin por Tenant)
- **@fastify/multipart** + **@fastify/static** (Almacenamiento físico por tenant)
- **Zod** (Validación de esquemas)

## 📁 Estructura del Backend

```text
├── prisma/
│   └── schema.prisma         # Modelos de base de datos MariaDB (SuperAdmin, Project, ProjectUser, ProjectSubmission)
├── src/
│   ├── config/               # Variables de entorno y configuración Zod
│   ├── lib/                  # Cliente Prisma singleton
│   ├── middlewares/          # Guards de autenticación de dos niveles
│   ├── modules/
│   │   ├── superadmin-auth/  # Auth del SuperAdmin maestro (/api/superadmin/auth)
│   │   ├── project-auth/     # Auth por tenant independiente (/api/projects/:slug/auth)
│   │   └── projects/         # CRUD de proyectos, bloques JSON y subida de archivos (/api/projects)
│   ├── services/
│   │   └── tenant-storage.service.ts # Gestor del workspace y carpetas físicas por tenant
│   └── server.ts             # Punto de entrada Fastify
└── storage/
    └── tenants/              # Espacios de trabajo aislados en disco por tenant
        └── {routePrefix}/
            └── {slug}/
                ├── uploads/  # Imágenes y multimedia del cliente
                ├── assets/   # Recursos del proyecto
                ├── exports/  # Exportaciones estáticas
                ├── config.json
                └── README.md
```

## 🛠️ Instalación y Puesta en Marcha

### 1. Variables de Entorno (.env)
```env
PORT=4000
HOST=0.0.0.0
NODE_ENV=development
DATABASE_URL="mysql://minicms_user:23010@localhost:3306/minicms_db"
JWT_SECRET="puvlo_builder_super_secret_jwt_key_2026_x99"
```

### 2. Comandos

```bash
# Instalar dependencias
npm install

# Generar cliente de Prisma y sincronizar esquema
npx prisma generate
npx prisma db push

# Iniciar en modo desarrollo
npm run dev

# Compilar TypeScript
npm run build
```

## 🌐 Repositorio Frontend

El frontend desacoplado se encuentra en:
👉 [Paulob0t/PuvloBuilder_Front](https://github.com/Paulob0t/PuvloBuilder_Front)
