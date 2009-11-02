From: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 04/27] ext2: Add ext2_sb_info mutex
Date: Mon, 2 Nov 2009 17:57:52 +0100
Message-ID: <20091102165752.GF21750@bolzano.suse.de>
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-5-git-send-email-jblunck@suse.de> <20091102102654.GG31511@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ev7mvGV+3JQuI2Eo"
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Christoph Hellwig <hch@lst.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756181AbZKBQ5z@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091102102654.GG31511@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--ev7mvGV+3JQuI2Eo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 02, Andi Kleen wrote:

> > @@ -762,6 +767,12 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
> >  	sbi->s_sb_block = sb_block;
> >  
> >  	/*
> > +	 * mutex for protection of modifications of the superblock while being
> > +	 * write out by ext2_write_super() or ext2_sync_fs().
> > +	 */
> > +	mutex_init(&sbi->s_mutex);
> 
> I didn't go over all the code paths in detail, but if you replace
> the BKL with a mutex that is hold over a longer write-out sleep
> period you potentially limit IO parallelism a lot.

Right. I converted it to be a spinlock and unlock before calling
ext2_sync_super().

What do you think?

Thanks,
Jan

--ev7mvGV+3JQuI2Eo
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0005-ext2-Add-ext2_sb_info-spinlock.patch"

>From d70afd90149d0318c0fe51d05aaebe24c7def96a Mon Sep 17 00:00:00 2001
From: Jan Blunck <jblunck@suse.de>
Date: Mon, 2 Nov 2009 17:20:28 +0100
Subject: [PATCH 05/28] ext2: Add ext2_sb_info spinlock

Add a spinlock that protects the ext2_sb_info from concurrent modifications.
This is a preparation for removing the BKL later.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>
---
 fs/ext2/inode.c            |    2 ++
 fs/ext2/super.c            |   41 ++++++++++++++++++++++++++++++++++++-----
 include/linux/ext2_fs_sb.h |    2 ++
 3 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index ade6340..65a0d4b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1401,9 +1401,11 @@ int ext2_write_inode(struct inode *inode, int do_sync)
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
index 5af1775..70c326c 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -52,8 +52,10 @@ void ext2_error (struct super_block * sb, const char * function,
 	struct ext2_super_block *es = sbi->s_es;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
+		spin_lock(&sbi->s_lock);
 		sbi->s_mount_state |= EXT2_ERROR_FS;
 		es->s_state |= cpu_to_le16(EXT2_ERROR_FS);
+		/* drops sbi->s_lock */
 		ext2_sync_super(sb, es);
 	}
 
@@ -84,6 +86,9 @@ void ext2_warning (struct super_block * sb, const char * function,
 	va_end(args);
 }
 
+/*
+ * This must be called with sbi->s_lock held.
+ */
 void ext2_update_dynamic_rev(struct super_block *sb)
 {
 	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
@@ -117,14 +122,16 @@ static void ext2_put_super (struct super_block * sb)
 
 	lock_kernel();
 
-	if (sb->s_dirt)
-		ext2_write_super(sb);
+	if (sb->s_dirt && !(sb->s_flags & MS_RDONLY))
+		ext2_sync_fs(sb, 1);
 
 	ext2_xattr_put_super(sb);
 	if (!(sb->s_flags & MS_RDONLY)) {
 		struct ext2_super_block *es = sbi->s_es;
 
+		spin_lock(&sbi->s_lock);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
+		/* drops sbi->s_lock */
 		ext2_sync_super(sb, es);
 	}
 	db_count = sbi->s_gdb_count;
@@ -207,6 +214,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	struct ext2_super_block *es = sbi->s_es;
 	unsigned long def_mount_opts;
 
+	spin_lock(&sbi->s_lock);
 	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
 
 	if (sbi->s_sb_block != 1)
@@ -279,6 +287,7 @@ static int ext2_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	if (!test_opt(sb, RESERVATION))
 		seq_puts(seq, ",noreservation");
 
+	spin_unlock(&sbi->s_lock);
 	return 0;
 }
 
