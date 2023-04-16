﻿
$cwd = Get-Location

$suspicious_process_paths = @(
    ".*\\windows\\fonts\\.*",
    ".*\\windows\\temp\\.*",
    ".*\\users\\public\\.*",
    ".*\\windows\\debug\\.*",
    ".*\\users\\administrator\\.*",
    ".*\\windows\\servicing\\.*",
    ".*\\users\\default\\.*",
    ".*recycle.bin.*",
    ".*\\windows\\media\\.*",
    ".*\\windows\\repair\\.*"
)
$ipv4_pattern = '.*((?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).*'
$ipv6_pattern = '.*:(?::[a-f\d]{1,4}){0,5}(?:(?::[a-f\d]{1,4}){1,2}|:(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})))|[a-f\d]{1,4}:(?:[a-f\d]{1,4}:(?:[a-f\d]{1,4}:(?:[a-f\d]{1,4}:(?:[a-f\d]{1,4}:(?:[a-f\d]{1,4}:(?:[a-f\d]{1,4}:(?:[a-f\d]{1,4}|:)|(?::(?:[a-f\d]{1,4})?|(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))))|:(?:(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|[a-f\d]{1,4}(?::[a-f\d]{1,4})?|))|(?::(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|:[a-f\d]{1,4}(?::(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|(?::[a-f\d]{1,4}){0,2})|:))|(?:(?::[a-f\d]{1,4}){0,2}(?::(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|(?::[a-f\d]{1,4}){1,2})|:))|(?:(?::[a-f\d]{1,4}){0,3}(?::(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|(?::[a-f\d]{1,4}){1,2})|:))|(?:(?::[a-f\d]{1,4}){0,4}(?::(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})\.){3}(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|(?::[a-f\d]{1,4}){1,2})|:)).*'



