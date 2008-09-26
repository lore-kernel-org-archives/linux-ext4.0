From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 2/10] ext3: Fix error handling in write_super_lockfs/unlockfs
Date: Fri, 26 Sep 2008 17:57:31 +0900
Message-ID: <20080926175732t-sato__6639.23059260032$1222419551$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"mtk.manpages@googlemail.c
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:60444 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYIZI5t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Sep 2008 04:57:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Changed write_super_lockfs so that it returns an error in case of an failure.
unlockfs always returns 0.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 super.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs/Documentation/dontdiff linux-2.6.27-rc7-lockfs/fs/ext3/super.c linux-2.6.27-rc7-lo
ckfs-ext3/fs/ext3/super.c
--- linux-2.6.27-rc7-lockfs/fs/ext3/super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-ext3/fs/ext3/super.c	2008-09-26 16:54:41.000000000 +0900
@@ -48,8 +48,8 @@ static int ext3_load_journal(struct supe
 			     unsigned long journal_devnum);
 static int ext3_create_journal(struct super_block *, struct ext3_super_block *,
 			       unsigned int);
-static void ext3_commit_super (struct super_block * sb,
-			       struct ext3_super_block * es,
+static int ext3_commit_super(struct super_block *sb,
+			       struct ext3_super_block *es,
 			       int sync);
 static void ext3_mark_recovery_complete(struct super_block * sb,
 					struct ext3_super_block * es);
@@ -60,9 +60,9 @@ static const char *ext3_decode_error(str
 				     char nbuf[16]);
 static int ext3_remount (struct super_block * sb, int * flags, char * data);
 static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf);
-static void ext3_unlockfs(struct super_block *sb);
+static int ext3_unfreeze(struct super_block *sb);
 static void ext3_write_super (struct super_block * sb);
-static void ext3_write_super_lockfs(struct super_block *sb);
+static int ext3_freeze(struct super_block *sb);
 
 /*
  * Wrappers for journal_start/end.
@@ -728,8 +728,8 @@ static const struct super_operations ext
 	.put_super	= ext3_put_super,
 	.write_super	= ext3_write_super,
 	.sync_fs	= ext3_sync_fs,
-	.write_super_lockfs = ext3_write_super_lockfs,
-	.unlockfs	= ext3_unlockfs,
+	.freeze_fs	= ext3_freeze,
+	.unfreeze_fs	= ext3_unfreeze,
 	.statfs		= ext3_statfs,
 	.remount_fs	= ext3_remount,
 	.clear_inode	= ext3_clear_inode,
@@ -2251,21 +2251,23 @@ static int ext3_create_journal(struct su
 	return 0;
 }
 
-static void ext3_commit_super (struct super_block * sb,
-			       struct ext3_super_block * es,
+static int ext3_commit_super(struct super_block *sb,
+			       struct ext3_super_block *es,
 			       int sync)
 {
 	struct buffer_head *sbh = EXT3_SB(sb)->s_sbh;
+	int error = 0;
 
 	if (!sbh)
-		return;
+		return error;
 	es->s_wtime = cpu_to_le32(get_seconds());
 	es->s_free_blocks_count = cpu_to_le32(ext3_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext3_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync)
-		sync_dirty_buffer(sbh);
+		error = sync_dirty_buffer(sbh);
+	return error;
 }
 
 
@@ -2379,28 +2381,39 @@ static int ext3_sync_fs(struct super_blo
  * LVM calls this function before a (read-only) snapshot is created.  This
  * gives us a chance to flush the journal completely and mark the fs clean.
  */
-static void ext3_write_super_lockfs(struct super_block *sb)
+static int ext3_freeze(struct super_block *sb)
 {
+	int error = 0;
+	journal_t *journal;
 	sb->s_dirt = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		journal_t *journal = EXT3_SB(sb)->s_journal;
+		journal = EXT3_SB(sb)->s_journal;
 
 		/* Now we set up the journal barrier. */
 		journal_lock_updates(journal);
-		journal_flush(journal);
+		error = journal_flush(journal);
+		if (error)
+			goto out;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
-		ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
+		error = ext3_commit_super(sb, EXT3_SB(sb)->s_es, 1);
+		if (error)
+			goto out;
 	}
+	return 0;
+
+out:
+	journal_unlock_updates(journal);
+	return error;
 }
 
 /*
  * Called by LVM after the snapshot is done.  We need to reset the RECOVER
  * flag here, even though the filesystem is not technically dirty yet.
  */
-static void ext3_unlockfs(struct super_block *sb)
+static int ext3_unfreeze(struct super_block *sb)
 {
 	if (!(sb->s_flags & MS_RDONLY)) {
 		lock_super(sb);
@@ -2410,6 +2423,7 @@ static void ext3_unlockfs(struct super_b
 		unlock_super(sb);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 	}
+	return 0;
 }
 
 static int ext3_remount (struct super_block * sb, int * flags, char * data)
