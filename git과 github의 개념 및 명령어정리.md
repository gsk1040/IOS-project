# **1. Git 기본 개념**

### **1.1 버전 관리의 필요성**

### **코드 관리에서 버전 관리 시스템의 역할**

버전 관리 시스템(VCS, Version Control System)은 코드와 프로젝트의 변경 사항을 추적하고 관리하는 도구입니다. 이를 통해 다음과 같은 이점을 제공합니다:

- **변경 사항 추적:** 프로젝트의 모든 변경 내역을 기록하여 이전 버전으로 되돌아가거나 변경 사항을 비교할 수 있습니다.
- **협업 지원:** 여러 개발자가 동일한 프로젝트에서 충돌 없이 동시에 작업할 수 있도록 지원합니다.
- **백업 역할:** 로컬 저장소와 원격 저장소에 데이터를 저장해 프로젝트 데이터를 안전하게 보호합니다.
- **효율적인 문제 해결:** 특정 버전에서 발생한 문제를 빠르게 파악하고 수정할 수 있습니다.

### **로컬 저장소와 원격 저장소의 개념**

- **로컬 저장소(Local Repository):**
각 개발자의 컴퓨터에 저장된 프로젝트 복사본으로, 인터넷 연결 없이도 작업이 가능합니다.
- **원격 저장소(Remote Repository):**
GitHub, GitLab, Bitbucket 같은 서버에 호스팅된 저장소로, 여러 사용자가 프로젝트를 공유하고 협업할 수 있도록 합니다.

로컬 저장소와 원격 저장소의 상호작용은 다음 과정을 따릅니다:

- **Pull:** 원격 저장소의 최신 데이터를 로컬 저장소로 가져오기
- **Push:** 로컬 저장소의 변경 사항을 원격 저장소에 반영하기

### **Git 이전의 버전 관리 도구와의 차이점**

Git이 등장하기 전, 주로 **CVS**(Concurrent Versions System)와 **SVN**(Apache Subversion) 같은 중앙집중형 버전 관리 시스템(CVCS)이 사용되었습니다.

- **CVS, SVN의 한계:**
    - 중앙 서버에 의존적이어서 서버 장애 시 모든 작업 중단.
    - 변경 사항을 서버에 직접 기록하며, 작업 속도가 느림.
- **Git의 개선점:**
    - 분산형 구조로, 로컬에서도 모든 작업 가능.
    - 스냅샷 기반 저장 방식으로 더 빠르고 효율적.

---

### **1.2 Git의 원리**

### **Git의 분산형 버전 관리 시스템(DVCS) 구조 이해**

Git은 분산형 버전 관리 시스템으로, 모든 개발자가 프로젝트의 전체 기록을 자신의 로컬 저장소에 복사해 작업합니다.

- **장점:**
    - 인터넷 없이도 히스토리 검색, 수정 작업 가능.
    - 중앙 서버에 문제가 생겨도 로컬 저장소로 복구 가능.
- **구조:**
    - 로컬 저장소와 원격 저장소가 독립적으로 존재하며, 필요에 따라 데이터 동기화.

### **스냅샷 방식과 변경점 추적 방식 비교**

- **변경점 추적 방식(Diff Tracking):**
    - CVS와 SVN이 사용하는 방식.
    - 각 파일의 변경 내역(차이점)만 기록.
    - 파일이 많아지면 성능 저하.
- **스냅샷 방식(Snapshot):**
    - Git은 프로젝트 전체 상태를 스냅샷으로 저장.
    - 변경 사항이 없으면 이전 스냅샷을 참조하여 저장 공간 효율화.
    - 빠른 속도와 데이터 복원 용이성 제공.

### **Git의 주요 저장소 구조**

Git은 세 가지 주요 저장소로 구성되어 있습니다:

1. **Working Directory (작업 디렉토리):**
    - 실제 파일 작업이 이루어지는 공간.
    - 파일을 추가, 수정, 삭제하면 이곳에서 반영됩니다.
