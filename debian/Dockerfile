FROM debian:13.1-slim@sha256:a347fd7510ee31a84387619a492ad6c8eb0af2f2682b916ff3e643eb076f925a AS installer
ENV PATH /usr/local/bin/texlive:$PATH
# Pin the TeXLive repository to a frozen historic tlnet-final mirror.
# This makes install-tl fetch the installer tarball, texlive.tlpdb and every
# package from a single stable host, eliminating the mirror.ctan.org
# double-random-redirect failures (#68/#70), and freezes the TeXLive version
# (2025) so image builds stay reproducible even after a new annual release.
ARG TL_REPO=https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2025/tlnet-final
WORKDIR /install-tl-unx
RUN apt-get update && \
    apt-get install -y \
  perl \
  wget \
  xz-utils \
  fontconfig
COPY ./texlive.profile ./
RUN ok=0; \
    for i in 1 2 3 4 5; do \
      if wget -nv --timeout=30 --tries=2 -O install-tl-unx.tar.gz ${TL_REPO}/install-tl-unx.tar.gz; then ok=1; break; fi; \
      echo "install-tl download attempt $i failed, retrying in 5s..."; \
      sleep 5; \
    done; \
    [ "$ok" = 1 ]
RUN tar -xzf ./install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl --repository=${TL_REPO} --profile=texlive.profile
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

FROM node:24-trixie-slim@sha256:05c08ce4291e9a58f59456a7985176defb12cdd42271f35ff81a3e167ea61d4c
ENV PATH /usr/local/bin/texlive:/npm/node_modules/.bin:$PATH
ENV TZ=Asia/Tokyo
WORKDIR /workdir
COPY --from=installer /usr/local/texlive /usr/local/texlive
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  perl \
  wget \
  git \
  ssh \
  tzdata \
  && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo "$TZ" > /etc/timezone \
  && rm -rf /var/lib/apt/lists/*
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
WORKDIR /npm
COPY ["package.json", "package-lock.json", "/npm"]
RUN npm install /npm
WORKDIR /workdir
CMD ["bash"]
