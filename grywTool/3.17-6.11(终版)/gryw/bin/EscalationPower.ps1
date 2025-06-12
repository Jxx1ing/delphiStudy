param (
    [Parameter(Mandatory=$true, HelpMessage="�����뵱ǰ�û��µ�ע���·����ʾ��: HKCU:\Software\MyApp��")]
    [string]$RegPath
)
 
try {
    # �Զ���ȡ��ǰ�û���
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
 
    # ��׼��·����ʽ
    $RegPath = $RegPath -replace '/','\'
 
    # �Զ�����·������������ڣ�
    if (-not (Test-Path $RegPath)) {
        Write-Host "���ڴ���ע���·��: $RegPath" -ForegroundColor Cyan
        New-Item -Path $RegPath -Force | Out-Null
    }
 
    # ��ȡACL����
    $acl = Get-Acl -Path $RegPath
 
    # ���õ�ǰ�û�Ϊ������
    Write-Host "������������Ȩ��: $currentUser" -ForegroundColor Cyan
    $acl.SetOwner([System.Security.Principal.NTAccount]$currentUser)
 
    # �������ʹ��򣨼̳�+��ȫ���ƣ�
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule(
        $currentUser,
        "FullControl",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )
 
    # Ӧ���¹��򣨱�������Ȩ�ޣ�
    $acl.AddAccessRule($rule)
 
    # д��Ȩ������
    Set-Acl -Path $RegPath -AclObject $acl -ErrorAction Stop
     
    # �ɹ�����
    Write-Host "`n[�����ɹ�]" -ForegroundColor Green
    Write-Host "·��: $RegPath" -ForegroundColor Green
    Write-Host "��ǰ�û��ѻ����ȫ����Ȩ��" -ForegroundColor Green
}
catch {
    Write-Host "`n[����ʧ��]" -ForegroundColor Red
    Write-Host "��������: $($_.Exception.GetType().Name)" -ForegroundColor Red
    Write-Host "��ϸ��Ϣ: $($_.Exception.Message)" -ForegroundColor Red
 
    # ����Դ�����
    if ($_ -like "*�ܾ�����*") {
        Write-Host "`n�����������: ����·���Ƿ����ڵ�ǰ�û������ֶ���������" -ForegroundColor Yellow
    }
    elseif ($_ -like "*�Ҳ���·��*") {
        Write-Host "`n·����֤ʧ��: ��ȷ��ע���·����ʽ��ȷ��ʾ��: HKCU:\Software\MyApp��" -ForegroundColor Yellow
    }
    exit 1
}