FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS installer
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
RUN apk add --no-cache \
  perl \
  tar \
  wget \
  xz \
  fontconfig
COPY ./texlive.profile ./
RUN ok=0; \
    for i in 1 2 3 4 5; do \
      if wget -nv --timeout=30 --tries=2 https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; then ok=1; break; fi; \
      echo "install-tl download attempt $i failed, retrying in 5s..."; \
      sleep 5; \
    done; \
    [ "$ok" = 1 ]
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

FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11
ENV PATH /usr/local/bin/texlive:$PATH
ENV TZ=Asia/Tokyo
WORKDIR /workdir
COPY --from=installer /usr/local/texlive /usr/local/texlive
RUN apk add --no-cache \
  bash \
  perl \
  git \
  openssh \
  npm \
  tzdata \
  wget \
  && cp /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo "$TZ" > /etc/timezone
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
WORKDIR /npm
COPY ["package.json", "package-lock.json", "/npm"]
RUN npm install /npm
WORKDIR /workdir
CMD ["bash"]
