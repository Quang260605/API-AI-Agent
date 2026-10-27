---
name: zero-leak-security-guard
description: >
  Giao thức bảo mật chống rò rỉ mật khẩu, API key, token, khóa riêng tư và dữ liệu nhạy cảm
  (Zero-Leak & Anti-Exfiltration). Kích hoạt BẮT BUỘC khi làm việc với file .env, cấu hình
  xác thực, biến môi trường, quét bảo mật, chụp màn hình hệ thống, hoặc chạy các lệnh có nguy cơ
  xóa/thay đổi dữ liệu.
version: 2.0.0
---

# Zero-Leak Security & Anti-Exfiltration Guard

## 1. Kiểm Tra Bí Mật Mù (Blind Credential Verification)
- **CẤM TUYỆT ĐỐI** chạy các lệnh làm hiển thị giá trị mật khẩu/API key ra màn hình hoặc ngữ cảnh của AI:
  - ❌ Cấm: `cat .env`, `type .env`, `Get-Content .env`, `printenv`, `set`, `Get-ChildItem Env:`, `echo $SECRET`, `grep "KEY" .env` (không có `-q`).
- **CHỈ kiểm tra sự tồn tại bằng mã thoát (Boolean Check)**:
  - **Bash**: `grep -sq "^CREDENTIAL_NAME=." ~/.env && echo "PRESENT" || echo "MISSING"`
  - **PowerShell**: `if ((Test-Path ".env") -and (Select-String -Path ".env" -Pattern "^CREDENTIAL_NAME=.+" -Quiet)) { "PRESENT" } else { "MISSING" }`
- **CẤM yêu cầu người dùng dán mật khẩu/API key vào khung chat**:
  - Cung cấp lệnh terminal ẩn ký tự (`read -s` trên Bash hoặc `Read-Host -AsSecureString` trên PowerShell) để người dùng tự nhập trực tiếp vào `.env`.

## 2. Tự Động Che Giấu (`[REDACTED]`) & Cắt Bỏ Đoạn Mã Nhạy Cảm
- Trước khi tạo báo cáo, log, hoặc git commit, thay thế mọi giá trị mật khẩu, token (`sk-...`, `ghp_...`, `AIza...`, `AKIA...`, JWT `eyJ...`), mật khẩu trong URL (`user:pass@host`), khóa riêng tư (`PRIVATE KEY`), và tên tài khoản máy tính (`C:\Users\<Name>`) thành `[REDACTED]`.
- Áp dụng **Longest-First Redaction**: thay thế chuỗi bí mật dài nhất trước để không làm lộ phần chuỗi con.
- Với lỗi bảo mật hardcoded credentials (CWE-798), chỉ ghi `file:line`, tuyệt đối không trích dẫn dòng code chứa mật khẩu.
- Có thể chạy công cụ offline đi kèm: `python secret_guard.py <path> --redact`.

## 3. Chống Thất Thoát Qua Mạng & Ảnh Chụp Màn Hình
- Luôn đặt `ANONYMIZED_TELEMETRY=false`, `DO_NOT_TRACK=1`, `POSTHOG_API_KEY=""`.
- Không đính kèm dữ liệu nội bộ vào URL/body gửi tới domain bên thứ ba.
- Trước khi gọi `Screenshot` / `Snapshot`, kiểm tra cửa sổ đang mở; nếu có trình quản lý mật khẩu, `.env` hoặc ngân hàng, chỉ dùng `use_dom=True` (`use_vision=False`) hoặc giới hạn `region=[l,t,r,b]`.

## 4. Chốt Chặn Thao Tác Hủy Dữ Liệu (Stop-and-Verify)
- Dừng lại, giải thích rõ tác động và xin phép người dùng trước mọi lệnh xóa dữ liệu (`DROP`, `TRUNCATE`, `rm -rf`, `Remove-Item -Recurse`, `git reset --hard`, sửa/xóa Registry, `kill` tiến trình).
