function Connect-AAD {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=1)]
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
    while (!(Test-MS365Module -Module $ModuleName)) {
        # and install if not available
        Install-MS365Module -Module $ModuleName
    }
    try {
        $null = Connect-AzureAD
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error -Message "Could not connect to $ServiceItem.`n$ErrorMessage" -Category ConnectionError
        Break
    }
    # set service name into window title if successfully connected
    Set-WindowTitle -Service $ServiceItem
}