From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3/5 resend] VFS: Fix s_umount thaw/write deadlock
Date: Mon,  5 Dec 2011 12:54:47 -0800
Message-ID: <1323118489-16326-4-git-send-email-kamal@canonical.com>
References: <1323118489-16326-1-git-send-email-kamal@canonical.com>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323118489-16326-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Valerie Aurora <val@vaaconsulting.com>

File system freeze/thaw require the superblock's s_umount lock.
However, we write to the file system while holding the s_umount lock
in several places (e.g., writeback and quotas).  Any of these can
block on a frozen file system while holding s_umount, preventing any
later thaw from occurring, since thaw requires s_umount.

The solution is to add a check, vfs_is_frozen(), to all code paths
that write while holding sb->s_umount and return without writing if it
is true.

BugLink: https://bugs.launchpad.net/bugs/897421
Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/drop_caches.c   |    8 ++++++++
 fs/fs-writeback.c  |   50 +++++++++++++++++++++++++++++++++-----------------
 fs/quota/quota.c   |   12 +++++++++++-
 fs/super.c         |   26 ++++++++++++++++++++++++++
 fs/sync.c          |    9 +++++----
 include/linux/fs.h |    6 +++++-
 6 files changed, 88 insertions(+), 23 deletions(-)

diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index c00e055..90f8f7e 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -57,6 +57,14 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
 	if (ret)
 		return ret;
+
+	/*
+	 * Any file-system specific routines eventually called by
+	 * drop_pagecache_sb() and drop_slab() ought to check for a
+	 * frozen file system before writing to the disk.  Most file
+	 * systems won't write in this case but XFS is a notable
+	 * exception in certain cases.
+	 */
 	if (write) {
 		if (sysctl_drop_caches & 1)
 			iterate_supers(drop_pagecache_sb, NULL);
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 73c3992..dbeaede 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -554,6 +554,14 @@ static long writeback_sb_inodes(struct super_block *sb,
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
 
+		if (inode->i_sb == sb && vfs_is_frozen(sb)) {
+			/*
+			 * Inode is on a frozen superblock; skip it for now.
+			 */
+			redirty_tail(inode, wb);
+			continue;
+		}
+
 		if (inode->i_sb != sb) {
 			if (work->sb) {
 				/*
@@ -1266,40 +1274,48 @@ EXPORT_SYMBOL(writeback_inodes_sb);
  * writeback_inodes_sb_if_idle	-	start writeback if none underway
  * @sb: the superblock
  *
- * Invoke writeback_inodes_sb if no writeback is currently underway.
- * Returns 1 if writeback was started, 0 if not.
+ * Invoke writeback_inodes_sb if no writeback is currently underway
+ * and no one else holds the s_umount lock.  Returns 1 if writeback
+ * was started, 0 if not.
  */
 int writeback_inodes_sb_if_idle(struct super_block *sb, enum wb_reason reason)
 {
 	if (!writeback_in_progress(sb->s_bdi)) {
-		down_read(&sb->s_umount);
-		writeback_inodes_sb(sb, reason);
-		up_read(&sb->s_umount);
-		return 1;
-	} else
-		return 0;
+		/*
+		 * Trylock also avoids read-write deadlocks that could be
+		 * triggered by freeze.
+		 */
+		if (down_read_trylock(&sb->s_umount)) {
+			writeback_inodes_sb(sb, reason);
+			up_read(&sb->s_umount);
+			return 1;
+		}
+	}
+	return 0;
 }
 EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
 
 /**
- * writeback_inodes_sb_if_idle	-	start writeback if none underway
+ * writeback_inodes_sb_nr_if_idle	-	start writeback if none underway
  * @sb: the superblock
  * @nr: the number of pages to write
  *
- * Invoke writeback_inodes_sb if no writeback is currently underway.
- * Returns 1 if writeback was started, 0 if not.
+ * Invoke writeback_inodes_sb_nr if no writeback is currently underway
+ * and no one else holds the s_umount lock.  Returns 1 if writeback
+ * was started, 0 if not.
  */
 int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
 				   unsigned long nr,
 				   enum wb_reason reason)
 {
 	if (!writeback_in_progress(sb->s_bdi)) {
-		down_read(&sb->s_umount);
-		writeback_inodes_sb_nr(sb, nr, reason);
-		up_read(&sb->s_umount);
-		return 1;
-	} else
-		return 0;
+		if (down_read_trylock(&sb->s_umount)) {
+			writeback_inodes_sb_nr(sb, nr, reason);
+			up_read(&sb->s_umount);
+			return 1;
+		}
+	}
+	return 0;
 }
 EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
 
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 35f4b0e..47983d9 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -47,7 +47,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 
 static void quota_sync_one(struct super_block *sb, void *arg)
 {
-	if (sb->s_qcop && sb->s_qcop->quota_sync)
+	if (sb->s_qcop && sb->s_qcop->quota_sync && !vfs_is_frozen(sb))
 		sb->s_qcop->quota_sync(sb, *(int *)arg, 1);
 }
 
@@ -368,8 +368,18 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
 		goto out;
 	}
 