@@ -762,6 +771,12 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_sb_block = sb_block;
 
 	/*
+	 * mutex for protection of modifications of the superblock while being
+	 * write out by ext2_write_super() or ext2_sync_fs().
+	 */
+	spin_lock_init(&sbi->s_lock);
+
+	/*
 	 * See what the current blocksize for the device is, and
 	 * use that as the blocksize.  Otherwise (or if the blocksize
 	 * is smaller than the default) use the default.
@@ -1103,11 +1118,14 @@ static void ext2_commit_super (struct super_block * sb,
 	sb->s_dirt = 0;
 }
 
-static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
+static void ext2_sync_super(struct super_block *sb,
+			    struct ext2_super_block *es)
 {
 	es->s_free_blocks_count = cpu_to_le32(ext2_count_free_blocks(sb));
 	es->s_free_inodes_count = cpu_to_le32(ext2_count_free_inodes(sb));
 	es->s_wtime = cpu_to_le32(get_seconds());
+	/* unlock before we do IO */
+	spin_unlock(&EXT2_SB(sb)->s_lock);
 	mark_buffer_dirty(EXT2_SB(sb)->s_sbh);
 	sync_dirty_buffer(EXT2_SB(sb)->s_sbh);
 	sb->s_dirt = 0;
@@ -1122,13 +1140,16 @@ static void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es)
  * flags to 0.  We need to set this flag to 0 since the fs
  * may have been checked while mounted and e2fsck may have
  * set s_state to EXT2_VALID_FS after some corrections.
+ *
+ * This must be called with sbi->s_lock held.
  */
-
 static int ext2_sync_fs(struct super_block *sb, int wait)
 {
-	struct ext2_super_block *es = EXT2_SB(sb)->s_es;
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
+	struct ext2_super_block *es = sbi->s_es;
 
 	lock_kernel();
+	spin_lock(&sbi->s_lock);
 	if (es->s_state & cpu_to_le16(EXT2_VALID_FS)) {
 		ext2_debug("setting valid to 0\n");
 		es->s_state &= cpu_to_le16(~EXT2_VALID_FS);
@@ -1137,9 +1158,11 @@ static int ext2_sync_fs(struct super_block *sb, int wait)
 		es->s_free_inodes_count =
 			cpu_to_le32(ext2_count_free_inodes(sb));
 		es->s_mtime = cpu_to_le32(get_seconds());
+		/* drops sbi->s_lock */
 		ext2_sync_super(sb, es);
 	} else {
 		ext2_commit_super(sb, es);
+		spin_unlock(&sbi->s_lock);
 	}
 	sb->s_dirt = 0;
 	unlock_kernel();
@@ -1166,6 +1189,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	int err;
 
 	lock_kernel();
+	spin_lock(&sbi->s_lock);
 
 	/* Store the old options */
 	old_sb_flags = sb->s_flags;
@@ -1203,12 +1227,14 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
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
@@ -1237,6 +1263,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 		if (!ext2_setup_super (sb, es, 0))
 			sb->s_flags &= ~MS_RDONLY;
 	}
+	/* drops sbi->s_lock */
 	ext2_sync_super(sb, es);
 	unlock_kernel();
 	return 0;
@@ -1245,6 +1272,7 @@ restore_opts:
 	sbi->s_resuid = old_opts.s_resuid;
 	sbi->s_resgid = old_opts.s_resgid;
 	sb->s_flags = old_sb_flags;
+	spin_unlock(&sbi->s_lock);
 	unlock_kernel();
 	return err;
 }
@@ -1256,6 +1284,8 @@ static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
 	struct ext2_super_block *es = sbi->s_es;
 	u64 fsid;
 
+	spin_lock(&sbi->s_lock);
+
 	if (test_opt (sb, MINIX_DF))
 		sbi->s_overhead_last = 0;
 	else if (sbi->s_blocks_last != le32_to_cpu(es->s_blocks_count)) {
@@ -1310,6 +1340,7 @@ static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
 	       le64_to_cpup((void *)es->s_uuid + sizeof(u64));
 	buf->f_fsid.val[0] = fsid & 0xFFFFFFFFUL;
 	buf->f_fsid.val[1] = (fsid >> 32) & 0xFFFFFFFFUL;
+	spin_unlock(&sbi->s_lock);
 	return 0;
 }
 
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index 1cdb663..0d20278 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
@@ -106,6 +106,8 @@ struct ext2_sb_info {
 	spinlock_t s_rsv_window_lock;
 	struct rb_root s_rsv_window_root;
 	struct ext2_reserve_window_node s_rsv_window_head;
+	/* protect against concurrent modifications of this structure */
+	spinlock_t s_lock;
 };
 
 static inline spinlock_t *
-- 
1.6.4.2


--ev7mvGV+3JQuI2Eo--
