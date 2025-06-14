FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS installer
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /install-tl-unx
RUN apk add --no-cache \
  perl \
  tar \
  wget \
  xz \
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

FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715
ENV PATH /usr/local/bin/texlive:$PATH
WORKDIR /workdir
COPY --from=installer /usr/local/texlive /usr/local/texlive
RUN apk add --no-cache \
  bash \
  perl \
  git \
  openssh \
  npm \
  wget
RUN ln -sf /usr/local/texlive/*/bin/* /usr/local/bin/texlive
WORKDIR /npm
COPY ["package.json", "package-lock.json", "/npm"]
RUN npm install /npm
WORKDIR /workdir
CMD ["bash"]
