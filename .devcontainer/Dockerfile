# syntax=docker/dockerfile:1

########################
# === Base Stage ===
########################
FROM python:3.10-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    CC=gcc \
    FC=gfortran \
    USE_AEC=0 \
    USE_NETCDF3=0 \
    USE_NETCDF4=0

WORKDIR /app

# System deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl bash build-essential musl-dev gfortran ffmpeg make \
      libjpeg-dev zlib1g-dev libpng-dev git git-lfs procps && \
    rm -rf /var/lib/apt/lists/*

RUN git lfs install

# Build and install wgrib2 (no AEC/OpenJPEG/NetCDF)
RUN set -eux; \
    curl -O https://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz && \
    tar -xvzf wgrib2.tgz && \
    cd grib2 && \
    make USE_AEC=0 USE_OPENJPEG=0 USE_NETCDF3=0 USE_NETCDF4=0 && \
    cp wgrib2/wgrib2 /usr/local/bin/ && \
    cd .. && rm -rf grib2 wgrib2.tgz

# Python tooling
RUN pip install --upgrade pip
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:${PATH}"

# Bring in your whole workspace (downstream)
COPY . /app

# Conditionally install deps if pyproject exists
RUN bash -lc 'if [ -f pyproject.toml ]; then poetry install --no-root --with dev --all-extras || true; else echo "No pyproject.toml; skipping poetry install"; fi'

########################
# === Dev Stage ===
########################
FROM base AS dev

# Node 18 + Codex CLI
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    npm install -g @openai/codex

# Ensure editable install if pyproject exists
RUN bash -lc 'if [ -f pyproject.toml ]; then poetry install --with dev --all-extras || true; fi'

# Healthcheck
HEALTHCHECK --interval=10s --timeout=3s --start-period=10s --retries=5 \
  CMD sh -c "curl -fsS http://localhost:${ZYRA_API_PORT:-${DATAVIZHUB_API_PORT:-8000}}/ready || exit 1"

# ---- Hybrid helper (no heredocs, no chmod) ----
COPY --chmod=0755 bin/new-branch.fallback.sh /opt/devtools/new-branch.sh
COPY --chmod=0755 bin/new-branch.wrapper.sh  /usr/local/bin/new-branch.sh

CMD ["sleep", "infinity"]
