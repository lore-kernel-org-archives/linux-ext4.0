Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E6E272816
	for <linux-ext4@vger.kernel.org>; Thu,  7 May 2026 05:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778130375; cv=none; b=PQ3aXj1VbS2xz5TD8MQfZpqQcN8iepeyAoqmMl7Poz6Pf78PMQazUaVEwNj8NsvO0SGx0pv51dOtJk48n2LcZTuew97g/NoOdnnGB+LkR2zfzsVK3F4mXhRl+OPC73h+gkdUjj1KPhIDx0aK0ow+7PHDXZLqzH29MsgB0ugtTC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778130375; c=relaxed/simple;
	bh=HldLlNSMQBI2EvfIaoiLFsjUVYQk+1E7wCrqoPzPH1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kNyDOdu685QOFyb/7ZsAvOye8WyocZ3GxJ773BDzrpFo9IhqMmMRLFSoR00fnAY8E9L/bBqv+e2m8CJE63AFOJBSzVavLDn00tLQxvsCI0YnNoD9+gyibYtQI7SxYB4K/go5Q2+JEiCERuZDn0lzNjRdJQUTWxCxYOf519Z1U3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j07+Nbdr; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j07+Nbdr"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-364f7c42c62so297882a91.0
        for <linux-ext4@vger.kernel.org>; Wed, 06 May 2026 22:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778130373; x=1778735173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MRQHcLvEp91JBko7kMqdgRddhW51jH2sEgDnI8KRetE=;
        b=j07+NbdrOdzMN8+s3+gZTAsMBq37mCz+7rb3iaHTxfX2xJdjzwrrdon1vxeW/+Ot/S
         J92LVQgaGWcZKVijeFWNLQSwa/e9zI84u2yqc/d7ftyLkUYvskkmQ5utzB8pPMWogwFC
         z6PWYhU4li1YOGrdVJGJ5t6V+FL3SB4kZzGLsFhHVr8nN+BHkU/6BYrzbkJCBz+zWyDL
         2vrBzRomSGDeEt5zleR9LfvKsmsKjlu+8Fmum0Zo3y8ybC5n8o24zfxpqp1Kgsrf+W1r
         qiZN8KZh7wciSE/rPziAGEzIoz3XKV/xcXu+cj9nRcbC6wqStYle2O3YpUC2vasK0SBd
         JGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778130373; x=1778735173;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRQHcLvEp91JBko7kMqdgRddhW51jH2sEgDnI8KRetE=;
        b=VzBAX/3GiqNa7F0PIz+LHJmC0bjAaPdCrKEoWn7nbPrTf7GyJkcX1GzwrxaNXyRNRl
         iOmj1LSFw5EJP4qeAEgpkQhOFRhAmlpqKFEYchOye19qG2o4145/JDKLZTs2pzzKASMH
         m8LeZ5JYBiTXL3bQy05DouO+ukZ52dLfGHlsb2tiuEU24nXrOqyN02973tyiC+wPEO4Z
         tZScYTERrZwZ4u2fXCunPTLqD9lW+7SGDNQD/jwjZAQTeSYfsItlaCmTqtWlYLTmakHO
         Z3ICHXXmSZ++v9usWLuCnIbWPK/JDDs5mO2xr38oNyrE5rG4CgQJ/rH2GjlWp2s10iC9
         2gcw==
X-Gm-Message-State: AOJu0Yykpa/TtqraGlbw2/UmaXRtY4hfB7D8tn7fw/jEFseOBjK8gFCk
	yQ84+l9BtINS+thigT+lbCsQrrQiXftnfytkX9LNAHXBL+/Ze40xqrwu
X-Gm-Gg: AeBDievO7IroG7J/JQVb1BZQG1ntMhmowBjdnVY2y8L+fyxDHnHHHUNIUXyPEXYh6qf
	PCC9swUH2Rq9SxeBQh1kg2yD7LQXCRZEjw9yhhkt4GBPeH71UuVpggIelUWJXov0mDDAMd+bCaj
	ZH4kwzOVTLYoDilV6YnOn/83uWJmybbIzVKtQBMIScK1C0HuzTbb9naCvkccWlEIUpVAcGVftzn
	pHybsqB7//QKKTnli4+9qYYuCCU7krh/Q/dXAu6ZB23ow3YXclyCoCsq2DzXIfeCNM8uBdFjqfY
	LrBQCmBsmgaM+h4zb2eU8++3v6ljk5yXgnIGMaph+MEz7Obm+g079mGi/5ipTFX3GNPdEP506eg
	i6kAq2oqXpcOfwC4dIuSh16oLOFs4ZxdghpHZuaAKiduIk2y3tXsJrbkwSjjVfhKFo2Z71d7v5R
	E+kvQECBRVu+FSf1bSdmGXtwHkzrC6cxeTkpJvV7reKKN+072Xt6CytQ7l4PLMMso9hX9w/Pbaa
	Y9OYOzW77IclJ1Lhg==
