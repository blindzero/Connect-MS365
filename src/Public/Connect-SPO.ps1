function Connect-SPO {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position = 1)]
        [String]
        $SPOOrgUrl,
        [Parameter(Mandatory=$False,Position = 2)]
        [PSCredential]
        $Credential
    )

    <#
    .SYNOPSIS
    Connects to Microsoft SharePoint Online service.

    .DESCRIPTION
    Connects to Microsoft SharePoint Online service.

    .PARAMETER SPOOrgUrl
    String object containing the SharePoint Online organization admin Url.

    .PARAMETER Credential
    PSCredential object containing user credentials.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    // <OBJECTTYPE>. TBD.

    .EXAMPLE
    Description: Connect to SharePoint Online organisation MyName with PSCredential object passed (no MFA)
    PS> Connect-SPO -SPOOrgUrl https://myname-admin.sharepoint.com -Credential $Credential

    .EXAMPLE
    Description: Connect to SharePoint Online organisation MyName without PSCredential object passed (MFA)
    PS> Connect-SPO -SPOOrgName https://myname-admin.sharepoint.com

    .LINK

    http://github.com/blindzero/Connect-MS365

    #>

    # testing if module is available
    while (!(Test-MS365Module -Module $ModuleName)) {
        # and install if not available
        Install-MS365Module -Module $ModuleName
    }
    try {
        # if MFA is set connect without PScredential object as modern authentication will be used
        if ($MFA) {
            Connect-SPOService -Url $SPOOrgUrl -ErrorAction Stop | Out-Null
        }
        # or pass PSCredential object it will asked if not created earlier
        else {
            Connect-SPOService -Url $SPOOrgUrl -Credential $Credential -ErrorAction Stop | Out-Null
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