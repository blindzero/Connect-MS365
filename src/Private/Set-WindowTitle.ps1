function Set-WindowTitle {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=1)]
        [String]
        $Service
    )

    <#
    .SYNOPSIS

    Sets Window Title if connection was successful.

    .DESCRIPTION

    Sets Window Title if connection was successful.
    Adds prefix if not already set.

    .PARAMETER Service
    Name of service to put in Window title.

    .INPUTS

    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS

    // <OBJECTTYPE>. TBD.

    .EXAMPLE

    Set-WindowTitle -Service MSOL

    .LINK

    http://github.com/blindzero/Connect-MS365

    #>
    If (($host.ui.RawUI.WindowTitle) -notlike "*MSOL*" ) {
        If (($host.ui.RawUI.WindowTitle) -notlike "*Connected To:*") {
                $host.ui.RawUI.WindowTitle += " - Connected To: $Service"
        }
        Else {
            $host.ui.RawUI.WindowTitle += " - $Service"
        }
    }
}