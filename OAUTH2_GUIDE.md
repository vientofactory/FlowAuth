# OAuth2 인증 시스템 가이드

이 문서는 FlowAuth의 OAuth2 인증 과정에 대해 설명합니다.

`{BACKEND_HOST}`, `{FRONTEND_HOST}`는 실제 서비스의 도메인 주소로 변경해야 합니다.

예시:

- 공식 데모 서비스의 경우
  - `{BACKEND_HOST}`: https://flowauth-api.viento.me
  - `{FRONTEND_HOST}`: https://auth.viento.me
- 실제 운영 환경에서는 각자의 서비스 도메인으로 대체하세요.

## Authorization Code Grant 플로우

FlowAuth는 OAuth 2.0 Authorization Code Grant 플로우를 완전히 지원합니다.

### 1. 인증 요청 (Authorization Request)

클라이언트 애플리케이션이 사용자를 인증 서버로 리다이렉트합니다.

**엔드포인트:** `GET {BACKEND_HOST}/oauth2/authorize`

**필수 파라미터:**

- `response_type=code` - 응답 타입
- `client_id` - 클라이언트 식별자
- `redirect_uri` - 인증 완료 후 리다이렉트될 URI

**선택 파라미터:**

- `scope` - 요청할 권한 스코프 (공백으로 구분)
- `state` - CSRF 방지를 위한 상태값
- `code_challenge` - PKCE 코드 챌린지
- `code_challenge_method` - PKCE 코드 챌린지 메서드 (S256 권장)

**예시 요청:**

```
GET {BACKEND_HOST}/oauth2/authorize?response_type=code&client_id=your-client-id&redirect_uri=https://your-app.com/callback&scope=read:user%20read:profile&state=random-state
```

**응답:**

- 사용자가 로그인하지 않은 경우: 로그인 페이지로 리다이렉트
- 사용자가 로그인한 경우: 동의 페이지로 리다이렉트 (`{FRONTEND_HOST}/oauth2/authorize`)
- 사용자가 동의한 경우: `redirect_uri`로 authorization code와 함께 리다이렉트

### 2. 동의 페이지 (Consent Page)

사용자가 클라이언트 애플리케이션의 권한 요청에 동의하는 페이지입니다.

**URL:** `{FRONTEND_HOST}/oauth2/authorize`

**동의 처리:** `POST {BACKEND_HOST}/oauth2/authorize/consent`

**요청 본문:**

```json
{
  "client_id": "your-client-id",
  "redirect_uri": "https://your-app.com/callback",
  "scope": "read:user read:profile",
  "state": "random-state",
  "approved": true
}
```

### 3. 토큰 교환 (Token Exchange)

Authorization Code를 사용하여 Access Token을 발급받습니다.

**엔드포인트:** `POST {BACKEND_HOST}/oauth2/token`

**헤더:**

```
Content-Type: application/x-www-form-urlencoded
Authorization: Basic <base64(client_id:client_secret)>
```

**요청 본문 (form-urlencoded):**

```
grant_type=authorization_code
client_id=your-client-id
code=authorization_code_from_redirect
redirect_uri=https://your-app.com/callback
code_verifier=pkce_code_verifier (PKCE를 사용한 경우)
```

**성공 응답 (200):**

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "refresh_token_string",
  "scope": "read:user read:profile"
}
```

**에러 응답 (400):**

```json
{
  "error": "invalid_grant",
  "error_description": "Authorization code expired"
}
```

## 프로필 정보 조회 (User Info)

Access Token을 사용하여 사용자 정보를 조회합니다.

**엔드포인트:** `GET {BACKEND_HOST}/oauth2/userinfo`

**헤더:**

```
Authorization: Bearer <access_token>
```

**스코프별 반환 정보:**

- **read:user 스코프:** 사용자 기본 정보 (ID, 사용자명, 권한)
- **read:profile 스코프:** 사용자 프로필 정보

**예시 응답:**

```json
{
  "sub": "123",
  "username": "johndoe",
  "roles": ["user"],
  "permissions": ["read:user"]
}
```

## 리프래시 토큰 (Refresh Token)

Access Token이 만료되었을 때 새로운 토큰을 발급받습니다.

**엔드포인트:** `POST {BACKEND_HOST}/oauth2/token`

**헤더:**

```
Content-Type: application/x-www-form-urlencoded
Authorization: Basic <base64(client_id:client_secret)>
```

**요청 본문 (form-urlencoded):**

```
grant_type=refresh_token
client_id=your-client-id
refresh_token=your_refresh_token
scope=read:user read:profile (선택사항, 기존 스코프 유지 시 생략)
```

**성공 응답 (200):**

```json
{
  "access_token": "new_access_token",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "new_refresh_token",
  "scope": "read:user read:profile"
}
```

## 지원되는 스코프 (Scopes)

FlowAuth에서 지원하는 OAuth2 스코프입니다:

### 사용자 정보 관련

- `read:user` - 사용자 기본 정보 읽기
- `email` - 사용자 이메일 주소 읽기

### 프로필 관련

- `read:profile` - 사용자 프로필 읽기

### 파일 관리

- `upload:file` - 파일 업로드
- `read:file` - 파일 읽기
- `delete:file` - 파일 삭제

### 클라이언트 관리

- `read:client` - 클라이언트 정보 읽기
- `write:client` - 클라이언트 정보 수정
- `delete:client` - 클라이언트 삭제

### 기본 권한

- `basic` - 기본 접근 권한

## 보안 기능

### PKCE (Proof Key for Code Exchange)

공개 클라이언트에서 Authorization Code를 안전하게 교환하기 위한 보안 메커니즘입니다.

**코드 챌린지 생성:**

```javascript
// 1. 랜덤 문자열 생성 (code_verifier)
const codeVerifier = generateRandomString(64);

