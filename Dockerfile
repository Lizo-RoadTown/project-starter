# Dockerfile — runs the project-starter scaffolder in a container.
#
# Build once:
#   docker build -t project-starter .
#
# Scaffold a new project into ./out:
#   docker run --rm -v "$(pwd)/out:/out" project-starter \
#     --type ui-app --name my-new-site --target /out \
#     --frontend "Next.js 16" --backend "FastAPI"
#
# The new project ends up at ./out/my-new-site/ on your host.

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
      bash \
      ca-certificates \
      git \
      rsync \
      sed \
      findutils \
      coreutils \
    && rm -rf /var/lib/apt/lists/*

# Git needs an identity for the initial commit. These are overridable at runtime via
#   -e GIT_AUTHOR_NAME=... -e GIT_AUTHOR_EMAIL=...
ENV GIT_AUTHOR_NAME="project-starter" \
    GIT_AUTHOR_EMAIL="project-starter@local" \
    GIT_COMMITTER_NAME="project-starter" \
    GIT_COMMITTER_EMAIL="project-starter@local"

WORKDIR /starter
COPY . /starter

RUN chmod +x /starter/scripts/new-project.sh \
 && git config --global init.defaultBranch main \
 && git config --global user.name  "${GIT_AUTHOR_NAME}" \
 && git config --global user.email "${GIT_AUTHOR_EMAIL}" \
 && git config --global --add safe.directory '*'

ENTRYPOINT ["/starter/scripts/new-project.sh"]
CMD ["--help"]
