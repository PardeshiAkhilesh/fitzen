import os
import time
import hashlib
import requests
from typing import Optional, Dict, Any
from datetime import datetime, timedelta, timezone

from dotenv import load_dotenv
from jose import jwt, JWTError
from passlib.context import CryptContext

load_dotenv()

# ================================
# 🔐 LOCAL JWT CONFIG (Manual Auth)
# ================================
SECRET_KEY = os.getenv("JWT_SECRET_KEY", "change-this-in-prod")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))

# ================================
# 🔐 SUPABASE CONFIG (OAuth)
# ================================
SUPABASE_URL = os.getenv("SUPABASE_URL")
if not SUPABASE_URL:
    raise RuntimeError("SUPABASE_URL not set")

JWKS_URL = f"{SUPABASE_URL.rstrip('/')}/auth/v1/.well-known/jwks.json"
ISSUER = f"{SUPABASE_URL.rstrip('/')}/auth/v1"
AUDIENCE = "authenticated"

# ================================
# 🔑 PASSWORD HASHING
# ================================
pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto",
    bcrypt__rounds=12
)

def _prehash_password(password: str) -> str:
    return hashlib.sha256(password.encode("utf-8")).hexdigest()

def hash_password(password: str) -> str:
    return pwd_context.hash(_prehash_password(password))

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(_prehash_password(plain_password), hashed_password)

# ================================
# 🪪 LOCAL JWT (Manual Login)
# ================================
def create_access_token(data: Dict[str, Any], expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()

    expire = datetime.now(timezone.utc) + (
        expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )

    to_encode.update({"exp": expire})

    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

# ================================
# 🌐 JWKS CACHE
# ================================
_jwks_cache = None
_jwks_cache_time = 0
JWKS_CACHE_TTL = 3600  # 1 hour

def get_jwks() -> Optional[Dict[str, Any]]:
    global _jwks_cache, _jwks_cache_time

    now = time.time()

    if _jwks_cache and (now - _jwks_cache_time) < JWKS_CACHE_TTL:
        return _jwks_cache

    try:
        response = requests.get(JWKS_URL, timeout=5)  # ✅ NO HEADERS
        response.raise_for_status()

        _jwks_cache = response.json()
        _jwks_cache_time = now

        print("✅ JWKS fetched")

        return _jwks_cache

    except requests.RequestException as e:
        print(f"❌ JWKS fetch failed: {e}")
        return None

# ================================
# 🔍 TOKEN DECODING (DUAL AUTH)
# ================================
def decode_access_token(token: str) -> Optional[Dict[str, Any]]:
    """
    Supports:
    - Supabase JWT (ES256 via JWKS)
    - Local JWT (HS256)
    """

    if not token:
        print("❌ Token missing")
        return None

    # -------------------------------
    # 🟢 Try Supabase JWT (JWKS)
    # -------------------------------
    try:
        header = jwt.get_unverified_header(token)
        kid = header.get("kid")

        if kid:
            jwks = get_jwks()

            if not jwks:
                print("❌ JWKS not available")
                return None

            for key in jwks.get("keys", []):
                if key["kid"] == kid:
                    try:
                        payload = jwt.decode(
                            token,
                            key,
                            algorithms=["ES256", "RS256"],  # ✅ supports both
                            audience=AUDIENCE,
                            issuer=ISSUER,
                        )
                        print("✅ Supabase JWT verified")
                        return payload

                    except JWTError as e:
                        print(f"❌ Supabase JWT decode failed: {e}")
                        return None

            print(f"❌ No matching key found for kid: {kid}")
            return None

    except JWTError as e:
        print(f"⚠️ Failed to read token header: {e}")

    # -------------------------------
    # 🟡 Fallback: Local JWT (ONLY if no kid)
    # -------------------------------
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        print("✅ Local JWT verified")
        return payload

    except JWTError as e:
        print(f"❌ Local JWT failed: {e}")
        return None