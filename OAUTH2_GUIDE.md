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
- `state` - CSRF 방지를 위한 상태값 (보안상 필수)

**선택 파라미터:**

- `scope` - 요청할 권한 스코프 (공백으로 구분)
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
  "approved": true,
  "client_id": "your-client-id",
  "redirect_uri": "https://your-app.com/callback",
  "response_type": "code",
  "scope": "read:user read:profile",
  "state": "random-state"
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
client_id=your-client-id (선택사항, 헤더에 포함된 경우 생략 가능)
code=authorization_code_from_redirect
redirect_uri=https://your-app.com/callback (선택사항)
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

- **항상 포함:** `sub` (사용자 식별자)
- **`email` 스코프:** `email` (사용자 이메일 주소)
- **`read:profile` 스코프:** `username`, `roles` (사용자명, 역할 정보)

**예시 응답:**

```json
{
  "sub": "123",
  "email": "user@example.com",
  "username": "johndoe",
  "roles": ["user"]
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

### 클라이언트 사이드 값 생성 가이드라인

OAuth2 플로우에서 클라이언트가 안전하게 생성해야 하는 값들에 대한 권장사항입니다.

#### State 파라미터 생성

**목적:** CSRF 공격 방지

**권장사항:**

- 최소 32바이트 (256비트) 엔트로피의 랜덤 값 사용
- URL-safe 문자만 사용 (A-Z, a-z, 0-9, -, ., \_)
- 각 요청마다 고유한 값 생성
- 요청/응답 사이에 안전하게 저장 (세션 스토리지 권장)

```javascript
function generateState() {
  // 32바이트 랜덤 값 생성 (브라우저 환경)
  const array = new Uint8Array(32);
  crypto.getRandomValues(array);

  // Base64URL 인코딩 (URL-safe)
  return btoa(String.fromCharCode(...array))
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=/g, "");
}

// Node.js 환경
const crypto = require("crypto");
function generateState() {
  return crypto.randomBytes(32).toString("base64url");
}
```

#### PKCE (Proof Key for Code Exchange)

**목적:** Authorization Code Interception Attack 방지

**Code Verifier 생성:**

- 43-128자 길이의 랜덤 문자열
- URL-safe 문자만 사용 (A-Z, a-z, 0-9, -, ., \_)
- 최소 32바이트 엔트로피 권장

**Code Challenge 생성:**

- Code Verifier를 SHA256 해시
- Base64URL 인코딩
- S256 메서드 권장 (Plain은 보안 취약)

```javascript
async function generatePKCE() {
  // Code Verifier 생성 (브라우저 환경)
  const codeVerifier = generateCodeVerifier();

  // Code Challenge 생성
  const codeChallenge = await generateCodeChallenge(codeVerifier);

  return {
    codeVerifier,
    codeChallenge,
    codeChallengeMethod: "S256",
  };
}

function generateCodeVerifier() {
  // 32-96바이트 랜덤 값 (43-128자 Base64URL)
  const array = new Uint8Array(64); // 64바이트 = 86자 Base64URL
  crypto.getRandomValues(array);

  return btoa(String.fromCharCode(...array))
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=/g, "");
}

