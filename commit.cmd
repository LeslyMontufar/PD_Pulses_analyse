::@Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Nls\CodePage" /v OEMCP /t Reg_SZ /D 850 /f

@echo off
echo "Sincronizando"
git pull
echo "Adicionando modificações"
git add .
git status

set /p id=Modificacoes:
echo "criando commit"
git commit -m "%id%"

echo "Enviando"
git push
@pause