2. **Staging Area (스테이징 영역):**
    - 커밋 전 변경 사항을 임시로 저장하는 공간.
    - `git add` 명령어를 사용해 변경 사항을 추가.
    - 커밋하기 전에 어떤 파일을 포함할지 선택 가능.
3. **Repository (저장소):**
    - 커밋된 모든 변경 사항의 스냅샷이 저장되는 공간.
    - 로컬 저장소와 원격 저장소로 나뉘며, `git commit`으로 스테이징 영역의 데이터를 저장.

---

### **요약**

- 버전 관리 시스템은 협업, 변경 사항 추적, 문제 해결을 효과적으로 지원하며, Git은 이전 VCS의 한계를 극복한 분산형 도구입니다.
- Git의 스냅샷 기반 저장 방식은 빠른 작업 속도와 효율성을 제공하며, Working Directory, Staging Area, Repository로 구성된 저장소 구조는 개발자들에게 유연성과 명확한 작업 흐름을 제공합니다.

---

# **2. Git 설치 및 초기 설정**

### **2.1 Git 설치**

### **macOS에서 Git 설치 방법**

이 단원에서는 Git을 설치하는 방법과 기본적인 설정을 수행하는 방법을 소개합니다.

1. **macOS에서 Git 설치:**
    - macOS: Homebrew를 사용하여 `brew install git` 명령어로 설치
    
    ```bash
    brew install git
    ```
    
2. 설치 후 버전을 확인하여 정상적으로 설치되었는지 확인:
    
    ```bash
    git --version
    ```
    

---

### **2.2 사용자 정보 설정**

### **1. 사용자 이름과 이메일 설정**

Git은 커밋 기록에 작성자 정보를 포함합니다. 이를 설정하기 위해 다음 명령어를 사용합니다:

- 사용자 이름 설정:
    
    ```bash
    git config --global user.name "Your Name"
    ```
    
- 이메일 설정:
    
    ```bash
    git config --global user.email "your.email@example.com"
    
    ```
    

### **2. 기본 텍스트 에디터 설정**

커밋 메시지를 입력하거나 Git 관련 설정 파일을 편집할 때 사용할 텍스트 에디터를 지정합니다.

- Vim 기본 설정:
    
    ```bash
    git config --global core.editor "vim"
    
    ```
    
- VS Code를 기본 에디터로 설정:
    
    ```bash
    git config --global core.editor "code --wait"
    
    ```
    

---

### **2.3 Git 설정 파일**

### **1. `.gitconfig` 파일의 역할 및 확인 방법**

- **역할:**`.gitconfig`는 Git 설정 정보를 저장하는 파일입니다. 사용자 이름, 이메일, 별칭(alias) 등을 포함합니다.
- **확인 방법:**
또는 Git 명령어를 통해 확인:
    
    ```bash
    cat ~/.gitconfig
    
    ```
    
    ```bash
    git config --list
    
    ```
    

### **2. 설정 파일에 alias(별칭) 추가 예제**

- Git 명령어를 짧게 사용할 수 있도록 별칭(alias)을 설정합니다.
- 예제:
    
    ```bash
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.br branch
    
    ```
    
- `.gitconfig` 파일의 결과 예시:
    
    ```
    [user]
        name = Your Name
        email = your.email@example.com
    [alias]
        st = status
        co = checkout
        br = branch
    
    ```
    

---

## gitignore.io 에서 .gitignore 파일 생성

웹 브라우저로  gitignore.io 접속.
https://www.toptal.com/developers/gitignore

### gitignore.io

- **gitignore.io 웹 사이트에서 .gitignore파일 자동 생성**
    
    생성 input 창에 운영체제, 개발 환경(IDE), 프로그래밍 언어를 검색해서 자동 생성 가능.
    
    생성된  내용을  프로젝트  루트에  .gitignore  파일로  저장한다.
    
    gitignore  파일에  기록된  파일들은  버전  관리  추적  대상에서  제외된다.
    
