function Connect-SCC {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=1)]
        [PSCredential]
        $Credential
    )

    <#
    .SYNOPSIS
    Connects to Microsoft Security and Comliance Center.

    .DESCRIPTION
    Connects to Microsoft Security and Comliance Center.

    .PARAMETER Credential
    PSCredential object containing user credentials.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    // <OBJECTTYPE>. TBD.

    .EXAMPLE
    PS> Connect-SCC -Credential $Credential

    .LINK
    http://github.com/blindzero/Connect-MS365

    #>

    # testing if module is available
    while (!(Test-MS365Module -Module $ModuleName)) {
        # and install if not available
        Install-MS365Module -Module $ModuleName
    }

    $ConfigDefaultUPN = $Config['DefaultUserPrincipalName']

    try {
        if ($ConfigDefaultUPN) {
            Write-Verbose -Message "Connecting to SCC with $ConfigDefaultUPN"
            Connect-IPPSSession -UserPrincipalName $ConfigDefaultUPN
        }
        else {
            Write-Verbose -Message "Connecting to SCC with UPN prompt"
            Connect-IPPSSession
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