+	/*
+	 * It's not clear which quota functions may write to the file
+	 * system (all?).  Check for a frozen fs and bail out now.
+	 */
+	if (vfs_is_frozen(sb)) {
+		ret = -EBUSY;
+		goto out_drop_super;
+	}
+
 	ret = do_quotactl(sb, type, cmds, id, addr, pathp);
 
+out_drop_super:
 	drop_super(sb);
 out:
 	if (pathp && !IS_ERR(pathp))
diff --git a/fs/super.c b/fs/super.c
index afd0f1a..a56696b 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -526,6 +526,10 @@ void sync_supers(void)
  *
  *	Scans the superblock list and calls given function, passing it
  *	locked superblock and given argument.
+ *
+ *	Note: If @f is going to write to the file system, it must first
+ *	check if the file system is frozen (via vfs_is_frozen(sb)) and
+ *	refuse to write if so.
  */
 void iterate_supers(void (*f)(struct super_block *, void *), void *arg)
 {
@@ -595,6 +599,10 @@ EXPORT_SYMBOL(iterate_supers_type);
  *	
  *	Scans the superblock list and finds the superblock of the file system
  *	mounted on the device given. %NULL is returned if no match is found.
+ *
+ *	Note: If caller is going to write to the superblock, it must first
+ *	check if the file system is frozen (via vfs_is_frozen(sb)) and
+ *	refuse to write if so.
  */
 
 struct super_block *get_super(struct block_device *bdev)
@@ -1132,6 +1140,24 @@ out:
  * Syncs the super to make sure the filesystem is consistent and calls the fs's
  * freeze_fs.  Subsequent calls to this without first thawing the fs will return
  * -EBUSY.
+ *
+ * During this function, sb->s_frozen goes through these values:
+ *
+ * SB_UNFROZEN: File system is normal, all writes progress as usual.
+ *
+ * SB_FREEZE_WRITE: The file system is in the process of being frozen
+ * and any remaining out-standing writes are being synced.  Writes
+ * that complete in-process writes should be permitted but new ones
+ * should be blocked.
+ *
+ * SB_FREEZE_TRANS: The file system is frozen.  The ->freeze_fs and
+ * ->unfreeze_fs ops are the only operations permitted to write to the
+ * file system in this state.
+ *
+ * sb->s_frozen is protected by sb->s_umount.  Additionally,
+ * SB_FREEZE_WRITE is only temporarily set during freeze/thaw while
+ * holding sb->s_umount for writing, so any other callers holding
+ * sb->s_umount will never see this state.
  */
 int freeze_super(struct super_block *sb)
 {
diff --git a/fs/sync.c b/fs/sync.c
index 101b8ef..f497be8 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -68,7 +68,7 @@ int sync_filesystem(struct super_block *sb)
 	/*
 	 * No point in syncing out anything if the filesystem is read-only.
 	 */
-	if (sb->s_flags & MS_RDONLY)
+	if ((sb->s_flags & MS_RDONLY) || vfs_is_frozen(sb))
 		return 0;
 
 	ret = __sync_filesystem(sb, 0);
@@ -80,7 +80,7 @@ EXPORT_SYMBOL_GPL(sync_filesystem);
 
 static void sync_one_sb(struct super_block *sb, void *arg)
 {
-	if (!(sb->s_flags & MS_RDONLY))
+	if (!(sb->s_flags & MS_RDONLY) && !vfs_is_frozen(sb))
 		__sync_filesystem(sb, *(int *)arg);
 }
 /*
@@ -136,7 +136,7 @@ SYSCALL_DEFINE1(syncfs, int, fd)
 {
 	struct file *file;
 	struct super_block *sb;
-	int ret;
+	int ret = 0;
 	int fput_needed;
 
 	file = fget_light(fd, &fput_needed);
@@ -145,7 +145,8 @@ SYSCALL_DEFINE1(syncfs, int, fd)
 	sb = file->f_dentry->d_sb;
 
 	down_read(&sb->s_umount);
-	ret = sync_filesystem(sb);
+	if (!(sb->s_flags & MS_RDONLY) && !vfs_is_frozen(sb))
+		ret = sync_filesystem(sb);
 	up_read(&sb->s_umount);
 
 	fput_light(file, fput_needed);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e313022..ac7a495 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1490,7 +1490,7 @@ extern void prune_dcache_sb(struct super_block *sb, int nr_to_scan);
 extern struct timespec current_fs_time(struct super_block *sb);
 
 /*
- * Snapshotting support.
+ * Snapshotting support.  See freeze_super() for documentation.
  */
 enum {
 	SB_UNFROZEN = 0,
@@ -1501,6 +1501,10 @@ enum {
 #define vfs_check_frozen(sb, level) \
 	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
 
+static inline int vfs_is_frozen(struct super_block *sb) {
+	return sb->s_frozen == SB_FREEZE_TRANS;
+}
+
 /*
  * until VFS tracks user namespaces for inodes, just make all files
  * belong to init_user_ns
-- 
1.7.5.4
