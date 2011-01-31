From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 1/4] Update ext4 journal routines to specify if journal
 allocations can fail with ENOMEM
Date: Sun, 30 Jan 2011 17:14:18 -0800
Message-ID: <AANLkTimMq=c_6TxghAUto8V0Cvei+ch8dXb_mY1Drw19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mkatiyar@gmail.com
To: "Theodore Ts'o" <tytso@mit.edu>, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65072 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1AaBOk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Jan 2011 20:14:40 -0500
Received: by qwa26 with SMTP id 26so4966822qwa.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Jan 2011 17:14:39 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Following patch updates ext4 journal routines to take extra paramter
to specify whether it
is ok to fail journal transaction allocation or not. Passing 'true'
means allocations can fail with ENOMEM
and the caller has to handle errors.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/ext4/ext4_jbd2.h |    9 +++++----
 fs/ext4/super.c     |    4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d8b992e..38f128e 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -161,7 +161,7 @@ int __ext4_handle_dirty_super(const char *where,
unsigned int line,
 #define ext4_handle_dirty_super(handle, sb) \
 	__ext4_handle_dirty_super(__func__, __LINE__, (handle), (sb))

-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
+handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks,
bool errok);
 int __ext4_journal_stop(const char *where, unsigned int line,
handle_t *handle);

 #define EXT4_NOJOURNAL_MAX_REF_COUNT ((unsigned long) 4096)
@@ -209,9 +209,10 @@ static inline void
ext4_journal_release_buffer(handle_t *handle,
 		jbd2_journal_release_buffer(handle, bh);
 }

-static inline handle_t *ext4_journal_start(struct inode *inode, int nblocks)
+static inline handle_t *ext4_journal_start(struct inode *inode,
+					   int nblocks, bool errok)
 {
-	return ext4_journal_start_sb(inode->i_sb, nblocks);
+	return ext4_journal_start_sb(inode->i_sb, nblocks, errok);
 }

 #define ext4_journal_stop(handle) \
@@ -232,7 +233,7 @@ static inline int ext4_journal_extend(handle_t
*handle, int nblocks)
 static inline int ext4_journal_restart(handle_t *handle, int nblocks)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_restart(handle, nblocks);
+		return jbd2_journal_restart(handle, nblocks, false);
 	return 0;
 }

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cb10a06..3f1d629 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,7 +241,7 @@ static void ext4_put_nojournal(handle_t *handle)
  * that sync() will call the filesystem's write_super callback if
  * appropriate.
  */
-handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
+handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks,
bool errok)
 {
 	journal_t *journal;

@@ -258,7 +258,7 @@ handle_t *ext4_journal_start_sb(struct super_block
*sb, int nblocks)
 			ext4_abort(sb, "Detected aborted journal");
 			return ERR_PTR(-EROFS);
 		}
-		return jbd2_journal_start(journal, nblocks);
+		return jbd2_journal_start(journal, nblocks, errok);
 	}
 	return ext4_get_nojournal();
 }
-- 
1.6.0.4


-- 
Thanks -
Manish
