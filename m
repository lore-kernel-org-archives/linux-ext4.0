Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C489C39FD4
	for <linux-ext4@vger.kernel.org>; Tue, 21 Jul 2026 14:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642523; cv=none; b=aQQ9UzN2dhJo+q/Dn7FLqr4+GhccSdcoggcBOcRBfiiwOXf9gJEumE0oNX54DSRJ4jMzMziIg9TkBbmzfoK/2i53kKicCOIi8YDSNvSqMkgmFs56re/Yhj2mHMmmIVC+O9oWlw1fPZm2HsRFwRFEnulxKLe09g20FbJxQh6asv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642523; c=relaxed/simple;
	bh=4TlRZfd5xlKGwOLMWmnkM6osHUmF0G74zxYABhite9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZ1fB5m2v/bVjKEP4cV6Lh3cCQFhbbbJ3gSdR+TPxitaXLCPtwQvO6SFOHVrZFEEZ2VO6i+Gfn3Sy5UN/F0Bz1cHsU5R8DptcrUZ/MggpuavdPppUud4PV7MfTlhW0BuUSGR5eT07DYWeU/17yp0IsekDaehMUPo/rexR6TGfQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=KK7pBzyx; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="KK7pBzyx"
Received: from trampoline.thunk.org (pool-108-49-65-18.bstnma.fios.verizon.net [108.49.65.18])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66LE1vGY010179
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Jul 2026 10:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784642519; bh=cE1zoSSNEX9A5hAhTzNdBFSHIkWnY1mWrO9PGAql1e0=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=KK7pBzyx0rK5d4ROzKWF0CgxzNTicM7To6DCQ1y+k8O27yhC3lrufGlEDzlqThhwH
	 oa+iUaZTJr3v3sc064I1w6521G3baaPVpxn/7HHBLWx9fa1B8tAAfDCndXYj9mJI79
	 ZMBpOmer7HYHJyAf80OFrOVmuZ9fvAVY5u+aVoL0UyVPDDEZkNi++dc1zPq2icF2NM
	 Z7WPYdcEBXGuPrHzPG2FTkj3t2yMI6LywwfnaGXMIj9SMDTvnl2UD0W+goAryqMebo
	 sv+cc3MYH7T1/384R4rZk8q4dFSkDh3mIZim1yj0xueK4uswFSfjLWbu+2w5gcDkLy
	 UUEt4javTvaWw==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 9A6992E3F12; Tue, 21 Jul 2026 10:01:57 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 1/2] ext4: enable scoped NOFS when starting a handle in nojournal mode
Date: Tue, 21 Jul 2026 10:01:35 -0400
Message-ID: <20260721140152.461286-2-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721140152.461286-1-tytso@mit.edu>
References: <20260721140152.461286-1-tytso@mit.edu>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The jbd2 layer enables NOFS mode using memalloc_nofs_{save,restore}()
while a handle is active.  We need to do the same in nojournal mode so
that it is safe to remove GFP_NOFS flags while a jbd2 handle is
active.

This will require that we actually allocate a real handle, but with an
h_invalid flag set, so there is a place to put the saved memalloc
context.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4_jbd2.c  | 36 ++++++++++++++++++++++--------------
 fs/ext4/ext4_jbd2.h  |  6 +-----
 fs/jbd2/journal.c    |  1 +
 include/linux/jbd2.h |  1 +
 4 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 9a8c225f2753..b4dacd1a89e7 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -33,14 +33,22 @@ int ext4_inode_journal_mode(struct inode *inode)
 static handle_t *ext4_get_nojournal(void)
 {
 	handle_t *handle = current->journal_info;
-	unsigned long ref_cnt = (unsigned long)handle;
 
-	BUG_ON(ref_cnt >= EXT4_NOJOURNAL_MAX_REF_COUNT);
-
-	ref_cnt++;
-	handle = (handle_t *)ref_cnt;
-
-	current->journal_info = handle;
+	BUG_ON(handle && !handle->h_invalid);
+
+	if (!handle) {
+		handle = jbd2_alloc_handle(GFP_NOFS);
+		if (!handle)
+			return ERR_PTR(-ENOMEM);
+		handle->h_invalid = 1;
+		/*
+		 * This is done by start_this_handle() if journalling
+		 * is enabled.
+		 */
+		handle->saved_alloc_context = memalloc_nofs_save();
+		current->journal_info = handle;
+	}
+	handle->h_ref++;
 	return handle;
 }
 
@@ -48,14 +56,14 @@ static handle_t *ext4_get_nojournal(void)
 /* Decrement the non-pointer handle value */
 static void ext4_put_nojournal(handle_t *handle)
 {
-	unsigned long ref_cnt = (unsigned long)handle;
+	BUG_ON(handle->h_ref == 0);
 
-	BUG_ON(ref_cnt == 0);
-
-	ref_cnt--;
-	handle = (handle_t *)ref_cnt;
-
-	current->journal_info = handle;
+	handle->h_ref--;
+	if (handle->h_ref == 0) {
+		memalloc_nofs_restore(handle->saved_alloc_context);
+		jbd2_free_handle(handle);
+		current->journal_info = NULL;
+	}
 }
 
 /*
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 63d17c5201b5..2fbf48b3dfe2 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -182,15 +182,11 @@ handle_t *__ext4_journal_start_sb(struct inode *inode, struct super_block *sb,
 				  int rsv_blocks, int revoke_creds);
 int __ext4_journal_stop(const char *where, unsigned int line, handle_t *handle);
 
-#define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
-
 /* Note:  Do not use this for NULL handles.  This is only to determine if
  * a properly allocated handle is using a journal or not. */
 static inline int ext4_handle_valid(handle_t *handle)
 {
-	if ((unsigned long)handle < EXT4_NOJOURNAL_MAX_REF_COUNT)
-		return 0;
-	return 1;
+	return (handle && !handle->h_invalid);
 }
 
 static inline void ext4_handle_sync(handle_t *handle)
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4fdf089500f6..f0eab6151f48 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -94,6 +94,7 @@ EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
 EXPORT_SYMBOL(jbd2_inode_cache);
+EXPORT_SYMBOL(jbd2_handle_cache);
 
 #ifdef CONFIG_JBD2_DEBUG
 void __jbd2_debug(int level, const char *file, const char *func,
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index b68561187e90..7348fdadc810 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -513,6 +513,7 @@ struct jbd2_journal_handle
 	unsigned int	h_sync:		1;
 	unsigned int	h_reserved:	1;
 	unsigned int	h_aborted:	1;
+	unsigned int	h_invalid:	1;
 	unsigned int	h_type:		8;
 	unsigned int	h_line_no:	16;
 
-- 
2.53.0

