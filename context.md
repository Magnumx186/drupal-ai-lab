# Drupal AI Lab — Contexto del proyecto

## ¿Qué es este proyecto?
Entorno de laboratorio/aprendizaje de Inteligencia Artificial con Drupal. Permite experimentar con modelos de IA locales (Ollama) y explorar los módulos de IA del ecosistema Drupal.

---

## Stack técnico
- **CMS:** Drupal 11
- **Entorno local:** DDEV v1.25.2
- **Base de datos:** MariaDB 11.8
- **PHP:** 8.3
- **Web server:** Nginx-FPM
- **Proveedor IA:** Ollama (local, gratuito)

---

## Ubicación del proyecto
```
/home/josefran/snap/copilot-cli/39/drupal-ai-lab/
```
> ⚠️ Está dentro del directorio snap, no en ~/drupal-ai-lab

---

## Levantar el entorno

El binario de DDEV está en:
```
/var/lib/snapd/hostfs/home/josefran/snap/copilot-cli/39/bin/ddev
```

```bash
# Alias recomendado
alias ddev='/var/lib/snapd/hostfs/home/josefran/snap/copilot-cli/39/bin/ddev'

cd /home/josefran/snap/copilot-cli/39/drupal-ai-lab
ddev start
```

> Si falla al arrancar por permisos de puerto (WSL2), ejecutar:
> ```bash
> ddev poweroff && ddev start
> ```

---

## URLs del proyecto
| Recurso | URL |
|---------|-----|
| Sitio | http://drupal-ai-lab.ddev.site |
| Admin | http://drupal-ai-lab.ddev.site/admin |
| Config AI | http://drupal-ai-lab.ddev.site/admin/config/ai |
| Providers | http://drupal-ai-lab.ddev.site/admin/config/ai/providers |
| Config Ollama | http://drupal-ai-lab.ddev.site/admin/config/ai/providers/ollama |
| API Explorer | http://drupal-ai-lab.ddev.site/admin/config/ai/explorers |
| Chat Explorer | http://drupal-ai-lab.ddev.site/admin/config/ai/explorers/chat_generator |

**Credenciales admin:** `admin` / `admin`

---

## Ollama — Configuración

Ollama corre en el host (WSL2) y es accesible desde los contenedores Docker vía `host.docker.internal`.

### Configuración en Drupal
- **Host:** `http://host.docker.internal`
- **Puerto:** `11434`
- **Módulo:** `ai_provider_ollama` v1.2.0-rc3

### Modelos instalados
| Modelo | Tamaño | Uso recomendado |
|--------|--------|-----------------|
| `gemma4:latest` | 8B | Chat y uso general |
| `qwen2.5-coder:latest` | 7.6B | Código |
| `qwen3.6:latest` | 36B | Tareas complejas (más lento) |

### Comandos útiles Ollama
```bash
# Ver modelos instalados
curl http://localhost:11434/api/tags

# Descargar nuevo modelo
ollama pull <modelo>

# Probar modelo directamente
ollama run gemma4
```

---

## Módulos de IA instalados

| Módulo | Estado | Descripción |
|--------|--------|-------------|
| `ai` | ✅ Enabled | Framework base de IA |
| `ai_api_explorer` | ✅ Enabled | Explorador de APIs de IA |
| `ai_assistant_api` | ✅ Enabled | API para asistentes/chatbots |
| `ai_agents` | ✅ Enabled | Agentes IA autónomos |
| `ai_automators` | ✅ Enabled | Relleno automático de campos |
| `ai_translate` | ✅ Enabled | Traducción con IA |
| `ai_image_alt_text` | ✅ Enabled | Alt text automático de imágenes |
| `ai_search` | ✅ Enabled | Búsqueda con IA |
| `ckeditor_ai_agent` | ✅ Enabled | Asistente IA en editor |
| `ai_provider_ollama` | ✅ Enabled | Proveedor Ollama (local) |

---

## Comandos Drush útiles
```bash
# Limpiar caché
ddev drush cr

# Ver/editar config de Ollama
ddev drush config:get ai_provider_ollama.settings
ddev drush config:set ai_provider_ollama.settings host_name "http://host.docker.internal" -y
ddev drush config:set ai_provider_ollama.settings port 11434 -y

# Ver módulos AI
ddev drush pm:list --filter=ai --format=table

# Instalar nuevo módulo
ddev composer require drupal/<modulo>
ddev drush pm:enable <modulo> -y
```

