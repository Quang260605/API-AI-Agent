#!/usr/bin/env python3
"""
secret_guard.py — Công cụ quét & tự động che giấu (redact) mật khẩu, API key, token,
khóa riêng tư và đường dẫn cá nhân hoàn toàn OFFLINE (không gửi dữ liệu đi đâu).

Chắt lọc từ:
- UI-TARS (@secretlint rules)
- Claude Security (scan-redactor Longest-First Redaction protocol)

Cách dùng:
  1. Chỉ kiểm tra (Scan mode - trả về exit code 1 nếu phát hiện lộ bí mật):
     python secret_guard.py <file_hoặc_thư_mục>

  2. Tự động che giấu thành [REDACTED] (Redact mode):
     python secret_guard.py <file_hoặc_thư_mục> --redact
"""

from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

# Các mẫu nhận diện mật khẩu, API key, token, private key, chuỗi kết nối
SECRET_PATTERNS: list[tuple[str, re.Pattern[str]]] = [
    (
        "Private Key Block",
        re.compile(
            r"-----BEGIN (?:RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----[\s\S]+?-----END (?:RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----"
        ),
    ),
    (
        "Anthropic / OpenAI / Vendor API Key",
        re.compile(r"\b(?:sk-ant-[a-zA-Z0-9_-]{20,}|sk-(?:proj-)?[a-zA-Z0-9_-]{20,})\b"),
    ),
    (
        "GitHub Token",
        re.compile(r"\b(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9_]{30,}\b|\bgithub_pat_[A-Za-z0-9_]{40,}\b"),
    ),
    (
        "Google / Gemini API Key",
        re.compile(r"\bAIza[0-9A-Za-z_-]{35}\b"),
    ),
    (
        "AWS Access Key ID",
        re.compile(r"\b(?:AKIA|ASIA)[0-9A-Z]{16}\b"),
    ),
    (
        "Slack Token",
        re.compile(r"\bxox[baprs]-[0-9a-zA-Z-]{10,}\b"),
    ),
    (
        "JWT Token",
        re.compile(r"\beyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b"),
    ),
    (
        "URL Credential (user:password@host)",
        re.compile(r"[a-zA-Z][a-zA-Z0-9+.-]*://[^/\s:@]+:(?!\[REDACTED\]|<[^>]+>|password\b)([^@\s\"'`]{4,})@"),
    ),
    (
        "Generic Password / Secret / Token Assignment",
        re.compile(
            r"(?i)\b(?:password|passwd|pwd|secret|api[_-]?key|auth[_-]?key|access[_-]?token|client[_-]?secret)\b"
            r"\s*[:=]\s*['\"]?(?!\[REDACTED\]|your_[a-z_]+|YOUR_[A-Z_]+|<[^>]+>|\$[A-Za-z_{][A-Za-z0-9_}]*|true|false|null|none|\d+\.\d+)"
            r"([A-Za-z0-9_!@#$%^&*+=-]{8,})['\"]?"
        ),
    ),
]

SKIP_DIRS = {".git", "node_modules", ".venv", "venv", "__pycache__", "dist", "build"}
SKIP_EXTENSIONS = {".png", ".jpg", ".jpeg", ".gif", ".ico", ".pdf", ".exe", ".dll", ".zip", ".7z", ".rar", ".woff", ".woff2"}


def scan_text(text: str) -> list[tuple[str, str, int]]:
    """Trả về danh sách (loại_secret, giá_trị_bắt_được, dòng) mà KHÔNG in giá trị thật ra màn hình."""
    findings: list[tuple[str, str, int]] = []
    for label, pattern in SECRET_PATTERNS:
        for match in pattern.finditer(text):
            secret_val = match.group(1) if match.lastindex else match.group(0)
            line_no = text.count("\n", 0, match.start()) + 1
            findings.append((label, secret_val, line_no))
    return findings


def redact_text(text: str, findings: list[tuple[str, str, int]]) -> str:
    """Nguyên tắc Longest-First Redaction từ Claude Security: thay chuỗi dài nhất trước."""
    unique_secrets = sorted({val for _, val, _ in findings if len(val) >= 6}, key=len, reverse=True)
    redacted = text
    for secret_val in unique_secrets:
        redacted = redacted.replace(secret_val, "[REDACTED]")
    return redacted


def mask_preview(val: str) -> str:
    """Chỉ hiển thị độ dài và 2 ký tự đầu để người dùng biết vị trí mà không làm lộ mật khẩu."""
    if len(val) <= 4:
        return "***"
    return f"{val[:2]}...({len(val)} chars)"


def iter_files(target: Path):
    if target.is_file():
        yield target
        return
    for root, dirs, files in os.walk(target):
        dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
        for f in files:
            p = Path(root) / f
            if p.suffix.lower() not in SKIP_EXTENSIONS:
                yield p


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if hasattr(sys.stderr, "reconfigure"):
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description="Quét và che giấu mật khẩu/API key an toàn (Offline).")
    parser.add_argument("target", help="Đường dẫn file hoặc thư mục cần kiểm tra")
    parser.add_argument("--redact", action="store_true", help="Tự động thay thế mọi secret phát hiện được bằng [REDACTED]")
    args = parser.parse_args()

    target_path = Path(args.target).resolve()
    if not target_path.exists():
        print(f"[ERROR] Không tìm thấy đường dẫn: {target_path}", file=sys.stderr)
        return 2

    total_findings = 0
    files_affected = 0

    for file_path in iter_files(target_path):
        try:
            content = file_path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, PermissionError, OSError):
            continue

        findings = scan_text(content)
        if not findings:
            continue

        files_affected += 1
        total_findings += len(findings)
        for label, val, line_no in findings:
            print(f"[DETECTED] {file_path}:{line_no} -> {label} [{mask_preview(val)}]")

        if args.redact:
            cleaned = redact_text(content, findings)
            if cleaned != content:
                file_path.write_text(cleaned, encoding="utf-8")
                print(f"[REDACTED] Đã làm sạch {len(findings)} giá trị nhạy cảm trong: {file_path}")

    if total_findings == 0:
        print("[OK] Không phát hiện mật khẩu hay khóa bí mật nào bị lộ.")
        return 0

    if args.redact:
        print(f"\n[DONE] Đã che giấu toàn bộ {total_findings} bí mật trên {files_affected} file.")
        return 0
    else:
        print(
            f"\n[WARNING] Phát hiện {total_findings} dấu hiệu bí mật trên {files_affected} file! "
            f"Chạy lại với cờ `--redact` để tự động thay bằng [REDACTED]."
        )
        return 1


if __name__ == "__main__":
    sys.exit(main())
