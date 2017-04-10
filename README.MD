New-Log4NetLogger
=================

This module will load log4net assembly into powershell and return a logger object that you can use with an xml config file to create log appenders to console / files / databases / event viewer / etc.

See full detail on the Apache project website => [https://logging.apache.org/log4net/](https://logging.apache.org/log4net/)

log4net dll
===========

This module ships with the log4net dll that is compatible with .NET Framework 4.5 and is version `v2.0.8.0`.

If you need to load a different version of the log4net lib then you can pass in the path to your dll using the `$DllPath` parameter to override the default assembly that ships with this module.

Please note that only the Dll that ships with this module has been tested. You may want to add the `-Verbose` switch when loading the module for more detailed debugging information.

If the `$DllPath` specified dll file fails to load (defaul dll or otherwise) then this module with throw.

usage
=====

There are 2 different use cases for this module (`Load` and `Reset`). That is why there are 2 different types of parameter sets. Each parameter set requires a different set of arguments. See the `options` section below for full details on each parameter set.

##### Example usage using Load param set (normal usage) :

Below is a simple example of how to load the module and return a new logger object that is configured based on the settings declared in the `$xmlConfigFile`. 

```
# import
Import-Module New-Log4NetLogger -EA Stop
# config
$xmlConfigFile = "./xmlconfig.xml"
# get logger
$logger = New-Log4NetLogger -XmlConfigPath $xmlConfigFile -loggerName "my cool log label"
# use logger as usual
$logger.Info("info message")
```

##### Example usage using Reset param set (clear config) :

There may be times when you need to clear the log4net configuration. You can do this by running the module as shown below :

```
# assuming the module is already loaded
# and you've already configured a logger with
# an xml config file

# to reset the log4net config
New-Log4NetLogger -Reset
```

The above will reset the log4net configuration. This will remove all existing appenders setup by the config file, including the removal on any file locks placed on any log files (so they can be safely deleted/moved/renamed/etc by another process).

example
=======

```
# import
Import-Module New-Log4NetLogger -EA Stop

# config
$xmlConfigFile = "./xmlconfig.xml"

# get logger
$logger = New-Log4NetLogger -XmlConfigPath $xmlConfigFile -loggerName "my cool log label"

# use logger as usual
$logger.Info("info message")
$logger.Warn("warn message")
$logger.Debug("debug message")
$logger.Error("error message")
$logger.Fatal("fatal message")
```

The output of your logger is completly dependent on what you setup in your xml config file.

See Apache docs for more details on different xml options : [https://logging.apache.org/log4net/release/config-examples.html](https://logging.apache.org/log4net/release/config-examples.html)

options
=======

This module has 2 differnt parameter sets. See below for details :

#### Load (normal usage) :

This is for normal usage in order to load an xml config file into the global space and get back a logger object that uses the xml configuration file that was loaded with the module.

| param name | type | required? | default | description |
| -----------| -----| ----------| --------| ------------|
| DllPath | string | false | ${RepoRoot}\bin\log4net-NET4.5-v2.0.8.0.dll | DLL to load the log4net lib |
| XmlConfigPath | string | true | null | Xml config file to load log4net settings |
| loggerName | string | false | root | label for the logger object |
| Verbose | switch | false | null | adds verbose output to internal module code for debugging purposes |


#### Reset (reset configuration) :

This for usage only when you want to clear or Reset the current xml configuration that has been loaded into log4net. This is handy when you want to load a new xml config or when you have a file appender and you can't delete the file until the handle is removed because it is loaded via the xml config. You can reset the config and then safely delete the file.

| param name | type | required? | default | description |
| -----------| -----| ----------| --------| ------------|
| Reset  | switch | true | null | switch param needs to be included to reset (clear) xml config loaded into log4net dll |
| Verbose | switch | false | null | adds verbose output to internal module code for debugging purposes |

tests
=====

```
Invoke-Pester
```

Test require Pester => [https://github.com/pester/Pester](https://github.com/pester/Pester)

license
=======

See Licenses Folder for more details
