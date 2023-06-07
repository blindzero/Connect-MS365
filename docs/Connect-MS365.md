---
external help file: Connect-MS365-help.xml
Module Name: Connect-MS365
online version:
schema: 2.0.0
---

# Connect-MS365

## SYNOPSIS

{{ Fill in the Synopsis }}

## SYNTAX

### True (Default)

```powershell
Connect-MS365 [-Service] <String[]> [[-SPOOrgName] <String>] [<CommonParameters>]
```

### Credential

```powershell
Connect-MS365 [-Service] <String[]> [[-SPOOrgName] <String>] [[-Credential] <PSCredential>]
 [<CommonParameters>]
```

### ReInitConfig

```powershell
Connect-MS365 [-Service] <String[]> [[-SPOOrgName] <String>] [-ReInitConfig] [<CommonParameters>]
```

## DESCRIPTION

{{ Fill in the Description }}

## EXAMPLES

### Example 1

```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Credential
{{ Fill Credential Description }}

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReInitConfig

{{ Fill ReInitConfig Description }}

```yaml
Type: SwitchParameter
Parameter Sets: ReInitConfig
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SPOOrgName

{{ Fill SPOOrgName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases: SPOOrg

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Service

{{ Fill Service Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: MSOL, EOL, Teams, SPO, SCC, AAD, AZ, S4B

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS
