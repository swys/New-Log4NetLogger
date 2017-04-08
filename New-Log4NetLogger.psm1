# functions
Function New-Log4NetLogger {
  [CmdletBinding()]
  param(
    # will use dll that is packaged with this module by default unless otherwise specified
    [Parameter(ParameterSetName='Reset',Mandatory=$False)][switch]$Reset,
    [Parameter(ParameterSetName='Load',Mandatory=$False)][string]$DllPath="$($PSScriptRoot)\log4net.dll",
    [Parameter(ParameterSetName='Load',Mandatory=$True)][string]$XmlConfigPath,
    [Parameter(ParameterSetName='Load',Mandatory=$False)][string]$loggerName="root"
  )
  if ($Reset) {
    if (!([System.Management.Automation.PSTypeName]'log4net.LogManager').Type) {
      throw "log4net.LogManager class is not loaded"
    }
    Write-Verbose "Resetting XML Configuration..."
    [log4net.LogManager]::ResetConfiguration();
    return;
  }
  # validate $DllPath and $XmlConfigPath exist and get absolute paths, if err then we throw
  Try {
    Write-Verbose "Getting Absolute path for [$($DllPath)]..."
    $absoluteDllPath = (Resolve-Path -Path $DllPath).Path
    Write-Verbose "Getting Absolute path for [$($XmlConfigPath)]..."
    $absoluteXmlPath = (Resolve-Path -Path $XmlConfigPath).Path
  }
  Catch {
    throw $_
  }

  # load log4net dll / reset config / load xml config
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
  # return new class object
  $logger = [log4net.LogManager]::GetLogger($loggerName)
  return $logger
  #return [Log4NetLogger]::new($DllPath,$XmlConfigPath,$loggerName)
}

# exports
Export-ModuleMember New-Log4NetLogger