---

## Notas importantes
- Ollama debe estar corriendo antes de usar los módulos de IA en Drupal (`ps aux | grep ollama`)
- En WSL2, el puerto de Docker puede bloquearse; solución: `ddev poweroff && ddev start`
- `host.docker.internal` es la forma de que los contenedores Docker accedan al host en Windows/WSL2

---

## CI/CD y despliegue

Desde esta sesión el proyecto queda preparado para:

- **CI** con GitHub Actions en `.github/workflows/ci.yml`
- **publicación de imagen** en GHCR con `.github/workflows/publish-image.yml`
- **despliegue manual por SSH** a una VM con `.github/workflows/deploy-vm.yml`
- **runtime de producción** con `Dockerfile` y `docker-compose.prod.yml`

### Estado al cerrar esta sesión

- El proyecto **no está desplegado todavía**.
- El proyecto **no es todavía un repositorio Git** y **no tiene remoto**.
- Lo que sí queda hecho es la **base técnica** para que, al subirlo a GitHub y provisionar una VM, ya exista un flujo de CI/CD razonable para Drupal.
- El objetivo fue dejar un despliegue **realista para Drupal**, no hosting estático.

### Recomendación de hosting

- **Recomendado:** Oracle Cloud Always Free VM + Docker Compose
- **Alternativa:** AWS EC2 / Elastic Beanstalk en free tier, útil pero menos estable como opción gratuita permanente

### Notas operativas

- El proyecto sigue estando dentro de una ruta `snap/`; conviene moverlo a `~/drupal-ai-lab` antes de publicarlo en GitHub.
- El despliegue queda listo para actualizaciones de una VM ya provisionada, pero el primer entorno productivo sigue necesitando `.env.production` y una base de datos inicial.
- Para que `config:import` sea útil, exporta antes la configuración local al directorio versionado `config/sync`.

### Archivos añadidos o modificados en esta sesión

#### Nuevos

- `.gitignore`
- `.dockerignore`
- `Dockerfile`
- `docker/apache-vhost.conf`
- `docker-compose.prod.yml`
- `.env.production.example`
- `README.md`
- `.github/workflows/ci.yml`
- `.github/workflows/publish-image.yml`
- `.github/workflows/deploy-vm.yml`
- `config/sync/.gitkeep`
- `var/db/.gitkeep`

#### Modificados

- `web/sites/default/settings.php`
- `context.md`

### Qué hace ahora `settings.php`

Se añadió lógica para producción basada en variables de entorno, manteniendo el include de DDEV al final para no romper el laboratorio local:

- `DRUPAL_CONFIG_SYNC_DIR` para la ruta de config sync
- `DRUPAL_HASH_SALT` para sesiones/tokens en producción
- `DRUPAL_DEPLOYMENT_IDENTIFIER` para invalidar contenedor cuando cambie el código desplegado
- `DRUPAL_TRUSTED_HOSTS` separado por comas
- `DRUPAL_REVERSE_PROXY` y `DRUPAL_REVERSE_PROXY_ADDRESSES`
- `DRUPAL_DB_*` para DB MySQL/MariaDB
- soporte opcional `sqlite` vía `DRUPAL_DB_DRIVER`
- override de `OLLAMA_HOST` y `OLLAMA_PORT`

### Qué hace cada workflow

#### `.github/workflows/ci.yml`

- checkout
- setup PHP 8.3 + Composer
- `composer validate --strict`
- build de la imagen Docker de producción sin publicarla

#### `.github/workflows/publish-image.yml`

- corre en `push` a `main`
- autentica contra **GHCR**
- construye y publica imagen con tag `latest` y un tag por SHA

#### `.github/workflows/deploy-vm.yml`

- se lanza manualmente con `workflow_dispatch`
- prepara SSH desde secretos
- sube `docker-compose.prod.yml` a la VM
- hace `docker compose pull` + `up -d`
- si Drupal ya arranca correctamente, ejecuta:
  - `drush updatedb -y`
  - `drush config:import -y` si hay archivos en `config/sync`
  - `drush cache:rebuild`
