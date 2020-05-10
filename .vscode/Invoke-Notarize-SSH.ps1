# Invoke-Notarize-SSH.ps1

Write-Verbose "Notarizing with vcn..."
# automatic notarize must have set VCN_USER, VCN_NOTARIZEPASSWORD set in environment

vcn notarize git://.
