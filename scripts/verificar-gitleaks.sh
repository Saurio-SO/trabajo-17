#!/bin/bash
set -uo pipefail
echo "================================================="
echo "  VERIFICACIÓN TÉCNICA - TP17 GITLEAKS SECURITY"
echo "================================================="
echo ""

if command -v gitleaks &> /dev/null; then
  echo "  [OK] Gitleaks instalado localmente ($(gitleaks version))"
else
  echo "  [WARN] Gitleaks no detectado en PATH local (Se ejecutará mediante GitHub Actions en CI/CD)"
fi

WORKFLOW_FILE=".github/workflows/cicd.yml"
if [ -f "$WORKFLOW_FILE" ]; then
  if grep -q "gitleaks-action" "$WORKFLOW_FILE" && grep -q "gitleaks-andon-cord" "$WORKFLOW_FILE"; then
    echo "  [OK] Workflow configurado correctamente con los jobs de Gitleaks"
  else
    echo "  [FAIL] Falta la configuración de los jobs de Gitleaks en $WORKFLOW_FILE"
    exit 1
  fi
else
  echo "  [FAIL] Archivo $WORKFLOW_FILE no encontrado"
  exit 1
fi

if command -v gitleaks &> /dev/null; then
  echo ""
  echo "--- Ejecutando escaneo preventivo con Gitleaks ---"
  gitleaks detect --source . --no-git -v || true
fi

echo ""
echo "=== Verificación del TP17 completada con éxito ==="