1. **.gitignore 파일 작성:**
    - 특정 파일과 디렉토리 제외: 예시로 `node_modules/`, `.log`, `.env`
    - 주석 추가 및 예외 규칙 작성 방법
2. **.gitignore 파일 적용:**
    - 이미 추적 중인 파일 무시하기: `git rm --cached <file>`

![image.png](attachment:02b2df15-199a-449b-8e8b-00b1b4949c74:image.png)

---

### 기존 Github 계정 설정 초기화 및 새 Github 계정으로 설정 변경.

## **✅ 1. 기존 GitHub 계정 설정 초기화**

기존 **comstudy21** 계정과 연결된 **GitHub 자격 증명(Git Credential)** 을 삭제해야 합니다.

🔹 **1️⃣ 기존 GitHub 계정 자격 증명 삭제**

```bash
git credential reject https://github.com

```

➡️ 이렇게 하면 기존 `comstudy21` 계정이 저장된 GitHub 인증 정보가 삭제됩니다.

🔹 **2️⃣ GitHub 캐시된 인증 정보 삭제 (추가적으로 필요할 경우)**

```bash
rm ~/.git-credentials

```

```bash
git credential reject https://github.com

```

➡️ Mac에 저장된 **GitHub 인증 정보**를 완전히 삭제하는 명령어입니다.

🔹 **3️⃣ SSH 키가 등록되어 있다면 기존 키 확인**

```bash
ls ~/.ssh

```

➡️ 만약 `id_rsa.pub` 또는 `id_ed25519.pub` 파일이 존재하면 기존 SSH 키가 설정된 것입니다.

➡️ **새로운 계정을 사용할 것이므로, 새로운 SSH 키를 생성하는 것이 좋습니다.** (Step 2로 이동)

---

## **✅ 2. 새로운 GitHub 계정(beomjoon8253)용 SSH 키 생성 및 등록**

이제 새 계정과 연결할 **SSH Key**를 새롭게 생성하고, GitHub에 등록해야 합니다.

🔹 **1️⃣ 새로운 SSH 키 생성**

```bash
ssh-keygen -t ed25519 -C "beomjoon@outlook.com"

```

➡️ `Generating public/private ed25519 key pair.` 라는 메시지가 나오면, 엔터(Enter) 눌러 기본 경로에 저장합니다.

➡️ Passphrase(암호) 설정할 건지 묻는데, 그냥 **엔터(Enter) 눌러서 넘어가도 무방**합니다.

🔹 **2️⃣ SSH 에이전트(Agent) 실행 및 키 추가**

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

```

🔹 **3️⃣ 새 SSH 키를 GitHub에 등록**

```bash
cat ~/.ssh/id_ed25519.pub

```

➡️ 위 명령어를 실행하면 **SSH 공개키(Public Key)** 가 출력됩니다.

➡️ 이 값을 **GitHub -> Settings -> SSH and GPG keys** 에 추가하면 됩니다. ([GitHub SSH 키 등록](https://github.com/settings/keys))

---

## **✅ 3. 새 계정으로 Git 설정 변경**

이제 새 계정 **beomjoon8253**로 Git 사용자 정보를 업데이트해야 합니다.

🔹 **1️⃣ Git 사용자 정보 업데이트**

```bash
git config --global user.name "beomjoon8253"
git config --global user.email "beomjoon@outlook.com"

```

✅ **변경된 설정 확인**

```bash
git config --global --list

```

➡️ `user.name=beomjoon8253`

➡️ `user.email=beomjoon@outlook.com`

➡️ 이런 식으로 나오면 정상적으로 변경된 것입니다.

---

## **✅ 4. 새로운 레포지토리 사용 설정 (`ioslecturetest2025.git`)**

이제 새 계정으로 **새로운 GitHub 레포지토리** 를 사용할 수 있도록 설정해야 합니다.

🔹 **1️⃣ 기존 레포지토리 디렉토리로 이동**

```bash
cd /path/to/your/project

