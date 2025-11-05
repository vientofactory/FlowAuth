# FlowAuth

<img width="600" height="164" alt="logo_1" src="https://github.com/user-attachments/assets/04383214-745c-4b18-8545-36c3cda04ee6" />

FlowAuth는 [OAuth 2.0 표준](https://datatracker.ietf.org/doc/html/rfc6749)과 [OpenID Connect 1.0 표준](https://openid.net/specs/openid-connect-core-1_0.html)을 준수하는 모던한 인증 및 권한 부여 시스템입니다. 외부 서비스 제공자들이 쉽게 애플리케이션을 등록하고 관리할 수 있는 플랫폼을 제공합니다.

## 특징

- **완전한 OAuth2/OIDC 구현**: Authorization Code Grant 플로우 완전 지원 및 OpenID Connect 1.0 표준 준수
- **표준 준수**: OAuth2 RFC 6749 및 OpenID Connect Core 1.0 표준 완전 준수
- **모던한 아키텍처**: NestJS (백엔드) + SvelteKit (프론트엔드)
- **심플 & 모던 UI/UX**: 직관적이고 아름다운 사용자 인터페이스
- **개발자 친화적**: OAuth2/OIDC 테스터 및 완전한 대시보드 제공
- **유연한 서비스 등록**: 외부 개발자들이 쉽게 애플리케이션 등록 가능
- **세밀한 권한 제어**: Scope 기반 권한 관리 시스템
- **TypeORM 통합**: 효율적인 데이터베이스 관리
- **TypeScript 지원**: 타입 안전성과 개발 생산 생산성 향상
- **완전한 토큰 관리**: 액세스/리프레시 토큰 생성, 조회, 취소
- **PKCE 지원**: Proof Key for Code Exchange 보안 강화
- **Docker 지원**: 완전한 컨테이너화된 개발/배포 환경
- **2단계 인증 (2FA)**: TOTP 기반 보안 강화
- **reCAPTCHA v3 통합**: 봇 공격 방지를 위한 Google reCAPTCHA v3 지원
- **사용자 유형 분리**: 일반 사용자와 개발자 역할 구분
- **맞춤형 대시보드**: 사용자 유형별 최적화된 인터페이스
- **역할 기반 접근 제어**: 세밀한 권한 관리 시스템
- **OAuth2/OIDC 클라이언트 SDK**: 외부 개발자들이 쉽게 통합할 수 있는 SDK 제공
- **공유 모듈 아키텍처**: 프론트엔드와 백엔드 간 중앙화된 권한 및 유틸리티 공유
- **Redis 캐싱**: 고성능 분산 캐싱으로 성능 최적화
- **구조화된 로깅**: Winston 기반 보안 이벤트 및 감사 로그

## 아키텍처 개요

```mermaid
flowchart LR
   FE[Frontend<br/>SvelteKit]
   BE[Backend<br/>NestJS]
   SHARED[Shared<br/>Module]
   DB[Database<br/>MariaDB]
   REDIS[Cache<br/>Redis]

   FE <--> SHARED
   BE <--> SHARED
   BE <--> DB
   BE <--> REDIS

   subgraph "Frontend Layer"
      FE_UI[사용자 인터페이스]
      FE_Tester[OAuth2 테스터]
      FE_Dashboard[대시보드]
      FE_Consent[동의 페이지]
      FE_2FA[2FA 인증]
   end

   subgraph "Backend Layer"
      BE_OAuth2[OAuth2/OIDC 서버]
      BE_JWT[JWT 인증]
      BE_Token[토큰 관리]
      BE_API[API 엔드포인트]
      BE_2FA[2FA 서비스]
      BE_RBAC[역할 기반 접근 제어]
      BE_Cache[Redis 캐싱]
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

   subgraph "Cache Layer"
      CACHE_User[사용자 캐시]
      CACHE_Scope[스코프 캐시]
      CACHE_Stats[통계 캐시]
   end

   FE --> FE_UI
   FE --> FE_Tester
   FE --> FE_Dashboard
   FE --> FE_Consent

   BE --> BE_OAuth2
   BE --> BE_JWT
   BE --> BE_Token
   BE --> BE_API
   BE --> BE_Cache

   DB --> DB_User
   DB --> DB_Client
   DB --> DB_Token
   DB --> DB_Scope

   REDIS --> CACHE_User
   REDIS --> CACHE_Scope
   REDIS --> CACHE_Stats
```

## 개발 & 배포

개발과 배포와 관련된 자세한 내용은 이 리포지토리의 각 서브모듈(프론트엔드, 백엔드, 공유모듈, SDK)의 README 파일을 참고하세요.

## 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다.
