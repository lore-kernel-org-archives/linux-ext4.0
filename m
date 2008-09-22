From: Takashi Sato <t-sato@yk.jp.nec.com>
Subject: [PATCH 3/10] ext4: Fix error handling in write_super_lockfs/unlockfs
Date: Mon, 22 Sep 2008 19:56:21 +0900
Message-ID: <20080922195621t-sato__42095.5602465712$1222081192$gmane$org@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redh
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:37411 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbYIVK6A (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Sep 2008 06:58:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've changed write_super_lockfs/unlockfs so that they return an error
in case of an I/O failure.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
---
 super.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff -uprN -X linux-2.6.27-rc7-lockfs-ext3/Documentation/dontdiff linux-2.6.27-rc7-lockfs-ext3/fs/ext4/super.c linux-2.6
.27-rc7-lockfs-ext4/fs/ext4/super.c
--- linux-2.6.27-rc7-lockfs-ext3/fs/ext4/super.c	2008-09-22 07:29:55.000000000 +0900
+++ linux-2.6.27-rc7-lockfs-ext4/fs/ext4/super.c	2008-09-22 10:46:36.000000000 +0900
@@ -49,7 +49,7 @@ static int ext4_load_journal(struct supe
 			     unsigned long journal_devnum);
 static int ext4_create_journal(struct super_block *, struct ext4_super_block *,
 			       unsigned int);
-static void ext4_commit_super(struct super_block *sb,
+static int ext4_commit_super(struct super_block *sb,
 			      struct ext4_super_block *es, int sync);
 static void ext4_mark_recovery_complete(struct super_block *sb,
 					struct ext4_super_block *es);
@@ -60,9 +60,9 @@ static const char *ext4_decode_error(str
 				     char nbuf[16]);
 static int ext4_remount(struct super_block *sb, int *flags, char *data);
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf);
-static void ext4_unlockfs(struct super_block *sb);
+static int ext4_unlockfs(struct super_block *sb);
 static void ext4_write_super(struct super_block *sb);
-static void ext4_write_super_lockfs(struct super_block *sb);
+static int ext4_write_super_lockfs(struct super_block *sb);
 
 
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
@@ -2792,20 +2792,22 @@ static int ext4_create_journal(struct su
 	return 0;
 }
 
-static void ext4_commit_super(struct super_block *sb,
+static int ext4_commit_super(struct super_block *sb,
 			      struct ext4_super_block *es, int sync)
 {
 	struct buffer_head *sbh = EXT4_SB(sb)->s_sbh;
+	int error = 0;
 
 	if (!sbh)
-		return;
+		return error;
 	es->s_wtime = cpu_to_le32(get_seconds());
 	ext4_free_blocks_count_set(es, ext4_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext4_count_free_inodes(sb));
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync)
-		sync_dirty_buffer(sbh);
+		error = sync_dirty_buffer(sbh);
+	return error;
 }
 
 
@@ -2919,37 +2921,50 @@ static int ext4_sync_fs(struct super_blo
  * LVM calls this function before a (read-only) snapshot is created.  This
  * gives us a chance to flush the journal completely and mark the fs clean.
  */
-static void ext4_write_super_lockfs(struct super_block *sb)
+static int ext4_write_super_lockfs(struct super_block *sb)
 {
+	int error = 0;
+	journal_t *journal;
 	sb->s_dirt = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		journal_t *journal = EXT4_SB(sb)->s_journal;
+		journal = EXT4_SB(sb)->s_journal;
 
 		/* Now we set up the journal barrier. */
 		jbd2_journal_lock_updates(journal);
-		jbd2_journal_flush(journal);
+		error = jbd2_journal_flush(journal);
+		if (error)
+			goto out;
 
 		/* Journal blocked and flushed, clear needs_recovery flag. */
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
-		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
+		error = ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
+		if (error)
+			goto out;
 	}
+	return 0;
+
+out:
+	jbd2_journal_unlock_updates(journal);
+	return error;
 }
 
 /*
  * Called by LVM after the snapshot is done.  We need to reset the RECOVER
  * flag here, even though the filesystem is not technically dirty yet.
  */
-static void ext4_unlockfs(struct super_block *sb)
+static int ext4_unlockfs(struct super_block *sb)
 {
+	int error = 0;
 	if (!(sb->s_flags & MS_RDONLY)) {
 		lock_super(sb);
 		/* Reser the needs_recovery flag before the fs is unlocked. */
 		EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
-		ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
+		error = ext4_commit_super(sb, EXT4_SB(sb)->s_es, 1);
 		unlock_super(sb);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	}
+	return error;
 }
 
 static int ext4_remount(struct super_block *sb, int *flags, char *data)
