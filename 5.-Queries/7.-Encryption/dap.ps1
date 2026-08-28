cls
$data = ""
$Url = "http://localhost:5000/api/client_identity_test"
$data = Invoke-RestMethod `
    -Uri $Url `
    -Method Get
$data
