Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA080363C77
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 05:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780981228; cv=none; b=Z+p4MUAoV9BGNu7LmEg3CYm26SU8fU6EZcw5FRmY9ZXb/uZ/FtzvvBp3wDrqbcm2zIPuI73+Y/NE3/5VjaNPeDGZV1iiYtRhsb7oVvLLQ5r8TaBAErSC6Onw3u6K670vQJ3G5SkM4cqsULpWGQS3PDqPi3DFSqpe5RfQst2hs8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780981228; c=relaxed/simple;
	bh=yaKP7/UvUzQTM1UAwBovHUg+etg/wRkptdb8tOq3nbY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q5M4V6t+IFsHx1oz5kHkTlltedwQBII+TrK3Dfsy1SoLmJdPhjJ0zrxUzmpD7OXc5b/aBK1Zes9RL/wAlysStOPsuHIxJ5LtY7vz76RysTbirTAr3gkJ/8dqMKhtdF6WXht8xHjj/oSb86kuoLlV+15XpSdDX6MoGFaw64RYKWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T1hFIbT9; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T1hFIbT9"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2bf3781ca51so47753475ad.0
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 22:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780981227; x=1781586027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fBlgRbs5zbK19LMQRjJDNeRT5MSpRwsmVLifXE9+D5M=;
        b=T1hFIbT9R8QTbb/qu9Gk47tvFch0v4pKf/C8LkdamMOudWdi5Ul9eyYHk6PqgxviXY
         dLpeFtFoKDYrO9U+7XP/vxpnmdplgSZktkuIVOGn9w4Q8RfWN0GqY1E/ABY02TvLErGf
         FIkoIPSeKKdbUx4zwwoXrgwL9jsf7ABo02yp2tsFJi/wqHevOlAuqLAvEb5X77WDM956
         MNKM8bC99QUxgaF6T66qQhHoVet+f5TNIFjuhK6ZZ+OMa652sIqiRqhDFD1DFu0X6vXp
         80AqAZCZX0ESiTlwfkzawG2qGW5NtCa+jphqyoyCSI3h2B/5XT8Xwu/Dq5U42DGcWIac
         g81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780981227; x=1781586027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBlgRbs5zbK19LMQRjJDNeRT5MSpRwsmVLifXE9+D5M=;
        b=hwxdfKst6pH+m+jKcBSt906fPDU3Jlz2hHoJNM5ZwRG7lNWzyaePaSCeKZyPscQ4ie
         KLv7y/gKwxBJRYHKa3CIBIxUfiVQ3vZsXiagGl1flvzHnrtNWf2YEnqjjmVWxISDkjYw
         uXiWr1GMaFJ3u9W2liFalV5WUbug/+XjtiKKDB/BIOwtr+KT38Gi0gfZJU4kGetfEBBF
         PwLWdPGl4jG6HJEMxFKG4zTyFksawmWQtmT8Ih+Sd/ik1nAomP8RpPzKXbWBtyp32zmu
         x2WAjg1DrLYIcXRMkUjnJh2wiTkqj1eDbDVXc1hFnX/r0alxlGABsRjXBZCdnUtKu2j/
         cVWQ==
X-Forwarded-Encrypted: i=1; AFNElJ/raQ7qXiP5tomT0BG+gC4PzHM1wz+bYVu8mw9J6v1hOtZWjm1cPIKE9nu1rjIwWjbn2g+QwTpEUgX+@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw1XlZlZMGgwWpFpbQUPuDsNDspXjfygZcrwulYTtDGj70JH6F
	1XKJYW6rrZl7lAIzMExNOdeakZPLGvE25S2EV/phgoqDCRXc1G5kpGFS
X-Gm-Gg: Acq92OHOOLVCD22fU/LSe9oGKPtDZwfT4fUUMaPmFlRb8faI9rI9ugDetx2fZlLa75+
	jJFWWqdpzQOKetKlYh7LkwZFTwxYxb66PrTu+zKql2daBmqU5C8X4eDCX7U1p3wAHjl2YfwUK1O
	BZJUFWn8OB12GS3LIEA8JA45bnRMdle3C5WXUhJ7ik5iOBpGzPdhdi9XkpTySScdlD2VDWMhyTl
	TKxQBqA0Geup2SdW5kDOiu9bBavODD0jT9n33aVlnBUM8iNAnw6jtpjCna8GlNDsFnzevya/9Ef
	ToKzGj/s6tFucxDP8rLnmfa/cxv6cZrtyMivz5+fuz/HVKmm+N2FJ4wIEwpzxbjQ1rX1XQLbewk
	TxaUUba7BKq/IxAoTzPRU+4UaWmOZT5T06JnKfBJavFt1aEnjVk+1hRqoat8aNWai4OGBaHnsht
	SjugPgvnNklhTEyzg8hAdeZK9HKlYhGo0EbHtnfFROS3ABwQVNyN/JBQ7TQZPv5VcjQS9dbl/gK
	rc+e0Dgvlurr80Zg9ZBtY4lA/mbccm0taqG2ABe8FSsAusfqtBRFPNgGb4TOsR5OgVCzzaXONX2
	eo0jA++27hS1zeeI2Ynz+ZsGqXwKoGO7b8m9fQOFJCfj4IHhig==
