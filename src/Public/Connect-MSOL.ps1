function Connect-MSOL {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=1)]
        [PSCredential]
        $Credential
    )

    <#
    .SYNOPSIS

    Connects to Microsoft Online service.

    .DESCRIPTION

    Connects to Microsoft Online service.

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

    $ServiceName = $MyInvocation.MyCommand.ToString().Replace("Connect-","")
    while (!(Test-MS365Module -Service $ServiceName)) {
        Install-MS365Module -Service $ServiceName
    }
    try {
        Connect-MsolService -Credential $Credential -ErrorAction Stop
    }
    catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error -Message "Could not connect to $ServiceName.`n$ErrorMessage" -Category ConnectionError
        Break
    }
    Set-WindowTitle -Service $ServiceName
}