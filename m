From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH v2 3/7] VFS: Fix s_umount thaw/write deadlock
Date: Thu,  8 Dec 2011 10:04:33 -0800
Message-ID: <1323367477-21685-4-git-send-email-kamal@canonical.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1323367477-21685-1-git-send-email-kamal@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
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
[kamal@canonical.com: minor changes; patch restructure]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/fs-writeback.c  |    8 ++++++++
 fs/quota/quota.c   |   21 ++++++++++++++++++++-
 fs/super.c         |    8 ++++++++
 fs/sync.c          |    4 ++--
 include/linux/fs.h |    7 ++++++-
 5 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 73c3992..eee01cd 100644
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
diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 35f4b0e..1d770f2 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -47,7 +47,7 @@ static int check_quotactl_permission(struct super_block *sb, int type, int cmd,
 
 static void quota_sync_one(struct super_block *sb, void *arg)
 {
-	if (sb->s_qcop && sb->s_qcop->quota_sync)
+	if (sb->s_qcop && sb->s_qcop->quota_sync && !vfs_is_frozen(sb))
 		sb->s_qcop->quota_sync(sb, *(int *)arg, 1);
 }
 
@@ -368,8 +368,27 @@ SYSCALL_DEFINE4(quotactl, unsigned int, cmd, const char __user *, special,
 		goto out;
 	}
 
+	/*
+	 * If the fs is frozen, only allow read-only quota subcmds.
+	 */
+	if (vfs_is_frozen(sb)) {
+		switch (cmd) {
+			case Q_GETFMT:
+			case Q_GETINFO:
+			case Q_XGETQSTAT:
+				ret = 0;
+				break;
+			default:
+				ret = -EBUSY;
+				break;
+		}
+		if ( ret != 0 )
+		    goto out_drop_super;
+	}
+
 	ret = do_quotactl(sb, type, cmds, id, addr, pathp);
 
+out_drop_super:
 	drop_super(sb);
 out:
 	if (pathp && !IS_ERR(pathp))
diff --git a/fs/super.c b/fs/super.c
index afd0f1a..5629d06 100644
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
diff --git a/fs/sync.c b/fs/sync.c
index 101b8ef..e8166db 100644
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 019dc55..ec33b4c 100644
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
@@ -1501,6 +1501,11 @@ enum {
 #define vfs_check_frozen(sb, level) \
 	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
 
+static inline int vfs_is_frozen(struct super_block *sb)
+{
+	return sb->s_frozen == SB_FREEZE_TRANS;
+}
+
 /*
  * until VFS tracks user namespaces for inodes, just make all files
  * belong to init_user_ns
-- 
1.7.5.4

