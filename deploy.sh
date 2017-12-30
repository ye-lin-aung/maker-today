# Pull submodule
cd themes/hugo-universal-theme/
git pull
cd ../..

# Run Hugo
hugo

# Compress files
find public/ -type f \( -name '*.html' -o -name '*.js' -o -name '*.css' -o -name '*.xml' -o -name '*.svg' \) -exec gzip -v -k -f --best {} \;
