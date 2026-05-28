# Drupal AI Lab

Laboratorio de Drupal 11 para experimentar con módulos de IA del ecosistema Drupal.

## Estado actual

- Desarrollo local con **DDEV**
- Base de datos **MariaDB**
- Integración actual con **Ollama** en local
- Proyecto preparado para **CI/CD con GitHub Actions**
- Runtime de producción preparado con **Docker**

## Importante antes de publicar

Ahora mismo el proyecto vive en:

```bash
/home/josefran/snap/copilot-cli/39/drupal-ai-lab
```

Antes de hacer `git init` o subirlo a GitHub, conviene moverlo a una ruta estable, por ejemplo:

```bash
mv /home/josefran/snap/copilot-cli/39/drupal-ai-lab ~/drupal-ai-lab
```

La ruta dentro de `snap/` puede cambiar con actualizaciones del paquete.

## Desarrollo local

El contexto detallado del laboratorio está en `context.md`.

Arranque local:

```bash
alias ddev='/var/lib/snapd/hostfs/home/josefran/snap/copilot-cli/39/bin/ddev'
cd /home/josefran/snap/copilot-cli/39/drupal-ai-lab
ddev start
```

## Qué se ha dejado listo

### CI

`.github/workflows/ci.yml`

- valida `composer.json`
- construye la imagen Docker de producción

### Entrega continua

`.github/workflows/publish-image.yml`

- publica la imagen en **GHCR** al hacer push a `main`

### Despliegue preparado

`.github/workflows/deploy-vm.yml`

- despliega manualmente por **SSH** a una VM
- actualiza contenedores
- ejecuta `drush updatedb`
- importa config si `config/sync` contiene archivos exportados
- reconstruye caché

## Hosting gratuito recomendado

### Opción recomendada: Oracle Cloud Always Free

Es la opción más realista para este proyecto porque Drupal necesita:

- runtime PHP persistente
- base de datos
- almacenamiento para `sites/default/files`

Con una VM Always Free puedes usar `docker-compose.prod.yml` tal cual.

### Alternativa AWS

AWS puede usarse, pero normalmente no es gratis para siempre:

- **EC2 free tier**: útil para pruebas, normalmente limitado en el tiempo
- **Elastic Beanstalk**: viable, pero requiere más piezas y no evita el coste de fondo

Si el objetivo es minimizar coste real, Oracle Cloud suele encajar mejor que AWS para este laboratorio.

## Primer despliegue en una VM

1. Copia `.env.production.example` a `.env.production` en la VM y ajusta valores.
2. Genera un salt real:

```bash
openssl rand -base64 48
```

3. Levanta el stack:

```bash
docker compose --env-file .env.production -f docker-compose.prod.yml up -d
```

4. Si quieres replicar la configuración actual del laboratorio, exporta primero la config desde DDEV y súbela al repo:

```bash
ddev drush config:export -y
```

5. Si quieres clonar también contenido o estado de base de datos, necesitarás además un volcado SQL del entorno local.

## Secretos de GitHub para el despliegue

| Secret | Uso |
| --- | --- |
| `DEPLOY_HOST` | Host o IP de la VM |
| `DEPLOY_PORT` | Puerto SSH, normalmente `22` |
| `DEPLOY_USER` | Usuario SSH |
| `DEPLOY_SSH_KEY` | Clave privada para el despliegue |
| `DEPLOY_PATH` | Directorio remoto donde vive `docker-compose.prod.yml` |

## Variables de producción relevantes

| Variable | Uso |
| --- | --- |
| `DRUPAL_HASH_SALT` | Obligatoria para sesiones y tokens |
| `DRUPAL_TRUSTED_HOSTS` | Hosts permitidos, separados por coma |
| `DRUPAL_DB_*` | Conexión a MariaDB |
| `DRUPAL_DEPLOYMENT_IDENTIFIER` | Fuerza reinicio del contenedor de servicios al desplegar |
| `OLLAMA_HOST` / `OLLAMA_PORT` | Override opcional si quieres un Ollama accesible también en la VM |

## Limitaciones que siguen pendientes

- El proyecto todavía no está en un repositorio Git real.
- El primer despliegue no recrea por sí solo el estado actual de la base de datos.
- Si mantienes los módulos de IA activos en producción, debes configurar un proveedor accesible desde la VM.