X-Received: by 2002:a17:90a:e09:b0:365:f8fc:3846 with SMTP id 98e67ed59e1d1-365f8fc3886mr1492596a91.22.1778130372548;
        Wed, 06 May 2026 22:06:12 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:8a0d:ca7b:792c:2dfa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4fb5e7esm4469788a91.15.2026.05.06.22.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 22:06:12 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: tytso@mit.edu,
	jack@suse.com
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
Subject: [PATCH] jbd2: check for aborted handle in jbd2_journal_dirty_metadata()
Date: Thu,  7 May 2026 10:36:05 +0530
Message-ID: <20260507050605.50081-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

jbd2_journal_dirty_metadata() unconditionally dereferences
handle->h_transaction at function entry to obtain the journal pointer:

	transaction_t *transaction = handle->h_transaction;
	journal_t *journal = transaction->t_journal;

However, h_transaction may legitimately be NULL for an aborted handle.
The is_handle_aborted() helper in include/linux/jbd2.h explicitly
treats !h_transaction as one of the aborted states:

	if (handle->h_aborted || !handle->h_transaction)
		return 1;

Every other entry point in fs/jbd2/transaction.c
(jbd2_journal_get_{write,undo,create}_access, jbd2_journal_extend,
jbd2_journal_restart, jbd2_journal_stop, etc.) guards against this
with an is_handle_aborted() check before any dereference of
h_transaction. jbd2_journal_dirty_metadata() was missing this guard.

This is reachable from ocfs2's xattr code. ocfs2_xa_set() intentionally
falls through to ocfs2_xa_journal_dirty() even after
ocfs2_xa_prepare_entry() fails, on the assumption that the buffer
needs to be journaled to record any partial modifications (see the
comment above the out_dirty label in fs/ocfs2/xattr.c). If the failure
was caused by the journal being aborted -- e.g. an underlying I/O
error during a sub-operation such as __ocfs2_remove_xattr_range() --
the handle's h_transaction has been cleared by the abort path, and
the unconditional deref in jbd2_journal_dirty_metadata() becomes a
NULL deref.

Reproduced by syzbot with a crafted ocfs2 image where I/O against the
loop device backing the mount is sabotaged via LOOP_SET_STATUS64
between two setxattr() calls, causing the second setxattr (which
truncates an external xattr value) to abort the journal mid-flight:

  Oops: general protection fault, probably for non-canonical
        address 0xdffffc0000000000
  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: jbd2_journal_dirty_metadata+0x4a/0xd30 fs/jbd2/transaction.c:1520
  Call Trace:
   ocfs2_journal_dirty+0x130/0x700 fs/ocfs2/journal.c:831
   ocfs2_xa_journal_dirty fs/ocfs2/xattr.c:1483 [inline]
   ocfs2_xa_set+0x15e3/0x2ec0 fs/ocfs2/xattr.c:2294
   ocfs2_xattr_block_set+0x3e0/0x33c0 fs/ocfs2/xattr.c:3016
   __ocfs2_xattr_set_handle+0x6b3/0xf50 fs/ocfs2/xattr.c:3418
   ocfs2_xattr_set+0xf3f/0x13e0 fs/ocfs2/xattr.c:3681
   __vfs_setxattr+0x43c/0x480 fs/xattr.c:218
   ...

Fix by adding the standard is_handle_aborted() guard at the top of
jbd2_journal_dirty_metadata() and returning -EROFS, matching the
pattern used by every other entry point in this file.
ocfs2_journal_dirty() already handles a non-zero return from
jbd2_journal_dirty_metadata() correctly.

Reported-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=98f651460e558a21baae
Tested-by: syzbot+98f651460e558a21baae@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 fs/jbd2/transaction.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 4885903bbd10..aa0be9e9c876 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1516,14 +1516,19 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
  */
 int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 {
-	transaction_t *transaction = handle->h_transaction;
-	journal_t *journal = transaction->t_journal;
+	transaction_t *transaction;
+	journal_t *journal;
 	struct journal_head *jh;
 	int ret = 0;
 
+	if (is_handle_aborted(handle))
+		return -EROFS;
 	if (!buffer_jbd(bh))
 		return -EUCLEAN;
 
+	transaction = handle->h_transaction;
+	journal = transaction->t_journal;
+
 	/*
 	 * We don't grab jh reference here since the buffer must be part
 	 * of the running transaction.
-- 
2.43.0