async function generateCodeChallenge(codeVerifier) {
  // SHA256 해시 후 Base64URL 인코딩
  const encoder = new TextEncoder();
  const data = encoder.encode(codeVerifier);
  const digest = await crypto.subtle.digest("SHA-256", data);

  return btoa(String.fromCharCode(...new Uint8Array(digest)))
    .replace(/\+/g, "-")
    .replace(/\//g, "_")
    .replace(/=/g, "");
}

// Node.js 환경
const crypto = require("crypto");

function generateCodeVerifier() {
  return crypto.randomBytes(64).toString("base64url");
}

function generateCodeChallenge(codeVerifier) {
  const hash = crypto.createHash("sha256").update(codeVerifier).digest();
  return hash.toString("base64url");
}
```

#### 보안 고려사항

1. **엔트로피 충분성:**

   - State: 최소 256비트
   - Code Verifier: 최소 256비트

2. **문자 집합:**

   - URL-safe 문자만 사용
   - Base64URL 인코딩 권장

3. **저장 및 관리:**

   - 민감한 값은 메모리에만 저장
   - 세션 스토리지에 임시 저장 시 암호화
   - 사용 후 즉시 폐기

4. **예측 불가능성:**

   - 충분한 엔트로피의 CSPRNG 사용
   - 시드 재사용 금지

5. **타임아웃:**
   - State: 요청 후 10분 이내 사용
   - Authorization Code: 발급 후 10분 이내 교환

### PKCE (Proof Key for Code Exchange)

공개 클라이언트에서 Authorization Code를 안전하게 교환하기 위한 보안 메커니즘입니다.

**코드 챌린지 생성:**

```javascript
// 1. 랜덤 문자열 생성 (code_verifier)
const codeVerifier = generateCodeVerifier();

// 2. SHA256 해시 후 Base64URL 인코딩 (code_challenge)
const codeChallenge = await generateCodeChallenge(codeVerifier);

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

## 클라이언트 구현 가이드

### HTTP 요청 예제 (cURL)

#### 1. 안전한 랜덤 값 생성 (클라이언트 사이드)

```bash
# Node.js에서 랜덤 값 생성
node -e "
const crypto = require('crypto');
const randomBytes = crypto.randomBytes(32);
const base64Url = randomBytes.toString('base64url');
console.log('Random value:', base64Url);
"
```

#### 2. PKCE 챌린지 생성

```bash
# Node.js에서 PKCE 생성
node -e "
const crypto = require('crypto');
const codeVerifier = crypto.randomBytes(32).toString('base64url');
const hash = crypto.createHash('sha256').update(codeVerifier).digest();
const codeChallenge = hash.toString('base64url');
console.log('Code Verifier:', codeVerifier);
console.log('Code Challenge:', codeChallenge);
"
```

#### 3. 인증 URL 생성

```bash
# 인증 URL 생성 예제
CLIENT_ID="your-client-id"
REDIRECT_URI="https://yourapp.com/callback"
SCOPE="read:user"
STATE="random-state-value"
CODE_CHALLENGE="generated-code-challenge"

curl -X GET "https://api.yourdomain.com/oauth2/authorize?\
response_type=code&\
client_id=$CLIENT_ID&\
redirect_uri=$REDIRECT_URI&\
scope=$SCOPE&\
state=$STATE&\
code_challenge=$CODE_CHALLENGE&\
code_challenge_method=S256"
```

#### 4. 토큰 교환

```bash
# Authorization Code Grant
curl -X POST "https://api.yourdomain.com/oauth2/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic $(echo -n 'your-client-id:your-client-secret' | base64)" \
  -d "grant_type=authorization_code&\
code=auth-code-from-callback&\
redirect_uri=https://yourapp.com/callback&\
code_verifier=your-code-verifier"
```

#### 5. 토큰 갱신

```bash
# Refresh Token Grant
curl -X POST "https://api.yourdomain.com/oauth2/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic $(echo -n 'your-client-id:your-client-secret' | base64)" \
  -d "grant_type=refresh_token&\
refresh_token=your-refresh-token"
```

#### 6. 사용자 정보 조회

```bash
# UserInfo 엔드포인트
curl -X GET "https://api.yourdomain.com/oauth2/userinfo" \
  -H "Authorization: Bearer your-access-token"
```

### JavaScript/TypeScript (순수 함수)

#### 보안 유틸리티 함수들

```javascript
// 안전한 랜덤 값 생성
async function generateSecureRandom(length = 32) {
  const array = new Uint8Array(length);
  crypto.getRandomValues(array);
  return arrayToBase64Url(array);
}

// ArrayBuffer를 Base64URL로 변환
function arrayToBase64Url(array) {
  const base64 = btoa(String.fromCharCode(...array));
  return base64.replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "");
}

// PKCE 챌린지 생성
async function generatePKCE() {
  const codeVerifier = await generateSecureRandom(32);
  const encoder = new TextEncoder();
  const data = encoder.encode(codeVerifier);
  const hash = await crypto.subtle.digest("SHA-256", data);
  const codeChallenge = arrayToBase64Url(new Uint8Array(hash));

  return {
    codeVerifier,
    codeChallenge,
    codeChallengeMethod: "S256",
  };
}

// 상태 파라미터 생성
async function generateState() {
  return await generateSecureRandom(16);
}
```

#### 인증 플로우 구현

```javascript
// 1. 인증 초기화
async function initializeAuth(clientId, redirectUri, scopes = ["read:user"]) {
  const state = await generateState();
  const pkce = await generatePKCE();

  // 세션 스토리지에 보안 값 저장
  sessionStorage.setItem("oauth_state", state);
  sessionStorage.setItem("oauth_code_verifier", pkce.codeVerifier);

  // 인증 URL 생성
  const params = new URLSearchParams({
    response_type: "code",
    client_id: clientId,
    redirect_uri: redirectUri,
    scope: scopes.join(" "),
    state: state,
    code_challenge: pkce.codeChallenge,
    code_challenge_method: "S256",
  });

  const authUrl = `https://api.yourdomain.com/oauth2/authorize?${params.toString()}`;

  return { authUrl, state, codeVerifier: pkce.codeVerifier };
}

