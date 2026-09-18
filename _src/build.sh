#!/bin/sh
# Gera tudo do perfil da org: banners (claro/escuro), avatar 500x500 e a imitação da página do GitHub (claro/escuro).
# O README é renderizado pelo próprio GitHub (gh api markdown), então o mock mostra o HTML real.
set -e
cd "$(dirname "$0")"
SHOT=C:/psds/brand-v2/shot.mjs

# banners: o Edge headless daqui roda em modo escuro; o claro força data-theme="light" no <html>
sed 's/<html lang="pt-BR" data-theme="dark">/<html lang="pt-BR" data-theme="light">/' banner.html > _banner-claro.html
node $SHOT banner.html ../profile/banner-escuro.png 1280 320
node $SHOT _banner-claro.html ../profile/banner-claro.png 1280 320
rm _banner-claro.html

# avatar da org: o avatar oficial (símbolo sobre Grafite), reduzido
magick C:/psds/brand-v2/marca/social/avatar-escuro.png -resize 500x500 -strip ../avatar-org.png

# mock do GitHub
gh api -X POST markdown -f mode=gfm -f context=strapassondev/.github -F text=@../profile/README.md > readme-gh.html
local_imgs='s#https://raw.githubusercontent.com/strapassondev/.github/HEAD/profile/#../profile/#g'
# claro: sem o <source> escuro (senão o Edge em modo escuro escolheria a versão escura)
sed -e "$local_imgs" -e '/<source media="(prefers-color-scheme: dark)"/d' readme-gh.html > _body-claro.html
sed -e "$local_imgs" readme-gh.html > _body-escuro.html
sed -e '/<!--README-->/{r _body-claro.html' -e 'd}' mock-github.html > _mock-claro.html
sed -e '/<!--README-->/{r _body-escuro.html' -e 'd}' -e 's/<html lang="pt-BR" data-theme="light">/<html lang="pt-BR" data-theme="dark">/' mock-github.html > _mock-escuro.html
node $SHOT _mock-claro.html ../_preview/github-claro.png 1280 1400
node $SHOT _mock-escuro.html ../_preview/github-escuro.png 1280 1400
# celular: o README cai para ~360 px de largura
sed -e 's/<html lang="pt-BR" data-theme="dark">/<html lang="pt-BR" data-theme="dark" class="celular">/' _mock-escuro.html > _mock-celular.html
node $SHOT _mock-celular.html ../_preview/github-celular-escuro.png 390 1700
rm _body-claro.html _body-escuro.html _mock-claro.html _mock-escuro.html _mock-celular.html
