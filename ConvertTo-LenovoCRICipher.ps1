<#
    Author:  Graham Foral
    Date:    3/12/2023

    Purpose: To encode the password string used by Lenovo's recovery programs. These are the Z7 and IMZ files on the recovery media. Base passwords are in the DRIVE:\RECOVERY\*.CRI files in the [Module] section.

    References:
        [1]: https://thinkpad-forum.de/threads/45475-recovery-zip-archives-passwort (German)
        [2]: https://github.com/mhaeuser/LenovoImzCipher/blob/master/LenovoImzCipher.py

    Usage:
    ./ConvertTo-LenovoCRICipher.ps1 -$CRIPassword "PasswordFromCRIFile" -OutFile C:\encoded.txt -ShowProgress
    
    OutFile and ShowProgress are optional parameters

#>

param(
    $CRIPassword,
    $OutFile,
    [switch]$ShowProgress
)

$i = 0

Write-Host "CRI Password:`t`t $CRIPassword"
$chars = "k``gybs0vampjd".ToCharArray()
$CRIPassword = $CRIPassword.ToCharArray()
$ContructedPW = $Null


For($i -eq 0; $i -lt $CRIPassword.Length; $i++) {
    $CurrentChar = [char](($chars[$CRIPassword[$i] % 13]) - ($i % 3) + 2) 
    $ContructedPW += $CurrentChar
    
    If($ShowProgress) {
        Write-Host "Character: $i - $($CRIPassword[$i])  -> $CurrentChar ($([byte][char]$($CurrentChar)))" 
    }  
}


Write-Output "Ciphered Password:`t $ContructedPW"
If($OutFile) {
    Write-Host "Exporting to file $OutFile"
    $ContructedPW | Out-File -FilePath $OutFile -Force -Append
} Else {}
