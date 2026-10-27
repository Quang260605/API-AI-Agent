---
name: distinctive-ui-and-playground
description: >
  Kỹ năng thiết kế giao diện chống rập khuôn AI (Anti-Slop Frontend Design) và tạo báo cáo/công cụ
  HTML tương tác tự chứa (Interactive HTML Playground & Deliverables). Kích hoạt khi xây dựng UI/UX,
  website, dashboard, hoặc xuất báo cáo trực quan.
version: 2.0.0
---

# Distinctive UI Design & Interactive HTML Playground

## 1. Bộ Lọc Chống Giao Diện AI Rập Khuôn (Anti-Slop Filter)
Tránh các dấu hiệu mặc định khiến giao diện trông như sản phẩm tạo tự động đại trà (trừ khi người dùng yêu cầu cụ thể):
- ❌ Nền kem ấm (`#F4F1EA`) kết hợp chữ serif tương phản cao và màu nhấn cam đất (`#D97757`).
- ❌ Nền đen (`#0B0B0B`) với duy nhất một màu xanh neon hoặc đỏ chói.
- ❌ Bộ "SaaS Card Kit": chia mọi nội dung thành các thẻ bo góc giống hệt nhau, cùng một bóng mờ `rgba(0,0,0,0.1)`, phủ gradient trang trí vô nghĩa.
- ❌ Nhãn phụ (eyebrow) VIẾT HOA GIÃN CHỮ trên mọi tiêu đề; đánh số `01 / 02 / 03` cho các mục không có tính tuần tự; gắn mũi tên `→` vào mọi nút bấm; dùng dấu `—` ở mọi tiêu đề phụ; in nghiêng/đổi màu đúng 1 từ trong tiêu đề chính.

## 2. Quy Trình Thiết Kế 2 Pha (Plan $\rightarrow$ Critique $\rightarrow$ Build)
1. **Pha 1 — Hệ thống Token & Wireframe ASCII**:
   - Chọn bảng màu 4–6 mã hex đặt tên rõ ràng, bám sát lĩnh vực thực tế của sản phẩm.
   - Chọn tối đa 1–2 họ font có phân cấp rõ ràng (độ dài dòng `< 80ch`, cỡ chữ tối thiểu `12px`).
   - Phác thảo bố cục bằng ASCII wireframe.
2. **Pha 2 — Tự phản biện & Tiết chế (Restraint)**:
   - Kiểm tra xem bố cục có bị trùng lặp với template mặc định không.
   - Dồn điểm nhấn thị giác vào **một khu vực duy nhất (Hero / Interactive Moment)**; giữ các phần còn lại tinh gọn, chuẩn responsive và hỗ trợ điều hướng bàn phím.
   - Ngôn từ giao diện (UX Copy): Dùng câu chủ động, nút bấm ghi rõ hành động thực tế (ví dụ: `"Lưu thay đổi"` thay vì `"Gửi"`), thông báo lỗi chỉ rõ nguyên nhân và cách khắc phục.

## 3. Quy Tắc Xuất Báo Cáo & Playground Tự Chứa (Deliverable Rules)
- **Tài liệu kỹ thuật, đặc tả, hướng dẫn**: Xuất file `.md`.
- **Dashboard, báo cáo điều hành, công cụ thử nghiệm (Playground)**: Xuất thành **1 file `.html` tự chứa duy nhất** (Self-contained HTML với inline CSS/JS), có thanh điều khiển tương tác trực tiếp (live preview, bộ lọc, thanh trượt) và nút Copy kết quả/cấu hình.
