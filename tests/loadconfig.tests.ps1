# remove module if loaded
if (Get-Module -Name New-Log4NetLogger) { Remove-Module New-Log4NetLogger }
# imports
Import-Module $PSScriptRoot\../New-Log4NetLogger.psm1 -EA Stop
# reset config
New-Log4NetLogger -Reset

Describe "Testing that we can load dll and config without errors" {
  Context "setup logger" {
      # setup log file to temp location for tests
      $xmlConfig = "$PSScriptRoot\xmllogconfig.xml"
      $xml = ([xml](Get-Content $xmlConfig))
      $xmlLogFile = "$($env:temp)\$(($xml.configuration.log4net.appender.ChildNodes.Item(0).value).split("\")[1])"
    It "should create the log file specified in the xml config" {
      $logger = New-Log4NetLogger -XmlConfigPath $xmlConfig -loggerName "pestering"
      $logger.Debug("testing debugging statements")
      Test-Path $xmlLogFile | Should Be $True
    }
    It "should have written to log file" {
      $pattern = "testing debugging statements"
      [boolean]$(Select-String -Path $xmlLogFile -Pattern $pattern) | Should Be $True
    }
    It "should throw when trying to delete logfile before resetting cofiguration" {
      $logger2 = New-Log4NetLogger -XmlConfigPath $xmlConfig -loggerName "testing reset xml config"
      $logger2.Info("writing some info")
      {Remove-Item $xmlLogFile -EA Stop} | Should Throw
      New-Log4NetLogger -Reset
      {Remove-Item $xmlLogFile -EA Stop} | Should Not Throw
    }
  # reset config and delete log file before exit
  New-Log4NetLogger -Reset
  if (Test-Path $xmlLogFile) { Remove-Item $xmlLogFile -Force }
  }
}