X-Received: by 2002:a17:902:fc4c:b0:2c2:1982:527a with SMTP id d9443c01a7336-2c2198254f0mr152300195ad.16.1780981222155;
        Mon, 08 Jun 2026 22:00:22 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (192.152.126.34.bc.googleusercontent.com. [34.126.152.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c166391d53sm254648635ad.65.2026.06.08.22.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 22:00:21 -0700 (PDT)
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	sashiko-reviews@lists.linux.dev,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Subject: [PATCH v3] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Tue,  9 Jun 2026 04:59:55 +0000
Message-ID: <20260609045956.1910-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the data=journal mount option is used, the ext4_journalled_write_end()
function incorrectly calls ext4_write_inline_data_end() without checking
if the EXT4_STATE_MAY_INLINE_DATA flag is still set on the inode.

If a previous attempt to convert the inline data to an extent failed (e.g.
due to ENOSPC), the EXT4_STATE_MAY_INLINE_DATA flag is cleared, but
the EXT4_INODE_INLINE_DATA flag remains set. In this scenario, the next
call to ext4_write_begin() will not prepare the inline data xattr for
writing, but ext4_journalled_write_end() will incorrectly attempt to write
to it, triggering a BUG_ON(pos + len > EXT4_I(inode)->i_inline_size) in
ext4_write_inline_data() since i_inline_size was not expanded.

Additionally, a concurrent ext4_page_mkwrite() can execute
ext4_convert_inline_data() between ext4_write_begin() and ext4_write_end()
since it only takes xattr_sem. This concurrent path converts the inline
data to an extent and clears both the EXT4_INODE_INLINE_DATA and
EXT4_STATE_MAY_INLINE_DATA flags. Since the block buffers were not
allocated in ext4_write_begin(), falling through to the block fallback path
causes a NULL pointer dereference because folio_buffers(folio) is NULL.

Fix this by ensuring that the write_end functions (including
ext4_write_end() and ext4_da_do_write_end()) safely return 0 to trigger
a VFS retry if they detect folio_buffers(folio) is NULL after falling
through from the inline data check. Returning 0 signals
generic_perform_write() to revert the write iterator and retry the
entire write operation, which will then properly allocate block buffers.

To prevent transaction handle leaks and subsequent filesystem hangs during
retries, we stop any active journal handle via ext4_journal_stop() before
returning 0. We also explicitly check that the retrieved handle is non-NULL
prior to stopping it, preventing a potential NULL pointer crash inside
ext4_put_nojournal().

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
v3:
  - Fix journal handle leak in ext4_da_do_write_end() by stopping the active
    handle before returning 0 on the fallback path.
  - Safely check if the retrieved handle is non-NULL before calling
    ext4_journal_stop() in ext4_write_end() and ext4_journalled_write_end()
    to prevent a kernel crash inside ext4_put_nojournal().
v2:
  - Address TOCTOU race condition (reported by Sashiko AI review):
    A concurrent ext4_page_mkwrite() can execute ext4_convert_inline_data()
    which takes xattr_sem and converts the inline data to extents, clearing
    both EXT4_INODE_INLINE_DATA and EXT4_STATE_MAY_INLINE_DATA flags between
    ext4_write_begin() and write_end().
  - Safely return 0 from write_end functions if folio_buffers(folio) is NULL
    to trigger a VFS retry. This prevents a NULL pointer dereference in
    ext4_journalled_zero_new_buffers() and ext4_walk_page_buffers().
  - Add check for ext4_write_end() and ext4_da_do_write_end().
 fs/ext4/inode.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c2c2d6ac7f3d..bc2688e03c19 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1455,6 +1455,14 @@ static int ext4_write_end(const struct kiocb *iocb,
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
+	if (unlikely(!folio_buffers(folio))) {
+		folio_unlock(folio);
+		folio_put(folio);
+		if (handle)
+			ext4_journal_stop(handle);
+		return 0;
+	}
+
 	copied = block_write_end(pos, len, copied, folio);
 	/*
 	 * it's important to update i_size while still holding folio lock:
@@ -1560,10 +1568,19 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
+	if (unlikely(!folio_buffers(folio))) {
+		folio_unlock(folio);
+		folio_put(folio);
+		if (handle)
+			ext4_journal_stop(handle);
+		return 0;
+	}
+
 	if (unlikely(copied < len) && !folio_test_uptodate(folio)) {
 		copied = 0;
 		ext4_journalled_zero_new_buffers(handle, inode, folio,
@@ -3231,7 +3248,10 @@ static int ext4_da_do_write_end(struct address_space *mapping,
 	if (unlikely(!folio_buffers(folio))) {
 		folio_unlock(folio);
 		folio_put(folio);
-		return -EIO;
+		handle = ext4_journal_current_handle();
+		if (handle)
+			ext4_journal_stop(handle);
+		return 0;
 	}
 	/*
 	 * block_write_end() will mark the inode as dirty with I_DIRTY_PAGES
-- 
2.47.3

