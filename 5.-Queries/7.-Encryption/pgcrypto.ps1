###########
# Paquete #
###########
# winget install GnuPG.GnuPG
# GnuPG (GnuPG.GnuPG) no es el mecanismo que cifra los datos en PostgreSQL. Es la herramienta que utilizamos en el backend/cliente para descifrar el dato que PostgreSQL cifró con pgcrypto.
# GnuPG significa GNU Privacy Guard (GPG). Es una implementación libre y de código abierto del estándar OpenPGP, utilizado para cifrado, descifrado, firmas digitales y gestión de claves.

# ============================================
# CONFIGURACION
# ============================================
cls
$Url = "http://localhost:3000/client_identity_test"
$Password = "MiClaveDemo2026"

# ============================================
# CONSULTAR POSTGREST
# ============================================

$data = Invoke-RestMethod -Uri $Url -Method Get

foreach ($client in $data) {

    Write-Host ""
    Write-Host "Cliente: $($client.client_name)"
    Write-Host "CI cifrado: $($client.ci_encrypted)"

    # ========================================
    # CONVERTIR BYTEA HEX A BYTES
    # ========================================

    $hex = $client.ci_encrypted -replace '^\\x', ''

    $bytes = for ($i = 0; $i -lt $hex.Length; $i += 2) {
        [Convert]::ToByte($hex.Substring($i, 2), 16)
    }

    # ========================================
    # GUARDAR TEMPORALMENTE EL CIPHERTEXT
    # ========================================

    $encryptedFile = Join-Path $env:TEMP "ci_encrypted.pgp"
    $decryptedFile = Join-Path $env:TEMP "ci_decrypted.txt"

    [System.IO.File]::WriteAllBytes(
        $encryptedFile,
        [byte[]]$bytes
    )

    # ========================================
    # DESCIFRAR CON GPG
    # ========================================

    & gpg.exe `
        --batch `
        --yes `
        --pinentry-mode loopback `
        --passphrase $Password `
        --decrypt `
        --output $decryptedFile `
        $encryptedFile

    # ========================================
    # MOSTRAR RESULTADO
    # ========================================

    if ($LASTEXITCODE -eq 0) {

        $ci = Get-Content $decryptedFile -Raw

        Write-Host "CI descifrado: $ci"
    }
    else {

        Write-Host "ERROR: No fue posible descifrar el CI."
    }

    # Limpiar archivos temporales
    Remove-Item $encryptedFile -Force -ErrorAction SilentlyContinue
    Remove-Item $decryptedFile -Force -ErrorAction SilentlyContinue
}