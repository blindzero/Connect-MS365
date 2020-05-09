---
external help file: Connect-MS365-help.xml
Module Name: Connect-MS365
online version: https://github.com/blindzero/Connect-MS365
schema: 2.0.0
---

# Connect-MS365

## SYNOPSIS
Connects to a given online service of Microsoft.

## SYNTAX

### True (Default)
```
Connect-MS365 [-Service] <String> [[-SPOOrgName] <String>] [<CommonParameters>]
```

### MFA
```
Connect-MS365 [-Service] <String> [[-SPOOrgName] <String>] [-MFA] [<CommonParameters>]
```

### Credential
```
Connect-MS365 [-Service] <String> [[-SPOOrgName] <String>] [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Connects to a given online service of Microsoft.
One or multiple service names can be chosen.
Supports connection handling for
- Microsoft Online (MSOL) - aka AzureAD v1
- Exchange Online (EOL)
- Teams
- SharePoint Online (SPO)
- Security and Compliance Center (SCC)
- Azure ActiveDirectory (AAD) v2

## EXAMPLES

### EXAMPLE 1
```
Description: Connect to Microsoft Online without using MFA
```

Connect-MS365 -Service MSOL

### EXAMPLE 2
```
Description: Connect to Microsoft Online by using MFA
```

Connect-MS365 -Service MSOL -MFA

### EXAMPLE 3
```
Description: Connect to Microsoft Online and Exchange Online by using MFA
```

Connect-MS365 -Service MSOL,EOL -MFA

### EXAMPLE 4
```
Description: Connect to SharePoint Online without MFA to connect to MyName-admin.sharepoint.com
```

Connect-MS365 -Service SPO -SPOOrgName MyName

### EXAMPLE 5
```
Description: Connect to SharePoint Online with MFA to connect to MyName-admin.sharepoint.com
```

Connect-MS365 -Service SPO -SPOOrgName MyName -MFA

### EXAMPLE 6
```
Description: Connect to Security and Compliance Center with MFA
```

Connect-MS365 -Service SCC -MFA

### EXAMPLE 7
```
Description: Connect to Azure ActiveDirectory with MFA
```

Connect-MS365 -Service AAD -MFA

## PARAMETERS

### -Service
Specifies the service to connect to.
May be a list of multiple services to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SPOOrgName
spoorg parameter for connection to SPO service
needed by connect cmdlet to assemble admin Url

```yaml
Type: String
Parameter Sets: (All)
Aliases: SPOOrg

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MFA
Toggles MFA usage.
Not requesting PSCredential object.

```yaml
Type: SwitchParameter
Parameter Sets: MFA
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
Credential parameter to receive previously created PSCredential object.
Primarily needed for testing calls

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Add-Extension.
## OUTPUTS

### // <OBJECTTYPE>. TBD.
## NOTES

## RELATED LINKS

[https://github.com/blindzero/Connect-MS365](https://github.com/blindzero/Connect-MS365)

