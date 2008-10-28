From: akpm@linux-foundation.org
Subject: + filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch added to -mm tree
Date: Mon, 27 Oct 2008 23:15:50 -0700
Message-ID: <200810280615.m9S6FoFi020068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: t-sato@yk.jp.nec.com, agk@redhat.com, david@fromorbit.com,
	hch@lst.de, linux-ext4@vger.kernel.org, m-hamaguchi@ys.jp.nec.com,
	shaggy@austin.ibm.com, viro@zeniv.linux.org.uk,
	xfs-masters@oss.sgi.com
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     filesystem freeze: add error handling of write_super_lockfs/unlockfs
has been added to the -mm tree.  Its filename is
     filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: filesystem freeze: add error handling of write_super_lockfs/unlockfs
From: Takashi Sato <t-sato@yk.jp.nec.com>

Currently, ext3 in mainline Linux doesn't have the freeze feature which
suspends write requests.  So, we cannot take a backup which keeps the
filesystem's consistency with the storage device's features (snapshot and
replication) while it is mounted.

In many case, a commercial filesystem (e.g.  VxFS) has the freeze feature
and it would be used to get the consistent backup.

If Linux's standard filesystem ext3 has the freeze feature, we can do it
without a commercial filesystem.

So I have implemented the ioctls of the freeze feature.
I think we can take the consistent backup with the following steps.
1. Freeze the filesystem with the freeze ioctl.
2. Separate the replication volume or create the snapshot
   with the storage device's feature.
3. Unfreeze the filesystem with the unfreeze ioctl.
4. Take the backup from the separated replication volume
   or the snapshot.


This patch:

VFS:
Changed the type of write_super_lockfs and unlockfs from "void"
to "int" so that they can return an error.
Rename write_super_lockfs and unlockfs of the super block operation
freeze_fs and unfreeze_fs to avoid a confusion.

ext3, ext4, xfs, gfs2, jfs:
Changed the type of write_super_lockfs and unlockfs from "void"
to "int" so that write_super_lockfs returns an error if needed,
and unlockfs always returns 0.

reiserfs:
Changed the type of write_super_lockfs and unlockfs from "void"
to "int" so that they always return 0 (success) to keep a current behavior.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Masayuki Hamaguchi <m-hamaguchi@ys.jp.nec.com>
Cc: <xfs-masters@oss.sgi.com>
Cc: <linux-ext4@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/Locking |    8 ++--
 Documentation/filesystems/vfs.txt |    8 ++--
 fs/buffer.c                       |    8 ++--
 fs/ext3/super.c                   |   45 +++++++++++++++++---------
 fs/ext4/super.c                   |   47 +++++++++++++++++++---------
 fs/gfs2/ops_super.c               |   16 +++++----
 fs/jfs/super.c                    |   10 +++--
 fs/reiserfs/super.c               |   10 +++--
 fs/xfs/linux-2.6/xfs_super.c      |    8 ++--
 fs/xfs/xfs_fsops.c                |   11 ++++--
 fs/xfs/xfs_fsops.h                |    2 -
 include/linux/fs.h                |    4 +-
 12 files changed, 108 insertions(+), 69 deletions(-)

