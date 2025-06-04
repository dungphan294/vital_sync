
FROM alpine AS base

WORKDIR /app

# RUN apk update && apk upgrade && \
#     apk add --no-cache python3 py3-pip sqlite sqlite-dev git curl tar

# RUN python3 -m venv vital_sync

# # Install FastAPI in the venv
# RUN source vital_sync/bin/activate && pip install "fastapi[standard]"

# # Install Flutter SDK (ARM64)
# RUN curl -o flutter.tar.xz -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.19.6-stable-arm64.tar.xz && \
#     tar -xf flutter.tar.xz -C /usr/local/ && \
#     rm flutter.tar.xz && \
#     ln -s /usr/local/flutter/bin/flutter /usr/local/bin/flutter

# (Optional) Set entrypoint or CMD here if needed
