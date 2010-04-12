From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 5/5] ext2: Add ext2_sb_info s_lock spinlock
Date: Mon, 12 Apr 2010 22:41:45 +0200
Message-ID: <1271104905-8804-6-git-send-email-jblunck@suse.de>
References: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Jan Blunck <jblunck@suse.de>,
	Andi Kleen <andi@firstfloor.org>, Jan Kara <jack@suse.cz>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38975 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab0DLUmH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 12 Apr 2010 16:42:07 -0400
In-Reply-To: <1271104905-8804-1-git-send-email-jblunck@suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a spinlock that protects against concurrent modifications of
s_mount_state, s_blocks_last, s_overhead_last and the content of the
superblock's buffer pointed to by sbi->s_es. This is a preparation patch
for removing the BKL from ext2 in the next patch.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jan Kara <jack@suse.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/ext2/inode.c            |    2 ++
 fs/ext2/super.c            |   31 +++++++++++++++++++++++++++++--
 include/linux/ext2_fs_sb.h |    6 ++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index fc13cc1..5d15442 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1407,9 +1407,11 @@ static int __ext2_write_inode(struct inode *inode, int do_sync)
 				* created, add a flag to the superblock.
 				*/
 				lock_kernel();
+				spin_lock(&EXT2_SB(sb)->s_lock);
 				ext2_update_dynamic_rev(sb);
 				EXT2_SET_RO_COMPAT_FEATURE(sb,
 					EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
+				spin_unlock(&EXT2_SB(sb)->s_lock);
 				unlock_kernel();
 				ext2_write_super(sb);
 			}
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index b01c491..34d7a62 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -52,8 +52,10 @@ void ext2_error (struct super_block * sb, const char * function,
 	struct ext2_super_block *es = sbi->s_es;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
+		spin_lock(&sbi->s_lock);
 		sbi->s_mount_state |= EXT2_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
+		spin_unlock(&sbi->s_lock);
 		ext2_sync_super(sb, es);
 	}
 
@@ -84,6 +86,9 @@ void ext2_msg(struct super_block *sb, const char *prefix,
 	va_end(args);
 }
 
+/*
+ * This must be called with sbi->s_lock held.
+ */
 void ext2_update_dynamic_rev(struct super_block *sb)
 {
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
@@ -124,7 +129,9 @@ static void ext2_put_super (struct super_block * sb)
 	if (!(sb->s_flags & MS_RDONLY)) {
 		struct ext2_super_block *es = sbi->s_es;
 
+		spin_lock(&sbi->s_lock);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
+		spin_unlock(&sbi->s_lock);
 		ext2_sync_super(sb, es);
 	}
 	db_count = sbi->s_gdb_count;
@@ -209,6 +216,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct ext2_super_block *es = sbi->s_es;
 	unsigned long def_mount_opts;
 
+	spin_lock(&sbi->s_lock);
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 
 	if (sbi->s_sb_block != 1)
@@ -281,6 +289,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!test_opt(sb, RESERVATION))
 		seq_puts(seq, ",noreservation");
 
+	spin_unlock(&sbi->s_lock);
 	return 0;
 }
 
@@ -766,6 +775,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = sbi;
 	sbi->s_sb_block = sb_block;
 
+	spin_lock_init(&sbi->s_lock);
+
 	/*
 	 * See what the current blocksize for the device is, and
 	 * use that as the blocksize.  Otherwise (or if the blocksize
@@ -1137,12 +1148,16 @@ static void ext2_commit_super (struct super_block * sb,
 	sb->s_dirt = 0;
 }
 
-static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
+static void ext2_sync_super(struct super_block *sb,
+			    struct ext2_super_block *es)
 {
 	ext2_clear_super_error(sb);
+	spin_lock(&EXT2_SB(sb)->s_lock);
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
+	/* unlock before we do IO */
+	spin_unlock(&EXT2_SB(sb)->s_lock);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
 	sb->s_dirt = 0;
@@ -1158,19 +1173,22 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
  * may have been checked while mounted and e2fsck may have
  * set s_state to EXT2_VALID_FS after some corrections.
  */
-
 static int ext2_sync_fs(struct super_block *sb, int wait)
 {
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
 	struct buffer_head *sbh = EXT2_SB(sb)->s_sbh;
 
 	lock_kernel();
+	spin_lock(&sbi->s_lock);
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
 		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
+		spin_unlock(&sbi->s_lock);
 		ext2_sync_super(sb, es);
 	} else {
 		ext2_commit_super(sb, es);
+		spin_unlock(&sbi->s_lock);
 	}
 	sb->s_dirt = 0;
 	unlock_kernel();
@@ -1197,6 +1215,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	int err;
 
 	lock_kernel();
+	spin_lock(&sbi->s_lock);
 
 	/* Store the old options */
 	old_sb_flags = sb->s_flags;
@@ -1235,12 +1254,14 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
 	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		spin_unlock(&sbi->s_lock);
 		unlock_kernel();
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
 		    !(sbi->s_mount_state & EXT2_VALID_FS)) {
+			spin_unlock(&sbi->s_lock);
 			unlock_kernel();
 			return 0;
 		}
@@ -1250,6 +1271,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		 */
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
 		es->s_mtime = cpu_to_le32(get_seconds());
+		spin_unlock(&sbi->s_lock);
 		ext2_sync_super(sb, es);
 	} else {
 		__le32 ret = EXT2_HAS_RO_COMPAT_FEATURE(sb,
@@ -1270,6 +1292,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		sbi->s_mount_state = le16_to_cpu(es->s_state);
 		if (!ext2_setup_super (sb, es, 0))
 			sb->s_flags &= ~MS_RDONLY;
+		spin_unlock(&sbi->s_lock);
 		ext2_write_super(sb);
 	}
 	unlock_kernel();
@@ -1279,6 +1302,7 @@ restore_opts:
 	sbi->s_resuid = old_opts.s_resuid;
 	sbi->s_resgid = old_opts.s_resgid;
 	sb->s_flags = old_sb_flags;
+	spin_unlock(&sbi->s_lock);
 	unlock_kernel();
 	return err;
 }
@@ -1290,6 +1314,8 @@ static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
 	struct ext2_super_block *es = sbi->s_es;
 	u64 fsid;
 
+	spin_lock(&sbi->s_lock);
+
 	if (test_opt (sb, MINIX_DF))
 		sbi->s_overhead_last = 0;
 	else if (sbi->s_blocks_last != le32_to_cpu(es->s_blocks_count)) {
@@ -1344,6 +1370,7 @@ static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
+	spin_unlock(&sbi->s_lock);
 	return 0;
 }
 
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index 1cdb663..dbc5934 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
@@ -106,6 +106,12 @@ struct ext2_sb_info {
 	spinlock_t s_rsv_window_lock;
 	struct rb_root s_rsv_window_root;
 	struct ext2_reserve_window_node s_rsv_window_head;
+	/*
+	 * protects against concurrent modifications of s_mount_state,
+	 * s_blocks_last, s_overhead_last and the content of superblock's
+	 * buffer pointed to by sbi->s_es.
+	 */
+	spinlock_t s_lock;
 };
 
 static inline spinlock_t *
-- 
1.6.4.2

