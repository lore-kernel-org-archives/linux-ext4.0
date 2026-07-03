Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB670328B4B
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 04:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783054489; cv=none; b=Ec+JcF/XiPRaFakHfzs0R1QaR3b4vJ6TWDQLSgminxBKLL8s5QRovF5UrVaDpbaMNFfoGIt2lKex8TcnBKIScVz4aI/SvjCBLjs4zzE1w9qjZ1BqHluP0elcN46WMNubw7ZiFMQGPMAUk4hL+UKLw/nLcKmTgNa6R3RMi937PLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783054489; c=relaxed/simple;
	bh=1HQHBopjc1BDf+xH7u+SaieGPLJaGXkItUCnYol8tes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SUcQEtQqXkLv7gZ6aksT892/gcwat3KjHUKbb/REs1nxKSXTh4lsA3LhJihzmDL1CwZniOt1kwencroUsUgsAJfWLdhqXSLod9Z4GO4Q+PzOfNxygyttPRxlOSjom5RRcouUa7q59JeYS/5hDpB0jHcMdElKs1kwp5d5h6Th6tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X8MveLnN; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X8MveLnN"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2caa57a41cdso1374285ad.1
        for <linux-ext4@vger.kernel.org>; Thu, 02 Jul 2026 21:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783054476; x=1783659276; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2F++k+Z1pCPfrLBBHA1hu3bWkozZ4jDkHb7+4ZuXGGw=;
        b=X8MveLnNp/6haMgm7PkL/QuMoll8mhHTNruWya6n/yxDJ9rjE5CEcG20zP2JUoTCT9
         Le7B2xfgqzCdnttFu0mBeRHhN600F1xe1tPdo4pkdG7m+tz4RBp8Y2lGTc5PBMNXt73v
         H0Rf0LLUi0w4NCyjnKeHcDuvfudrKnM7BRvrthuljfsgKDG4nGKXnAJdjgXK+7vCUuWg
         af03+LmHz3XFkChHTJf2EV4mAwvr4h5qE7myHpHsIlEGnMdhC8b9J8owtxvmAXS2E11g
         OPrf7G6wDmCIfNDiHpE5QLy39Kc3qGTJdNKSG3lvFhwtREPzrXDmJFDt8WttIz2v3T8V
         gzkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783054476; x=1783659276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2F++k+Z1pCPfrLBBHA1hu3bWkozZ4jDkHb7+4ZuXGGw=;
        b=Yl+WUjMxdwkWn/pJJiCOOF+mKip1Oe3e7s82EwIVUtZ3a+Nd6WZYeExfsA04gnh+8s
         3huj9QhjRCQowF43Xl6gmSNcXx+AAg1Hs5AfsOA4XhqeSwD4MDMFbVMLkOft5gw5pHqq
         eIljY9lDhHDuuQoExSsOY4dJDKOFcwHhYi2t+1dqmhGACxvVHZEnh0HLPiMcIgOFfGPz
         kpK0wrFMAJ/964SoQAAIZ0iCWJQkr5l2f8sXAPXjDiLdT42nSHpdTjuNkhVsa4ONqxPQ
         fhD/UnDcYl6bXjOH0bqP8Hpd2UWq9IRGFx0rR4OdVFYEHdgnttladIk6+X7El+UEcRfZ
         YUUw==
X-Forwarded-Encrypted: i=1; AHgh+Rq/jD5/iTh1Pj2Mt6Xyt9W8i9I3nzFPgD6ReIGm8qjUCVz05zKDPIxnXBuSgEWZ3FvfqFK4DuK91qbA@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq8BZeIayg0fpptoSZ6WSQb0wOr0JLZf+B1nUizh9o1Tyw0QI4
	M/5nS13BfkA05z4Okz5qRQO0R4F/M+r3/Y+AdGJs4czrmpk6NdN3D6aL
X-Gm-Gg: AfdE7ckIw1a6dwIx/GlsRzHabLifi8AT5UVTOk4z6pQDUIUF1oQStPhgeuPRZjZsdOq
	oY4ppnl4obZXQbKko/C58DWa/iQREr4EuEXLuXuZ5iRcLkUsjJEmO/dxUJzCECBAZRRMmrgdxFc
	eSb/zu0ulSJiCj49HcgHilUlKeVsRkxqyE0VgkUPcW9e1/j8WI4xbI8ZXyIhkyX7Va0ky3iVO1p
	QjdAk2B6cvGgdPvsSVLkbE9vDJ7uu3JhirVqSyQwQ8kUtoNVQSLZkiTtM0emGVItdbp6Ew7uk5i
	g5dvNra+Iq49m66bHVSH9lyUQ9x2GJLYpp7KiGw1aurd4yntVNYTPJi4ARLNgnaE3BJ5G1lxBUx
	aDlyS+YGvaceI5CXdUk6S7oBDvdnaVq0VoU7YydTCoJ7GFzs4358nSAbE4FZ9eCqYa5CLoLoBDZ
	xj51uagdXNkiNXk71Em5s8NGOd2MiD4NvhlbktpgjdojR5jbRc1Ht6bCVbNkBZgXOBdLJEGuLF1
	0brbjDlogF76Sfae6ONAgPgzshgnvdlTUxtFOiQyOpEf2/hGzvPli8QP9W6AeBP2fiBci+r9W1p
	vZaRONVvM4IFII4iJSDnXYw=
X-Received: by 2002:a17:902:d4c7:b0:2c9:97a7:3276 with SMTP id d9443c01a7336-2ca7e89a620mr102121505ad.39.1783054475814;
        Thu, 02 Jul 2026 21:54:35 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (213.28.87.34.bc.googleusercontent.com. [34.87.28.213])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c7fa65asm15615643c88.6.2026.07.02.21.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:54:35 -0700 (PDT)
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
Subject: [PATCH v4 1/2] ext4: use fsdata to track inline data write state and fix race
Date: Fri,  3 Jul 2026 04:54:12 +0000
Message-ID: <20260703045414.1768-1-aditya.ansh182@gmail.com>
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
Changes in v4:
- Resent the bug fix (Patch 1) and the cleanup (Patch 2) as a unified
  2-patch series to ensure clean upstream application and perfect
  logical separation, as suggested by Jan Kara.

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

