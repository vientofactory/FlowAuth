# FlowAuth

> [!NOTE]
> 이 프로젝트는 아직 개발 중인 미완성 상태입니다. 많은 기능이 추가될 예정이며, 누구나 자유롭게 기여하실 수 있습니다!

FlowAuth는 OAuth2 표준을 준수하는 모던한 인증 및 권한 부여 시스템입니다. 외부 서비스 제공자들이 쉽게 애플리케이션을 등록하고 관리할 수 있는 플랫폼을 제공합니다.

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
   end

   subgraph "Backend Layer"
      BE_OAuth2[OAuth2 서버]
      BE_JWT[JWT 인증]
      BE_Token[토큰 관리]
      BE_API[API 엔드포인트]
   end

   subgraph "Database Layer"
      DB_User[사용자 정보]
      DB_Client[클라이언트 정보]
      DB_Token[토큰 저장]
      DB_Scope[권한 범위]
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

## � 시스템 요구사항

- **Node.js**: v18 이상
- **Database**: MySQL 8.0 이상 (또는 호환되는 데이터베이스)
- **Package Manager**: npm 또는 yarn

## 🛠️ 빠른 시작

### 1. 저장소 클론

```bash
git clone https://github.com/vientofactory/FlowAuth.git
cd FlowAuth
```

### 2. 백엔드 설정

```bash
cd backend

# 의존성 설치
npm install

# 환경 변수 설정
cp .env.example .env
# .env 파일을 편집하여 데이터베이스 및 기타 설정을 구성하세요

# 데이터베이스 마이그레이션 실행
npm run migration:run

# 개발 서버 시작
npm run start:dev
```

### 3. 프론트엔드 설정

```bash
cd ../frontend

# 의존성 설치
npm install

# 개발 서버 시작
npm run dev
```

### 4. 애플리케이션 접속

- **프론트엔드**: http://localhost:5173
- **백엔드 API**: http://localhost:3000
- **API 문서**: http://localhost:3000/api

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

## 🚀 시작하기

### 사전 요구사항

- **Node.js**: v18 이상
- **MySQL**: 8.0 이상 (또는 다른 지원 데이터베이스)
- **npm** 또는 **yarn**
- **Git**: 서브모듈 지원

### ⚡ 빠른 시작

1. **프로젝트 클론** (서브모듈 포함):

   ```bash
   git clone --recursive https://github.com/your-username/FlowAuth.git
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

### 🔧 환경 설정

#### 백엔드 (.env 파일)

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

#### 데이터베이스 초기화

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

## 📊 프로젝트 상태

### ✅ 완료된 기능들

- [x] **프론트엔드 UI/UX**: 현대적인 디자인 시스템 및 완전한 컴포넌트 라이브러리
- [x] **백엔드 API**: 사용자 및 클라이언트 관리 완전 구현
- [x] **OAuth2 시스템**: Authorization Code Grant 플로우 완전 구현
- [x] **인증 시스템**: JWT 기반 로그인/회원가입 시스템
- [x] **사용자 대시보드**: 클라이언트, 토큰, 프로필 관리 대시보드
- [x] **OAuth2 테스터**: 개발자용 OAuth2 플로우 테스트 도구
- [x] **데이터베이스**: 완전한 스키마 및 마이그레이션
- [x] **보안**: JWT, bcrypt, CORS, 헬멧 적용
- [x] **문서화**: Swagger API 문서 자동 생성

### 🔄 진행 중

- [ ] 관리자 페이지 개발
- [ ] 고급 보안 기능 (2FA, 세션 관리)
- [ ] 사용자 설정 페이지 완성

### 📋 다음 단계

- [ ] 통합 테스트 및 QA
- [ ] Docker 컨테이너화
- [ ] CI/CD 파이프라인 구축
- [ ] 프로덕션 배포 가이드
- [ ] 성능 최적화
- [ ] 모니터링 및 로깅 시스템

## 📞 문의

- **이슈**: [GitHub Issues](https://github.com/your-username/FlowAuth/issues)
- **토론**: [GitHub Discussions](https://github.com/your-username/FlowAuth/discussions)

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

## 📊 프로젝트 상태

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

### 🔄 진행 중인 작업

- [ ] 관리자 페이지 개발
- [ ] 고급 보안 기능 (2FA, 세션 관리)
- [ ] 사용자 설정 페이지 완성

### 📋 향후 계획

- [ ] 통합 테스트 및 QA
- [ ] Docker 컨테이너화
- [ ] CI/CD 파이프라인 구축
- [ ] 프로덕션 배포 가이드
- [ ] 성능 최적화
- [ ] 모니터링 및 로깅 시스템

## 🤝 기여하기

1. 이 리포지토리를 Fork 하세요
2. Feature 브랜치를 생성하세요 (`git checkout -b feature/AmazingFeature`)
3. 변경사항을 커밋하세요 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 Push 하세요 (`git push origin feature/AmazingFeature`)
5. Pull Request를 생성하세요

## 📞 문의 및 지원

- **이슈**: [GitHub Issues](https://github.com/vientofactory/FlowAuth/issues)
- **토론**: [GitHub Discussions](https://github.com/vientofactory/FlowAuth/discussions)

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다.

---

<div align="center">

**FlowAuth** - 모던한 OAuth2 인증 시스템

[🌐 웹사이트](https://flowauth.dev) • [📚 문서](https://docs.flowauth.dev) • [🐛 이슈](https://github.com/vientofactory/FlowAuth/issues)

</div>
