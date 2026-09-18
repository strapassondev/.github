# Perfil da organização `strapassondev` no GitHub

O repositório será `strapassondev/.github`, **público**. Tudo o que estiver em `profile/` aparece na página da org. Ainda **não foi publicado**.

## Settings > Profile (github.com/organizations/strapassondev/settings/profile)

| Campo | Valor |
|---|---|
| Organization display name | `Pedro Strapasson` (hoje está "Pedro Strapasson — Desenvolvimento de Sistemas") |
| Description (até 160 caracteres, este tem 136) | `Tecnologia sob medida: sistemas, automações e IA para empresas, a partir da demanda de cada uma. Quem conversa com você é quem constrói.` |
| URL | `https://strapasson.dev` |
| Email (público) | `pedro@strapasson.dev` |
| Location | `Brasil` |
| Social accounts / Twitter | em branco (a marca não usa redes) |
| Profile picture | `C:\psds\github-perfil\avatar-org.png` (500×500). O GitHub não tem API para isso: o envio é pela tela, em "Upload new picture". |

## Publicação (PowerShell)

O token atual do `gh` não tem a permissão `admin:org`, que o passo 1 precisa. Rode este comando uma vez antes. Ele abre o navegador para autorizar.

```powershell
gh auth refresh -h github.com -s admin:org
```

**1. Dados do perfil da org**

```powershell
gh api -X PATCH orgs/strapassondev `
  -f name="Pedro Strapasson" `
  -f description="Tecnologia sob medida: sistemas, automações e IA para empresas, a partir da demanda de cada uma. Quem conversa com você é quem constrói." `
  -f blog="https://strapasson.dev" `
  -f email="pedro@strapasson.dev" `
  -f location="Brasil"
```

**2. Repositório público `.github`, com o `profile/`**

Vão só o README e os dois banners. `_src`, `_preview`, o avatar e este arquivo ficam fora.

```powershell
$tmp = Join-Path $env:TEMP "strapassondev-github"
if (Test-Path $tmp) { Remove-Item -Recurse -Force $tmp -Confirm:$false }
New-Item -ItemType Directory $tmp | Out-Null
Copy-Item -Recurse C:\psds\github-perfil\profile $tmp
Set-Location $tmp
git init -b main
git add profile
git commit -m "Add organization profile"
gh repo create strapassondev/.github --public --description "Perfil da organização Pedro Strapasson" --source . --push
```

**3. Conferir:** abra https://github.com/strapassondev nos temas claro e escuro. Os banners apontam para `raw.githubusercontent.com/strapassondev/.github/HEAD/profile/`, então só aparecem depois do push.

## Refazer as imagens e a prévia

`sh C:/psds/github-perfil/_src/build.sh` gera de novo:
- os banners (`_src/banner.html`);
- o avatar (reduzido de `brand-v2/marca/social/avatar-escuro.png`);
- a imitação da página do GitHub em `_preview/`: claro, escuro e celular.

O corpo do README na prévia vem do próprio GitHub (`gh api markdown`).

WhatsApp ficou fora do README de propósito. A página é pública e indexada, e o número hoje é pessoal. Quando houver um WhatsApp comercial, acrescente em "Contato": `· [WhatsApp +55 41 98873-6556](https://wa.me/5541988736556)`.
