# Connect-MS365

## 03-CONFIGURATION

Connect-MS365 uses a default user configuration file located in ```$env:LOCALAPPDATA\Connect-MS365\Connect-MS365.Config.md1```

### Initialization

When started, Connect-MS365 checks for the default user configuration file and initializes with a empty default file.
This can be edited by user manually using preferred text editor.

If you want to re-initialize user config file to an empty default file, use the switch ```-ReInitConfig```.
_You are not prompted, so be sure if you are using this switch._

### Configuration Options

* __DefaultUserPrincipalName__

  Sets the user's default userPrincipalName (UPN) in email format (xxx@domain.tld).
  This is used by some services as a default value, so it is not needed to enter it manually.
  
  _Due to multi-factor authentication / modern authentication not all service modules can use this option._
  _At the moment this is only supported by services EOL, SCC, S4B_.
