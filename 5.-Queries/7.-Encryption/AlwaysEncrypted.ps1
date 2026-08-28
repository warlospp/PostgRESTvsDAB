cls
#1. Instalar módulo SQL Server
Install-Module SqlServer -MinimumVersion 22.0.50 -Scope CurrentUser -Force

Import-Module SqlServer

Get-Module SqlServer -ListAvailable

#2. Crear el certificado CMK

# ============================================
# CONFIGURACION
# ============================================

$CertName = "AE_Demo_CMK"
$CertPath = "Cert:\CurrentUser\My"

# ============================================
# CREAR CERTIFICADO
# ============================================

$cert = New-SelfSignedCertificate `
    -Subject "CN=$CertName" `
    -CertStoreLocation $CertPath `
    -KeyExportPolicy Exportable `
    -KeySpec KeyExchange `
    -KeyLength 2048 `
    -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" `
    -NotAfter (Get-Date).AddYears(5)

$cert

Write-Host ""
Write-Host "Certificado creado:"
Write-Host $cert.Thumbprint


Get-ChildItem Cert:\CurrentUser\My |
    Sort-Object NotBefore -Descending |
    Select-Object -First 5 `
        Subject,
        Thumbprint,
        NotBefore,
        NotAfter,
        HasPrivateKey

#3. Crear la configuración de Column Master Key

$cert = New-SelfSignedCertificate `
    -Subject "CN=AE_Demo_CMK" `
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -KeyExportPolicy Exportable `
    -KeySpec KeyExchange `
    -KeyLength 2048 `
    -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" `
    -NotAfter (Get-Date).AddYears(5)

$cert | Format-List Subject, Thumbprint, HasPrivateKey, NotBefore, NotAfter

#SQL
Import-Module SqlServer
Get-Module SqlServer -ListAvailable |
    Select-Object Name, Version
$ServerInstance = "localhost,1433"
$DatabaseName = "bdd_demo"
$Username = "sa"
$Password = "Admin.123"
$Thumbprint = "D6D9A165200BB380CFE077B996D68E1AC4BDA566"

cls
$cmkSettings = New-SqlCertificateStoreColumnMasterKeySettings `
    -CertificateStoreLocation "CurrentUser" `
    -Thumbprint $Thumbprint
$cmkSettings | Format-List *

Get-Command New-SqlColumnMasterKey -Syntax

New-SqlColumnMasterKey `
    -Name "CMK_AE_Demo" `
    -Path "SQLSERVER:\SQL\$env:COMPUTERNAME\$ServerInstance\Databases\$DatabaseName" `
    -ColumnMasterKeySettings $cmkSettings `
    -TrustServerCertificate

$ConnectionString = "Server=localhost,1433;Database=bdd_demo;User Id=sa;Password=Admin.123;TrustServerCertificate=True;Encrypt=False"

$db = Get-SqlDatabase `
    -Name $DatabaseName `
    -ConnectionString $ConnectionString `
    -TrustServerCertificate

New-SqlColumnMasterKey `
    -Name "CMK_AE_Demo" `
    -InputObject $db `
    -ColumnMasterKeySettings $cmkSettings `
    -TrustServerCertificate


$db = Get-SqlDatabase `
    -Name "bdd_demo" `
    -ServerInstance "localhost,1433" `
    -TrustServerCertificate


  

$ConnectionString = "Server=localhost,1433;Database=bdd_demo;User Id=sa;Password=Admin.123;TrustServerCertificate=True;Encrypt=False"
    $db = Get-SqlDatabase `
    -Name "bdd_demo" `
    -ConnectionString $ConnectionString
      $db | Select-Object Name


$cek = New-SqlColumnEncryptionKey `
    -Name "CEK_AE_Demo" `
    -InputObject $db `
    -ColumnMasterKeyName "CMK_AE_Demo"



$columnEncryptionSettings = New-SqlColumnEncryptionSettings `
    -ColumnName "dbo.client_identity_test.ci" `
    -EncryptionType "Deterministic" `
    -EncryptionKey "CEK_AE_Demo"

Set-SqlColumnEncryption `
    -InputObject $db `
    -ColumnEncryptionSettings $columnEncryptionSettings `
    -TrustServerCertificate