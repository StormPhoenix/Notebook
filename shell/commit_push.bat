git add ./*

set now=%date% %time%
echo "Time:" %now%

git commit -m "Sync files at: %now%"
git push