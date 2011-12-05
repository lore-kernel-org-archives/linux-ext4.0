From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 4/5 resend] VFS: Rename vfs_check_frozen() to vfs_block_until_thawed()
Date: Mon,  5 Dec 2011 12:54:48 -0800
Message-ID: <1323118489-16326-5-git-send-email-kamal@canonical.com>
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

The name of vfs_check_frozen() tends to de-emphasize an important
fact: that it will block until the file system thaws to the specified
level.  Make bugs slightly less likely by renaming to
vfs_block_until_thawed().

BugLink: https://bugs.launchpad.net/bugs/897421
Signed-off-by: Valerie Aurora <val@vaaconsulting.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/disk-io.c  |    4 ++--
 fs/btrfs/file.c     |    2 +-
 fs/buffer.c         |    7 ++++---
 fs/ext4/inode.c     |    2 +-
 fs/ext4/super.c     |    4 ++--
 fs/fuse/file.c      |    2 +-
 fs/gfs2/file.c      |    2 +-
 fs/nilfs2/ioctl.c   |    2 +-
 fs/nilfs2/segment.c |    2 +-
 fs/ntfs/file.c      |    2 +-
 fs/ocfs2/file.c     |    2 +-
 fs/xfs/xfs_mount.h  |    2 +-
 include/linux/fs.h  |    2 +-
 mm/filemap.c        |    2 +-
 mm/filemap_xip.c    |    2 +-
 15 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 632f8f3..308afe1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1569,7 +1569,7 @@ static int cleaner_kthread(void *arg)
 	struct btrfs_root *root = arg;
 
 	do {
-		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
+		vfs_block_until_thawed(root->fs_info->sb, SB_FREEZE_WRITE);
 
 		if (!(root->fs_info->sb->s_flags & MS_RDONLY) &&
 		    mutex_trylock(&root->fs_info->cleaner_mutex)) {
@@ -1603,7 +1603,7 @@ static int transaction_kthread(void *arg)
 
 	do {
 		delay = HZ * 30;
-		vfs_check_frozen(root->fs_info->sb, SB_FREEZE_WRITE);
+		vfs_block_until_thawed(root->fs_info->sb, SB_FREEZE_WRITE);
 		mutex_lock(&root->fs_info->transaction_kthread_mutex);
 
 		spin_lock(&root->fs_info->trans_lock);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index dafdfa0..40bff2e 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1346,7 +1346,7 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	ssize_t err = 0;
 	size_t count, ocount;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 
 	mutex_lock(&inode->i_mutex);
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 19d8eb7..fc679ba 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2338,8 +2338,9 @@ EXPORT_SYMBOL(block_commit_write);
  * beyond EOF, then the page is guaranteed safe against truncation until we
  * unlock the page.
  *
- * Direct callers of this function should call vfs_check_frozen() so that page
- * fault does not busyloop until the fs is thawed.
+ * Direct callers of this function should call
+ * vfs_block_until_thawed() so that page fault does not busyloop until
+ * the fs is thawed.
  */
 int __block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 			 get_block_t get_block)
@@ -2401,7 +2402,7 @@ int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 	 * This check is racy but catches the common case. The check in
 	 * __block_page_mkwrite() is reliable.
 	 */
-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(sb, SB_FREEZE_WRITE);
 	ret = __block_page_mkwrite(vma, vmf, get_block);
 	return block_page_mkwrite_return(ret);
 }
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 848f436..3d54061 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4737,7 +4737,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * This check is racy but catches the common case. We rely on
 	 * __block_page_mkwrite() to do a reliable check.
 	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 95f28b8..9fd8836 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -314,7 +314,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	 * handles are not stopped.
 	 */
 	if (!handle)
-		vfs_check_frozen(sb, SB_FREEZE_TRANS);
+		vfs_block_until_thawed(sb, SB_FREEZE_TRANS);
 
 	if (!journal)
 		return ext4_get_nojournal();
@@ -4282,7 +4282,7 @@ int ext4_force_commit(struct super_block *sb)
 
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
-		vfs_check_frozen(sb, SB_FREEZE_TRANS);
+		vfs_block_until_thawed(sb, SB_FREEZE_TRANS);
 		ret = ext4_journal_force_commit(journal);
 	}
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 594f07a..42e5e30 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -944,7 +944,7 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		return err;
 
 	mutex_lock(&inode->i_mutex);
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index ce36a56..9fea809 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -373,7 +373,7 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * and retry if the fs has been frozen after the page lock has
 	 * been acquired
 	 */
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 41d6743..084c8d9 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -655,7 +655,7 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
 		goto out_free;
 	}
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 
 	ret = nilfs_ioctl_move_blocks(inode->i_sb, &argv[0], kbufs[0]);
 	if (ret < 0)
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index bb24ab6..e3388f1 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -189,7 +189,7 @@ int nilfs_transaction_begin(struct super_block *sb,
 	if (ret > 0)
 		return 0;
 
-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(sb, SB_FREEZE_WRITE);
 
 	nilfs = sb->s_fs_info;
 	down_read(&nilfs->ns_segctor_sem);
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index c587e2d..16f1ac6 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2084,7 +2084,7 @@ static ssize_t ntfs_file_aio_write_nolock(struct kiocb *iocb,
 	if (err)
 		return err;
 	pos = *ppos;
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 	/* We can write back this queue in page reclaim. */
 	current->backing_dev_info = mapping->backing_dev_info;
 	written = 0;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index de4ea1a..f863955 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2240,7 +2240,7 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	if (iocb->ki_left == 0)
 		return 0;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 
 	appending = file->f_flags & O_APPEND ? 1 : 0;
 	direct_io = file->f_flags & O_DIRECT ? 1 : 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bb24dac..bacfab8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -312,7 +312,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 #define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
 
 #define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)
-#define xfs_wait_for_freeze(mp,l)	vfs_check_frozen((mp)->m_super, (l))
+#define xfs_wait_for_freeze(mp,l)	vfs_block_until_thawed((mp)->m_super, (l))
 
 /*
  * Flags for xfs_mountfs
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ac7a495..662e412 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1498,7 +1498,7 @@ enum {
 	SB_FREEZE_TRANS = 2,
 };
 
-#define vfs_check_frozen(sb, level) \
+#define vfs_block_until_thawed(sb, level) \
 	wait_event((sb)->s_wait_unfrozen, ((sb)->s_frozen < (level)))
 
 static inline int vfs_is_frozen(struct super_block *sb) {
diff --git a/mm/filemap.c b/mm/filemap.c
index c0018f2..a973a13 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2529,7 +2529,7 @@ ssize_t __generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	count = ocount;
 	pos = *ppos;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index f91b2f6..4539564 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -406,7 +406,7 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 	pos = *ppos;
 	count = len;
 
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	vfs_block_until_thawed(inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
-- 
1.7.5.4
