Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8898346795
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 05:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782968871; cv=none; b=I0mRcHGgdWxeMwQ88+zNXTTO8PQm/yI0hVOHF6JdFAEzbWSJw1cKECheNwQc7GlGJD6sXiha5Kjvp2RpHcoEiQHAzu4nGNJ0j29ElWPWXAQGb/l2KIq7Qx0f2rUDqNsrcajUS3kGp5rJ2SKurYrcr/lsc+atIWBHGa8T3JA0p7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782968871; c=relaxed/simple;
	bh=vfudGdDMTAN7PKtYg6BXJyD+IEFJPDvbJmrzU1uAq4E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jm+gj1gAC+M/OVn0xBrmkjiTuEw0cfbRcVlfXPoTuj7zTGHrIKEk+0DSFRDHqoOKyxUhmBnxocQheXvY8o9/SDytnkHy/xYvqlIhHc7/D8JCHuduEOTx0mLSa4CjZ4GSnHPpLnQE2s8UhQQLzKR9ikLqBVRPM+ZeEwpyNTrln1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qIKHjYnL; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qIKHjYnL"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-37de8008910so1017769a91.0
        for <linux-ext4@vger.kernel.org>; Wed, 01 Jul 2026 22:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782968869; x=1783573669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UnKeOoYlfFDW0xHMr63qC+RpUvRoKz8WII+Y9JurVlU=;
        b=qIKHjYnLIisHC9tlR+G3WX8WeBsR/pMx/mVmjR2kiLY0HVbpTyW8HZLx4k4ADGaW35
         6YN1iXyu/WSnzudh5C/VUSLZDJ60czW24MbwQ+RfvVFUiN9hgBiubFAa+ItDvBldnbcn
         lZDXlMVN7r6D7ZYkZJ9ucs91ZgmF53Vu35Fb0HThKlQYjY9G2xyxmHrpnG/ROr2qPSi0
         M18iqB2Bwpxr6UCMXY3A+1uqJEwoCMubwlAlZvgMqFgeVfkwfgvkrKFZoE+UxbmbkJDs
         hR1Ja55WiEOMa6npzCHWN0id60zKYhLo6rbO7fxHtZRtuAKS9PUTu8d2AGNhCDQtNFPB
         BYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782968869; x=1783573669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UnKeOoYlfFDW0xHMr63qC+RpUvRoKz8WII+Y9JurVlU=;
        b=h11pYw/AR17wkrXhZEHoMYc2/WdiBI0EoT7yIoU6zDqvVo8RsN7eQyOIyLoKI+0dss
         GFMwmwktwUCqwrQ5pnV3ROWaDUjLfgC4i8rvnI95Ee1rPmB1qGivTXZ0HmJs+0irWWK4
         27KnwqA2tjY2/x14DraQlXJdXW6k8k6gPM9bWxA9+AmDAw6tuY/ihCKKxGCjWPZ6SmCA
         dlTy3vSoP5WBGe21NrKEviVgD6z1zbQc/P4upUd+cbXdfS/UvmT2RTBlJrqs69mheRhE
         VuRxjC8JX5t39tFeVCjgT3xEuIjTTj/0D9zT2vu+rQKBD6lQjpDObHkD2uTnZklupdtv
         lM6g==
X-Forwarded-Encrypted: i=1; AHgh+Rr28y0M+veBBB8bFl+qWX0wKy+MazbZIM82y2whfJQSWSDRyflTcwxzR75QJkvLMWK3oKQzjSdg+HaI@vger.kernel.org
X-Gm-Message-State: AOJu0YxHoH5nSo2mgiAG45eUH9d5T8eJ7WXeItAEvGTpE9PXh4xIZ1Y+
	0cGU0/sxsvUGwYPIpKdH8+84SVh67ZL4QWlVP1Nbp1o1uMobjyjaLwXX
X-Gm-Gg: AfdE7ck/ozUMKj1mdix4eckxDp1zPpJgrwZJWI0n3NK50F/GYP5tUdUzDnEE2ASHvTp
	E0+geFoCFkilxrfz2d6DA8fu8/mH776/7p0O4o43SfMFBfsfkXb05ShuMVn4VcH5ER4qLxG3o0Q
	bBq5yepsmMm5zICQtsvFQyXZBJsGNQUvZlwxGO5AhBylolzLMLPAieeIpK4PWfnuwONmAq1Nmsf
	gf6OAbtkbCJeWZLXPLm7YhPhYLk8vmVHvuuamg7aih5Ft5P3tQPR7MhBnAXAfz8xnOFijbBElrV
	gxW8eM1sZ9AEpq0e19/qvaYkksRaoyVV7SR+2ACKEGQpQhHBFT/3REoYYhIrenscrUUW5Mc5wRR
	T6l/Z6h4fUxbxCZodJtqqMT5PVJCucMgwIYfkrFsmwkiZmk+Zl/dk8bX7F4iX4Hm/s1z37I0Km/
	9uci4gg0dGIkwfHfWJMNvhWiFyLDcRudps69ou9baIngcuGLm0RwoOmwiIluLw6m26Am1M8UCaX
	Gb/5TA1o/4y0D2F35S7egZN4QPC+Wjp773fN+rHSmWSyr3adEk0tXfWDHZlN8a7LF3mrQ/vfIvo
	ITS2CtIpaIcUK2LsAJsqdzsm4dtHYM6+oq+ViGA=
