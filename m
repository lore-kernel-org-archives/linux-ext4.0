From: Jan Blunck <jblunck@suse.de>
Subject: [PATCH 04/27] ext2: Add ext2_sb_info mutex
Date: Mon,  2 Nov 2009 11:04:44 +0100
Message-ID: <1257156307-24175-5-git-send-email-jblunck@suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Jan Blunck <jblunck@suse.de>, Andi Kleen <andi@firstfloor.org>,
	Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754673AbZKBKHf@vger.kernel.org>
In-Reply-To: <1257156307-24175-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add a mutex that protects the ext2_sb_info from concurrent modifications.
This is a preparation for removing the BKL later.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/ext2/inode.c            |    2 ++
 fs/ext2/super.c            |   30 +++++++++++++++++++++++++++---
 include/linux/ext2_fs_sb.h |    2 ++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index ade6340..057074e 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1401,9 +1401,11 @@ int ext2_write_inode(struct inode *inode, int do_sync)
 				* created, add a flag to the superblock.
 				*/
 				lock_kernel();
+				mutex_lock(&EXT2_SB(sb)->s_mutex);
 				ext2_update_dynamic_rev(sb);
 				EXT2_SET_RO_COMPAT_FEATURE(sb,
 					EXT2_FEATURE_RO_COMPAT_LARGE_FILE);
+				mutex_unlock(&EXT2_SB(sb)->s_mutex);
 				unlock_kernel();
 				ext2_write_super(sb);
 			}
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 5af1775..d610eb9 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -84,6 +84,9 @@ void ext2_warning (struct super_block * sb, const char * function,
 	va_end(args);
 }
 
+/*
+ * This must be called with sbi->s_mutex held.
+ */
 void ext2_update_dynamic_rev(struct super_block *sb)
 {
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
@@ -117,8 +120,8 @@ static void ext2_put_super (struct super_block * sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
-		ext2_write_super(sb);
+	if (sb->s_dirt && !(sb->s_flags & MS_RDONLY))
+		ext2_sync_fs(sb, 1);
 
 	ext2_xattr_put_super(sb);
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -207,6 +210,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct ext2_super_block *es = sbi->s_es;
 	unsigned long def_mount_opts;
 
+	mutex_lock(&sbi->s_mutex);
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 
 	if (sbi->s_sb_block != 1)
@@ -279,6 +283,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!test_opt(sb, RESERVATION))
 		seq_puts(seq, ",noreservation");
 
+	mutex_unlock(&sbi->s_mutex);
 	return 0;
 }
 
@@ -762,6 +767,12 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_sb_block = sb_block;
 
 	/*
+	 * mutex for protection of modifications of the superblock while being
+	 * write out by ext2_write_super() or ext2_sync_fs().
+	 */
+	mutex_init(&sbi->s_mutex);
+
+	/*
 	 * See what the current blocksize for the device is, and
 	 * use that as the blocksize.  Otherwise (or if the blocksize
 	 * is smaller than the default) use the default.
@@ -1122,8 +1133,9 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
  * flags to 0.  We need to set this flag to 0 since the fs
  * may have been checked while mounted and e2fsck may have
  * set s_state to EXT2_VALID_FS after some corrections.
+ *
+ * This must be called with sbi->s_mutex held.
  */
-
 static int ext2_sync_fs(struct super_block *sb, int wait)
 {
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
@@ -1150,10 +1162,14 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 
 void ext2_write_super(struct super_block *sb)
 {
+	struct ext2_sb_info * sbi = EXT2_SB(sb);
+
+	mutex_lock(&sbi->s_mutex);
 	if (!(sb->s_flags & MS_RDONLY))
 		ext2_sync_fs(sb, 1);
 	else
 		sb->s_dirt = 0;
+	mutex_unlock(&sbi->s_mutex);
 }
 
 static int ext2_remount (struct super_block * sb, int * flags, char * data)
@@ -1166,6 +1182,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	int err;
 
 	lock_kernel();
+	mutex_lock(&sbi->s_mutex);
 
 	/* Store the old options */
 	old_sb_flags = sb->s_flags;
@@ -1203,12 +1220,14 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		sbi->s_mount_opt |= old_mount_opt & EXT2_MOUNT_XIP;
 	}
 	if ((*flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
+		mutex_unlock(&sbi->s_mutex);
 		unlock_kernel();
 		return 0;
 	}
 	if (*flags & MS_RDONLY) {
 		if (le16_to_cpu(es->s_state) & EXT2_VALID_FS ||
 		    !(sbi->s_mount_state & EXT2_VALID_FS)) {
+			mutex_unlock(&sbi->s_mutex);
 			unlock_kernel();
 			return 0;
 		}
@@ -1238,6 +1257,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 			sb->s_flags &= ~MS_RDONLY;
 	}
 	ext2_sync_super(sb, es);
+	mutex_unlock(&sbi->s_mutex);
 	unlock_kernel();
 	return 0;
 restore_opts:
@@ -1245,6 +1265,7 @@ restore_opts:
 	sbi->s_resuid = old_opts.s_resuid;
 	sbi->s_resgid = old_opts.s_resgid;
 	sb->s_flags = old_sb_flags;
+	mutex_unlock(&sbi->s_mutex);
 	unlock_kernel();
 	return err;
 }
@@ -1256,6 +1277,8 @@ static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
 	struct ext2_super_block *es = sbi->s_es;
 	u64 fsid;
 
+	mutex_lock(&sbi->s_mutex);
+
 	if (test_opt (sb, MINIX_DF))
 		sbi->s_overhead_last = 0;
 	else if (sbi->s_blocks_last != le32_to_cpu(es->s_blocks_count)) {
@@ -1310,6 +1333,7 @@ static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
+	mutex_unlock(&sbi->s_mutex);
 	return 0;
 }
 
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index 1cdb663..8518361 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
@@ -106,6 +106,8 @@ struct ext2_sb_info {
 	spinlock_t s_rsv_window_lock;
 	struct rb_root s_rsv_window_root;
 	struct ext2_reserve_window_node s_rsv_window_head;
+	/* protect against concurrent modifications of this structure */
+	struct mutex s_mutex;
 };
 
 static inline spinlock_t *
-- 
1.6.4.2
