# OpenEMPI 3.5.0c + OrientDB – Entorno Docker

## Estructura del proyecto

```
docker-openempi/
├── docker-compose.yml          ← orquestación de los 3 servicios
├── openempi/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── app/                    ← pon aquí el contenido de C:\openempi
├── orientdb/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── app/                    ← pon aquí el contenido de tu carpeta orientdb
└── README.md
```

---

## Paso 1 – Preparar los ficheros fuente

Antes de construir las imágenes, copia tus instalaciones locales dentro del proyecto:

### OpenEMPI
```powershell
# En PowerShell (Windows)
xcopy /E /I C:\openempi\* C:\ruta\docker-openempi\openempi\app\
```
O simplemente copia la carpeta `C:\openempi` dentro de `docker-openempi/openempi/` y renómbrala `app`.

### OrientDB
```powershell
xcopy /E /I "C:\Users\Oier\OneDrive\Escritorio\orientdb\*" C:\ruta\docker-openempi\orientdb\app\
```
O copia tu carpeta `orientdb` dentro de `docker-openempi/orientdb/` y renómbrala `app`.

---

## Paso 2 – Construir y arrancar

Abre Docker Desktop y asegúrate de que está en ejecución. Luego, en PowerShell:

```powershell
cd C:\ruta\docker-openempi

# Construir las imágenes (solo la primera vez, o cuando cambies algo)
docker compose build

# Arrancar todos los servicios en segundo plano
docker compose up -d
```

---

## Paso 3 – Verificar que todo arranca

```powershell
# Ver el estado de los contenedores
docker compose ps

# Ver los logs en tiempo real (Ctrl+C para salir)
docker compose logs -f

# Ver logs de un servicio concreto
docker compose logs -f openempi
docker compose logs -f orientdb
docker compose logs -f postgres
```

---

## Acceso a las interfaces

| Servicio | URL / Conexión | Credenciales |
|----------|---------------|--------------|
| OpenEMPI (consola web) | http://localhost:8080/openempi-web-resources | admin / admin |
| OrientDB (consola web) | http://localhost:2480 | root / admin |
---

## Comandos útiles

```powershell
# Parar los servicios (sin borrar datos)
docker compose down

# Parar y borrar TODOS los datos (volúmenes)
docker compose down -v

# Reiniciar un servicio concreto
docker compose restart openempi

# Entrar a la shell de un contenedor
docker compose exec openempi bash
docker compose exec orientdb bash
docker compose exec postgres psql -U openempi

# Ver uso de recursos
docker stats
```

---

## Persistencia de datos

Los datos se guardan en volúmenes Docker con nombre, que sobreviven a reinicios:

| Volumen | Contenido |
|---------|-----------|
| `openempi_postgres_data` | Base de datos PostgreSQL de OpenEMPI |
| `openempi_orientdb_databases` | Bases de datos de OrientDB (enlaces de matching) |
| `openempi_orientdb_backup` | Backups de OrientDB |
| `openempi_logs` | Logs de la aplicación OpenEMPI |

Para hacer un backup manual de PostgreSQL:
```powershell
docker compose exec postgres pg_dump -U openempi openempi > backup.sql
```

Para restaurar:
```powershell
Get-Content backup.sql | docker compose exec -T postgres psql -U openempi openempi
```

---

## Solución de problemas frecuentes

### OpenEMPI no arranca / no encuentra el script de inicio
Comprueba que la carpeta `openempi/app/` contiene el contenido correcto:
```powershell
dir C:\ruta\docker-openempi\openempi\app\
# Deberías ver: bin/, conf/, lib/, etc.
```

### Error de conexión a PostgreSQL o a OrientDB
Los contenedores tienen healthchecks que hacen que OpenEMPI espere a que las bases de datos estén listas. Si el error persiste, revisa los logs:
```powershell
docker compose logs postgres
docker compose logs orientdb
```

### Puerto 8080 ya en uso
Si tienes OpenEMPI corriendo en local, para el servicio de Windows antes de arrancar Docker, o cambia el puerto en `docker-compose.yml`:
```yaml
ports:
  - "9090:8080"   # OpenEMPI accesible en localhost:9090
```

### Reconstruir una imagen tras cambios
```powershell
docker compose build openempi --no-cache
docker compose up -d openempi
```

---

## Para compartir el entorno

Para que otra persona pueda reproducir este entorno exactamente:

1. Comprime la carpeta `docker-openempi/` completa (incluyendo `app/` dentro de `openempi/` y `orientdb/`).
2. El destinatario solo necesita tener **Docker Desktop** instalado.
3. Ejecuta `docker compose up -d` y listo.

Si quieres evitar copiar los ficheros de la app, puedes publicar las imágenes en Docker Hub:
```powershell
docker compose build
docker tag openempi_app tuusuario/openempi:3.5.0c
docker tag openempi_orientdb tuusuario/orientdb-openempi:latest
docker push tuusuario/openempi:3.5.0c
docker push tuusuario/orientdb-openempi:latest
```

---

## Despliegue en Kubernetes (Minikube)

### Requisitos
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) instalado
- [kubectl](https://kubernetes.io/docs/tasks/tools/) instalado

### Pasos

**1. Iniciar Minikube:**
```powershell
minikube start
```

**2. Apuntar Docker al registro de Minikube (para usar imágenes locales):**
```powershell
minikube docker-env | Invoke-Expression
```

**3. Construir las imágenes dentro del contexto de Minikube:**
```powershell
docker build -t openempi-orientdb:latest ./orientdb
docker build -t openempi-app:latest ./openempi
```

**4. Aplicar los manifiestos de Kubernetes:**
```powershell
kubectl apply -f k8s/orientdb-deployment.yaml
kubectl apply -f k8s/openempi-deployment.yaml
```

**5. Verificar que los pods están corriendo:**
```powershell
kubectl get pods
kubectl get services
```

**6. Acceder a OpenEMPI:**
```powershell
minikube service openempi
```
Esto abrirá automáticamente el navegador en la URL correcta.

**7. Ver logs de un pod:**
```powershell
kubectl logs deployment/openempi -f
kubectl logs deployment/orientdb -f
```

**8. Eliminar el despliegue:**
```powershell
kubectl delete -f k8s/
```
