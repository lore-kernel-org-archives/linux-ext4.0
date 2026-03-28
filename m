Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C222EB10
	for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774710056; cv=none; b=ES5/bn6AmL8pSJ7w5aGEYZ9s9ZIc9CWyu8T0zMbIQ42208W5KOyD7B+cu0VehVPLfxKN/n7kJA+kRrJlu+JnbfWnwO98kSp/8RQ7goNWrCSLDg/NLo36lZpGFchLQASnk6Io1bshswON31YTPSumfrX4kh7pa5Yojrux79xTdFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774710056; c=relaxed/simple;
	bh=8ZVqhZ/N1PdMAWTWRuymqWQ5zXGNYBpTlwAycXGZ7jQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TqgyNoZP9grOG1w4Hmwy7SkiCMlLYlidvxtgO2ZLkCHxeqTWFPuZBJ/heDJBZR+7p1JWWwwPD0crF8YSeVNAL9BJlmOHhUx5X8+MW4a8jEt+Veh0rXshEFWH+sFeGaFbr3ZL5wy2we5T5CgmPYNLDma5CLfleRspj3c0R3mhxKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZIMzOwRo; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZIMzOwRo"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c648bc907ebso2138967a12.3
        for <linux-ext4@vger.kernel.org>; Sat, 28 Mar 2026 08:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774710054; x=1775314854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qUWulkuc6nwiMpNnsS5d9tfMi0kH9Q6gq1CmIp5Vans=;
        b=ZIMzOwRodO5zXcjr7c0+2lIuw8j72Ts9rKKn5AJ2QeQnMZaYQ7h7kTVylQTn07Ji1j
         ey5RGjRuCLwc+BTHT3YcfzS9rSphFkwtRSHn1AjlNYNEYrlDmv9ikVyc8Y8NvnNh5VZ6
         B7ugRN7cd7IijXLArPvkhWrUyM0Dkbw4UF1CelGPTbEpw3qfkH9FIeOAcn9enYtHsWbQ
         /+/cY+Iw0aVEaCqCwKG2h5Vr3M5/TmjDaiE9wUxG3BnJTOm4Tt1NTLFT5aZlb/sfRUvq
         yZDdHzG4s0bhBCCaQPUbtSUvnsjbBI+jFE21KgJoCiW4uNrccE3uqYtOEg7KZzNn3AxY
         LU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774710054; x=1775314854;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qUWulkuc6nwiMpNnsS5d9tfMi0kH9Q6gq1CmIp5Vans=;
        b=O3FAiTpEX8rwlzeRNqmhUhs6M8XWgX6rDDDpZIEGZ/Rc0KwpLKgRsiitr8CdxD1SeR
         W5a3QLUfR3yld8DxgkCd0FUUX6q92gNi+YjxqM2DdX8NTdu0zVWRFNMBLAcmmnM7G25R
         htfA4X7WBI1mk1h0DuJGDAcJ/XNqdhYxqxGvAiYfdLg+8/GF2z8jooG3y18+gEgIAqHS
         8p6222xFucr8wJjfTgctGYgOhUU2YqsHVqpzfvaWu/tWkJy8nzxPBMWon9NUYc/sLfiL
         hd2tyQgnAZMDsfiRLgRR3zk7IU/qb9RqIzhK1rb66xaAdgVXiq0tS3RbqowpWZJkSr9D
         hVNQ==
X-Gm-Message-State: AOJu0Yzo0afr2KZ5eLQjJvf1hlsv5XnwayjnB9vJM6YwtdCSg5xvJ3PB
	5S7qIeW1DC+yT0KPZ+eBFle0VSCMTzK28VmtUyS4zxsIrwFnh8iPjYzb
X-Gm-Gg: ATEYQzzdPob33Z++RixbKn01x9WnRQs8640r3oe2fa6m7Ph1w/fEyulKhLph6AHb9qH
	X1TY/wdfCvaimYQqLIhHkK5NiL/IHTjAaYKzPeuCYnhcqPD0MgWxHMBBzuMPAqlEXQQ9g7S/tpZ
	0m+krHmPd80ckJhMtUOO5bkTCkijoP+6447ppAi89RAD9iVXvvyV945rhowA66fRh4yRppHyvBK
	huZQw4zKOwSPf/ORBqBwuks1G+KqfhcbvMMjOGuoRJKK/DuqK9G+Wz7FT7sKKgx0wZKQHaAuSOI
	MlCNgL0tRDI+J/0HCU4B1AmLsrBN7zyw6CyaEwbqvZbFFKdkIwIYrJVbBGIt94O8xxFL6gghS58
	lKLMXS4ltVZvDW+7s40QjJZEJ/X4/t5VcOXYRS6L0vmwIvAJ1et17YWD4LE08xyd3GtsAmGOGzg
	eR+2b42zBNjYJst87TgrfNtgTMiPmimvXNusB/vRtNKATeWmhh4lku1ToVuYSZXN1nep+gdaHF8
	eHjyzrjis9qn2HZZA==
X-Received: by 2002:a05:6a20:a12b:b0:398:9466:2eef with SMTP id adf61e73a8af0-39c87812061mr7154979637.12.1774710046987;
        Sat, 28 Mar 2026 08:00:46 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:7beb:e3a8:8b1a:3a0d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85fc6e9sm2653328b3a.46.2026.03.28.08.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 08:00:46 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: tytso@mit.edu,
	adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	stable@vger.kernel.org,
	syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Subject: [PATCH v2] ext4: fix bounds check in check_xattrs() to prevent out-of-bounds access
Date: Sat, 28 Mar 2026 20:30:38 +0530
Message-ID: <20260328150038.349497-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bounds check for the next xattr entry in check_xattrs() uses
(void *)next >= end, which allows next to point within sizeof(u32)
bytes of end. On the next loop iteration, IS_LAST_ENTRY() reads 4
bytes via *(__u32 *)(entry), which can overrun the valid xattr region.

For example, if next lands at end - 1, the check passes since
next < end, but IS_LAST_ENTRY() reads 4 bytes starting at end - 1,
accessing 3 bytes beyond the valid region.

Fix this by changing the check to (void *)next + sizeof(u32) > end,
ensuring there is always enough space for the IS_LAST_ENTRY() read
on the subsequent iteration.

Fixes: 3478c83cf26b ("ext4: improve xattr consistency checking and error reporting")
Cc: stable@vger.kernel.org
Reported-by: syzbot+fb32afec111a7d61b939@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fb32afec111a7d61b939
Link: https://lore.kernel.org/all/20260224231429.31361-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

---
v2: Move the fix to check_xattrs() as suggested by Ted Ts'o,
    instead of adding a check in ext4_xattr_ibody_get().
---
 fs/ext4/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7bf9ba19a89d..c6205b405efe 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -226,7 +226,7 @@ check_xattrs(struct inode *inode, struct buffer_head *bh,
 	/* Find the end of the names list */
 	while (!IS_LAST_ENTRY(e)) {
 		struct ext4_xattr_entry *next = EXT4_XATTR_NEXT(e);
-		if ((void *)next >= end) {
+		if ((void *)next + sizeof(u32) > end) {
 			err_str = "e_name out of bounds";
 			goto errout;
 		}
-- 
2.43.0

