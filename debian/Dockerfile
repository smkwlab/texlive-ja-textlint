FROM debian:13.5-slim@sha256:28de0877c2189802884ccd20f15ee41c203573bd87bb6b883f5f46362d24c5c2 AS installer
ENV PATH /usr/local/bin/texlive:$PATH
# Pin the TeXLive repository to a frozen historic tlnet-final snapshot.
# Serving the installer tarball, texlive.tlpdb and every package from one host
# eliminates the mirror.ctan.org double-random-redirect failures (#68/#70), and
# the frozen 2025 snapshot keeps builds reproducible across annual releases.
# One host is a single point of failure though (#95), so try the TUG historic
# mirrors in turn; whichever serves the tarball also serves install-tl.
# Set TL_REPO to a full tlnet-final URL to bypass the list entirely.
ARG TL_REPO=
ARG TL_MIRRORS="https://ftp.tu-chemnitz.de/pub/tug/historic https://texlive.info/historic https://pi.kwarc.info/historic https://ftp.math.utah.edu/pub/tex/historic"
ARG TL_SNAPSHOT=systems/texlive/2025/tlnet-final
WORKDIR /install-tl-unx
RUN apt-get update && \
    apt-get install -y \
  perl \
  wget \
  xz-utils \
  fontconfig
COPY ./texlive.profile ./
# Bounded worst case: two passes over the list, one short attempt per mirror
# (~25s against a blackholed host), so a total outage fails in minutes.
RUN set -e; \
    if [ -n "${TL_REPO}" ]; then \
      candidates="${TL_REPO}"; \
    else \
      candidates=""; \
      for mirror in ${TL_MIRRORS}; do candidates="${candidates} ${mirror}/${TL_SNAPSHOT}"; done; \
    fi; \
    for pass in 1 2; do \
      for repo in ${candidates}; do \
        echo "Fetching install-tl from ${repo} (pass ${pass})"; \
        if wget -nv --timeout=20 --tries=1 -O install-tl-unx.tar.gz "${repo}/install-tl-unx.tar.gz"; then \
          echo "${repo}" > /tl-repo; \
          break 2; \
        fi; \
        echo "mirror unavailable: ${repo}"; \
      done; \
      sleep 5; \
    done; \
    if [ ! -s /tl-repo ]; then echo "no usable TeXLive mirror"; exit 1; fi; \
    echo "Using TeXLive repository: $(cat /tl-repo)"
RUN tar -xzf ./install-tl-unx.tar.gz --strip-components=1
RUN ./install-tl --repository="$(cat /tl-repo)" --profile=texlive.profile
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

FROM node:24-trixie-slim@sha256:366fdef91728b1b7fa18c84fba63b6e79ed77b7e10cc206878e9705da4d7b169
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
RUN npm ci --no-audit
WORKDIR /workdir
CMD ["bash"]
