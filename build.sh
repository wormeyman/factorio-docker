#!/bin/bash
set -eoux pipefail

if [[ -z ${1:-} ]] && [[ -n ${CI:-} ]]; then
  echo "Usage: ./build.sh \$VERSION_SHORT"
  exit 1
elif [[ $CI == true ]]; then
  VERSION_SHORT="$1"
else
  VERSION_SHORT=$(find . -maxdepth 1 -type d | sort | tail -1 | grep -o "[[0-9]].[[0-9]]*")
  EXTRA_TAG=latest
fi

cd "$VERSION_SHORT" || exit 1

VERSION=$(grep -oP '[0-9]+\.[0-9]+\.[0-9]+' Dockerfile | head -1)
DOCKER_REPO=factoriotools/factorio

if [[ $TRAVIS_PULL_REQUEST == true ]]; then
  TAGS="$DOCKER_REPO:$TRAVIS_PULL_REQUEST_SLUG"
else
  # we are either on master or on a tag build
  if [[ $TRAVIS_BRANCH == master ]] || [[ $TRAVIS_BRANCH == "$VERSION" ]]; then
    TAGS="$DOCKER_REPO:$VERSION -t $DOCKER_REPO:$VERSION_SHORT"
  # we are on an incremental build of a tag
  elif [[ $TRAVIS_BRANCH == "${VERSION%-*}" ]]; then
    TAGS="$DOCKER_REPO:$TRAVIS_BRANCH -t $DOCKER_REPO:$VERSION -t $DOCKER_REPO:$VERSION_SHORT"
  # we build a other branch than master
  elif [[ -n $TRAVIS_BRANCH ]]; then
    TAGS="$DOCKER_REPO:$TRAVIS_BRANCH"
  # we are not in CI and tag version and version short
  elif [[ $CI == "" ]]; then
    TAGS="$DOCKER_REPO:$VERSION -t $DOCKER_REPO:$VERSION_SHORT"
  fi

  if [[ -n $EXTRA_TAG ]]; then
    TAGS="$TAGS -t $DOCKER_REPO:$EXTRA_TAG"
  fi
fi

# shellcheck disable=SC2086
docker build . -t $TAGS
docker images

# only push when:
# latest changes where made in the folder corosponding to the version we build, we are on master and don#t build a PR.
if [[ $(dirname "$(git diff --name-only HEAD^)") =~ $VERSION_SHORT ]] && [[ $TRAVIS_BRANCH == master ]] && [[ $TRAVIS_PULL_REQUEST_BRANCH == "" ]] ||
  # we build a tag and we are not on master
  [[ $TRAVIS_BRANCH == "${VERSION%-*}" ]] && [[ $TRAVIS_PULL_REQUEST_BRANCH == "" ]] ||
  # we are not in CI
  [[ $CI == "" ]]; then

  if [[ $CI == true ]]; then
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  fi

  # push a tag on a branch other than master
  if [[ -n "$TRAVIS_BRANCH" ]] && [[ "$TRAVIS_BRANCH" != "${VERSION%-*}" ]] && [[ "$TRAVIS_BRANCH" != "master" ]]; then
    docker push "$DOCKER_REPO:$TRAVIS_BRANCH"
  fi

  # push an incremental tag
  if [[ "$TRAVIS_BRANCH" != "${VERSION%-*}" ]]; then
    docker push "$DOCKER_REPO:$TRAVIS_BRANCH"
  fi

  if [[ -n "$TRAVIS_TAG" ]] || [[ "$CI" == "" ]]; then
    docker push "$DOCKER_REPO:$VERSION"
    docker push "$DOCKER_REPO:$VERSION_SHORT"
  fi

  if [[ -n "$EXTRA_TAG" ]]; then
    docker push "$DOCKER_REPO:$EXTRA_TAG"
  fi

  curl -X POST https://hooks.microbadger.com/images/factoriotools/factorio/TmmKGNp8jKcFqZvcJhTCIAJVluw=
fi
