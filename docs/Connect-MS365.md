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
Connect-MS365 [-Service] <String[]> [<CommonParameters>]
```

### MFA
```
Connect-MS365 [-Service] <String[]> [-MFA] [<CommonParameters>]
```

### Credential
```
Connect-MS365 [-Service] <String[]> [[-Credential] <PSCredential>] [<CommonParameters>]
```

## DESCRIPTION
Connects to a given online service of Microsoft.
One or multiple service names can be chosen.
Supports connection handling for
- Microsoft Online (MSOL)
- Exchange Online (EOL)
- Teams

## EXAMPLES

### EXAMPLE 1
```
Connect-MS365 -Service MSOL
```

### EXAMPLE 2
```
Connect-MS365 -Service MSOL -MFA
```

### EXAMPLE 3
```
Connect-MS365 -Service MSOL,EOL -MFA
```

## PARAMETERS

### -Service
Specifies the service to connect to.
May be a list of multiple services to use.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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
Position: 3
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