// 2. 콜백 처리
async function handleCallback(callbackUrl) {
  const url = new URL(callbackUrl);
  const code = url.searchParams.get("code");
  const state = url.searchParams.get("state");
  const error = url.searchParams.get("error");

  if (error) {
    throw new Error(`OAuth2 Error: ${error}`);
  }

  // 상태 검증
  const storedState = sessionStorage.getItem("oauth_state");
  if (!state || state !== storedState) {
    throw new Error("Invalid state parameter");
  }

  if (!code) {
    throw new Error("Authorization code missing");
  }

  const codeVerifier = sessionStorage.getItem("oauth_code_verifier");

  // 세션 정리
  sessionStorage.removeItem("oauth_state");
  sessionStorage.removeItem("oauth_code_verifier");

  return { code, codeVerifier };
}

// 3. 토큰 교환
async function exchangeCode(code, codeVerifier, clientId, clientSecret, redirectUri) {
  const params = new URLSearchParams({
    grant_type: "authorization_code",
    client_id: clientId,
    code: code,
    redirect_uri: redirectUri,
    code_verifier: codeVerifier,
  });

  const response = await fetch("https://api.yourdomain.com/oauth2/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: `Basic ${btoa(`${clientId}:${clientSecret}`)}`,
    },
    body: params.toString(),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Token exchange failed: ${error.error_description || error.error}`);
  }

  return response.json();
}

// 4. 토큰 갱신
async function refreshToken(refreshToken, clientId, clientSecret) {
  const params = new URLSearchParams({
    grant_type: "refresh_token",
    client_id: clientId,
    refresh_token: refreshToken,
  });

  const response = await fetch("https://api.yourdomain.com/oauth2/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      Authorization: `Basic ${btoa(`${clientId}:${clientSecret}`)}`,
    },
    body: params.toString(),
  });

  if (!response.ok) {
    const error = await response.json();
    throw new Error(`Token refresh failed: ${error.error_description || error.error}`);
  }

  return response.json();
}

// 5. 사용자 정보 조회
async function getUserInfo(accessToken) {
  const response = await fetch("https://api.yourdomain.com/oauth2/userinfo", {
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  if (!response.ok) {
    throw new Error("Failed to fetch user info");
  }

  return response.json();
}
```

#### 사용 예제

```javascript
// 설정
const CLIENT_ID = "your-client-id";
const CLIENT_SECRET = "your-client-secret";
const REDIRECT_URI = "https://yourapp.com/callback";

// 인증 시작
document.getElementById("login-btn").addEventListener("click", async () => {
  try {
    const { authUrl } = await initializeAuth(CLIENT_ID, REDIRECT_URI, ["read:user"]);
    window.location.href = authUrl; // 리다이렉트
  } catch (error) {
    console.error("Login failed:", error);
  }
});

// 콜백 처리 (콜백 페이지에서)
async function handleOAuthCallback() {
  try {
    const { code, codeVerifier } = await handleCallback(window.location.href);
    const tokens = await exchangeCode(code, codeVerifier, CLIENT_ID, CLIENT_SECRET, REDIRECT_URI);

    // 토큰 저장
    sessionStorage.setItem("access_token", tokens.access_token);
    sessionStorage.setItem("refresh_token", tokens.refresh_token);

    // 사용자 정보 조회
    const userInfo = await getUserInfo(tokens.access_token);
    console.log("User info:", userInfo);
  } catch (error) {
    console.error("Callback handling failed:", error);
  }
}
```

### Python

#### 보안 유틸리티 함수들

```python
import secrets
import hashlib
import base64

def generate_secure_random(length=32):
    """안전한 랜덤 값 생성"""
    random_bytes = secrets.token_bytes(length)
    return base64.urlsafe_b64encode(random_bytes).decode('utf-8').rstrip('=')

def generate_pkce():
    """PKCE 챌린지 생성"""
    code_verifier = generate_secure_random(32)
    code_challenge = base64.urlsafe_b64encode(
        hashlib.sha256(code_verifier.encode('utf-8')).digest()
    ).decode('utf-8').rstrip('=')

    return {
        'code_verifier': code_verifier,
        'code_challenge': code_challenge,
        'code_challenge_method': 'S256'
    }

def generate_state():
    """상태 파라미터 생성"""
    return generate_secure_random(16)
```

#### 인증 플로우 구현

```python
import requests
from urllib.parse import urlencode

class OAuth2Client:
    def __init__(self, client_id, client_secret, redirect_uri, base_url='https://api.yourdomain.com'):
        self.client_id = client_id
        self.client_secret = client_secret
        self.redirect_uri = redirect_uri
        self.base_url = base_url

    def initialize_auth(self, scopes=['read:user']):
        """인증 초기화"""
        state = generate_state()
        pkce = generate_pkce()

        # 세션에 보안 값 저장 (실제 구현시 세션 관리 필요)
        self._state = state
        self._code_verifier = pkce['code_verifier']

        params = {
            'response_type': 'code',
            'client_id': self.client_id,
            'redirect_uri': self.redirect_uri,
            'scope': ' '.join(scopes),
            'state': state,
            'code_challenge': pkce['code_challenge'],
            'code_challenge_method': 'S256'
        }

        auth_url = f"{self.base_url}/oauth2/authorize?{urlencode(params)}"
        return auth_url

    def exchange_code(self, code):
        """토큰 교환"""
        data = {
            'grant_type': 'authorization_code',
            'client_id': self.client_id,
            'code': code,
            'redirect_uri': self.redirect_uri,
            'code_verifier': self._code_verifier
        }

        auth = (self.client_id, self.client_secret)
        response = requests.post(
            f"{self.base_url}/oauth2/token",
            data=data,
            auth=auth
        )

        if response.status_code != 200:
            error = response.json()
            raise Exception(f"Token exchange failed: {error.get('error_description', error.get('error'))}")

        return response.json()

    def refresh_token(self, refresh_token):
        """토큰 갱신"""
        data = {
            'grant_type': 'refresh_token',
            'client_id': self.client_id,
            'refresh_token': refresh_token
        }

        auth = (self.client_id, self.client_secret)
        response = requests.post(
            f"{self.base_url}/oauth2/token",
            data=data,
            auth=auth
        )

        if response.status_code != 200:
            error = response.json()
            raise Exception(f"Token refresh failed: {error.get('error_description', error.get('error'))}")

        return response.json()

    def get_user_info(self, access_token):
        """사용자 정보 조회"""
        headers = {'Authorization': f'Bearer {access_token}'}
        response = requests.get(f"{self.base_url}/oauth2/userinfo", headers=headers)

        if response.status_code != 200:
            raise Exception('Failed to fetch user info')

        return response.json()
```

### Java

#### 보안 유틸리티 클래스

```java
import java.security.SecureRandom;
import java.security.MessageDigest;
import java.util.Base64;
import java.nio.charset.StandardCharsets;

public class OAuth2Utils {
    private static final SecureRandom secureRandom = new SecureRandom();

    public static String generateSecureRandom(int length) {
        byte[] randomBytes = new byte[length];
        secureRandom.nextBytes(randomBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(randomBytes);
    }

    public static PKCEData generatePKCE() throws Exception {
        String codeVerifier = generateSecureRandom(32);
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(codeVerifier.getBytes(StandardCharsets.UTF_8));
        String codeChallenge = Base64.getUrlEncoder().withoutPadding().encodeToString(hash);

        return new PKCEData(codeVerifier, codeChallenge, "S256");
    }

    public static String generateState() {
        return generateSecureRandom(16);
    }

    public static class PKCEData {
        public final String codeVerifier;
        public final String codeChallenge;
        public final String codeChallengeMethod;

        public PKCEData(String codeVerifier, String codeChallenge, String codeChallengeMethod) {
            this.codeVerifier = codeVerifier;
            this.codeChallenge = codeChallenge;
            this.codeChallengeMethod = codeChallengeMethod;
        }
    }
}
```

#### 인증 클라이언트 클래스

```java
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import com.fasterxml.jackson.databind.ObjectMapper;

public class OAuth2Client {
    private final String clientId;
    private final String clientSecret;
    private final String redirectUri;
    private final String baseUrl;
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;

    // 세션 저장용 (실제 구현시 세션 관리 필요)
    private String state;
    private String codeVerifier;

    public OAuth2Client(String clientId, String clientSecret, String redirectUri) {
        this(clientId, clientSecret, redirectUri, "https://api.yourdomain.com");
    }

    public OAuth2Client(String clientId, String clientSecret, String redirectUri, String baseUrl) {
        this.clientId = clientId;
        this.clientSecret = clientSecret;
        this.redirectUri = redirectUri;
        this.baseUrl = baseUrl;
        this.httpClient = HttpClient.newHttpClient();
        this.objectMapper = new ObjectMapper();
    }

    public String initializeAuth(String[] scopes) throws Exception {
        this.state = OAuth2Utils.generateState();
        OAuth2Utils.PKCEData pkce = OAuth2Utils.generatePKCE();
        this.codeVerifier = pkce.codeVerifier;

        String scopeParam = String.join(" ", scopes);
        String params = String.format(
            "response_type=code&client_id=%s&redirect_uri=%s&scope=%s&state=%s&code_challenge=%s&code_challenge_method=%s",
            URLEncoder.encode(clientId, StandardCharsets.UTF_8),
            URLEncoder.encode(redirectUri, StandardCharsets.UTF_8),
            URLEncoder.encode(scopeParam, StandardCharsets.UTF_8),
            URLEncoder.encode(state, StandardCharsets.UTF_8),
            URLEncoder.encode(pkce.codeChallenge, StandardCharsets.UTF_8),
            URLEncoder.encode(pkce.codeChallengeMethod, StandardCharsets.UTF_8)
        );

        return baseUrl + "/oauth2/authorize?" + params;
    }

    public String exchangeCode(String code) throws Exception {
        String data = String.format(
            "grant_type=authorization_code&client_id=%s&code=%s&redirect_uri=%s&code_verifier=%s",
            URLEncoder.encode(clientId, StandardCharsets.UTF_8),
            URLEncoder.encode(code, StandardCharsets.UTF_8),
            URLEncoder.encode(redirectUri, StandardCharsets.UTF_8),
            URLEncoder.encode(codeVerifier, StandardCharsets.UTF_8)
        );

        String auth = Base64.getEncoder().encodeToString(
            (clientId + ":" + clientSecret).getBytes(StandardCharsets.UTF_8)
        );

        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/oauth2/token"))
            .header("Content-Type", "application/x-www-form-urlencoded")
            .header("Authorization", "Basic " + auth)
            .POST(HttpRequest.BodyPublishers.ofString(data))
            .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new RuntimeException("Token exchange failed: " + response.body());
        }

        return response.body();
    }

    public String refreshToken(String refreshToken) throws Exception {
        String data = String.format(
            "grant_type=refresh_token&client_id=%s&refresh_token=%s",
            URLEncoder.encode(clientId, StandardCharsets.UTF_8),
            URLEncoder.encode(refreshToken, StandardCharsets.UTF_8)
        );

        String auth = Base64.getEncoder().encodeToString(
            (clientId + ":" + clientSecret).getBytes(StandardCharsets.UTF_8)
        );

        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/oauth2/token"))
            .header("Content-Type", "application/x-www-form-urlencoded")
            .header("Authorization", "Basic " + auth)
            .POST(HttpRequest.BodyPublishers.ofString(data))
            .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new RuntimeException("Token refresh failed: " + response.body());
        }

        return response.body();
    }

    public String getUserInfo(String accessToken) throws Exception {
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/oauth2/userinfo"))
            .header("Authorization", "Bearer " + accessToken)
            .GET()
            .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new RuntimeException("Failed to fetch user info");
        }

        return response.body();
    }
}
```
