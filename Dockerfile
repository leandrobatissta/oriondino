# ─────────────────────────────────────────────────────────────
# Dockerfile — Build APK (debug) do Oriondino
# Uso:
#   docker build -t oriondino-apk .
#   docker run --rm -v "$PWD/output:/app/android/app/build/outputs" oriondino-apk
# O APK ficará em ./output/apk/debug/app-debug.apk
# ─────────────────────────────────────────────────────────────

FROM node:20-bullseye

# ── 1. Dependências de sistema ───────────────────────────────
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# ── 2. Android SDK ───────────────────────────────────────────
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /tmp/cmdtools.zip && \
    unzip -q /tmp/cmdtools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdtools.zip

RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# ── 3. Código do projeto ─────────────────────────────────────
WORKDIR /app
COPY . .

# ── 4. Instalar dependências Node e gerar projeto Android ────
RUN npm install

# ── 4b. Montar pasta www com os arquivos do jogo ─────────────
RUN mkdir -p www && \
    cp index.html www/ && \
    cp -r assets www/ && \
    cp -r sounds www/ && \
    cp *.png www/ 2>/dev/null || true && \
    cp bonus_surf.html www/ 2>/dev/null || true && \
    cp bonus_car.html www/ 2>/dev/null || true && \
    cp return_from_surf.html www/ 2>/dev/null || true

RUN npx cap add android && npx cap sync android

# ── 4c. Instalar ImageMagick e gerar ícones Android ──────────
RUN apt-get update && apt-get install -y imagemagick && rm -rf /var/lib/apt/lists/*

RUN for dir in \
      android/app/src/main/res/mipmap-mdpi \
      android/app/src/main/res/mipmap-hdpi \
      android/app/src/main/res/mipmap-xhdpi \
      android/app/src/main/res/mipmap-xxhdpi \
      android/app/src/main/res/mipmap-xxxhdpi; do \
      mkdir -p $dir; \
    done && \
    convert assets/icon.png -resize 48x48   android/app/src/main/res/mipmap-mdpi/ic_launcher.png && \
    convert assets/icon.png -resize 72x72   android/app/src/main/res/mipmap-hdpi/ic_launcher.png && \
    convert assets/icon.png -resize 96x96   android/app/src/main/res/mipmap-xhdpi/ic_launcher.png && \
    convert assets/icon.png -resize 144x144 android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png && \
    convert assets/icon.png -resize 192x192 android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png && \
    convert assets/icon.png -resize 48x48   android/app/src/main/res/mipmap-mdpi/ic_launcher_round.png && \
    convert assets/icon.png -resize 72x72   android/app/src/main/res/mipmap-hdpi/ic_launcher_round.png && \
    convert assets/icon.png -resize 96x96   android/app/src/main/res/mipmap-xhdpi/ic_launcher_round.png && \
    convert assets/icon.png -resize 144x144 android/app/src/main/res/mipmap-xxhdpi/ic_launcher_round.png && \
    convert assets/icon.png -resize 192x192 android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png

# ── 5. Build do APK debug ────────────────────────────────────
RUN cd android && chmod +x gradlew && ./gradlew assembleDebug --no-daemon

# ── 6. Copiar APK para /output (montado via volume) ──────────
CMD cp -r /app/android/app/build/outputs /output && \
    echo "✅ APK gerado em /output/apk/debug/app-debug.apk"
