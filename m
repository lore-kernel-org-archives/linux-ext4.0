Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716032E7391
	for <linux-ext4@vger.kernel.org>; Tue,  9 Jun 2026 06:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780986280; cv=none; b=cspPdpPOYHxVtkao62pWOBU/aUeyLpdVkPqFFsgDpJMljaop7vcRkbjdKAeEyoPspU9afOzG/OphFisK7p0YH2PH/8EPmtoXHi3/0Nba2bdsYQA0GXQsHSo/NAObahb+xVF114W24x83Z2MfuTWehc+XyLWqozYozmepfSqM/aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780986280; c=relaxed/simple;
	bh=gxdXkhPdeB27/kOhL4gfSF2FNgquQm99OxSBd1GkHwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kwBhprbDvSlcReld8/CX7Vi+DWjXaZ2dMiJl7ji0NsaOvo6nTOa5RyFA3vVQfjV0+5kt7MCTSPUoh7AG6yjVcpYerBxwuo//zTZ8foJu45T3ii4jpb7s/2xLckIYcg8FMFNXdMXfYfRwKw4seEqcLGoTq9NI1zlNeYNmyudo7gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ndy3Fjs5; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ndy3Fjs5"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-36baec934b6so3412361a91.0
        for <linux-ext4@vger.kernel.org>; Mon, 08 Jun 2026 23:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780986279; x=1781591079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3jhi+W8bAr8azxKU4Q0p1B06xZdGDUeBs2ccd1mUisI=;
        b=Ndy3Fjs5cXcaCPKZ7IakKh7b1qo9UUHjkfpBGtvmg0JI6S2BlP+qWXepHdmIEwvMXL
         Fsp1z322JXXnyiE+M2+GmC5wqFRv0hAdpI0zYd41WQujW28Y4GW75vEQbl0QIu3Du41T
         AwG/qReaqDQGphz480mcWjISfxq/ahHGwqg/ggymD0gS60OuDk6bytmALcbIN0/XgMvo
         IN5nCoY8bWhnDFEewBU7bg7TQuKAAzGXYj0KSVbxid9uClqdF0C115NF/iR8kuWsAO2H
         9KvJvRSaaKs1XoX5W67MyLHr0vsCk3snmXl7uZW42oIrzCOUyeoTplpPH34T+PZUiIg6
         yeog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780986279; x=1781591079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jhi+W8bAr8azxKU4Q0p1B06xZdGDUeBs2ccd1mUisI=;
        b=IHmRAh5sr6Xq31H/xdOrPogy+Dds4eKuAfxbBhx45j0LPFfwKQ5Ullmj/HDCk8Nyms
         MuiBme7vKldg6SPOYbXnnzkqR9HfvNULNmZwD1mvd4ZoYclqr/3rR0bwuPkyvg4NQzvM
         3owQvKTS6HckWsTa3v7BK5JW+XflxRPk9PG5ZNqgt6D17+kqVqfQZmXagt8xZ+XTbxsf
         A2qXOD4O2sqY/HYiMpyWI9UFraTj2rL9qdYsHqBf61EO/5V/Rqpib7yUX390ytTfp4g+
         gLY5n1nCIsBdfnrAp08d5WBkq1/KVbapynzclfVaSrDzhlJcQNeI2MPRT7I5AV2bp7uA
         yieg==
X-Forwarded-Encrypted: i=1; AFNElJ+FrgJ/7WNrJ16v46Bx/CFXjk8YeNQVxaQ+hm/P8t96H7yhBA1evwoEfDnHbuDSQDSRvreyD/PeV3eG@vger.kernel.org
X-Gm-Message-State: AOJu0YxANLj3huAnzwDiyji6fzMndnSlaiWQQLxJlLYMvUSoJI8izXW0
	vt8nOvDYzfT4vC4hzGwNTE8NRJ+xS9RvyebWCiP4XQ5PM2bAjjlKR90d
X-Gm-Gg: Acq92OG9NMsQQwPVd5ILsF06TRGTttsR09XjGMJcmP2UdhCb8pB7RLvF4SOxuEW7zva
	1V50wiIJZ38Xo+H+3mWQotXGCLnun7GVikIuHcdja3hWHyC+7Bla9WDhbXWGmGQxNcLg+vdw3Oe
	JmVqv7hCCw7wrbzKV0pZax7Yco/bbwZ9/q1Hm1LRbbOSC+jojpWqmDSC6oBRW+AH2n8mjtmDeUo
	EvmB07JoCf4d4Hw5CPuiFiPwjGivO3mSDSd15NL8XubtrJ04E0Y1ccNcAheR/gV3qh/WDfX+zk1
	duV/bVra3EabXGThnRmX5rMcnE0b4gND/kDd+GTlX+L3oqmqgrcyFIdGVNIIekvPe7HxeymIOu+
	4n6jxcIOSTMyMXePiNdlB+YBy3ou/LaYcdJTWwfitglQeG8iGtl09hmPsfAdVBWezYtcx7qXpHo
	QDhqsx9LSGUdHJuaRoNyB8EUIqaYv4u7XzzqBwiyvc8YA3AAxkb/W0EADUjRuLgoxhiuYek3kEa
	vQT6hQ5gjsf+Hz3JxjL9jmjCgB5MSrFWO4zPIYEIm1ZO7POknFD+c+1CeIGHWz8jjsDia5yLuB2
	Ki89Fh5HaP+xMG8nnWIr4UWtq2rXvegZ0YpAYAEMd44wObk=