```

➡️ **이 부분에서 `/path/to/your/project` 를 현재 사용 중인 프로젝트 폴더 경로로 변경**하세요.

🔹 **2️⃣ 기존 GitHub 원격 저장소 정보 확인**

```bash
git remote -v

```

✅ **출력 예시 (기존 계정과 연결되어 있을 경우)**

```bash
origin  https://github.com/comstudy21/old-repository.git (fetch)
origin  https://github.com/comstudy21/old-repository.git (push)

```

➡️ 이 주소를 **새로운 GitHub 계정의 레포지토리로 변경해야 합니다.**

🔹 **3️⃣ 기존 원격 저장소(origin) 삭제**

```bash
git remote remove origin

```

🔹 **4️⃣ 새 GitHub 레포지토리 추가**

```bash
git remote add origin git@github.com:beomjoon8253/ioslecturetest2025.git

```

✅ **추가된 원격 저장소 확인**

```bash
git remote -v

```

➡️ 이제 `origin`이 **새 GitHub 레포지토리 주소로 설정**되었는지 확인합니다.

🔹 **5️⃣ 새로운 GitHub 계정으로 Push 테스트**

```bash
git push -u origin main

```

➡️ SSH 키가 정상적으로 등록되었다면, **GitHub 비밀번호 입력 없이 푸시(Push)가 성공**할 것입니다.

---

## ✅ **1. SSH 키 vs. Personal Access Token (PAT) 차이점**

| 인증 방법 | 사용 방식 | 보안 수준 | 주로 사용되는 상황 |
| --- | --- | --- | --- |
| **SSH 키** | 로컬에서 생성한 SSH 키를 GitHub에 등록 | 매우 안전 (Private Key 보관) | 장기적으로 Git을 사용할 때, SSH 방식으로 인증 |
| **Personal Access Token (PAT)** | GitHub 웹에서 발급 후, HTTPS 방식으로 Git 인증 | 중간 수준 (Token 유출 위험) | 빠르게 설정해야 할 때, CI/CD, 스크립트에서 사용 |

📌 **PAT는 HTTPS 방식으로 인증할 때 사용되며, SSH와는 별개로 작동합니다.**

📌 **GitHub는 2021년부터 보안 강화 정책으로 "기본 비밀번호 인증"을 폐지하고, 대신 PAT 사용을 권장하고 있습니다.**

---

## ✅ **2. Personal Access Token (PAT) 생성 방법**

GitHub에서 PAT를 생성하고, **HTTPS 인증 방식으로 Git을 사용할 수 있습니다.**

### **🔹 1️⃣ GitHub에서 PAT 발급**

1. [GitHub Personal Access Token 설정 페이지](https://github.com/settings/tokens)로 이동
2. **"Generate new token (classic)"** 클릭
3. **"Note"** 필드에 간단한 설명 입력 (예: `GitHub CLI for Mac`)
4. **Expiration(만료일)** 설정 (`No Expiration` 선택 가능, 하지만 보안상 30~90일 추천)
5. **Scopes(권한) 설정** → 다음 항목 선택
    - `repo` → **모든 Repository에 접근 가능 (Push, Pull 포함)**
    - `workflow` → **GitHub Actions 실행 가능**
    - `read:org` → **Organization 정보 읽기 가능 (필요할 경우)**
6. **"Generate token"** 클릭
7. **발급된 Token을 복사** (다시 볼 수 없으므로 따로 저장해 둬야 함!)

---

## ✅ **3. Personal Access Token (PAT)으로 GitHub 인증**

PAT를 이용해서 기존 GitHub 인증을 변경해야 합니다.

### **🔹 1️⃣ 기존 GitHub 자격 증명 제거 (HTTPS 인증 사용 시)**

```bash
git credential reject https://github.com

