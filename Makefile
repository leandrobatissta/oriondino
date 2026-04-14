# ─────────────────────────────────────────────────────────────
# MAKEFILE - ORIONDINO (HTML5 Game → Android APK via Docker no servidor)
# ─────────────────────────────────────────────────────────────

# Servidor remoto (mesmo do padrão dos outros projetos)
SERVIDOR    = lucky@192.168.15.78
PATH_DEV    = /home/lucky/dev
PATH_REMOTE = $(PATH_DEV)/oriondino

# Local onde o APK será salvo após pull
APK_DIR     = apk
APK_FILE    = app-debug.apk

# Git
GIT_REMOTE  = origin
GIT_BRANCH  = main

# Docker image name (no servidor)
DOCKER_IMG  = oriondino-apk

.PHONY: help cycle-android-apk deploy build-remote pull-apk git-push clean

# ============================
# HELP
# ============================
help:
	@echo ""
	@echo "🚀 COMANDOS DISPONÍVEIS - ORIONDINO"
	@echo ""
	@echo "   make cycle-android-apk  🔄 Fluxo completo: envia código, compila APK no servidor e puxa"
	@echo "   make deploy         📤 Envia código para o servidor remoto (rsync)"
	@echo "   make build-remote   🔨 Compila APK no servidor via Docker"
	@echo "   make pull-apk       📥 Baixa APK do servidor para $(APK_DIR)/"
	@echo "   make git-push       📤 Sobe código para o GitHub (branch $(GIT_BRANCH))"
	@echo "   make clean          🧹 Limpa APK local e build remoto"
	@echo ""

# ============================
# CYCLE — fluxo completo
# ============================
cycle-android-apk:
	@echo ""
	@echo "🔄 =============================="
	@echo "🔄  CICLO COMPLETO - ORIONDINO"
	@echo "🔄 =============================="
	@echo ""
	@echo "📤 1/4: Enviando código para o servidor remoto..."
	@$(MAKE) deploy
	@echo ""
	@echo "🔨 2/4: Compilando APK no servidor via Docker..."
	@$(MAKE) build-remote
	@echo ""
	@echo "📥 3/4: Baixando APK para $(APK_DIR)/..."
	@$(MAKE) pull-apk
	@echo ""
	@echo "📤 4/4: Subindo código para o GitHub..."
	@$(MAKE) git-push

	@echo ""
	@echo "✅ =============================="
	@echo "✅  CICLO CONCLUÍDO!"
	@echo "✅ =============================="
	@echo ""
	@echo "   APK disponível em: $(APK_DIR)/$(APK_FILE)"
	@echo ""
	@echo "📱 Para instalar: copie o APK para o Android e abra o arquivo."
	@echo "   (Habilite 'Fontes desconhecidas' nas configurações se necessário)"
	@echo ""

# ============================
# DEPLOY — envia código para o servidor
# ============================
deploy:
	@echo "📤 Enviando código para $(SERVIDOR):$(PATH_REMOTE)..."
	@sshpass -p 'lucky' ssh $(SERVIDOR) "mkdir -p $(PATH_REMOTE)"
	@sshpass -p 'lucky' rsync -av --progress \
		--exclude='.git' \
		--exclude='$(APK_DIR)' \
		--exclude='node_modules' \
		--exclude='android' \
		./ $(SERVIDOR):$(PATH_REMOTE)/
	@echo "✅ Código enviado!"

# ============================
# BUILD — compila APK no servidor via Docker
# ============================
build-remote:
	@echo "🔨 Construindo imagem Docker no servidor..."
	@sshpass -p 'lucky' ssh $(SERVIDOR) "cd $(PATH_REMOTE) && docker build -t $(DOCKER_IMG) ."
	@echo "🔨 Rodando container para gerar APK..."
	@sshpass -p 'lucky' ssh $(SERVIDOR) "mkdir -p $(PATH_REMOTE)/output && docker run --rm -v $(PATH_REMOTE)/output:/output $(DOCKER_IMG)"
	@echo "✅ APK gerado no servidor em: $(PATH_REMOTE)/output/"

# ============================
# PULL APK — baixa APK do servidor
# ============================
pull-apk:
	@echo "📥 Baixando APK do servidor..."
	@mkdir -p $(APK_DIR)
	@sshpass -p 'lucky' rsync -av $(SERVIDOR):$(PATH_REMOTE)/output/outputs/apk/debug/$(APK_FILE) $(APK_DIR)/$(APK_FILE)
	@echo "✅ APK salvo em: $(APK_DIR)/$(APK_FILE)"
	@ls -lh $(APK_DIR)/$(APK_FILE)

# ============================
# GIT — sobe código para o GitHub
# ============================
git-push:
	@echo "📤 Subindo código para o GitHub..."
	@git add -A
	@git commit -m "🔄 Auto-commit oriondino - $$(date '+%Y-%m-%d %H:%M:%S')" || echo "   ℹ️  Nenhuma mudança para commitar"
	@git push $(GIT_REMOTE) $(GIT_BRANCH)
	@echo "✅ Git push concluído!"

# ============================
# CLEAN
# ============================
clean:
	@echo "🧹 Limpando APK local..."
	@rm -rf $(APK_DIR)/
	@echo "🧹 Limpando build no servidor..."
	@sshpass -p 'lucky' ssh $(SERVIDOR) "cd $(PATH_REMOTE) && rm -rf output/ && docker rmi $(DOCKER_IMG) 2>/dev/null || true"
	@echo "✅ Limpeza concluída!"
