Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80E2175A7D
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 04:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783052728; cv=none; b=Kg83G4nCJJjxFEsBHphESeTA6Z785aW2dQqbs7+IxqcCTo1k4Zj8lsm4Uuj+RGZ9dEZRQ6PTtbP3At4h0mmCYCEJ4GXbb6w5m0YY+NuzN6oF9e0Dcf4jnF9HNOyyuH/mHhUS412J4r9o2HDxgCuncUcE+/+HCGGWTbnkVTW0gvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783052728; c=relaxed/simple;
	bh=lFpkZ4hLyujAZZSPkQA0jkSN/QGSA37oQVkYFmyEAB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cXoBrVxZFMLeDashqJSXctYkuD9iBqVhboqrvulGStSs5glsuL1Uyey6soNFAjJAoacI3ahZD+/Djasyy4DxMQ3B/GMRP8Qr7l9ALB9FHFnUNkk2OfkAP9ZgpfRwB0FQc1qnqGeXzTPf6dVecWwoPi0g3svX+Gb8Ue0yOQN2zKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LylOCr53; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LylOCr53"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-845e47133c9so743395b3a.0
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 21:25:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052714; x=1783657514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PadUhAX8JU7W3vYotKGvueCt2WpXGLFXJEVXJ+5nFKA=;
        b=LylOCr53OMJC1nden83SBTJKm5v9w7Wg3j53b7HSFqfN2IiZiisQ5GgNLZMo/NVKaA
         0lrWYgHH3tnpVub8eq+IrUaGKjgAj0xs4y1jwbCJiS159qyjNH5wDKCfpi7YRVXaYqeM
         eqYJ9ztH6it0Pw+9wNLy0YaXMEZugr+1rS1O6y/IujwkcwEchSjOyazfx+WyDINKPf7W
         toms7GXC08dhRbDMrhqpFk58RRx3Pg2+Avr0QMEFSkHplP+UXLSgv5+AfzjoGWZKUFjs
         +6aqLDnNDyHKhrPoytXPYhT7XJoQzvA0KEJg2q4hGZq7AcFTKkufel2/ltAYF80BFtrD
         p+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052714; x=1783657514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PadUhAX8JU7W3vYotKGvueCt2WpXGLFXJEVXJ+5nFKA=;
        b=rXauBuvIlsYyXIawkcBhGemDJMZjKVm3ir+VJlkKhuBogIScfLGbdZrZo42QbEH3+O
         5UMK3HmVFA9H+g55mAW0FMNRp4s8Hi2jkNdCPbhzQhAi6qH11i8i3Ahl1mBLPKY3rdCd
         STkhc3SBiOf41ajg9hMnvH2/M07sRYpmcC1pA+LCAqhuDAQKRP3uBET/qfwbAHNtS0/A
         AdqK4htnJbHZ3jYZr2pIdwiURUS4nYAo3/bVCYxgXPjsInT/vcnx3CH9daAM2kM+/LHx
         S9ZJc2p9MAOZK3ivW86J5gJ1WH4x2OmjtHudh+/VPNI17zDYgZcVwJHUjJc83pYUvW0+
         CQaQ==
X-Forwarded-Encrypted: i=1; AFNElJ9frYiLRV4rXLdyKxMVAH6vdp6HIrKy18arddQl2ScyLH42yu8MUPO37huvev9HbmBEgS2B0yj7iNHI@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8I6B2QwE6m2+WoJv3XbVyO7K87Pk13MoCbGmeDRmdAHnpkY7X
	tLpGRymmFmuKkggMCjsKCNvo7ocKt8IZs80I05pwyDXHwH48g/CsXOsp
X-Gm-Gg: AfdE7cmU/PJLbokbTUJijX7YMI7d3k5P0oMJ72q6+CoVjcvbxJndPjIG1FzAaUKeTmY
	Mt+LdARaf5ACnrQNOCSopXuzNHhAP/7qtL030U9fwAGPbSUTiSqsrQyhuPNArGsmi9/TCLJuqUE
	dJcaT4TeuKAUUSkgZvlv+biM8Tz0D4rVnJkmFXgelgnmhBcTgXgFeKALdr2AqscNgNFx0FET0v+
	EFQm7WxhxRvYjwWiIq+tNT8DZxJR4xOm7zMVFolpxRxVpcSPXIe+e6YwFzZimqLWLprTxOv9iZD
	Ls3AenfM0AugSv3MXK93wNVaSTPnATnCkFHDgrifHDcVT9gGBf2lnh+JiMxym6KCrMLlzky/JiC
	nuHs/8Cc7k/ZhShJaVUuWwlHK4um5KDX4Gl6C4iNHpeiSEJhzBLp+oj15+2eCeOSSV2u5fC/rVj
	wz9yfWRSaufOhGwtByN9n6NGiC5BJ8k+Go90FV6SChyjJleK5OWWeQx99FOa8GIQb40KzzOJqTE
	M6VFOmx5GuwCyUD+WXBJeXCswSvxL2EsxegkZWxObv+xAZG9ONaLxn/ssqzM5MSJdoJHDUCJNKV
	MWGDhBl4pgN+/qjhQjibD/Q=
X-Received: by 2002:a05:6a21:487:b0:398:76d4:c7e9 with SMTP id adf61e73a8af0-3c01cbdb181mr3398227637.35.1783052713667;
        Thu, 02 Jul 2026 21:25:13 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (213.28.87.34.bc.googleusercontent.com. [34.87.28.213])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f116065c5sm13284830eec.11.2026.07.02.21.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:25:13 -0700 (PDT)
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
Subject: [PATCH v3] ext4: use fsdata to track inline data write state and fix race
Date: Fri,  3 Jul 2026 04:24:42 +0000
Message-ID: <20260703042443.1655-1-aditya.ansh182@gmail.com>
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

