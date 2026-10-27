---
name: adversarial-verifier-siege
description: >
  Kỹ năng xác minh đối kháng trên ngữ cảnh mới (Fresh-Context Adversarial Verification), giải quyết
  vấn đề phức tạp theo vòng lặp (Siege: Judge - Worker - Evidence Ledger) và tách biệt ranh giới
  lập kế hoạch theo đặc tả (Spec-Driven Boundary). Kích hoạt khi cần sửa bug khó, kiểm toán bảo mật
  (Security Audit), thiết kế kiến trúc, hoặc chứng minh thuật toán.
version: 3.0.0
---

# Adversarial Verifier & Siege Problem Solver

## 1. Xác Minh Đối Kháng Ngữ Cảnh Mới (`Fresh-Context Adversarial Verifier`)
- Tự kiểm tra lời giải/code vừa viết trong cùng một luồng suy nghĩ rất dễ mắc thiên kiến xác nhận (confirmation bias).
- **Quy trình bắt buộc cho bài toán/bản vá quan trọng**:
  1. Tạo giải pháp hoặc bản vá nháp, kiểm tra cả nơi phát sinh dữ liệu (`producing boundary`) lẫn các nơi tiêu thụ (`affected consumers`).
  2. Khởi tạo một Subagent độc lập (fresh context) hoặc chuyển sang chế độ **Adversarial Critic** với nhiệm vụ duy nhất là **tìm cách đánh sập giải pháp** dựa trên danh sách mẫu lỗi:
     - *Biên & Chuẩn hóa*: `null`/`undefined`, tập rỗng, số âm, tràn số, Unicode, hai giá trị khác nhau bị gộp trùng sau khi chuẩn hóa.
     - *Đồng thời & Vòng đời*: Race condition, deadlock, hủy yêu cầu (`cancellation`) khi đang dọn dẹp, một tiến trình con lỗi trong khi tiến trình con khác thành công (`mixed child outcomes`).
     - *Bảo mật*: SQL/Command/Prompt Injection, SSRF, Path Traversal, lộ thông tin nhạy cảm.
  3. Chỉ chấp nhận giải pháp sau khi vượt qua vòng phản biện đối kháng và xóa bỏ các đoạn code vá víu cũ không còn cần thiết.

## 2. Chiến Thuật Bao Vây Đa Vòng (`Siege`: Judge – Worker – Evidence Ledger)
Khi xử lý bug hệ thống lớn hoặc bài toán phức tạp kéo dài nhiều bước:
1. **Khởi tạo Sổ cái bằng chứng (`ledger.md`)** theo 4 tầng sự thật để không bao giờ mất dấu kết quả:
   - ✅ **OBSERVED / PROVED**: Các khẳng định đã có log/test thực nghiệm chứng minh kèm mã định danh (`file:line` hoặc `evidence_id`).
   - 🔍 **INFERRED**: Giả thuyết suy luận hợp lý từ mã nguồn tĩnh nhưng chưa kiểm chứng lúc chạy (`runtime`).
   - ❌ **REFUTED**: Các giả thuyết đã bị bác bỏ (kèm lý do để không lặp lại).
   - ⏳ **UNKNOWN / OPEN**: Các câu hỏi mở cần điều tra ở vòng kế tiếp (thiếu dữ liệu $\neq$ không tồn tại).
2. **Chia vòng thực thi**: Ở mỗi vòng, tách các câu hỏi trong mục `UNKNOWN / OPEN` thành các phép thử độc lập, thực thi kiểm chứng, rồi cập nhật lại `ledger.md` cho đến khi giải quyết triệt để gốc rễ vấn đề.

## 3. Ranh Giới Lập Kế Hoạch Theo Đặc Tả (`Spec-Driven Planning Boundary`)
- Khi người dùng yêu cầu lập phương án hoặc thiết kế kiến trúc (`Propose`), hãy hoàn thành đầy đủ chuỗi đặc tả (`proposal` $\rightarrow$ `specs` $\rightarrow$ `design` $\rightarrow$ `tasks`) và dừng lại chờ người dùng duyệt trước khi bắt đầu sửa code (`Apply`).
