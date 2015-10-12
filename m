From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH v2] ext4, jbd2: ensure entering into panic after recording an
 error in superblock
Date: Mon, 12 Oct 2015 11:19:19 +0900
Message-ID: <1444616359-21149-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:33071 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbbJLCTG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Oct 2015 22:19:06 -0400
Received: from epcpsbgr1.samsung.com
 (u141.gpu120.samsung.co.kr [203.254.230.141])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NW301B2S53RPJ80@mailout4.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 12 Oct 2015 11:19:03 +0900 (KST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a EXT4 filesystem utilizes JBD2 journaling and an error occurs, the
journaling will be aborted first and the error number will be recorded
into JBD2 superblock and, finally, the system will enter into the
panic state in "errors=panic" option.  But, in the rare case, this
sequence is little twisted like the below figure and it will happen
that the system enters into panic state, which means the system reset
in mobile environment, before completion of recording an error in the
journal superblock. In this case, e2fsck cannot recognize that the
filesystem failure occurred in the previous run and the corruption
wouldn't be fixed.

Task A                        Task B
ext4_handle_error()
-> jbd2_journal_abort()
  -> __journal_abort_soft()
    -> __jbd2_journal_abort_hard()
    | -> journal->j_flags |= JBD2_ABORT;
    |
    |                         __ext4_abort()
    |                         -> jbd2_journal_abort()
    |                         | -> __journal_abort_soft()
    |                         |   -> if (journal->j_flags & JBD2_ABORT)
    |                         |           return;
    |                         -> panic()
    |
    -> jbd2_journal_update_sb_errno()

Tested-by: Hobin Woo <hobin.woo@samsung.com>
Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c      |   12 ++++++++++--
 fs/jbd2/journal.c    |    6 +++++-
 include/linux/jbd2.h |    1 +
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ca9d4a2..baecf29 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -380,9 +380,13 @@ static void ext4_handle_error(struct super_block *sb)
 		smp_wmb();
 		sb->s_flags |= MS_RDONLY;
 	}
-	if (test_opt(sb, ERRORS_PANIC))
+	if (test_opt(sb, ERRORS_PANIC)) {
+		if (EXT4_SB(sb)->s_journal &&
+		  !(EXT4_SB(sb)->s_journal->j_flags & JBD2_REC_ERR))
+			return;
 		panic("EXT4-fs (device %s): panic forced after error\n",
 			sb->s_id);
+	}
 }
 
 #define ext4_error_ratelimit(sb)					\
@@ -571,8 +575,12 @@ void __ext4_abort(struct super_block *sb, const char *function,
 			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 		save_error_info(sb, function, line);
 	}
-	if (test_opt(sb, ERRORS_PANIC))
+	if (test_opt(sb, ERRORS_PANIC)) {
+		if (EXT4_SB(sb)->s_journal &&
+		  !(EXT4_SB(sb)->s_journal->j_flags & JBD2_REC_ERR))
+			return;
 		panic("EXT4-fs panic from previous error\n");
+	}
 }
 
 void __ext4_msg(struct super_block *sb,
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index b96bd80..b7ac9f2 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2053,8 +2053,12 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 
 	__jbd2_journal_abort_hard(journal);
 
-	if (errno)
+	if (errno) {
 		jbd2_journal_update_sb_errno(journal);
+		write_lock(&journal->j_state_lock);
+		journal->j_flags |= JBD2_REC_ERR;
+		write_unlock(&journal->j_state_lock);
+	}
 }
 
 /**
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 20e7f78..75f2e85 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1007,6 +1007,7 @@ struct journal_s
 #define JBD2_ABORT_ON_SYNCDATA_ERR	0x040	/* Abort the journal on file
 						 * data write error in ordered
 						 * mode */
+#define JBD2_REC_ERR	0x080	/* The errno in the sb has been recorded */
 
 /*
  * Function declarations for the journaling transaction and buffer
-- 
1.7.9.5