Define EXT4_WRITE_DATA_INLINE (4) as a bit flag (Bit 2), treating
fsdata as bitwise flags rather than mutually exclusive enums to keep
states of the write path independent. Communicate this state via
fsdata:
1) ext4_write_begin() and ext4_da_write_begin() set the
   EXT4_WRITE_DATA_INLINE bit in *fsdata via bitwise OR when an inline
   write is successfully prepared.
2) On entry, ext4_write_begin() clears the EXT4_WRITE_DATA_INLINE bit
   to safely handle VFS retries (where generic_perform_write() bypasses
   the fsdata initialization on its retry jump).
3) The write_end handlers perform a bitwise AND to check if the
   EXT4_WRITE_DATA_INLINE bit is set and invoke the inline write_end
   helper accordingly.

Furthermore, during a buffered write, ext4_write_inline_data_end()
acquires the xattr lock after preparing the write. If a concurrent
page fault (ext4_page_mkwrite()) converts the inline data to an extent
after the write_end handlers check the state but before
ext4_write_inline_data_end() acquires the xattr write lock, the
subsequent check will trigger a kernel panic via
BUG_ON(!ext4_has_inline_data(inode)).

To keep git history working and bisectability clean, replace the
BUG_ON check in ext4_write_inline_data_end() with a graceful error-
handling retry path in this same commit. If the inline data is cleared
after locking the xattr, we safely release all resources (releasing
iloc.bh, unlocking/putting the folio, stopping the active journal
transaction handle) and return 0 (VFS retry) to let the generic write
path retry the operation safely.

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
Changes in v3:
- Changed EXT4_WRITE_DATA_INLINE to 4 (Bit 2) and treat fsdata as
  bitwise flags, allowing decoupling of independent states in the
  write path (e.g. standard fallback and inline writes), as suggested
  by Jan Kara.
- Clear the EXT4_WRITE_DATA_INLINE bit on entry to ext4_write_begin() to
  safely unroll state for any VFS write retries.
- Perform bitwise AND checks for EXT4_WRITE_DATA_INLINE and
  FALL_BACK_TO_NONDELALLOC flags in the write_end and da_write_end
  handlers.

Changes in v2:
- Folded the BUG_ON fix from the second patch into the first one to
  ensure bisectability across git history, as suggested by Jan Kara.
- Removed the pointless initialization `*fsdata = NULL` on entry to
  `ext4_write_begin()`.
- Removed the redundant check `if (fsdata)` in `ext4_write_begin()`.

 fs/ext4/ext4.h   |  1 +
 fs/ext4/inline.c | 14 +++++++++++++-
 fs/ext4/inode.c  | 24 +++++++++++++-----------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b37c136ea3ab..9e6f6467bdeb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3138,6 +3138,7 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 void ext4_set_inode_mapping_order(struct inode *inode);
 #define FALL_BACK_TO_NONDELALLOC 1
 #define CONVERT_INLINE_DATA	 2
+#define EXT4_WRITE_DATA_INLINE	 4
 
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
index ce99807c5f5b..4e1bf54e511d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1302,6 +1302,8 @@ static int ext4_write_begin(const struct kiocb *iocb,
 	if (unlikely(ret))
 		return ret;
 
+	*fsdata = (void *)((unsigned long)*fsdata & ~EXT4_WRITE_DATA_INLINE);
+
 	trace_ext4_write_begin(inode, pos, len);
 	/*
 	 * Reserve one block more for addition to orphan list in case
@@ -1316,8 +1318,10 @@ static int ext4_write_begin(const struct kiocb *iocb,
 						    foliop);
 		if (ret < 0)
 			return ret;
-		if (ret == 1)
+		if (ret == 1) {
+			*fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
 			return 0;
+		}
 	}
 
 	/*
@@ -1450,8 +1454,7 @@ static int ext4_write_end(const struct kiocb *iocb,
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if (ext4_has_inline_data(inode) &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+	if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
@@ -1560,8 +1563,7 @@ static int ext4_journalled_write_end(const struct kiocb *iocb,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (ext4_has_inline_data(inode) &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+	if ((unsigned long)fsdata & EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
@@ -3161,8 +3163,10 @@ static int ext4_da_write_begin(const struct kiocb *iocb,
 						     foliop, fsdata, true);
 		if (ret < 0)
 			return ret;
-		if (ret == 1)
+		if (ret == 1) {
+			*fsdata = (void *)((unsigned long)*fsdata | EXT4_WRITE_DATA_INLINE);
 			return 0;
+		}
 	}
 
 retry:
@@ -3291,17 +3295,15 @@ static int ext4_da_write_end(const struct kiocb *iocb,
 			     struct folio *folio, void *fsdata)
 {
 	struct inode *inode = mapping->host;
-	int write_mode = (int)(unsigned long)fsdata;
+	unsigned long write_mode = (unsigned long)fsdata;
 
-	if (write_mode == FALL_BACK_TO_NONDELALLOC)
+	if (write_mode & FALL_BACK_TO_NONDELALLOC)
 		return ext4_write_end(iocb, mapping, pos,
 				      len, copied, folio, fsdata);
 
 	trace_ext4_da_write_end(inode, pos, len, copied);
 
-	if (write_mode != CONVERT_INLINE_DATA &&
-	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA) &&
-	    ext4_has_inline_data(inode))
+	if (write_mode & EXT4_WRITE_DATA_INLINE)
 		return ext4_write_inline_data_end(inode, pos, len, copied,
 						  folio);
 
-- 
2.47.3