X-Received: by 2002:a17:90b:4d11:b0:369:1dbb:4732 with SMTP id 98e67ed59e1d1-3712cd075a0mr13846211a91.0.1780986278715;
        Mon, 08 Jun 2026 23:24:38 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-b.c.d33bddc1d573818c7-tp.internal (77.152.143.34.bc.googleusercontent.com. [34.143.152.77])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37134116c2esm8794702a91.1.2026.06.08.23.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 23:24:38 -0700 (PDT)
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
Subject: [PATCH v4] ext4: fix kernel BUG in ext4_write_inline_data_end
Date: Tue,  9 Jun 2026 06:20:05 +0000
Message-ID: <20260609062005.1702-1-aditya.ansh182@gmail.com>
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

Additionally, two separate TOCTOU race conditions exist due to concurrent
ext4_page_mkwrite() execution:
1) A concurrent ext4_page_mkwrite() can execute ext4_convert_inline_data()
between write_begin and write_end, clearing the inline flags. Since block
buffers were not allocated in write_begin, this results in a NULL pointer
dereference in the write_end fallback paths because folio_buffers(folio) is
NULL.
2) If ext4_convert_inline_data() clears the flags exactly after the inline
flags checks pass in write_end, but before ext4_write_inline_data_end()
acquires the xattr semaphore, the subsequent check will hit a panic via
BUG_ON(!ext4_has_inline_data(inode)).

Fix these issues completely by:
1) Having write_end functions (ext4_write_end(),
ext4_journalled_write_end(), and ext4_da_do_write_end()) return 0
(VFS retry) if they fall through to the block fallback path and detect
that folio_buffers(folio) is NULL, after safely stopping any active
journal handle (protecting against a NULL handle panic in
ext4_put_nojournal()).
2) Replacing BUG_ON(!ext4_has_inline_data(inode)) inside
ext4_write_inline_data_end() with a graceful error path. If the inline flag
is cleared after locking the xattr, we unlock the xattr, release the iloc,
unlock/put the folio, stop the journal, and return 0 to trigger a retry.

Reported-by: syzbot+0c89d865531d053abb2d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c89d865531d053abb2d
Fixes: 3fdcfb668fd7 ("ext4: add journalled write support for inline data")
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
v4:
  - Address critical TOCTOU race condition (reported by Sashiko AI review):
    * Scenario: A buffered write holds the folio lock and evaluates the inline
      flags checks in write_end to true. Before it enters or locks the xattr_sem
      in ext4_write_inline_data_end(), a concurrent memory-mapped page fault
      (ext4_page_mkwrite()) converts the inline data to an extent. This page fault
      bypasses the folio lock (since ext4_convert_inline_data() runs lockless),
      acquires the xattr_sem, and clears the inline flags. When the buffered write
      resumes and enters ext4_write_inline_data_end(), it acquires the xattr_sem
      and immediately triggers BUG_ON(!ext4_has_inline_data(inode)) causing a
      kernel panic.
    * Fix: Replace the BUG_ON() with a graceful error-handling retry path that
      releases all resources (locks/buffers/folios/journals) and returns 0.
v3:
  - Fix journal handle leak and NULL handle crash (reported by Sashiko AI review):
    * Scenario 1 (leak): During a delayed allocation write (ext4_da_write_begin),
      inline data was prepared and a transaction handle started. If a concurrent
      page fault converts the inline data before write_end, ext4_da_write_end()
      falls through to ext4_da_do_write_end(). If the fallback check for
      !folio_buffers(folio) returns 0 to retry without calling ext4_journal_stop(),
      the transaction handle is leaked open-ended, eventually hanging the filesystem.
    * Scenario 2 (crash): If we blindly call ext4_journal_stop() on a NULL handle
      (e.g., when no transaction was started because we never took the inline path),
      __ext4_journal_stop() delegates to ext4_put_nojournal(NULL) which triggers
      BUG_ON(ref_cnt == 0), panicking the kernel.
    * Fix: Retrieve the active handle in ext4_da_do_write_end() and stop it
      if non-NULL. Also explicitly check "if (handle)" before calling
      ext4_journal_stop() in ext4_write_end() and ext4_journalled_write_end().
v2:
  - Address TOCTOU race condition (reported by Sashiko AI review):
    * Scenario: A concurrent ext4_page_mkwrite() converts inline data to extents
      and clears the flags between ext4_write_begin() and write_end(). The
      write_end function falls through to the block fallback path. Since block
      buffers were not allocated in write_begin (because it took the inline path),
      folio_buffers(folio) is NULL, causing a NULL pointer dereference in
      ext4_journalled_zero_new_buffers() or ext4_walk_page_buffers(), or silent
      data loss in the standard write path.
    * Fix: Have the write_end functions return 0 if folio_buffers(folio) is NULL,
      triggering a safe VFS-level retry. On the next write attempt, the inline
      flags will be detected as cleared, and blocks/buffers will be properly allocated.
 fs/ext4/inline.c |  9 ++++++++-
 fs/ext4/inode.c  | 24 ++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8045e4ff270c..161136e84661 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -812,7 +812,14 @@ int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
 			goto out;
 		}
 		ext4_write_lock_xattr(inode, &no_expand);
-		BUG_ON(!ext4_has_inline_data(inode));
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