X-Received: by 2002:a17:90b:2b47:b0:37f:9cdf:f0b1 with SMTP id 98e67ed59e1d1-380aa26a360mr4360306a91.32.1782968868918;
        Wed, 01 Jul 2026 22:07:48 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (193.151.247.35.bc.googleusercontent.com. [35.247.151.193])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb84405sm5962297eec.17.2026.07.01.22.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 22:07:48 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Tao Ma <boyu.mt@taobao.com>,
	syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com,
	linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v2] ext4: use fsdata to track inline data write state and fix race
Date: Thu,  2 Jul 2026 05:07:24 +0000
Message-ID: <20260702050724.1658-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Instead of checking the live inode state (ext4_has_inline_data(inode)
and ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) in the
write_end handlers, use the fsdata parameter of the address space
operations to explicitly pass down the state in which write_begin
prepared the write.

A concurrent thread (such as ext4_page_mkwrite()) can convert the
inline data to an extent between write_begin and write_end. If this
happens, the write_end handlers would previously miss the inline
write_end path and fall through to extent-based write_end logic.
However, since block buffers were never allocated in write_begin,
this resulted in NULL pointer dereferences or data loss because
folio_buffers(folio) was NULL.

Define EXT4_WRITE_DATA_INLINE (3) and communicate this state via
fsdata:
1) ext4_write_begin() and ext4_da_write_begin() explicitly set
   *fsdata to EXT4_WRITE_DATA_INLINE when an inline write is
   successfully prepared.
2) ext4_write_end(), ext4_journalled_write_end(), and
   ext4_da_write_end() rely solely on fsdata / write_mode to
   invoke ext4_write_inline_data_end().

Furthermore, during a buffered write, ext4_write_inline_data_end()
acquires the xattr lock after preparing the write. If a concurrent
page fault (ext4_page_mkwrite()) converts the inline data to an extent
after the write_end handlers check the state but before
ext4_write_inline_data_end() acquires the xattr write lock, the
subsequent check will trigger a kernel panic via
BUG_ON(!ext4_has_inline_data(inode)).

Replace the BUG_ON check in ext4_write_inline_data_end() with a graceful
error-handling retry path. If the inline data is cleared after locking
the xattr, we safely release all resources (releasing iloc.bh,
unlocking/putting the folio, stopping the active journal transaction
handle) and return 0 (VFS retry) to let the generic write path retry
the operation safely.

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
Changes in v2:
- Folded the BUG_ON fix from the second patch into the first one to
  ensure bisectability across git history, as suggested by Jan Kara.
- Removed the pointless initialization `*fsdata = NULL` on entry to
  `ext4_write_begin()`.
- Removed the redundant check `if (fsdata)` in `ext4_write_begin()`.

 fs/ext4/ext4.h   |  1 +
 fs/ext4/inline.c | 14 +++++++++++++-
 fs/ext4/inode.c  | 18 +++++++++---------
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..521bd5d6321c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 void ext4_set_inode_mapping_order(struct inode *inode);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
+#define EXT4_WRITE_DATA_INLINE	 3
 
 typedef enum {
 	EXT4_IGET_NORMAL =	0,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..cfd591dc1d9c 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -812,7 +812,19 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 			goto out;
 		}
 		ext4_write_lock_xattr(inode, &no_expand);
-		BUG_ON(!ext4_has_inline_data(inode));
+		/*
+		 * We could have raced with ext4_page_mkwrite() converting
+		 * the inode and clearing the inline data flag, so we just
+		 * release resources and retry the whole write.
+		 */
+		if (unlikely(!ext4_has_inline_data(inode))) {
+			ext4_write_unlock_xattr(inode, &no_expand);
+			brelse(iloc.bh);
+			folio_unlock(folio);
+			folio_put(folio);
+			ext4_journal_stop(handle);
+			return 0;
+		}
 
 		/*
 		 * ei->i_inline_off may have changed since
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce99807c5f5b..d3d9e1999670 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1316,8 +1316,10 @@ static int ext4_write_begin(const struct kiocb *iocb,
 						    foliop);
 		if (ret < 0)
 			return ret;
-		if (ret == 1)
+		if (ret == 1) {
+			*fsdata = (void *)EXT4_WRITE_DATA_INLINE;
 			return 0;
+		}
 	}
 
 	/*
@@ -1450,8 +1452,7 @@ static int ext4_write_end(const struct kiocb *iocb,
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if (ext4_has_inline_data(inode) &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+	if (fsdata == (void *)EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
@@ -1560,8 +1561,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode) &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+	if (fsdata == (void *)EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
@@ -3161,8 +3161,10 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
 						     foliop, fsdata, true);
 		if (ret < 0)
 			return ret;
-		if (ret == 1)
+		if (ret == 1) {
+			*fsdata = (void *)EXT4_WRITE_DATA_INLINE;
 			return 0;
+		}
 	}
 
 retry:
@@ -3299,9 +3301,7 @@ static int ext4_da_write_end(const struct kiocb *iocb,
 
 	trace_ext4_da_write_end(inode, pos, len, copied);
 
-	if (write_mode != CONVERT_INLINE_DATA &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
-	    ext4_has_inline_data(inode))
+	if (write_mode == EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-- 
2.47.3

