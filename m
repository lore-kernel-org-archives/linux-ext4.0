Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355703EAC8F
	for <linux-ext4@vger.kernel.org>; Thu, 25 Jun 2026 17:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782408347; cv=none; b=aOsbjeCKhaA/4bAtDJwhut0sQvVKMmE9+AmcMroSCS7775yKMXmbtyG/2ptC0Co/47wYIfsWZETMwpf2zQ4jHjm6BkXtzaG96RmJS3QWXO8MuNFddf2JeyTALMoUuA/sejTUheWkKB4KDqIwpSvzQ/TXJSk2j5Uv11gfDom2wzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782408347; c=relaxed/simple;
	bh=8O0z6NM21IytQL/RKeSrTG52KWtD0u15OsIU6uvkf68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SMNJcSOYj0pH+0JTe57TfNKY11KUgXWFdhStSHpkh41xSgLuPwFXFtIEYgvVE5AWWLcX/7jC7Ydg5vFBQscU02Rk66c1whHHm8C25Bvy7tqVmRraDSuPbcSESgL14H2ssglwfzNFTWoN6z69VTbEdgObwuwMnhUVXjaGSL4eHck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=UDDNOxPh; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="UDDNOxPh"
Received: from trampoline.thunk.org (pool-108-26-156-113.bstnma.fios.verizon.net [108.26.156.113])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 65PHMTFF003904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jun 2026 13:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1782408152; bh=10Hut2mNUeuBmzPVHLp1hncCuphKpgToxyugpIRx+4k=;
	h=From:Subject:Date:Message-ID:MIME-Version;
	b=UDDNOxPh6iiYw614Vh6rU2CQK+A/Fuufo1C0uoqsy787YR9i3bzS77uC00FeHlclT
	 n6Gz8tJQ/3lrr3K0PvTOrnrvEUKPIftLTlVezRb+u2V/VT1zu9/jO/E2bLlAXl6m/J
	 mOTdQD+aVquZlx73wrURFoFqOeTo49MssTYqmSIzoIlk3yXcwQG10R2KvMeulxlECS
	 ka6OMa2c+WGZfKbAXypnoUPWrD+Kcv0B2IjdO9CItnCpZp3zpI4axi/xS0JGc1MHH/
	 aVFlG2Ry8sCEgfwECeju7Zz2ucAhKnLytmJqceFL5TQ/TmPKaOChzyv5EskkVgsU/G
	 8RAO7GXSTaV8g==
Received: by trampoline.thunk.org (Postfix, from userid 15806)
	id F3CD12E3652; Thu, 25 Jun 2026 13:22:28 -0400 (EDT)
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH RFC] ext4: enable scoped NOFS when starting a handle in nojournal mode
Date: Thu, 25 Jun 2026 13:22:23 -0400
Message-ID: <20260625172223.88878-1-tytso@mit.edu>
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
 fs/ext4/ext4_jbd2.c  | 35 ++++++++++++++++++++++-------------
 fs/ext4/ext4_jbd2.h  |  6 +-----
 include/linux/jbd2.h |  1 +
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 9a8c225f2753..c2f09cf4b506 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -35,12 +35,21 @@ static handle_t *ext4_get_nojournal(void)
 	handle_t *handle = current->journal_info;
 	unsigned long ref_cnt = (unsigned long)handle;
 
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
 
@@ -48,14 +57,14 @@ static handle_t *ext4_get_nojournal(void)
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
index 63d17c5201b5..75d4670d389c 100644
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
+	return !handle->h_invalid;
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

