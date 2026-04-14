# Orion & Yamin — Corrida da Aventura

Jogo 2D em **HTML5 Canvas** inspirado em corrida infinita, com seleção de personagem, clima dinâmico, fases e escolhas de habilidades.

## Como rodar

Este projeto é estático (não precisa build).

### Opção 1: servidor local (recomendado)

Na raiz do projeto, sirva os arquivos com qualquer servidor HTTP.

Exemplos:

- `python3 -m http.server 8000`
- `npx serve .`

Depois abra:

- `http://localhost:8000`

### Opção 2: abrir o HTML direto

Funciona em muitos casos abrindo o `index.html`, mas alguns navegadores podem bloquear áudio/carregamento de assets. Se algo falhar, use um servidor local.

## Controles

- **Toque / Clique**: pular
- **Espaço / Seta para cima**: pular

Na tela de seleção:

- Toque nos cards para escolher o personagem
- Use o botão **COMEÇAR A AVENTURA** para iniciar

Na tela de habilidades:

- Toque em uma das 3 opções para ativar o bônus

## Personagens

- Orion (sprite1)
- Yamin (sprite2)

Cada um possui variações/fantasias selecionáveis.

## Pontuação e recorde

- **Score**: sua pontuação atual
- **Record**: melhor pontuação registrada e o personagem que chegou mais longe
- O botão **Zerar Recorde** limpa os dados de recorde salvos.

Os dados são persistidos via `localStorage`.

## Fases e dificuldade

- A cada **10 pontos**, o jogo avança de fase e ajusta dificuldade (velocidade/spawn).

## Clima dinâmico

Em cada partida o clima pode variar aleatoriamente:

- Dia
- Noite
- Nevoeiro
- Chuva
- Tempestade (com relâmpagos)

A chuva possui **efeito visual** no canvas e **efeito sonoro**.

## Habilidades (a cada 10 obstáculos)

Ao atingir o marco, aparece uma tela para escolher **1** habilidade entre 3:

- **Invencível**: sem dano por **5 segundos**
- **Pulo alto**: pulo mais alto por **5 segundos**
- **Mais lento**: reduz a velocidade por **5 segundos**

Regras:

- Após usar uma habilidade, ela entra em **cooldown de 20 obstáculos**
- Cada habilidade tem **efeito visual** no personagem e **som** ao ativar

## Estrutura

- `index.html`: jogo completo (canvas, lógica, UI e áudio)
- `sprite.png`: sprites do Orion
- `sprite2.png`: sprites da Yamin
- `assets/`: imagens/sons auxiliares

## Build APK Android

### Opção 1: GitHub Actions (recomendado)

Ao fazer `push` para `main`/`master`, o workflow `.github/workflows/build-apk.yml` gera o APK automaticamente.

1. Vá em **Actions** no seu repositório GitHub
2. Aguarde o job terminar
3. Baixe o artefato **app-debug-apk** na seção *Artifacts*

### Opção 2: Docker local

```bash
# Build da imagem (primeira vez demora ~10 min — baixa SDK Android)
docker build -t oriondino-apk .

# Gerar APK (fica na pasta ./output/)
mkdir -p output
docker run --rm -v "$PWD/output:/output" oriondino-apk
```

O APK estará em `output/apk/debug/app-debug.apk`.

### Opção 3: Máquina local (Node + Android Studio)

```bash
npm install
npx cap add android
npx cap sync android
cd android && ./gradlew assembleDebug
```

APK em `android/app/build/outputs/apk/debug/app-debug.apk`.

> **Instalar no Android:** copie o APK para o celular e abra. Pode ser necessário habilitar *"Instalar de fontes desconhecidas"* nas configurações.

## Créditos

Projeto criado e iterado junto com melhorias de UI/UX, áudio e gameplay.
