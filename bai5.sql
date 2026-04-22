
CREATE DATABASE session02;
USE session02;

-- 1. Tạo bảng Ví tiền (WALLETS)
CREATE TABLE WALLETS (
    WalletID INT PRIMARY KEY,               -- [PRIMARY KEY]: Định danh ví
    UserID INT NOT NULL UNIQUE,              -- [UNIQUE]: 1 khách hàng chỉ có 1 ví duy nhất
                                             -- [NOT NULL]: Ví phải thuộc về ai đó
    Balance DECIMAL(18, 2) NOT NULL DEFAULT 0.00, 
                                             -- [DEFAULT]: Mới tạo ví thì có 0 đồng
    CONSTRAINT chk_balance_positive CHECK (Balance >= 0), 
                                             -- [CHECK]: Chặn rủi ro số dư âm (Nỗi đau số 1)
    FOREIGN KEY (UserID) REFERENCES USERS(UserID) 
                                             -- [FOREIGN KEY]: Kết nối với bảng người dùng
);

-- 2. Tạo bảng Lịch sử giao dịch (TRANSACTION_HISTORY)
CREATE TABLE TRANSACTION_HISTORY (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT, -- [PRIMARY KEY]
    WalletID INT NOT NULL,                        -- [NOT NULL]: Giao dịch phải có ví
    TransactionType VARCHAR(20) NOT NULL,         -- [NOT NULL]: Nạp/Rút/Thanh toán
    Amount DECIMAL(18, 2) NOT NULL,               -- [NOT NULL]
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP, 
                                                  -- [DEFAULT]: Tự ghi lại giờ giao dịch
    Status BOOLEAN DEFAULT FALSE,                 -- [DEFAULT]: Mặc định là chưa xử lý (0)
    
    CONSTRAINT chk_amount_positive CHECK (Amount > 0), 
                                                  -- [CHECK]: Số tiền giao dịch phải > 0
    FOREIGN KEY (WalletID) REFERENCES WALLETS(WalletID) 
                                                  -- [FOREIGN KEY]: Giao dịch phải thuộc ví tồn tại
);