```

또는

```bash
rm ~/.git-credentials

```

➡️ 기존 GitHub 계정 정보가 저장되어 있었다면, 삭제 후 진행해야 합니다.

### **🔹 2️⃣ HTTPS 방식으로 GitHub 레포지토리 등록**

### ✅ **기존 원격 저장소 변경**

```bash
git remote set-url origin https://github.com/beomjoon8253/ioslecturetest2025.git

```

### ✅ **Git Push 할 때 PAT 입력**

이제 `git push` 명령어 실행 시 **GitHub 비밀번호 대신 PAT 입력**이 필요합니다.

```bash
git push origin main

```

🔹 **기존 비밀번호 입력창이 나오면,**

**GitHub 비밀번호 대신 생성한 PAT를 입력합니다.**

---

## ✅ **4. PAT 인증 방식 자동화 (Mac Keychain 저장)**

PAT를 매번 입력하지 않으려면 **MacOS Keychain에 저장**할 수 있습니다.

🔹 **1️⃣ Git Credential Helper를 Keychain으로 설정**

```bash
git config --global credential.helper osxkeychain

```

🔹 **2️⃣ 이후 첫 GitHub 인증 시 PAT 입력**
PAT을 입력하면 **Keychain에 저장**되어 다시 입력할 필요가 없습니다.

---

# **3. Git 명령어 기초**

### **3.1 로컬 저장소 생성 및 초기화**

### **1. `git init` 명령어로 로컬 저장소 초기화**

Git 저장소를 초기화하면 해당 프로젝트 디렉토리가 버전 관리 대상이 됩니다. 초기화 후 다음 단계로 넘어 갑니다.

### **2. `.git` 폴더 구조 살펴보기**

- `.git` 폴더는 기본적으로 숨겨져 있습니다. 폴더 구조를 확인하려면 다음 명령어를 사용합니다:

주요 폴더와 파일:
    
    ```bash
    ls -a .git
    ```
    
    - **HEAD:** 현재 브랜치 정보를 저장.
    - **objects:** 커밋, 블롭(blob), 트리(tree) 데이터를 저장.
    - **refs:** 브랜치와 태그 정보를 저장.
    - **config:** 프로젝트 수준 설정 파일.

![image.png](attachment:9ca935a9-ab2b-4319-9c18-defd07f0a7f4:image.png)

---

### **3.2 기본적인 Git 명령어**

### **1. 파일 추가 및 상태 확인**

- Git은 변경 사항을 추적하기 위해 파일을 **Staging Area**에 추가해야 합니다.
- 상태 확인:
    
    ```bash
    git status
    ```
    
    - 현재 작업 디렉토리의 상태를 보여줍니다.
- 파일 추가:
    
    ```bash
    git add <filename>
    ```
    
    - 특정 파일 추가.
    
    ```bash
    git add .
    ```
    
    - 모든 변경 사항 추가.

### **2. 변경 사항 커밋**

- 변경 사항을 저장소에 기록하려면 `git commit`을 사용합니다.
    - `m` 옵션은 커밋 메시지를 작성할 때 사용됩니다.
    
    ```bash
    git commit -m "Initial commit"
    ```
    

### **3. 이력 확인**

- 프로젝트의 모든 커밋 이력을 확인합니다:
    - 기본 출력: 커밋 해시, 작성자, 날짜, 메시지.
    
    ```bash
    git log
    git log --oneline
    ```
    

---

### **3.3 원격 저장소와 동기화**

### **1. 원격 저장소 연결**

- 원격 저장소를 로컬 저장소에 연결합니다:
    - `<repository-url>`은 GitHub, GitLab, Bitbucket 등에서 제공하는 HTTPS 또는 SSH URL.
    
    ```bash
    git remote add origin <repository-url>
    git remote -v
    ```
    

### **2. 로컬 커밋을 원격 저장소에 푸시**

- 초기 푸시:
    
    ```bash
    git push -u origin main
    ```
    
    - `u` 옵션은 로컬 브랜치를 원격 브랜치에 연결합니다. 이후에는 `git push`로 간단히 푸시 가능.

### **3. 원격 저장소의 변경 사항 가져오기**

- 원격 저장소의 최신 변경 사항을 로컬 저장소로 가져옵니다:
    
    ```bash
    git pull
    ```
    
    - 변경 사항이 로컬과 충돌할 경우 수동으로 해결해야 합니다.

---

# **4. GitHub와 원격 저장소 연결**

![image.png](attachment:6dfa00fd-f595-4596-8d65-08160a7ee938:image.png)

### **4.1 GitHub 계정 생성**

### **1. GitHub 계정 생성 및 기본 설정**

1. **GitHub 가입 절차**
    - [GitHub 공식 웹사이트](https://github.com/)에 접속하여 "Sign Up" 버튼 클릭.
    - 이메일, 비밀번호, 사용자 이름 입력 후 계정 생성.
    - 이메일 인증 과정을 완료하여 계정 활성화.
2. **프로필 설정**
    - "Profile" 섹션에서 이름, 프로필 사진, 간단한 소개 등 사용자 정보를 추가.
    - "Settings"에서 2단계 인증(2FA)을 설정하여 계정 보안을 강화.

### **2. Public/Private 저장소의 차이점**

- **Public 저장소**:
    - 누구나 저장소 내용을 볼 수 있음.
    - 오픈소스 프로젝트나 공개 협업에 적합.
- **Private 저장소**:
    - 저장소 내용을 초대받은 사용자만 열람 가능.
    - 비공개 프로젝트나 민감한 데이터 관리에 적합.
    - GitHub Free 계정에서도 Private 저장소 생성 가능.

---

### **4.2 GitHub에서 원격 저장소 생성**

### **1. 웹에서 새로운 저장소 생성하기**

1. GitHub에 로그인 후 "Repositories" 탭에서 "New" 버튼 클릭.
2. 저장소 이름 입력 (예: `my_first_repo`).
3. Public 또는 Private 옵션 선택.
4. "Add a README file" 옵션 선택(선택 사항).
5. "Create repository" 버튼 클릭하여 저장소 생성.

### **2. 로컬 Git 저장소와 원격 GitHub 저장소 연결**

1. GitHub에서 생성된 저장소 URL 복사 (HTTPS 또는 SSH).
    
    예:
    
    ```
    https://github.com/username/my_first_repo.git
    ```
    
2. 로컬 저장소에서 원격 저장소 연결:
    
    ```bash
    git remote add origin https://github.com/username/my_first_repo.git
    ```
    
3. 연결된 원격 저장소 확인:
    
    ```bash
    git remote -v
    ```
    

---

### **4.3 기본 GitHub 사용법**

### **1. 저장소 README 파일 작성**

1. 로컬에서 README.md 파일 생성:
    
    ```bash
    echo "# My First Repository" > README.md
    git add README.md
    git commit -m "Add README file"
    git push -u origin main
    ```
    
2. GitHub 웹 UI에서 README 파일 편집:
    - 저장소 페이지에서 README.md 클릭 후 "Edit" 버튼 사용.

### **2. GitHub Issues, Wiki, Pull Requests의 기본 개념**

- **Issues**:
    - 프로젝트의 버그, 기능 요청, 아이디어 등을 관리.
    - 각 Issue는 제목, 설명, 라벨, 담당자를 포함.
- **Wiki**:
    - 프로젝트와 관련된 문서를 관리하는 공간.
    - 설치 방법, 사용 가이드, 프로젝트 개요 등을 작성 가능.
- **Pull Requests (PR)**:
    - 브랜치 간 변경 사항을 병합할 때 사용.
    - 코드 리뷰와 논의를 통해 협업 강화.