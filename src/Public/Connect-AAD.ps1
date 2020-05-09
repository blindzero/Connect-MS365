function Connect-AAD {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False,Position=1)]
        [PSCredential]
        $Credential
    )

    <#
    .SYNOPSIS

    Connects to Microsoft Azure ActiveDirectory (AzureAD / AAD) service.

    .DESCRIPTION

    Connects to Microsoft Azure ActiveDirectory (AzureAD / AAD) service.

    .PARAMETER Credential

    PSCredential object containing user credentials.

    .INPUTS

    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS

    // <OBJECTTYPE>. TBD.

    .EXAMPLE

    PS> Connect-AAD -Credential $Credential

    .LINK

    http://github.com/blindzero/Connect-MS365

    #>

    # testing if module is available
    while (!(Test-MS365Module -Service $ServiceItem)) {
        # and install if not available
        Install-MS365Module -Service $ServiceItem
    }
    try {
        # if MFA is set connect without PScredential object as modern authentication will be used
        if ($MFA) {
            Connect-AzureAD | Out-Null
        }
        # or pass PSCredential object it will asked if not created earlier
        else {
            Connect-AzureAD -Credential $Credential | Out-Null
        }
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error -Message "Could not connect to $ServiceItem.`n$ErrorMessage" -Category ConnectionError
        Break
    }
    # set service name into window title if successfully connected
    Set-WindowTitle -Service $ServiceItem
}