// 2. SHA256 해시 후 Base64URL 인코딩 (code_challenge)
const codeChallenge = base64URLEncode(sha256(codeVerifier));

// 3. 인증 요청 시 code_challenge 전송
// GET /oauth2/authorize?code_challenge=...&code_challenge_method=S256

// 4. 토큰 교환 시 code_verifier 전송
// POST /oauth2/token
// grant_type=authorization_code&code=...&code_verifier=...
```

### 2단계 인증 (2FA)

FlowAuth는 TOTP 기반 2단계 인증을 지원합니다. OAuth2 플로우에서도 2FA가 적용됩니다.

## 클라이언트 등록

OAuth2 클라이언트를 등록하려면:

1. FlowAuth 대시보드에 로그인
2. "새 클라이언트" 메뉴 선택
3. 클라이언트 정보 입력:
   - 이름
   - 설명
   - Redirect URIs
   - 권한 부여 타입 (Authorization Code)
   - 스코프
   - 로고 URL (선택사항)

## 에러 처리

### 표준 OAuth2 에러

- `invalid_request` - 잘못된 요청 파라미터
- `unauthorized_client` - 권한이 없는 클라이언트
- `access_denied` - 사용자가 권한 부여를 거부
- `unsupported_response_type` - 지원하지 않는 응답 타입
- `invalid_scope` - 잘못된 스코프
- `invalid_grant` - 잘못된 권한 부여
- `server_error` - 서버 내부 오류
- `temporarily_unavailable` - 일시적으로 사용할 수 없음

### HTTP 상태 코드

- `200` - 성공
- `302` - 리다이렉트
- `400` - 잘못된 요청
- `401` - 인증 실패
- `403` - 권한 부족
- `500` - 서버 오류

## SDK 및 라이브러리

### JavaScript/TypeScript

```javascript
class OAuth2Client {
  constructor(clientId, clientSecret, redirectUri) {
    this.clientId = clientId;
    this.clientSecret = clientSecret;
    this.redirectUri = redirectUri;
    this.backendHost = "https://api.yourdomain.com";
  }

  // 인증 URL 생성
  createAuthorizeUrl(scopes = ["read:user"], state = null) {
    const params = new URLSearchParams({
      response_type: "code",
      client_id: this.clientId,
      redirect_uri: this.redirectUri,
      scope: scopes.join(" "),
    });

    if (state) params.set("state", state);

    return `${this.backendHost}/oauth2/authorize?${params.toString()}`;
  }

  // 토큰 교환
  async exchangeCode(code, codeVerifier = null) {
    const params = new URLSearchParams({
      grant_type: "authorization_code",
      client_id: this.clientId,
      code: code,
      redirect_uri: this.redirectUri,
    });

    if (codeVerifier) params.set("code_verifier", codeVerifier);

    const response = await fetch(`${this.backendHost}/oauth2/token`, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: `Basic ${btoa(`${this.clientId}:${this.clientSecret}`)}`,
      },
      body: params.toString(),
    });

    return response.json();
  }

  // 사용자 정보 조회
  async getUserInfo(accessToken) {
    const response = await fetch(`${this.backendHost}/oauth2/userinfo`, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
      },
    });

    return response.json();
  }

  // 토큰 리프래시
  async refreshToken(refreshToken) {
    const params = new URLSearchParams({
      grant_type: "refresh_token",
      client_id: this.clientId,
      refresh_token: refreshToken,
    });

    const response = await fetch(`${this.backendHost}/oauth2/token`, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: `Basic ${btoa(`${this.clientId}:${this.clientSecret}`)}`,
      },
      body: params.toString(),
    });

    return response.json();
  }
}
```

## 모니터링 및 로깅

FlowAuth는 OAuth2 관련 모든 이벤트를 구조화된 로그로 기록합니다:

- 인증 요청/응답
- 토큰 발급/갱신/취소
- 사용자 동의 처리
- 에러 발생

로그는 Winston을 통해 JSON 형식으로 저장되며, ELK 스택 등으로 모니터링할 수 있습니다.
