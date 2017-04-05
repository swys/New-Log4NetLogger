# functions
Function New-Log4NetLogger {
  [CmdletBinding()]
  param(
    # will use dll that is packaged with this module by default unless otherwise specified
    [string]$DllPath="$($PSScriptRoot)\log4net.dll",
    [Parameter(Mandatory=$True)]
    [string]$XmlConfigPath,
    [string]$loggerName="root"
  )
  # validate $DllPath and $XmlConfigPath exist and get absolute paths, if err then we throw
  Try {
    Write-Verbose "Getting Absolute path for [$($DllPath)]..."
    $absoluteDllPath = Resolve-Path -Path $DllPath
    Write-Verbose "Getting Absolute path for [$($XmlConfigPath)]..."
    $absoluteXmlPath = Resolve-Path -Path $XmlConfigPath
  }
  Catch {
    # if any of the above fails it will be caught here and we can throw to bail out
    throw $_
  }
  # load log4net dll and reset config, if err we throw
  Try {
    Write-Verbose "Attempting to load log4net dll from path : [$($XmlConfigPath)]..."
    [void][Reflection.Assembly]::LoadFile($absoluteDllPath)
    Write-Verbose "Dll successfully loaded...resetting configuration..."
    [log4net.LogManager]::ResetConfiguration();
    Write-Verbose "Attempting to load the xml config file : [$($XmlConfigPath)]..."
    [log4net.Config.XmlConfigurator]::ConfigureAndWatch((Get-Item $($XmlConfigPath)))
  }
  Catch {
    throw $_
  }
  # load the xml config file 

  # create logger object
  Write-Verbose "Creating logger object..."
  $logger = [log4net.LogManager]::GetLogger($loggerName)
  Write-Verbose "Returning logger object..."
  return $logger
}

# exports
Export-ModuleMember New-Log4NetLogger