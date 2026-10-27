---
name: mcp-blackbox-qa-tester
description: >
  Kỹ năng kiểm thử hộp đen (Black-box QA), kiểm toán bộ test/CI bắt "test xanh giả" (Suspicious
  Green Tests Audit), kiểm thử hồi quy biên/vòng đời (Boundary & Lifecycle Regressions) và đo
  hiệu năng (Benchmark) cho các MCP Tool, API endpoint hoặc CLI. Kích hoạt khi người dùng yêu cầu
  test, validate, audit CI, benchmark, hoặc kiểm tra chất lượng một MCP server hay công cụ.
version: 3.0.0
---

# MCP, API & CI Black-Box QA Tester

## 1. Nguyên Tắc Cốt Lõi
- **Kiểm thử hộp đen thuần túy (Black-box only)**: Thiết kế test case dựa trên mô tả và JSON Schema của công cụ. Mọi điểm mơ hồ trong schema phải được ghi nhận là **Documentation Gap**.
- **Độc lập về Chuẩn Đúng (`Independent Correctness Oracle`)**: So sánh kết quả với một nguồn sự thật độc lập (file thực tế trên đĩa, công cụ hệ thống thứ hai), không bao giờ dùng cùng một bộ giải mã lỗi để tự kiểm tra chính nó.

## 2. Ma Trận 6 Nhóm Test Case Hộp Đen (Categories A–F)
1. **Category A — Basic Functionality**: Kiểm tra từng chế độ (`mode`/action) với tham số chuẩn.
2. **Category B — Parameter Variations & Union Coercion**:
   - Kiểm tra từng tham số tùy chọn, mọi giá trị `enum`, trạng thái `true`/`false`.
   - Với `anyOf: [boolean, string]`: test cả `true`/`false`, `"true"`/`"false"`, và chuỗi ngoài chuẩn (`"yes"`, `"1"`).
   - Với `anyOf: [<type>, null]`: test truyền `null` tường minh để bắt lỗi `TypeError`.
3. **Category C — Edge & Boundary Regressions**:
   - Chuỗi rỗng `""`, số `0`, số âm, ký tự Unicode/Emoji/đặc biệt, dữ liệu sát ngưỡng giới hạn bộ nhớ, `timeout=0`.
   - Phân biệt rõ các giá trị `omitted`, `null`, `empty`, `0`, và `false`.
4. **Category D — Error Handling & Partial Evidence**:
   - Thiếu tham số bắt buộc, sai kiểu dữ liệu, tài nguyên không tồn tại.
   - Khi thực thi chuỗi nhiều bước mà bước sau bị lỗi, kiểm tra xem dữ liệu hợp lệ của bước trước có được bảo toàn không.
5. **Category E — Cross-Mode Parameter Interaction**: Truyền tham số của chế độ A khi gọi chế độ B để xem công cụ có cảnh báo hay âm thầm bỏ qua.
6. **Category F — Idempotency & Lifecycle Regressions**:
   - Gọi 2 lần liên tiếp với cùng tham số cho các thao tác idempotent.
   - Kiểm tra hủy yêu cầu (`cancellation`) ngay trong lúc đang chạy VÀ trong lúc đang dọn dẹp (`final cleanup`), đảm bảo không rò rỉ tiến trình con hay file tạm.

## 3. Kiểm Toán "Test Xanh Giả" (`Suspicious Green Tests Audit`)
- Khi kiểm tra một bộ test có sẵn nhưng nghi ngờ test "xanh giả" (chỉ lặp lại `mock` hoặc gọi vào nhánh code chết):
  1. Chủ động làm lệch hành vi hoặc tiêm một lỗi có kiểm soát (fault injection/perturbation) vào bản nháp.
  2. Chạy lại test để xác nhận bài test **thực sự báo đỏ vì đúng nguyên nhân đó**.
  3. Khôi phục lại code gốc ngay sau khi kiểm chứng xong.
- Tuyệt đối không xóa assertion, tăng timeout vô căn cứ, hay thêm retry tràn lan chỉ để làm CI báo xanh.

## 4. Xác Minh Độc Lập & Dọn Dẹp An Toàn Theo PID
- **Mandatory Side-Effect Verification**: Mọi thao tác làm thay đổi trạng thái hệ thống (File, Registry, Process, Clipboard, DB) **bắt buộc** phải được kiểm chứng độc lập bằng công cụ thứ hai.
- **PID-Tracked Safe Teardown**: Ghi lại chính xác `PID` của tiến trình được tạo ra trong lúc test và chỉ đóng đúng `PID` đó khi kết thúc (tuyệt đối không `kill` theo tên ứng dụng).
