#!/bin/bash
set -e

usage() {
  cat <<EOF
사용법: $0 [sync|update|branch <branch-name>]
  sync             : 서브모듈 원격 정보 동기화만 수행
  update           : 서브모듈을 원격 최신 커밋으로 리셋 및 업데이트
  branch <name>    : 모든 서브모듈을 지정한 브랜치로 체크아웃하고 최신 상태로 동기화
EOF
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

case "$1" in
  sync)
    echo "[1/1] 서브모듈 원격 정보 동기화..."
    git submodule sync
    echo "서브모듈 원격 정보 동기화 완료!"
    ;;
  update)
    echo "[1/1] 서브모듈 최신 커밋으로 리셋 및 업데이트..."
    git submodule update --init --recursive --remote
    echo "서브모듈 최신 커밋 리셋 완료!"
    ;;
  branch)
    if [ -z "$2" ]; then
      echo "Error: 브랜치 이름을 입력하세요."
      usage
    fi
    BRANCH="$2"
    git submodule foreach --quiet '
      echo "\n--- Updating $name to branch '"$BRANCH"' ---"
      git fetch origin
      if git show-ref --verify --quiet refs/remotes/origin/'"$BRANCH"'; then
        if git show-ref --verify --quiet refs/heads/'"$BRANCH"'; then
          git checkout '"$BRANCH"'
        else
          git checkout -b '"$BRANCH"' origin/'"$BRANCH"'
        fi
        git pull origin '"$BRANCH"'
      else
        echo "  [!] origin/'"$BRANCH"' 브랜치가 없습니다. 건너뜁니다."
      fi
    '
    echo "--- Staging submodule changes in superproject ---"
    for path in $(git config --file .gitmodules --get-regexp path | awk '{print $2}'); do
      git add "$path"
    done
    echo "Done. now commit/push to the parent repository."
    ;;
  *)
    usage
    ;;
esac