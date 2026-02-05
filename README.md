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

## Créditos

Projeto criado e iterado junto com melhorias de UI/UX, áudio e gameplay.