function Scheduled-Tasks {
    $tasks = Get-ScheduledTask  | Select -Property State,Actions,Author,Date,Description,Principal,SecurityDescriptor,Settings,TaskName,TaskPath,Triggers,URI, @{Name="RunAs";Expression={ $_.principal.userid }} -ExpandProperty Actions | Select *

    $default_task_exe_paths = @(
        "%windir%\System32\XblGameSaveTask.exe",
        "%SystemRoot%\System32\WiFiTask.exe",
        "%SystemRoot%\System32\dsregcmd.exe",
        "C:\Windows\system32\sc.exe"
        '"%ProgramFiles%\Windows Media Player\wmpnscfg.exe"',
        "C:\ProgramData\Microsoft\Windows Defender\Platform\*\MpCmdRun.exe",
        "%windir%\system32\wermgr.exe",
        "%windir%\system32\rundll32.exe",
        "%systemroot%\system32\MusNotification.exe",
        "%windir%\system32\tzsync.exe",
        "%windir%\System32\UNP\UpdateNotificationMgr.exe",
        "%systemroot%\system32\MusNotification.exe",
        "%systemroot%\system32\usoclient.exe",
        "%windir%\system32\appidpolicyconverter.exe",
        "%windir%\system32\appidcertstorecheck.exe".
        "%windir%\system32\compattelrunner.exe",
        "%windir%\system32\rundll32.exe",
        "%windir%\system32\compattelrunner.exe",
        "%windir%\system32\rundll32.exe",
        "%windir%\system32\AppHostRegistrationVerifier.exe",
        "%windir%\system32\AppHostRegistrationVerifier.exe",
        "%windir%\system32\rundll32.exe",
        "%windir%\system32\dstokenclean.exe",
        "%windir%\system32\defrag.exe",
        "%windir%\system32\devicecensus.exe",
        "%SystemRoot%\system32\ClipRenew.exe",
        "%windir%\system32\srtasks.exe",
        "%windir%\system32\sc.exe",
        "%windir%\system32\RAServer.exe",
        "%windir%\System32\wpcmon.exe",
        "%windir%\system32\SpaceAgent.exe",
        "%windir%\system32\spaceman.exe",
        "%windir%\system32\ProvTool.exe",
        "%windir%\system32\appidcertstorecheck.exe",
        "BthUdTask.exe",
        "%windir%\system32\bcdboot.exe",
        "%SystemRoot%\system32\ClipUp.exe",
        "%SystemRoot%\system32\fclip.exe",
        '"C:\Windows\System32\MicTray64.exe"',
        '"C:\Windows\System32\SynaMonApp.exe"',
        "%SystemRoot%\System32\wsqmcons.exe",
        "%windir%\system32\directxdatabaseupdater.exe",    
        "%windir%\system32\dxgiadaptercache.exe",
        "%windir%\system32\cleanmgr.exe",
        "%windir%\system32\DFDWiz.exe",
        "%windir%\system32\disksnapshot.exe",
        "%SystemRoot%\System32\dusmtask.exe",
        "%windir%\system32\dmclient.exe",
        "C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe",
        "C:\Program Files\NVIDIA Corporation\nview\nwiz.exe",
        "C:\Program Files\Microsoft OneDrive\OneDriveStandaloneUpdater.exe",
        "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe",
        "C:\Program Files\Microsoft Office\root\Office16\sdxhelper.exe",
        "C:\Program Files\Microsoft Office\root\VFS\ProgramFilesCommonX64\Microsoft Shared\Office16\operfmon.exe",
        "%WinDir%\System32\WinBioPlugIns\FaceFodUninstaller.exe",
        "%windir%\System32\LocationNotificationWindows.exe",
        "%windir%\System32\WindowsActionDialog.exe",
        "%SystemRoot%\System32\MbaeParserTask.exe",
        "%windir%\system32\lpremove.exe",
        "%windir%\system32\gatherNetworkInfo.vbs",
        "%SystemRoot%\System32\drvinst.exe",
        "%windir%\system32\eduprintprov.exe",
        "%windir%\system32\speech_onecore\common\SpeechModelDownload.exe"
    )


    ForEach ($task in $tasks){
        # Detection - Non-Standard Tasks
        ForEach ($i in $default_task_exe_paths){
            if ( $task.Execute -like $i) {
                $exe_match = $true
                break
            } elseif ($task.Execute.Length -gt 0) { 
                $exe_match = $false 
            }
        }
        if ($exe_match -eq $false) {
            # Current Task Executable Path is non-standard
            $detection = [PSCustomObject]@{
                Name = 'Non-Standard Scheduled Task Executable'
                Risk = 'Low'
                Source = 'Scheduled Tasks'
                Technique = "T1053: Scheduled Task/Job"
                Meta = "Task Name: "+ $task.TaskName+", Task Executable: "+ $task.Execute+", RunAs: "+$task.RunAs
            }
            Write-Detection $detection
        }
        # Task Running as SYSTEM
        if ($task.RunAs -eq "SYSTEM" -and $exe_match -eq $false) {
            # Current Task Executable Path is non-standard
            $detection = [PSCustomObject]@{
                Name = 'Non-Standard Scheduled Task Running as SYSTEM'
                Risk = 'High'
                Source = 'Scheduled Tasks'
                Technique = "T1053: Scheduled Task/Job"
                Meta = "Task Name: "+ $task.TaskName+", Task Executable: "+ $task.Execute+", RunAs: "+$task.RunAs
            }
            Write-Detection $detection
        }
        # Detection - Task contains an IP Address
        if ($task.Execute -match $ipv4_pattern -or $task.Execute -match $ipv6_pattern) {
            # Task Contains an IP Address
            $detection = [PSCustomObject]@{
                Name = 'Task contains an IP Address'
                Risk = 'High'
                Source = 'Scheduled Tasks'
                Technique = "T1053: Scheduled Task/Job"
                Meta = "Task Name: "+ $task.TaskName+", Task Executable: "+ $task.Execute+", Task Author: "+ $task.Author+", RunAs: "+$task.RunAs
            }
            Write-Detection $detection
        }
        # Task has suspicious terms
        if ($task.Execute -match ".*(regsvr32.exe | downloadstring | mshta | frombase64 | tobase64 | EncodedCommand | DownloadFile | certutil | csc.exe | ieexec.exe | wmic.exe).*") {
            $detection = [PSCustomObject]@{
                Name = 'Task contains suspicious keywords.'
                Risk = 'High'
                Source = 'Scheduled Tasks'
                Technique = "T1053: Scheduled Task/Job"
                Meta = "Task Name: "+ $task.TaskName+", Task Executable: "+ $task.Execute+", Task Author: "+ $task.Author+", RunAs: "+$task.RunAs
            }
            Write-Detection $detection
        }
        # Detection - User Created Tasks
        if ($task.Author -ne $null) {
            if (($task.Author).Contains("\")) {
                if ((($task.Author.Split('\')).count-1) -eq 1) {
                    # Single '\' in author most likely indicates it is a user-made task
                    $detection = [PSCustomObject]@{
                        Name = 'User Created Task'
                        Risk = 'Low'
                        Source = 'Scheduled Tasks'
                        Technique = "T1053: Scheduled Task/Job"
                        Meta = "Task Name: "+ $task.TaskName+", Task Executable: "+ $task.Execute+", Task Author: "+ $task.Author+", RunAs: "+$task.RunAs
                    }
                    Write-Detection $detection
                    if ($task.RunAs -eq "SYSTEM") {
                        # Current Task Executable Path is non-standard
                        $detection = [PSCustomObject]@{
                            Name = 'User-Created Task running as SYSTEM'
                            Risk = 'High'
                            Source = 'Scheduled Tasks'
                            Technique = "T1053: Scheduled Task/Job"
                            Meta = "Task Name: "+ $task.TaskName+", Task Executable: "+ $task.Execute+", Task Author: "+ $task.Author+", RunAs: "+$task.RunAs
                        }
                        Write-Detection $detection
                    }
                }
            }
        }
    }
}

function Users {
    $local_admins = Get-LocalGroupMember -Group "Administrators" | Select *
    ForEach ($admin in $local_admins){
        $admin_user = Get-LocalUser -SID $admin.SID | Select-Object AccountExpires,Description,Enabled,FullName,PasswordExpires,UserMayChangePassword,PasswordLastSet,LastLogon,Name,SID,PrincipalSource
        $detection = [PSCustomObject]@{
            Name = 'Local Administrator Account'
            Risk = 'Medium'
            Source = 'Users'
            Technique = "TODO"
            Meta = "Name: "+$admin.Name +", Last Logon: "+ $admin_user.LastLogon+", Enabled: "+ $admin_user.Enabled
        }
        Write-Detection $detection
    }
    
}

function Services {
    $default_service_exe_paths = @(
        'C:\Windows\system32\svchost.exe -k LocalServiceNetworkRestricted -p',
        'C:\Windows\System32\alg.exe',
        'C:\Windows\system32\Alps\GlidePoint\HidMonitorSvc.exe',
        'C:\Windows\system32\svchost.exe -k netsvcs -p',
        'C:\Windows\System32\svchost.exe -k AppReadiness -p',
        'C:\Windows\system32\AppVClient.exe',
        'C:\Windows\system32\svchost.exe -k wsappx -p',
        'C:\Windows\system32\svchost.exe -k AssignedAccessManagerSvc',
        'C:\Windows\System32\svchost.exe -k LocalSystemNetworkRestricted -p',
        'C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted -p',
        'C:\Windows\system32\svchost.exe -k autoTimeSvc',
        'C:\Windows\system32\svchost.exe -k AxInstSVGroup',
        'C:\Windows\System32\svchost.exe -k netsvcs -p',
        'C:\Windows\system32\svchost.exe -k LocalServiceNoNetworkFirewall -p',
        'C:\Windows\system32\svchost.exe -k DcomLaunch -p',
        'C:\Windows\system32\svchost.exe -k LocalServiceNetworkRestricted',
        'C:\Windows\system32\svchost.exe -k LocalService -p',
        'C:\Windows\system32\svchost.exe -k appmodel -p',
        'C:\Windows\system32\svchost.exe -k netsvcs',
        '"C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" /service',
        'C:\Windows\System32\svchost.exe -k wsappx -p',
        'C:\Windows\system32\svchost.exe -k CloudIdServiceGroup -p',
        'C:\Windows\system32\svchost.exe -k LocalServiceNoNetwork -p',
        'C:\Windows\System32\DriverStore\FileRepository\iigd_dch.inf_amd64_*\IntelCpHeciSvc.exe',
        'C:\Windows\System32\DriverStore\FileRepository\iigd_dch.inf_amd64_*\IntelCpHDCPSvc.exe',
        'C:\Windows\system32\svchost.exe -k NetworkService -p',
        '"C:\Windows\CxSvc\CxAudioSvc.exe"',
        '"C:\Windows\CxSvc\CxUtilSvc.exe"',
        'C:\Windows\system32\svchost.exe -k defragsvc',
        'C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted -p',
        'C:\Windows\system32\DiagSvcs\DiagnosticsHub.StandardCollector.Service.exe',
        'C:\Windows\System32\svchost.exe -k diagnostics',
        'C:\Windows\System32\svchost.exe -k utcsvc -p',
        'C:\Windows\system32\svchost.exe -k DialogBlockingService',
        'C:\Windows\System32\svchost.exe -k NetworkService -p',
        'C:\Windows\System32\svchost.exe -k LocalServiceNoNetwork -p',
        '"C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe" /svc',
        '"C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe" /medsvc',
        'C:\Windows\System32\lsass.exe',
        'C:\Windows\system32\fxssvc.exe',
        'C:\Windows\system32\svchost.exe -k LocalServiceAndNoImpersonation -p',
        '"C:\Program Files\Microsoft OneDrive\*\FileSyncHelper.exe"',
        'C:\Windows\Microsoft.Net\*\*\WPF\PresentationFontCache.exe',
        'C:\Windows\System32\svchost.exe -k Camera',
        '"C:\Program Files\Google\Chrome\Application\*\elevation_service.exe"',
        'C:\Windows\System32\svchost.exe -k GraphicsPerfSvcGroup',
        '"C:\Program Files (x86)\Google\Update\GoogleUpdate.exe" /svc',
        '"C:\Program Files (x86)\Google\Update\GoogleUpdate.exe" /medsvc',
        'C:\Windows\System32\DriverStore\FileRepository\hpqkbsoftwarecompnent.inf_amd64_*\HotKeyServiceUWP.exe',
        'C:\Windows\System32\ibtsiva',
        'C:\Windows\System32\DriverStore\FileRepository\igcc_dch.inf_amd64_*\OneApp.IGCC.WinService.exe',
        'C:\Windows\System32\DriverStore\FileRepository\cui_dch.inf_amd64_*\igfxCUIService.exe',
        'C:\Windows\system32\cAVS\Intel(R) Audio Service\IntelAudioService.exe',
        'C:\Windows\System32\svchost.exe -k NetSvcs -p',
        'C:\Windows\system32\lsass.exe',
        'C:\Windows\System32\svchost.exe -k NetworkServiceAndNoImpersonation -p',
        'C:\Windows\System32\DriverStore\FileRepository\hpqkbsoftwarecompnent.inf_amd64_*\LanWlanWwanSwitchingServiceUWP.exe',
        'C:\Windows\System32\svchost.exe -k LocalService -p',
        'C:\Windows\system32\svchost.exe -k McpManagementServiceGroup',
        '"C:\Program Files (x86)\Microsoft\Edge\Application\*\elevation_service.exe"',
        'C:\Windows\System32\msdtc.exe',
        'C:\Windows\system32\msiexec.exe /V',
        'C:\Windows\Microsoft.NET\Framework64\*\SMSvcHost.exe',
        '"C:\Program Files\NVIDIA Corporation\Display.NvContainer\NVDisplay.Container.exe" -s NVDisplay.ContainerLocalSystem -f "C:\ProgramData\NVIDIA\NVDisplay.ContainerLocalSystem.log" -l 3 -d "C:\Program Files\NVIDIA Corporation\Display.NvContainer\plugins\LocalSystem" -r -p 30000 ',
        'C:\Windows\System32\nvwmi64.exe',
        '"C:\Program Files\Microsoft OneDrive\*\OneDriveUpdaterService.exe"',
        'C:\Windows\System32\svchost.exe -k LocalServicePeerNet',
        'C:\Windows\System32\svchost.exe -k PeerDist',
        'C:\Windows\system32\PerceptionSimulation\PerceptionSimulationService.exe',
        'C:\Windows\SysWow64\perfhost.exe',
        'C:\Windows\system32\svchost.exe -k NetworkServiceNetworkRestricted -p',
        'C:\Windows\system32\svchost.exe -k print',
        'C:\Windows\System32\svchost.exe -k netsvcs',
        'C:\Windows\system32\svchost.exe -k localService -p',
        'C:\Windows\System32\svchost.exe -k rdxgroup',
        'C:\Windows\System32\svchost.exe -k LocalServiceNetworkRestricted',
        'C:\Windows\system32\svchost.exe -k RPCSS -p',
        'C:\Windows\system32\locator.exe',
        'C:\Windows\system32\svchost.exe -k rpcss -p',
        'C:\Windows\System32\DriverStore\FileRepository\iaahcic.inf_amd64_*\RstMwService.exe',
        'C:\Windows\system32\svchost.exe -k LocalServiceAndNoImpersonation',
        'C:\Windows\system32\svchost.exe -k LocalSystemNetworkRestricted',
        'C:\Windows\system32\svchost.exe -k SDRSVC',
        'C:\Windows\system32\SecurityHealthService.exe',
        '"C:\Program Files\Windows Defender Advanced Threat Protection\MsSense.exe"',
        'C:\Windows\System32\SensorDataService.exe',
        'C:\Windows\system32\SgrmBroker.exe',
        'C:\Windows\System32\svchost.exe -k smphost',
        'C:\Windows\System32\snmptrap.exe',
        'C:\Windows\system32\spectrum.exe',
        'C:\Windows\System32\spoolsv.exe',
        'C:\Windows\system32\sppsvc.exe',
        'C:\Windows\System32\OpenSSH\ssh-agent.exe',
        'C:\Windows\system32\svchost.exe -k imgsvc',
        'C:\Windows\System32\svchost.exe -k swprv',
        'C:\Windows\System32\svchost.exe -k NetworkService',
        'C:\Windows\system32\TieringEngineService.exe',
        'C:\Windows\servicing\TrustedInstaller.exe',
        'C:\Windows\system32\AgentService.exe',
        '"C:\Program Files\Microsoft Update Health Tools\uhssvc.exe"',
        'C:\Windows\System32\vds.exe',
        'C:\Windows\system32\svchost.exe -k ICService -p',
        'C:\Windows\system32\vssvc.exe',
        'C:\Windows\system32\svchost.exe -k LocalService',
        'C:\Windows\system32\svchost.exe -k wusvcs -p',
        'C:\Windows\System32\svchost.exe -k appmodel -p',
        '"C:\Windows\system32\wbengine.exe"',
        'C:\Windows\system32\svchost.exe -k WbioSvcGroup',
        'C:\Windows\System32\svchost.exe -k LocalServiceAndNoImpersonation -p',
        '"C:\ProgramData\Microsoft\Windows Defender\Platform\*\NisSrv.exe"',
        'C:\Windows\system32\svchost.exe -k WepHostSvcGroup',
        'C:\Windows\System32\svchost.exe -k WerSvcGroup',
        '"C:\ProgramData\Microsoft\Windows Defender\Platform\*\MsMpEng.exe"',
        'C:\Windows\system32\wbem\WmiApSrv.exe',
        '"C:\Program Files\Windows Media Player\wmpnetwk.exe"',
        'C:\Windows\system32\SearchIndexer.exe /Embedding',
        'C:\Windows\SysWOW64\XtuService.exe',
        'C:\Windows\system32\svchost.exe -k AarSvcGroup -p',
        'C:\Windows\system32\svchost.exe -k BcastDVRUserService',
        'C:\Windows\system32\svchost.exe -k BthAppGroup -p',
        'C:\Windows\system32\svchost.exe -k ClipboardSvcGroup -p',
        'C:\Windows\system32\svchost.exe -k UnistackSvcGroup',
        'C:\Windows\system32\svchost.exe -k DevicesFlow',
        'C:\Windows\system32\CredentialEnrollmentManager.exe',
        'C:\Windows\system32\svchost.exe -k DevicesFlow -p',
        'C:\Windows\system32\svchost.exe -k PrintWorkflow',
        'C:\Windows\system32\svchost.exe -k UdkSvcGroup',
        'C:\Windows\System32\svchost.exe -k UnistackSvcGroup'
    )

    $services = Get-CimInstance -ClassName Win32_Service  | select Name, PathName, StartMode, Caption, DisplayName, InstallDate, ProcessId, State

    ForEach ($service in $services){
        # Detection - Non-Standard Tasks
        ForEach ($i in $default_service_exe_paths){
            if ( $service.PathName -like $i) {
                $exe_match = $true
                break
            } elseif ($service.PathName.Length -gt 0) { 
                $exe_match = $false 
            }
        }
        if ($exe_match -eq $false) {
            # Current Task Executable Path is non-standard
            $detection = [PSCustomObject]@{
                Name = 'Non-Standard Service Path'
                Risk = 'Low'
                Source = 'Services'
                Technique = "TODO"
                Meta = "Service Name: "+ $service.Name+", Service Path: "+ $service.PathName
            }
            Write-Detection $detection
        }
        if ($service.PathName -match ".*cmd.exe /(k|c).*") {
            # Command 
            $detection = [PSCustomObject]@{
                Name = 'Service launching from cmd.exe'
                Risk = 'Medium'
                Source = 'Services'
                Technique = "TODO"
                Meta = "Service Name: "+ $service.Name+", Service Path: "+ $service.PathName
            }
            Write-Detection $detection
        }
    }
}

function Processes {
    # TODO - Check for processes spawned from netsh.dll
    $processes = Get-CimInstance -ClassName Win32_Process | Select ProcessName,CreationDate,CommandLine,ExecutablePath,ParentProcessId,ProcessId
    ForEach ($process in $processes){
        if ($process.CommandLine -match $ipv4_pattern -or $process.CommandLine -match $ipv6_pattern) {
            $detection = [PSCustomObject]@{
                Name = 'IP Address Pattern detected in Process CommandLine'
                Risk = 'Medium'
                Source = 'Processes'
                Technique = "TODO"
                Meta = "Process Name: "+ $process.ProcessName+", CommandLine: "+ $process.CommandLine+", Executable: "+$process.ExecutablePath
            }
            Write-Detection $detection
        }
        ForEach ($path in $suspicious_process_paths) {
            if ($process.ExecutablePath -match $path){
                $detection = [PSCustomObject]@{
                    Name = 'Suspicious Executable Path on Running Process'
                    Risk = 'High'
                    Source = 'Processes'
                    Technique = "TODO"
                    Meta = "Process Name: "+ $process.ProcessName+", CommandLine: "+ $process.CommandLine+", Executable: "+$process.ExecutablePath
                }
                Write-Detection $detection
            }
        }
    }
}

function Connections {
    $tcp_connections = Get-NetTCPConnection | Select State,LocalAddress,LocalPort,OwningProcess,RemoteAddress,RemotePort
    $suspicious_ports = @(20,21,22,23,25,137,139,445,3389,443)
    $allow_listed_process_names = @(
        "chrome",
        "GitHubDesktop",
        "Spotify",
        "Discord",
        "OneDrive",
        "msedge",
        "brave",
        "iexplorer",
        "safari",
        "firefox",
        "officeclicktorun"
        "steam"
        "SearchApp"
    )
    ForEach ($conn in $tcp_connections) {
        $proc = Get-Process -Id $conn.OwningProcess | Select Name,Path
        if ($conn.State -eq 'Listen' -and $conn.LocalPort -gt 1024){
            $detection = [PSCustomObject]@{
                Name = 'Process Listening on Ephemeral Port'
                Risk = 'Very Low'
                Source = 'Connections'
                Technique = "TODO"
                Meta = "Local Port: "+$conn.LocalPort+", PID: "+$conn.OwningProcess+", Process Name: "+$proc.Name+", Process Path: "+$proc.Path
            }
            Write-Detection $detection
        }
        if ($conn.State -eq 'Established' -and ($conn.LocalPort -in $suspicious_ports -or $conn.RemotePort -in $suspicious_ports) -and $proc.Name -inotin $allow_listed_process_names){
            $detection = [PSCustomObject]@{
                Name = 'Established Connection on Suspicious Port'
                Risk = 'Low'
                Source = 'Connections'
                Technique = "TODO"
                Meta = "Local Port: "+$conn.LocalPort+", Remote Port: "+$conn.RemotePort+", Remote Address: "+$conn.RemoteAddress+", PID: "+$conn.OwningProcess+", Process Name: "+$proc.Name+", Process Path: "+$proc.Path
            }
            Write-Detection $detection
        }
        if ($proc.Path -ne $null){
            ForEach ($path in $suspicious_process_paths){
                if (($proc.Path).ToLower() -match $path){
                    $detection = [PSCustomObject]@{
                        Name = 'Process running from suspicious path has Network Connection'
                        Risk = 'High'
                        Source = 'Connections'
                        Technique = "TODO"
                        Meta = "Local Port: "+$conn.LocalPort+", Remote Port: "+$conn.RemotePort+", Remote Address: "+$conn.RemoteAddress+", PID: "+$conn.OwningProcess+", Process Name: "+$proc.Name+", Process Path: "+$proc.Path
                    }
                    Write-Detection $detection
                }
            }
        }
    }
}

function WMI-Consumers {
    $consumers = Get-WMIObject -Namespace root\Subscription -Class __EventConsumer | Select *

    ForEach ($consumer in $consumers) {
        if ($consumer.ScriptingEngine -ne $null) {
            $detection = [PSCustomObject]@{
                Name = 'WMI ActiveScript Consumer'
                Risk = 'High'
                Source = 'WMI'
                Technique = "TODO"
                Meta = "Consumer Name: "+$consumer.Name+", Script Name: "+$consumer.ScriptFileName+", Script Text: "+$consumer.ScriptText
            }
            Write-Detection $detection
        }
        if ($consumer.CommandLineTemplate -ne $null) {
            $detection = [PSCustomObject]@{
                Name = 'WMI CommandLine Consumer'
                Risk = 'High'
                Source = 'WMI'
                Technique = "TODO"
                Meta = "Consumer Name: "+$consumer.Name+", Executable Path: "+$consumer.ExecutablePath+", CommandLine Template: "+$consumer.CommandLineTemplate
            }
            Write-Detection $detection
        }
    }
}

function Startups {
    $startups = Get-CimInstance -ClassName Win32_StartupCommand | Select Command,Location,Name,User
    ForEach ($item in $startups) {
        $detection = [PSCustomObject]@{
            Name = 'Startup Item Review'
            Risk = 'Low'
            Source = 'Startup'
            Technique = "TODO"
            Meta = "Item Name: "+$item.Name+", Command: "+$item.Command+", Location: "+$item.Location+", User: "+$item.User
        }
        Write-Detection $detection
    }
}

function BITS {
    $bits = Get-BitsTransfer | Select JobId,DisplayName,TransferType,JobState,OwnerAccount
    ForEach ($item in $bits) {
        $detection = [PSCustomObject]@{
            Name = 'BITS Item Review'
            Risk = 'Low'
            Source = 'BITS'
            Technique = "TODO"
            Meta = "Item Name: "+$item.DisplayName+", TransferType: "+$item.TransferType+", Job State: "+$item.JobState+", User: "+$item.OwnerAccount
        }
        Write-Detection $detection
    }
}

function Modified-Windows-Accessibility-Feature {
    $files_to_check = @(
        "C:\Windows\System32\sethc.exe",
        "C:\Windows\System32\utilman.exe",
        "C:\Windows\System32\osk.exe",
        "C:\Windows\System32\Magnify.exe",
        "C:\Windows\System32\Narrator.exe",
        "C:\Windows\System32\DisplaySwitch.exe",
        "C:\Windows\System32\AtBroker.exe"
        "C:\Program Files\Common Files\microsoft shared\ink\HID.dll"

    )
    ForEach ($file in $files_to_check){ 
        $fdata = Get-Item $file -ErrorAction SilentlyContinue | Select CreationTime,LastWriteTime
        if ($fdata.CreationTime -ne $null) {
            if ($fdata.CreationTime.ToString() -ne $fdata.LastWriteTime.ToString()){
                $detection = [PSCustomObject]@{
                    Name = 'Potential modification of Windows Accessibility Feature'
                    Risk = 'High'
                    Source = 'Windows'
                    Technique = "T1546.008: Event Triggered Execution: Accessibility Features"
                    Meta = "File: "+$file+", Created: "+$fdata.CreationTime+", Modified: "+$fdata.LastWriteTime
                }
                Write-Detection $detection
            }
        }
    }
}


function PowerShell-Profiles {
    # PowerShell profiles may be abused by adversaries for persistence.

    # $PSHOME\Profile.ps1
    # $PSHOME\Microsoft.PowerShell_profile.ps1
    # $HOME\Documents\PowerShell\Profile.ps1
    # $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
    $PROFILE | Select AllUsersAllHosts,AllUsersCurrentHost,CurrentUserAllHosts,CurrentUserCurrentHost | Out-Null
    if (Test-Path $PROFILE.AllUsersAllHosts){
        $detection = [PSCustomObject]@{
            Name = 'Custom PowerShell Profile for All Users should be reviewed.'
            Risk = 'Medium'
            Source = 'Windows'
            Technique = "T1546.013: Event Triggered Execution: PowerShell Profile"
            Meta = "Profile: "+$PROFILE.AllUsersAllHosts
        }
        Write-Detection $detection
    }
    if (Test-Path $PROFILE.AllUsersCurrentHost){
        $detection = [PSCustomObject]@{
            Name = 'Custom PowerShell Profile for All Users should be reviewed.'
            Risk = 'Medium'
            Source = 'Windows'
            Technique = "T1546.013: Event Triggered Execution: PowerShell Profile"
            Meta = "Profile: "+$PROFILE.AllUsersCurrentHost
        }
        Write-Detection $detection
    }

    $profile_names = Get-ChildItem 'C:\Users' -Attributes Directory | Select Name
    ForEach ($name in $profile_names){
        $path1 = "C:\Users\$name\Documents\WindowsPowerShell\profile.ps1"
        $path2 = "C:\Users\$name\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1"
        $path3 = "C:\Users\$name\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
        if (Test-Path $path1){
            $detection = [PSCustomObject]@{
                Name = 'Custom PowerShell Profile for Specific User should be reviewed.'
                Risk = 'Medium'
                Source = 'Windows'
                Technique = "T1546.013: Event Triggered Execution: PowerShell Profile"
                Meta = "Profile: "+$path1
            }
            Write-Detection $detection
        }
        if (Test-Path $path2){
            $detection = [PSCustomObject]@{
                Name = 'Custom PowerShell Profile for Specific User should be reviewed.'
                Risk = 'Medium'
                Source = 'Windows'
                Technique = "T1546.013: Event Triggered Execution: PowerShell Profile"
                Meta = "Profile: "+$path2
            }
            Write-Detection $detection
        }
        if (Test-Path $path3){
            $detection = [PSCustomObject]@{
                Name = 'Custom PowerShell Profile for Specific User should be reviewed.'
                Risk = 'Medium'
                Source = 'Windows'
                Technique = "T1546.013: Event Triggered Execution: PowerShell Profile"
                Meta = "Profile: "+$path3
            }
            Write-Detection $detection
        }
    }
}


function Write-Detection($det)  {
    # Data is a custom object which will contain various pieces of metadata for the detection
    # Name
    # Risk (Very Low, Low, Medium, High, Very High, Critical)
    # Source
    # Tactic
    # Technique
    # Meta - String containing detection reference material specific to the detection
    if ($det.Risk -eq 'Very Low' -or $det.Risk -eq 'Low') {
        $fg_color = 'Green'
    } elseif ($det.Risk -eq 'Medium'){
        $fg_color = 'Yellow'
    } elseif ($det.Risk -eq 'High') {
        $fg_color = 'Red'
    } elseif ($det.Risk -eq 'Very High') {
        $fg_color = 'Magenta'
    }
    Write-Host [+] New Detection: $det.Name - Risk: $det.Risk -ForegroundColor $fg_color
    Write-Host [%] $det.Meta
    $det | Export-CSV $cwd"\detections.csv" -Append -NoTypeInformation -Encoding UTF8
}

function Logo {
    $logo = "
  __________  ___ _       ____    __________ 
 /_  __/ __ \/   | |     / / /   / ____/ __ \
  / / / /_/ / /| | | /| / / /   / __/ / /_/ /
 / / / _, _/ ___ | |/ |/ / /___/ /___/ _, _/ 
/_/ /_/ |_/_/  |_|__/|__/_____/_____/_/ |_|  
    "
    Write-Host $logo
    Write-Host "Trawler - Dredging Windows for Persistence"
    Write-Host "github.com/joeavanzato/trawler"
    Write-Host ""
}

function Main {
    Logo
    Scheduled-Tasks
    Users
    services
    Processes
    Connections
    WMI-Consumers
    Startups
    BITS
    Modified-Windows-Accessibility-Feature
    PowerShell-Profiles
}

Main