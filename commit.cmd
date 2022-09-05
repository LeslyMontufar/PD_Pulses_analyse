chcp 850
echo off
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
pause

