#!/bin/bash
set -eoux pipefail

if [[ -z ${1:-} && -n ${CI:-} ]]; then
  echo 'Usage: ./build.sh VERSION_SHORT'
  exit 1
elif [[ ${CI:-} == true || -n ${1:-} ]]; then
  VERSION_SHORT="$1"
else
  VERSION_SHORT=$(find . -maxdepth 1 -type d | sort | tail -1 | grep -o "[[0-9]].[[0-9]]*")
  EXTRA_TAG=latest
fi

cd "$VERSION_SHORT" || exit 1

VERSION=$(grep -oP '[0-9]+\.[0-9]+\.[0-9]+' Dockerfile | head -1)
DOCKER_REPO=factoriotools/factorio

if [[ ${TRAVIS_PULL_REQUEST:-} == true ]]; then
  TAGS="$DOCKER_REPO:$TRAVIS_PULL_REQUEST_SLUG"
else
  if [[ -n ${CI:-} ]]; then
    # we are either on master or on a tag build
    if [[ ${TRAVIS_BRANCH:-} == master || ${TRAVIS_BRANCH:-} == "$VERSION" ]]; then
      TAGS="-t $DOCKER_REPO:$VERSION -t $DOCKER_REPO:$VERSION_SHORT"
    # we are on an incremental build of a tag
    elif [[ $VERSION == "${TRAVIS_BRANCH%-*}" ]]; then
      TAGS="-t $DOCKER_REPO:$TRAVIS_BRANCH -t $DOCKER_REPO:$VERSION -t $DOCKER_REPO:$VERSION_SHORT"
    # we build a other branch than master and exclude dependabot branches from tags cause the / is not supported by docker
    elif [[ -n ${TRAVIS_BRANCH:-} && ! $TRAVIS_BRANCH =~ "/" ]]; then
      TAGS="-t $DOCKER_REPO:$TRAVIS_BRANCH"
    fi
  else
    # we are not in CI and tag version and version short
    TAGS="-t $DOCKER_REPO:$VERSION -t $DOCKER_REPO:$VERSION_SHORT"
  fi

  if [[ -n ${EXTRA_TAG:-} ]]; then
    IFS=","
    for TAG in $EXTRA_TAG; do
      TAGS+=" -t $DOCKER_REPO:$TAG"
    done
  fi

  if [[ ${STABLE:-} == "$VERSION" ]]; then
    TAGS+=" -t $DOCKER_REPO:stable"
  fi
fi

# shellcheck disable=SC2068
eval docker build . ${TAGS[@]:-}
docker images

# remove -1 from incremental tag
# eg before: 0.18.24-1, after 0.18.24
if [[ ${TRAVIS_BRANCH:-} ]]; then
  TRAVIS_BRANCH_VERSION=${TRAVIS_BRANCH%-*}
fi

# only push when:
# or we build a tag and we don't build a PR
if [[ $VERSION == "${TRAVIS_BRANCH_VERSION:-}" && ${TRAVIS_PULL_REQUEST_BRANCH:-} == "" ]] ||
  # or we are not in CI
  [[ -z ${CI:-} ]]; then

  if [[ ${CI:-} == true ]]; then
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  fi

  # push a tag on a branch other than master except dependabot branches cause docker does not support /
  if [[ -n ${TRAVIS_BRANCH:-} && $VERSION != "${TRAVIS_BRANCH_VERSION:-}" && ${TRAVIS_BRANCH:-} != "master" && ! ${TRAVIS_BRANCH:-} =~ "/" ]]; then
    docker push "$DOCKER_REPO:$TRAVIS_BRANCH"
  fi

  # push an incremental tag
  # eg 0.18.24-1
  if [[ $VERSION == "${TRAVIS_BRANCH_VERSION:-}" ]]; then
    docker push "$DOCKER_REPO:$TRAVIS_BRANCH"
  fi

  # only push on tags or when manually running the script
  if [[ -n ${TRAVIS_TAG:-} || -z ${CI:-} ]]; then
    docker push "$DOCKER_REPO:$VERSION"
    docker push "$DOCKER_REPO:$VERSION_SHORT"
  fi

  if [[ -n ${EXTRA_TAG:-} ]]; then
    IFS=","
    for TAG in $EXTRA_TAG; do
      docker push "$DOCKER_REPO:$TAG"
    done
  fi

  if [[ ${STABLE:-} == "$VERSION" ]]; then
    docker push "$DOCKER_REPO:stable"
  fi

  curl -X POST https://hooks.microbadger.com/images/factoriotools/factorio/TmmKGNp8jKcFqZvcJhTCIAJVluw=
fi
