function Connect-MSOL {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False,Position=1)]
        [PSCredential]
        $Credential
    )

    <#
    .SYNOPSIS
    Connects to Microsoft Online service.

    .DESCRIPTION
    Connects to Microsoft Online service / Azure ActiveDirectory v1

    .PARAMETER Credential
    PSCredential object containing user credentials.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    // <OBJECTTYPE>. TBD.

    .EXAMPLE
    PS> Connect-MSOL -Credential $Credential

    .LINK
    http://github.com/blindzero/Connect-MS365

    #>

    # testing if module is available
    while (!(Test-MS365Module -Module $ModuleName)) {
        # and install if not available
        Install-MS365Module -Module $ModuleName
    }
    try {
        Connect-MsolService -ErrorAction Stop
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error -Message "Could not connect to $ServiceItem.`n$ErrorMessage" -Category ConnectionError
        Break
    }
    # set service name into window title if successfully connected
    Set-WindowTitle -Service $ServiceItem
}