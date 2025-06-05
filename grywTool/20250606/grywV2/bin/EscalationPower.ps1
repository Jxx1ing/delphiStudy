param (
    [Parameter(Mandatory=$true, HelpMessage="请输入当前用户下的注册表路径（示例: HKCU:\Software\MyApp）")]
    [string]$RegPath
)
 
try {
    # 自动获取当前用户名
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
 
    # 标准化路径格式
    $RegPath = $RegPath -replace '/','\'
 
    # 自动创建路径（如果不存在）
    if (-not (Test-Path $RegPath)) {
        Write-Host "正在创建注册表路径: $RegPath" -ForegroundColor Cyan
        New-Item -Path $RegPath -Force | Out-Null
    }
 
    # 获取ACL配置
    $acl = Get-Acl -Path $RegPath
 
    # 设置当前用户为所有者
    Write-Host "正在设置所有权给: $currentUser" -ForegroundColor Cyan
    $acl.SetOwner([System.Security.Principal.NTAccount]$currentUser)
 
    # 创建访问规则（继承+完全控制）
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule(
        $currentUser,
        "FullControl",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )
 
    # 应用新规则（保留现有权限）
    $acl.AddAccessRule($rule)
 
    # 写入权限设置
    Set-Acl -Path $RegPath -AclObject $acl -ErrorAction Stop
     
    # 成功反馈
    Write-Host "`n[操作成功]" -ForegroundColor Green
    Write-Host "路径: $RegPath" -ForegroundColor Green
    Write-Host "当前用户已获得完全控制权限" -ForegroundColor Green
}
catch {
    Write-Host "`n[操作失败]" -ForegroundColor Red
    Write-Host "错误类型: $($_.Exception.GetType().Name)" -ForegroundColor Red
    Write-Host "详细信息: $($_.Exception.Message)" -ForegroundColor Red
 
    # 针对性错误处理
    if ($_ -like "*拒绝访问*") {
        Write-Host "`n解决方案尝试: 请检查路径是否属于当前用户，或手动创建父项" -ForegroundColor Yellow
    }
    elseif ($_ -like "*找不到路径*") {
        Write-Host "`n路径验证失败: 请确认注册表路径格式正确（示例: HKCU:\Software\MyApp）" -ForegroundColor Yellow
    }
    exit 1
}