- si Drupal todavía no está instalado, el workflow **no fuerza** `updatedb/config:import`

### Secretos esperados por GitHub Actions

Para `deploy-vm.yml` hacen falta:

- `DEPLOY_HOST`
- `DEPLOY_PORT`
- `DEPLOY_USER`
- `DEPLOY_SSH_KEY`
- `DEPLOY_PATH`

### Variables importantes en `.env.production`

Tomar como base `.env.production.example`.

Variables clave:

- `GHCR_IMAGE`
- `APP_PORT`
- `DRUPAL_DB_DRIVER`
- `DRUPAL_DB_HOST`
- `DRUPAL_DB_PORT`
- `DRUPAL_DB_NAME`
- `DRUPAL_DB_USER`
- `DRUPAL_DB_PASSWORD`
- `MARIADB_ROOT_PASSWORD`
- `DRUPAL_HASH_SALT`
- `DRUPAL_CONFIG_SYNC_DIR`
- `DRUPAL_TRUSTED_HOSTS`
- `DRUPAL_DEPLOYMENT_IDENTIFIER`
- `DRUPAL_REVERSE_PROXY`
- `DRUPAL_REVERSE_PROXY_ADDRESSES`
- `OLLAMA_HOST`
- `OLLAMA_PORT`

### Decisiones de arquitectura tomadas

- **No usar GitHub Pages / hosting estático** porque esto es Drupal con base de datos y ficheros persistentes.
- **Recomendar Oracle Cloud Always Free** como mejor encaje gratuito para VM persistente.
- **Dejar AWS solo como alternativa** y no como opción principal.
- **No meter secretos en el repo**.
- **No asumir que producción tendrá Ollama local**; se dejó override por variables de entorno.
- **Persistir `sites/default/files`** con volumen Docker.
- **Fijar MariaDB 11.8** en `docker-compose.prod.yml` para alinearlo con local.

### Riesgos / cosas que siguen pendientes

- El proyecto vive en `/snap/...`; conviene moverlo antes de publicar nada.
- El primer despliegue sigue necesitando:
  - una VM real
  - Docker + Compose en esa VM
  - `.env.production`
  - una instalación inicial de Drupal o una importación de BD
- Si se quiere conservar la parte de IA en producción, hay que decidir:
  - usar un Ollama accesible desde la VM, o
  - cambiar a otro provider, o
  - desactivar ese flujo en producción
- `config/sync` está versionado pero **vacío** salvo `.gitkeep`; hay que exportar config desde DDEV si se quiere usar config import.

### Validación hecha en esta sesión

- Se validó que los YAML nuevos parsean bien:
  - `docker-compose.prod.yml`
  - `.github/workflows/ci.yml`
  - `.github/workflows/publish-image.yml`
  - `.github/workflows/deploy-vm.yml`
- Se comprobó que los archivos esperados existen.
- **No** se pudo ejecutar build Docker, PHP o Composer en esta sesión porque ese tooling no está disponible en este entorno del CLI.

### Checklist recomendada para la próxima sesión

1. Mover el proyecto fuera de `snap`:
   ```bash
   mv /home/josefran/snap/copilot-cli/39/drupal-ai-lab ~/drupal-ai-lab
   ```
2. Inicializar Git y conectar remoto GitHub.
3. Exportar configuración actual:
   ```bash
   ddev drush config:export -y
   ```
4. Decidir la estrategia de IA en producción.
5. Provisionar una VM gratuita (preferible Oracle Cloud).
6. Instalar Docker y Docker Compose en la VM.
7. Crear `.env.production` en la VM a partir del ejemplo.
8. Subir secretos a GitHub.
9. Hacer primer despliegue.
10. Si se quiere clonar fielmente el laboratorio local, importar también la base de datos actual.

### Comandos útiles para retomar

```bash
# DDEV local
alias ddev='/var/lib/snapd/hostfs/home/josefran/snap/copilot-cli/39/bin/ddev'
cd /home/josefran/snap/copilot-cli/39/drupal-ai-lab
ddev start

# Exportar config antes de publicar
ddev drush config:export -y

# Generar hash salt para producción
openssl rand -base64 48
```
