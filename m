Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71621424D40
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784213320; cv=none; b=qGLeUavvYUHobYWWn1PCxHEbTptVrpVnvpcjNMALoYsxZ0W9I6c7ylLP/LvI7v9BjFPPJGdwiTknxdAyi2ccQTQeJMRssYWt2O0j0N47pEXt9m6oWSk0vLunByadHysS7X2cTi5DFqVv/JgbOFF/SjOg7eYPOYE2EHQXQEHV5T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784213320; c=relaxed/simple;
	bh=RZr5amneMOq+2ySPO1hG78msBo2YU3mPgiQhM/MGE4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uWZgDg6WhAnOOWjX0KItv1Yg3Drj/WHTc9c6Tel43G8kl0WsKmJQv2vA3twq7mzyyik0a5EsSXtqSfL7CDkaqCuw1H6ajAMFTo9L6z4NwT0giRE5AKimBWjNagfI1ohuqhDJ6ANnSyNu3wPyryx+Kny6pfhI8CiiOV7shSXwCL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=KhiR3xnl; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="KhiR3xnl"
Received: from trampoline.thunk.org (pool-70-22-250-221.bstnma.fios.verizon.net [70.22.250.221] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 66GEmYIN015788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Jul 2026 10:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1784213315; bh=XWGaOY8568DXWHkF1eD/XDkBahXQ0eOXM4TLZd49RLM=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=KhiR3xnldQiKI3BaeV8wIerICWCPpdWBQSySlsFUDhnDNhf8Ju4bZ2/0Ns1PIqQ4f
	 TD5W5qfI1JWAIFhaizzT8568Ih++v+Xc84HUEIiMi1gfQ3+MTfr6rPFyw1u8PzPCVR
	 tv2i8M2O08CxOJ6MAxAnkgzc54Ujh88zZxCPTdeBHtHvk8MOZ6M2liTRDcDJzxklJm
	 C6L7A4Ixd08UMPdtVPfO2Ytm6nK+TR3V9448vVd1HFTqDCXOUZ/gquP14vs4Sbi5aG
	 7oVGIKaAnmhSS+PknC3aFCaDuXIxEopsUUEKF9wz5BuhZdbLRRBGZ45AU2xvMT+p4h
	 79B1YSUmy85kA==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id 693512E3F04; Thu, 16 Jul 2026 10:48:34 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH -v2] ext4: enable scoped NOFS when starting a handle in nojournal mode
Date: Thu, 16 Jul 2026 10:48:31 -0400
Message-ID: <20260716144831.41290-1-tytso@mit.edu>
X-Mailer: git-send-email 2.53.0
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
 include/linux/jbd2.h |  1 +
 3 files changed, 24 insertions(+), 19 deletions(-)

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

