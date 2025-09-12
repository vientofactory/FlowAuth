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

## ✅ 완료된 기능들

### 🎨 프론트엔드 (100% 완료)

- **현대적인 메인 페이지**: 그라데이션 배경과 애니메이션 효과
- **컴포넌트 라이브러리**: Button, Input, Card 컴포넌트
- **TailwindCSS 통합**: 커스텀 디자인 시스템
- **Font Awesome 아이콘**: 모든 아이콘 통합
- **반응형 디자인**: 모바일 우선 접근 방식
- **API 클라이언트**: 타입 안전한 API 통신

### 🔧 백엔드 (95% 완료)

- **사용자 관리**: 등록, 로그인, 프로필 관리 API
- **클라이언트 관리**: OAuth2 클라이언트 CRUD 작업
- **보안 강화**: 헬멧, CORS, 레이트 리미팅 적용
- **데이터베이스**: TypeORM으로 완전한 모델링
- **API 문서화**: Swagger를 통한 자동 문서 생성

### 🔄 진행 중인 작업

- **로그인 페이지**: UI/UX 개선 및 기능 구현
- **OAuth2 플로우**: 인가 코드 플로우 구현

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

- [x] **프론트엔드 UI/UX**: 현대적인 디자인 시스템 및 컴포넌트
- [x] **백엔드 API**: 사용자 및 클라이언트 관리
- [x] **데이터베이스**: 완전한 스키마 및 마이그레이션
- [x] **보안**: JWT, bcrypt, CORS, 헬멧 적용
- [x] **문서화**: Swagger API 문서 자동 생성

### 🔄 진행 중

- [ ] OAuth2 인가 코드 플로우 구현
- [ ] 회원가입 페이지 완성
- [ ] 사용자 대시보드 개발

### 📋 다음 단계

- [ ] 통합 테스트 및 QA
- [ ] Docker 컨테이너화
- [ ] CI/CD 파이프라인 구축

## 🤝 기여하기

FlowAuth는 오픈소스 프로젝트입니다! 기여를 환영합니다:

1. **이슈 생성**: 버그 리포트 또는 기능 제안
2. **풀 리퀘스트**: 코드 개선 또는 새로운 기능
3. **문서화**: README 또는 API 문서 개선

### 기여 가이드라인

- TypeScript 엄격 모드 준수
- ESLint/Prettier 규칙 따르기
- 의미 있는 커밋 메시지 작성
- 테스트 코드 포함

## 📞 문의

- **이슈**: [GitHub Issues](https://github.com/your-username/FlowAuth/issues)
- **토론**: [GitHub Discussions](https://github.com/your-username/FlowAuth/discussions)

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
