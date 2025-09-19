# FlowAuth

> [!NOTE]
> 이 프로젝트는 아직 개발 중인 미완성 상태입니다. 많은 기능이 추가될 예정이며, 누구나 자유롭게 기여하실 수 있습니다!

<img width="600" height="164" alt="logo_1" src="https://github.com/user-attachments/assets/04383214-745c-4b18-8545-36c3cda04ee6" />

FlowAuth는 [OAuth 2.0 표준](https://datatracker.ietf.org/doc/html/rfc6749)을 준수하는 모던한 인증 및 권한 부여 시스템입니다. 외부 서비스 제공자들이 쉽게 애플리케이션을 등록하고 관리할 수 있는 플랫폼을 제공합니다.

## 🚀 특징

- **완전한 OAuth2 구현**: Authorization Code Grant 플로우 완전 지원
- **표준 준수**: OAuth2 RFC 6749 표준 완전 준수
- **모던한 아키텍처**: NestJS (백엔드) + SvelteKit (프론트엔드)
- **심플 & 모던 UI/UX**: 직관적이고 아름다운 사용자 인터페이스
- **개발자 친화적**: OAuth2 테스터 및 완전한 대시보드 제공
- **유연한 서비스 등록**: 외부 개발자들이 쉽게 애플리케이션 등록 가능
- **세밀한 권한 제어**: Scope 기반 권한 관리 시스템
- **TypeORM 통합**: 효율적인 데이터베이스 관리
- **TypeScript 지원**: 타입 안전성과 개발 생산성 향상
- **완전한 토큰 관리**: 액세스/리프레시 토큰 생성, 조회, 취소
- **PKCE 지원**: Proof Key for Code Exchange 보안 강화
- **환경 변수 기반 설정**: 유연한 배포 환경 지원
- **2단계 인증 (2FA)**: TOTP 기반 보안 강화
- **사용자 유형 분리**: 일반 사용자와 개발자 역할 구분
- **맞춤형 대시보드**: 사용자 유형별 최적화된 인터페이스
- **역할 기반 접근 제어**: 세밀한 권한 관리 시스템

## 🏗️ 아키텍처 개요

```mermaid
flowchart LR
   FE[Frontend<br/>SvelteKit]
   BE[Backend<br/>NestJS]
   DB[Database<br/>MySQL]

   FE <--> BE
   BE <--> DB

   subgraph "Frontend Layer"
      FE_UI[사용자 인터페이스]
      FE_Tester[OAuth2 테스터]
      FE_Dashboard[대시보드]
      FE_Consent[동의 페이지]
      FE_2FA[2FA 인증]
   end

   subgraph "Backend Layer"
      BE_OAuth2[OAuth2 서버]
      BE_JWT[JWT 인증]
      BE_Token[토큰 관리]
      BE_API[API 엔드포인트]
      BE_2FA[2FA 서비스]
      BE_RBAC[역할 기반 접근 제어]
   end

   subgraph "Database Layer"
      DB_User[사용자 정보]
      DB_Client[클라이언트 정보]
      DB_Token[토큰 저장]
      DB_Scope[권한 범위]
      DB_2FA[2FA 시크릿]
   end

   FE --> FE_UI
   FE --> FE_Tester
   FE --> FE_Dashboard
   FE --> FE_Consent

   BE --> BE_OAuth2
   BE --> BE_JWT
   BE --> BE_Token
   BE --> BE_API

   DB --> DB_User
   DB --> DB_Client
   DB --> DB_Token
   DB --> DB_Scope
```

## 📋 시스템 요구사항

- **Node.js**: v18 이상
- **MySQL**: 8.0 이상 (또는 다른 지원 데이터베이스)
- **npm** 또는 **yarn**
- **Git**: 서브모듈 지원

## 🛠️ 빠른 시작

1. **프로젝트 클론** (서브모듈 포함):

   ```bash
   git clone --recursive https://github.com/vientofactory/FlowAuth.git
   cd FlowAuth
   ```

2. **백엔드 실행**:

   ```bash
   cd backend
   npm install
   cp .env.example .env  # 환경 변수 설정
   npm run start:dev
   ```

3. **프론트엔드 실행** (새 터미널에서):

   ```bash
   cd frontend
   npm install
   npm run dev
   ```

4. **브라우저에서 접속**:
   - 프론트엔드: http://localhost:5173
   - 백엔드 API: http://localhost:3000
   - API 문서: http://localhost:3000/api

## 📁 프로젝트 구조

```
FlowAuth/
├── backend/              # NestJS 백엔드 애플리케이션
│   ├── src/
│   │   ├── auth/         # JWT 인증 모듈
│   │   ├── oauth2/       # OAuth2 핵심 구현
│   │   ├── user/         # 사용자 엔티티 및 서비스
│   │   ├── client/       # OAuth2 클라이언트 엔티티
│   │   ├── token/        # 토큰 엔티티 및 관리
│   │   ├── scope/        # 권한 범위 엔티티
│   │   ├── authorization-code/  # 인가 코드 엔티티
│   │   ├── database/     # 데이터베이스 설정 및 시딩
│   │   ├── migrations/   # 데이터베이스 마이그레이션
│   │   └── utils/        # 유틸리티 (암호화, ID 생성 등)
│   └── ...
├── frontend/             # SvelteKit 프론트엔드 애플리케이션
│   ├── src/
│   │   ├── routes/       # 페이지 라우트
│   │   │   ├── auth/     # 로그인/회원가입 페이지
│   │   │   ├── dashboard/  # 사용자 대시보드
│   │   │   ├── oauth/    # OAuth2 동의 페이지
│   │   │   └── callback/ # OAuth2 콜백 페이지
│   │   ├── lib/          # 재사용 가능한 컴포넌트
│   │   │   ├── components/  # UI 컴포넌트
│   │   │   ├── stores/   # Svelte 스토어
│   │   │   ├── types/    # TypeScript 타입 정의
│   │   │   └── utils/    # 유틸리티 함수
│   │   └── ...
│   └── ...
├── .gitmodules           # Git 서브모듈 설정
└── README.md
```

## ⚙️ 환경 설정

### 백엔드 (.env 파일)

```env
# 데이터베이스 설정
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=your_password
DB_NAME=flowauth

# 애플리케이션 설정
PORT=3000
NODE_ENV=development

# JWT 설정
JWT_SECRET=your_super_secret_jwt_key_here
JWT_EXPIRES_IN=1h

# 보안 설정
BCRYPT_SALT_ROUNDS=10
```

### 데이터베이스 초기화

```bash
# 백엔드에서 마이그레이션 실행
cd backend
npm run migration:run
```

## 🔧 개발 가이드

### 개발 서버 실행

```bash
# 백엔드 (포트 3000)
cd backend && npm run start:dev

# 프론트엔드 (포트 5173)
cd frontend && npm run dev
```

### 사용 가능한 스크립트

#### 백엔드

```bash
npm run start:dev      # 개발 서버
npm run build         # 프로덕션 빌드
npm run test          # 단위 테스트
npm run lint          # 코드 린팅
```

#### 프론트엔드

```bash
npm run dev           # 개발 서버
npm run build         # 프로덕션 빌드
npm run preview       # 빌드 미리보기
npm run lint          # 코드 린팅
```

## 프로젝트 상태

### ✅ 완료된 기능들

#### 🎨 프론트엔드

- **현대적인 메인 페이지**: 그라데이션 배경과 애니메이션 효과
- **인증 시스템**: 회원가입, 로그인, 프로필 관리 페이지
- **사용자 대시보드**: 완전한 대시보드 UI 및 네비게이션
- **OAuth2 동의 페이지**: 사용자 권한 승인 인터페이스
- **클라이언트 관리**: OAuth2 애플리케이션 등록 및 관리
- **토큰 관리**: 발급된 토큰 조회 및 취소 기능
- **OAuth2 테스터**: 개발자용 OAuth2 플로우 테스트 도구
- **컴포넌트 라이브러리**: Button, Input, Card, Badge, Modal 등 완전한 컴포넌트 시스템
- **TailwindCSS 통합**: 커스텀 디자인 시스템
- **Font Awesome 아이콘**: 모든 아이콘 통합
- **반응형 디자인**: 모바일 우선 접근 방식
- **API 클라이언트**: 타입 안전한 API 통신
- **Toast 알림 시스템**: 사용자 피드백 시스템
- **🔐 2단계 인증 (2FA)**: TOTP 기반 보안 로그인
- **👥 사용자 유형별 인터페이스**: 일반 사용자와 개발자 맞춤형 UI
- **📊 동적 대시보드**: 사용자 유형에 따른 통계 및 메뉴 표시
- **🛡️ 역할 기반 네비게이션**: 권한에 따른 메뉴 필터링

#### 🔧 백엔드

- **완전한 OAuth2 구현**: Authorization Code Grant 플로우
- **사용자 관리**: 등록, 로그인, 프로필 관리 API
- **클라이언트 관리**: OAuth2 클라이언트 CRUD 작업
- **토큰 관리**: 액세스 토큰 및 리프레시 토큰 생성/관리
- **권한 범위(Scope) 시스템**: 세밀한 권한 제어
- **인가 코드 관리**: 보안 인가 코드 생성 및 검증
- **JWT 인증**: 안전한 토큰 기반 인증
- **보안 강화**: 헬멧, CORS, 레이트 리미팅 적용
- **데이터베이스**: TypeORM으로 완전한 모델링
- **API 문서화**: Swagger를 통한 자동 문서 생성
- **데이터 시딩**: 개발용 초기 데이터 생성
- **🔐 2단계 인증 (2FA)**: TOTP 기반 보안 강화
- **👥 사용자 유형 분리**: 일반 사용자와 개발자 역할 구분
- **🛡️ 역할 기반 액세스 제어 (RBAC)**: 세부적인 권한 관리
- **📊 대시보드 API**: 사용자 유형별 통계 및 데이터 제공

### 🔄 진행 중인 작업

- [ ] 관리자 페이지 개발
- [ ] 사용자 설정 페이지 완성

### 📋 향후 계획

- [ ] 통합 테스트 및 QA
- [ ] Docker 컨테이너화
- [ ] CI/CD 파이프라인 구축
- [ ] 프로덕션 배포 가이드
- [ ] 성능 최적화
- [ ] 모니터링 및 로깅 시스템

## 📚 API 문서

백엔드 서버 실행 후 다음에서 API 문서를 확인할 수 있습니다:

- **Swagger UI**: http://localhost:3000/api

## 🔒 보안 기능

- **JWT 토큰 기반 인증**
- **비밀번호 해싱 (bcrypt)**
- **헬멧 (Helmet) 보안 헤더**
- **CORS 설정**
- **레이트 리미팅**
- **PKCE (Proof Key for Code Exchange) 지원**
- **인가 코드 만료 (환경 변수로 설정 가능)**
- **토큰 만료 관리**
- **2단계 인증 (2FA)**: TOTP 기반 추가 보안 계층
- **역할 기반 액세스 제어 (RBAC)**: 세부적인 권한 관리

## 🤝 기여 가이드

FlowAuth는 모든 개발자의 기여를 환영합니다! 아래 절차에 따라 자유롭게 참여해 주세요.

1. **Fork**: 백엔드 또는 프론트엔드 리포지토리를 자신의 GitHub 계정으로 포크하세요.
   > ⚠️ 이 메인 리포지토리는 서브모듈 관리용입니다. 실제 코드 변경은 각 하위 리포지토리에서 진행해 주세요.
2. **브랜치 생성**: 새로운 기능 또는 버그 수정을 위한 브랜치를 만드세요.
   ```bash
   git checkout -b feature/YourFeatureName
   ```
3. **커밋**: 변경사항을 명확한 메시지와 함께 커밋하세요.
   ```bash
   git commit -m "feat: Your concise commit message"
   ```
4. **푸시**: 작업한 브랜치를 자신의 원격 저장소에 푸시하세요.
   ```bash
   git push origin feature/YourFeatureName
   ```
5. **Pull Request 생성**: GitHub에서 Pull Request를 생성하고, 변경 내용을 설명해 주세요.
6. **리뷰 및 반영**: 리뷰어의 피드백을 반영해 주세요.

## 📞 문의 및 지원

- **이슈**: [GitHub Issues](https://github.com/vientofactory/FlowAuth/issues)
- **토론**: [GitHub Discussions](https://github.com/vientofactory/FlowAuth/discussions)

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다.