diff -puN Documentation/filesystems/Locking~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs Documentation/filesystems/Locking
--- a/Documentation/filesystems/Locking~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/Documentation/filesystems/Locking
@@ -97,8 +97,8 @@ prototypes:
 	void (*put_super) (struct super_block *);
 	void (*write_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
-	void (*write_super_lockfs) (struct super_block *);
-	void (*unlockfs) (struct super_block *);
+	int (*freeze_fs) (struct super_block *);
+	int (*unfreeze_fs) (struct super_block *);
 	int (*statfs) (struct dentry *, struct kstatfs *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
@@ -119,8 +119,8 @@ delete_inode:		no
 put_super:		yes	yes	no
 write_super:		no	yes	read
 sync_fs:		no	no	read
-write_super_lockfs:	?
-unlockfs:		?
+freeze_fs:		?
+unfreeze_fs:		?
 statfs:			no	no	no
 remount_fs:		yes	yes	maybe		(see below)
 clear_inode:		no
diff -puN Documentation/filesystems/vfs.txt~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/Documentation/filesystems/vfs.txt
@@ -210,8 +210,8 @@ struct super_operations {
         void (*put_super) (struct super_block *);
         void (*write_super) (struct super_block *);
         int (*sync_fs)(struct super_block *sb, int wait);
-        void (*write_super_lockfs) (struct super_block *);
-        void (*unlockfs) (struct super_block *);
+        int (*freeze_fs) (struct super_block *);
+        int (*unfreeze_fs) (struct super_block *);
         int (*statfs) (struct dentry *, struct kstatfs *);
         int (*remount_fs) (struct super_block *, int *, char *);
         void (*clear_inode) (struct inode *);
@@ -270,11 +270,11 @@ or bottom half).
   	a superblock. The second parameter indicates whether the method
 	should wait until the write out has been completed. Optional.
 
-  write_super_lockfs: called when VFS is locking a filesystem and
+  freeze_fs: called when VFS is locking a filesystem and
   	forcing it into a consistent state.  This method is currently
   	used by the Logical Volume Manager (LVM).
 
-  unlockfs: called when VFS is unlocking a filesystem and making it writable
+  unfreeze_fs: called when VFS is unlocking a filesystem and making it writable
   	again.
 
   statfs: called when the VFS needs to get filesystem statistics. This
diff -puN fs/buffer.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/buffer.c
--- a/fs/buffer.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/buffer.c
@@ -213,8 +213,8 @@ struct super_block *freeze_bdev(struct b
 
 		sync_blockdev(sb->s_bdev);
 
-		if (sb->s_op->write_super_lockfs)
-			sb->s_op->write_super_lockfs(sb);
+		if (sb->s_op->freeze_fs)
+			sb->s_op->freeze_fs(sb);
 	}
 
 	sync_blockdev(bdev);
@@ -234,8 +234,8 @@ void thaw_bdev(struct block_device *bdev
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
 
-		if (sb->s_op->unlockfs)
-			sb->s_op->unlockfs(sb);
+		if (sb->s_op->unfreeze_fs)
+			sb->s_op->unfreeze_fs(sb);
 		sb->s_frozen = SB_UNFROZEN;
 		smp_wmb();
 		wake_up(&sb->s_wait_unfrozen);
diff -puN fs/ext3/super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/ext3/super.c
--- a/fs/ext3/super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/ext3/super.c
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
@@ -736,8 +736,8 @@ static const struct super_operations ext
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
@@ -2283,21 +2283,23 @@ static int ext3_create_journal(struct su
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
 
 
@@ -2415,12 +2417,14 @@ static int ext3_sync_fs(struct super_blo
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
@@ -2429,20 +2433,28 @@ static void ext3_write_super_lockfs(stru
 		 * We don't want to clear needs_recovery flag when we failed
 		 * to flush the journal.
 		 */
-		if (journal_flush(journal) < 0)
-			return;
+		error = journal_flush(journal);
+		if (error < 0)
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
@@ -2452,6 +2464,7 @@ static void ext3_unlockfs(struct super_b
 		unlock_super(sb);
 		journal_unlock_updates(EXT3_SB(sb)->s_journal);
 	}
+	return 0;
 }
 
 static int ext3_remount (struct super_block * sb, int * flags, char * data)
diff -puN fs/ext4/super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/ext4/super.c
--- a/fs/ext4/super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/ext4/super.c
@@ -53,7 +53,7 @@ static int ext4_load_journal(struct supe
 			     unsigned long journal_devnum);
 static int ext4_create_journal(struct super_block *, struct ext4_super_block *,
 			       unsigned int);
-static void ext4_commit_super(struct super_block *sb,
+static int ext4_commit_super(struct super_block *sb,
 			      struct ext4_super_block *es, int sync);
 static void ext4_mark_recovery_complete(struct super_block *sb,
 					struct ext4_super_block *es);
@@ -64,9 +64,9 @@ static const char *ext4_decode_error(str
 				     char nbuf[16]);
 static int ext4_remount(struct super_block *sb, int *flags, char *data);
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf);
-static void ext4_unlockfs(struct super_block *sb);
+static int ext4_unfreeze(struct super_block *sb);
 static void ext4_write_super(struct super_block *sb);
-static void ext4_write_super_lockfs(struct super_block *sb);
+static int ext4_freeze(struct super_block *sb);
 
 
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
@@ -826,8 +826,8 @@ static const struct super_operations ext
 	.put_super	= ext4_put_super,
 	.write_super	= ext4_write_super,
 	.sync_fs	= ext4_sync_fs,
-	.write_super_lockfs = ext4_write_super_lockfs,
-	.unlockfs	= ext4_unlockfs,
+	.freeze_fs	= ext4_freeze,
+	.unfreeze_fs	= ext4_unfreeze,
 	.statfs		= ext4_statfs,
 	.remount_fs	= ext4_remount,
 	.clear_inode	= ext4_clear_inode,
@@ -2759,13 +2759,14 @@ static int ext4_create_journal(struct su
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
 	if (buffer_write_io_error(sbh)) {
 		/*
 		 * Oh, dear.  A previous attempt to write the
@@ -2786,14 +2787,19 @@ static void ext4_commit_super(struct sup
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync) {
-		sync_dirty_buffer(sbh);
-		if (buffer_write_io_error(sbh)) {
+		error = sync_dirty_buffer(sbh);
+		if (error)
+			return error;
+
+		error = buffer_write_io_error(sbh);
+		if (error) {
 			printk(KERN_ERR "ext4: I/O error while writing "
 			       "superblock for %s.\n", sb->s_id);
 			clear_buffer_write_io_error(sbh);
 			set_buffer_uptodate(sbh);
 		}
 	}
+	return error;
 }
 
 
@@ -2912,12 +2918,14 @@ static int ext4_sync_fs(struct super_blo
  * LVM calls this function before a (read-only) snapshot is created.  This
  * gives us a chance to flush the journal completely and mark the fs clean.
  */
-static void ext4_write_super_lockfs(struct super_block *sb)
+static int ext4_freeze(struct super_block *sb)
 {
+	int error = 0;
+	journal_t *journal;
 	sb->s_dirt = 0;
 
 	if (!(sb->s_flags & MS_RDONLY)) {
-		journal_t *journal = EXT4_SB(sb)->s_journal;
+		journal = EXT4_SB(sb)->s_journal;
 
 		/* Now we set up the journal barrier. */
 		jbd2_journal_lock_updates(journal);
@@ -2926,20 +2934,28 @@ static void ext4_write_super_lockfs(stru
 		 * We don't want to clear needs_recovery flag when we failed
 		 * to flush the journal.
 		 */
-		if (jbd2_journal_flush(journal) < 0)
-			return;
+		error = jbd2_journal_flush(journal);
+		if (error < 0)
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
+static int ext4_unfreeze(struct super_block *sb)
 {
 	if (!(sb->s_flags & MS_RDONLY)) {
 		lock_super(sb);
@@ -2949,6 +2965,7 @@ static void ext4_unlockfs(struct super_b
 		unlock_super(sb);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	}
+	return 0;
 }
 
 static int ext4_remount(struct super_block *sb, int *flags, char *data)
diff -puN fs/gfs2/ops_super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/gfs2/ops_super.c
--- a/fs/gfs2/ops_super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/gfs2/ops_super.c
@@ -214,18 +214,18 @@ static int gfs2_sync_fs(struct super_blo
 }
 
 /**
- * gfs2_write_super_lockfs - prevent further writes to the filesystem
+ * gfs2_freeze - prevent further writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static void gfs2_write_super_lockfs(struct super_block *sb)
+static int gfs2_freeze(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
 
 	if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return;
+		return -EINVAL;
 
 	for (;;) {
 		error = gfs2_freeze_fs(sdp);
@@ -245,17 +245,19 @@ static void gfs2_write_super_lockfs(stru
 		fs_err(sdp, "retrying...\n");
 		msleep(1000);
 	}
+	return 0;
 }
 
 /**
- * gfs2_unlockfs - reallow writes to the filesystem
+ * gfs2_unfreeze - reallow writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static void gfs2_unlockfs(struct super_block *sb)
+static int gfs2_unfreeze(struct super_block *sb)
 {
 	gfs2_unfreeze_fs(sb->s_fs_info);
+	return 0;
 }
 
 /**
@@ -563,8 +565,8 @@ const struct super_operations gfs2_super
 	.put_super		= gfs2_put_super,
 	.write_super		= gfs2_write_super,
 	.sync_fs		= gfs2_sync_fs,
-	.write_super_lockfs 	= gfs2_write_super_lockfs,
-	.unlockfs		= gfs2_unlockfs,
+	.freeze_fs 		= gfs2_freeze,
+	.unfreeze_fs		= gfs2_unfreeze,
 	.statfs			= gfs2_statfs,
 	.remount_fs		= gfs2_remount_fs,
 	.clear_inode		= gfs2_clear_inode,
diff -puN fs/jfs/super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/jfs/super.c
--- a/fs/jfs/super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/jfs/super.c
@@ -543,7 +543,7 @@ out_kfree:
 	return ret;
 }
 
-static void jfs_write_super_lockfs(struct super_block *sb)
+static int jfs_freeze(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
@@ -553,9 +553,10 @@ static void jfs_write_super_lockfs(struc
 		lmLogShutdown(log);
 		updateSuper(sb, FM_CLEAN);
 	}
+	return 0;
 }
 
-static void jfs_unlockfs(struct super_block *sb)
+static int jfs_unfreeze(struct super_block *sb)
 {
 	struct jfs_sb_info *sbi = JFS_SBI(sb);
 	struct jfs_log *log = sbi->log;
@@ -568,6 +569,7 @@ static void jfs_unlockfs(struct super_bl
 		else
 			txResume(sb);
 	}
+	return 0;
 }
 
 static int jfs_get_sb(struct file_system_type *fs_type,
@@ -735,8 +737,8 @@ static const struct super_operations jfs
 	.delete_inode	= jfs_delete_inode,
 	.put_super	= jfs_put_super,
 	.sync_fs	= jfs_sync_fs,
-	.write_super_lockfs = jfs_write_super_lockfs,
-	.unlockfs       = jfs_unlockfs,
+	.freeze_fs	= jfs_freeze,
+	.unfreeze_fs	= jfs_unfreeze,
 	.statfs		= jfs_statfs,
 	.remount_fs	= jfs_remount,
 	.show_options	= jfs_show_options,
diff -puN fs/reiserfs/super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/reiserfs/super.c
@@ -83,7 +83,7 @@ static void reiserfs_write_super(struct 
 	reiserfs_sync_fs(s, 1);
 }
 
-static void reiserfs_write_super_lockfs(struct super_block *s)
+static int reiserfs_freeze(struct super_block *s)
 {
 	struct reiserfs_transaction_handle th;
 	reiserfs_write_lock(s);
@@ -101,11 +101,13 @@ static void reiserfs_write_super_lockfs(
 	}
 	s->s_dirt = 0;
 	reiserfs_write_unlock(s);
+	return 0;
 }
 
-static void reiserfs_unlockfs(struct super_block *s)
+static int reiserfs_unfreeze(struct super_block *s)
 {
 	reiserfs_allow_writes(s);
+	return 0;
 }
 
 extern const struct in_core_key MAX_IN_CORE_KEY;
@@ -613,8 +615,8 @@ static const struct super_operations rei
 	.put_super = reiserfs_put_super,
 	.write_super = reiserfs_write_super,
 	.sync_fs = reiserfs_sync_fs,
-	.write_super_lockfs = reiserfs_write_super_lockfs,
-	.unlockfs = reiserfs_unlockfs,
+	.freeze_fs = reiserfs_freeze,
+	.unfreeze_fs = reiserfs_unfreeze,
 	.statfs = reiserfs_statfs,
 	.remount_fs = reiserfs_remount,
 	.show_options = generic_show_options,
diff -puN fs/xfs/linux-2.6/xfs_super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -1269,14 +1269,14 @@ xfs_fs_remount(
  * need to take care of the metadata. Once that's done write a dummy
  * record to dirty the log in case of a crash while frozen.
  */
-STATIC void
-xfs_fs_lockfs(
+STATIC int
+xfs_fs_freeze(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_quiesce_attr(mp);
-	xfs_fs_log_dummy(mp);
+	return -xfs_fs_log_dummy(mp);
 }
 
 STATIC int
@@ -1597,7 +1597,7 @@ static struct super_operations xfs_super
 	.put_super		= xfs_fs_put_super,
 	.write_super		= xfs_fs_write_super,
 	.sync_fs		= xfs_fs_sync_super,
-	.write_super_lockfs	= xfs_fs_lockfs,
+	.freeze_fs		= xfs_fs_freeze,
 	.statfs			= xfs_fs_statfs,
 	.remount_fs		= xfs_fs_remount,
 	.show_options		= xfs_fs_show_options,
diff -puN fs/xfs/xfs_fsops.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/xfs/xfs_fsops.c
--- a/fs/xfs/xfs_fsops.c~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/xfs/xfs_fsops.c
@@ -589,17 +589,19 @@ out:
 	return 0;
 }
 
-void
+int
 xfs_fs_log_dummy(
 	xfs_mount_t	*mp)
 {
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
+	int		error;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
-	if (xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0)) {
+	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
-		return;
+		return error;
 	}
 
 	ip = mp->m_rootip;
@@ -609,9 +611,10 @@ xfs_fs_log_dummy(
 	xfs_trans_ihold(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_set_sync(tp);
-	xfs_trans_commit(tp, 0);
+	error = xfs_trans_commit(tp, 0);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 int
diff -puN fs/xfs/xfs_fsops.h~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs fs/xfs/xfs_fsops.h
--- a/fs/xfs/xfs_fsops.h~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/fs/xfs/xfs_fsops.h
@@ -25,6 +25,6 @@ extern int xfs_fs_counts(xfs_mount_t *mp
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern void xfs_fs_log_dummy(xfs_mount_t *mp);
+extern int xfs_fs_log_dummy(xfs_mount_t *mp);
 
 #endif	/* __XFS_FSOPS_H__ */
diff -puN include/linux/fs.h~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs include/linux/fs.h
--- a/include/linux/fs.h~filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs
+++ a/include/linux/fs.h
@@ -1362,8 +1362,8 @@ struct super_operations {
 	void (*put_super) (struct super_block *);
 	void (*write_super) (struct super_block *);
 	int (*sync_fs)(struct super_block *sb, int wait);
-	void (*write_super_lockfs) (struct super_block *);
-	void (*unlockfs) (struct super_block *);
+	int (*freeze_fs) (struct super_block *);
+	int (*unfreeze_fs) (struct super_block *);
 	int (*statfs) (struct dentry *, struct kstatfs *);
 	int (*remount_fs) (struct super_block *, int *, char *);
 	void (*clear_inode) (struct inode *);
_

Patches currently in -mm which might be from t-sato@yk.jp.nec.com are

filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
filesystem-freeze-implement-generic-freeze-feature.patch
filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch

