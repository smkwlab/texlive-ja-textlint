FROM debian:12.11-slim@sha256:90522eeb7e5923ee2b871c639059537b30521272f10ca86fdbbbb2b75a8c40cd AS installer
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
RUN apt-get update && \
    apt-get install -y \
  perl \
  wget \
  xz-utils \
  fontconfig
COPY ./texlive.profile ./
RUN wget -nv https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf ./install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl --profile=texlive.profile
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
RUN tlmgr install \
  collection-fontsrecommended \
  collection-langjapanese \
  collection-latexextra \
  jlreq \
  luatexja \
  fontspec \
  unicode-math \
  newtx \
  stix2-otf \
  tex-gyre \
  haranoaji \
  lm \
  latexmk

FROM node:20-bookworm-slim
ENV PATH /usr/local/bin/texlive:/npm/node_modules/.bin:$PATH
WORKDIR /workdir
COPY --from=installer /usr/local/texlive /usr/local/texlive
RUN apt-get update \
  && apt-get install -y \
  perl \
  wget \
  git \
  ssh \
  && rm -rf /var/lib/apt/lists/*
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
WORKDIR /npm
COPY ["package.json", "package-lock.json", "/npm"]
RUN npm install /npm

# Debian version already has node user from base image (node:20-bookworm-slim)
# Ensure proper permissions for node user (backward compatibility)
RUN chown -R node:node /npm && \
    chown -R node:node /workdir

# Add texuser for dedicated LaTeX environment use (recommended)
RUN groupadd -g 1001 texuser && \
    useradd -u 1001 -g texuser -m -s /bin/bash texuser && \
    chown -R texuser:texuser /npm && \
    chown -R texuser:texuser /workdir

USER texuser
WORKDIR /workdir
CMD ["bash"]
