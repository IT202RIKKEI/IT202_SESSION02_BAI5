/* ================================================================
YÊU CẦU 3: LIỆT KÊ 3 KỊCH BẢN RỦI RO
1. Kịch bản "Số dư ma": Người dùng cố tình nạp/rút số tiền âm để gian lận số dư.
   => Chặn bằng: CHECK (Amount > 0) và CHECK (Balance >= 0).
2. Kịch bản "Ví lậu": Một UserID cố tình tạo nhiều ví để nhận khuyến mãi.
   => Chặn bằng: UNIQUE (UserID) trong bảng WALLETS.
3. Kịch bản "Giao dịch vô danh": Tạo giao dịch mà không gắn với ví nào hoặc thiếu thông tin tiền.
   => Chặn bằng: NOT NULL và FOREIGN KEY (WalletID).
================================================================
*/

CREATE DATABASE session02;
USE session02;

-- BỔ SUNG: Bảng USERS (Phải có bảng này trước thì mới làm khóa ngoại được)
CREATE TABLE USERS (
    UserID INT PRIMARY KEY,
    UserName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE
);

-- 1. Tạo bảng Ví tiền (WALLETS)
CREATE TABLE WALLETS (
    WalletID INT PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,              -- [UNIQUE]: 1 khách hàng - 1 ví
    Balance DECIMAL(18, 2) NOT NULL DEFAULT 0.00, 
    CONSTRAINT chk_balance_positive CHECK (Balance >= 0), -- Chặn nợ tiền
    FOREIGN KEY (UserID) REFERENCES USERS(UserID)        -- Khóa ngoại đã có bảng để trỏ tới
);

-- 2. Tạo bảng Lịch sử giao dịch (TRANSACTION_HISTORY)
CREATE TABLE TRANSACTION_HISTORY (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    WalletID INT NOT NULL,
    -- Tối ưu: Dùng ENUM để giới hạn các giá trị nhập vào, tránh lỗi chính tả
    TransactionType ENUM('NAP_TIEN', 'RUT_TIEN', 'THANH_TOAN') NOT NULL,
    Amount DECIMAL(18, 2) NOT NULL,
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- Tối ưu: Status dùng ENUM để thể hiện nhiều trạng thái thực tế hơn
    Status ENUM('PENDING', 'SUCCESS', 'FAILED') DEFAULT 'PENDING',
    
    CONSTRAINT chk_amount_positive CHECK (Amount > 0), -- Chặn nạp/rút số âm
    FOREIGN KEY (WalletID) REFERENCES WALLETS(WalletID)
);