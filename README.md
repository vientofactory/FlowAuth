# FlowAuth

> [!NOTE]
> 이 프로젝트는 아직 개발 중인 미완성 상태입니다. 많은 기능이 추가될 예정이며, 누구나 자유롭게 기여하실 수 있습니다!

FlowAuth는 OAuth2 표준을 준수하는 모던한 인증 및 권한 부여 시스템입니다. 외부 서비스 제공자들이 쉽게 애플리케이션을 등록하고 관리할 수 있는 플랫폼을 제공합니다.

## 🚀 특징

- **OAuth2 표준 준수**: 안전하고 표준화된 인증 플로우 구현
- **모던한 아키텍처**: NestJS (백엔드) + Svelte (프론트엔드)
- **심플 & 모던 UI/UX**: 직관적이고 아름다운 사용자 인터페이스
- **유연한 서비스 등록**: 외부 개발자들이 쉽게 애플리케이션 등록 가능
- **TypeORM 통합**: 효율적인 데이터베이스 관리
- **TypeScript 지원**: 타입 안전성과 개발 생산성 향상

## 🛠 기술 스택

### Backend

- **Framework**: NestJS
- **Database**: MySQL + TypeORM
- **Authentication**: Passport.js + JWT
- **Language**: TypeScript
- **Testing**: Jest

### Frontend

- **Framework**: SvelteKit
- **Styling**: TailwindCSS
- **Language**: TypeScript
- **Build Tool**: Vite

## 📁 프로젝트 구조

```
FlowAuth/
├── backend/          # NestJS 백엔드 애플리케이션
│   ├── src/
│   │   ├── auth/     # 인증 관련 모듈
│   │   ├── user/     # 사용자 엔티티
│   │   ├── client/   # OAuth2 클라이언트 엔티티
│   │   └── ...
│   └── ...
├── frontend/         # Svelte 프론트엔드 애플리케이션
│   ├── src/
│   │   ├── routes/   # 페이지 라우트
│   │   ├── lib/      # 재사용 가능한 컴포넌트
│   │   └── ...
│   └── ...
├── .gitmodules       # Git 서브모듈 설정
└── README.md
```

## 🚀 시작하기

### 사전 요구사항

- Node.js (v18 이상)
- MySQL (또는 다른 지원 데이터베이스)
- npm 또는 yarn

### 설치 및 실행

1. **리포지토리 클론** (서브모듈 포함):

   ```bash
   git clone --recursive https://github.com/your-username/FlowAuth.git
   cd FlowAuth
   ```

2. **백엔드 설정**:

   ```bash
   cd backend
   npm install
   # 환경 변수 설정 (.env 파일 생성)
   npm run start:dev
   ```

3. **프론트엔드 설정**:
   ```bash
   cd ../frontend
   npm install
   npm run dev
   ```

### 환경 변수 설정

백엔드의 `.env` 파일에 다음 변수를 설정하세요. `.env.example` 파일을 복사해서 사용하세요:

```bash
cp .env.example .env
```

주요 환경 변수들:

```env
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=your_password_here
DB_NAME=flowauth

# Application Configuration
PORT=3000
NODE_ENV=development

# Frontend Configuration (for CORS)
FRONTEND_URL=http://localhost:5173

# JWT Configuration
JWT_SECRET=your_super_secret_jwt_key_here
JWT_EXPIRES_IN=1h
JWT_REFRESH_EXPIRES_IN=7d

# OAuth2 Configuration
OAUTH2_DEFAULT_REDIRECT_URI=http://localhost:3000/auth/callback
OAUTH2_SUPPORTED_GRANTS=authorization_code,refresh_token,password,client_credentials

# Security Configuration
BCRYPT_SALT_ROUNDS=10
```

**보안 주의사항:**

- 실제 운영 환경에서는 강력한 비밀번호와 JWT 시크릿을 사용하세요
- `.env` 파일은 절대 Git에 커밋하지 마세요 (이미 .gitignore에 포함됨)

## 🔧 개발

### 백엔드 개발 서버 실행

```bash
cd backend
npm run start:dev
```

### 프론트엔드 개발 서버 실행

```bash
cd frontend
npm run dev
```

### 테스트 실행

```bash
# 백엔드 테스트
cd backend
npm run test

# 프론트엔드 테스트 (필요시)
cd frontend
npm run test
```

## 📚 API 문서

백엔드 서버 실행 후 다음 엔드포인트에서 API 문서를 확인할 수 있습니다:

- Swagger UI: `http://localhost:3000/api`

## 🤝 기여하기

1. 이 리포지토리를 Fork 하세요
2. Feature 브랜치를 생성하세요 (`git checkout -b feature/AmazingFeature`)
3. 변경사항을 커밋하세요 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 Push 하세요 (`git push origin feature/AmazingFeature`)
5. Pull Request를 생성하세요

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다.
