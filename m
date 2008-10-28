From: akpm@linux-foundation.org
Subject: + filesystem-freeze-implement-generic-freeze-feature.patch added to -mm tree
Date: Mon, 27 Oct 2008 23:15:54 -0700
Message-ID: <200810280615.m9S6FslE020091@imap1.linux-foundation.org>
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
     filesystem freeze: implement generic freeze feature
has been added to the -mm tree.  Its filename is
     filesystem-freeze-implement-generic-freeze-feature.patch

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
Subject: filesystem freeze: implement generic freeze feature
From: Takashi Sato <t-sato@yk.jp.nec.com>

The ioctls for the generic freeze feature are below.
o Freeze the filesystem
  int ioctl(int fd, int FIFREEZE, arg)
    fd: The file descriptor of the mountpoint
    FIFREEZE: request code for the freeze
    arg: Ignored
    Return value: 0 if the operation succeeds. Otherwise, -1

o Unfreeze the filesystem
  int ioctl(int fd, int FITHAW, arg)
    fd: The file descriptor of the mountpoint
    FITHAW: request code for unfreeze
    arg: Ignored
    Return value: 0 if the operation succeeds. Otherwise, -1
    Error number: If the filesystem has already been unfrozen,
                  errno is set to EINVAL.

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

 fs/block_dev.c              |    2 
 fs/buffer.c                 |   74 +++++++++++++++++++++++++++++-----
 fs/ioctl.c                  |   46 +++++++++++++++++++++
 include/linux/buffer_head.h |    2 
 include/linux/fs.h          |    7 +++
 5 files changed, 121 insertions(+), 10 deletions(-)

diff -puN fs/block_dev.c~filesystem-freeze-implement-generic-freeze-feature fs/block_dev.c
--- a/fs/block_dev.c~filesystem-freeze-implement-generic-freeze-feature
+++ a/fs/block_dev.c
@@ -285,6 +285,8 @@ static void init_once(void *foo)
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
 	inode_init_once(&ei->vfs_inode);
+	/* Initialize mutex for freeze. */
+	mutex_init(&bdev->bd_fsfreeze_mutex);
 }
 
 static inline void __bd_forget(struct inode *inode)
diff -puN fs/buffer.c~filesystem-freeze-implement-generic-freeze-feature fs/buffer.c
--- a/fs/buffer.c~filesystem-freeze-implement-generic-freeze-feature
+++ a/fs/buffer.c
@@ -195,10 +195,25 @@ int fsync_bdev(struct block_device *bdev
  * happen on bdev until thaw_bdev() is called.
  * If a superblock is found on this device, we take the s_umount semaphore
  * on it to make sure nobody unmounts until the snapshot creation is done.
+ * The reference counter (bd_fsfreeze_count) guarantees that only the last
+ * unfreeze process can unfreeze the frozen filesystem actually when multiple
+ * freeze requests arrive simultaneously. It counts up in freeze_bdev() and
+ * count down in thaw_bdev(). When it becomes 0, thaw_bdev() will unfreeze
+ * actually.
  */
 struct super_block *freeze_bdev(struct block_device *bdev)
 {
 	struct super_block *sb;
+	int error = 0;
+
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	if (bdev->bd_fsfreeze_count > 0) {
+		bdev->bd_fsfreeze_count++;
+		sb = get_super(bdev);
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return sb;
+	}
+	bdev->bd_fsfreeze_count++;
 
 	down(&bdev->bd_mount_sem);
 	sb = get_super(bdev);
@@ -213,11 +228,24 @@ struct super_block *freeze_bdev(struct b
 
 		sync_blockdev(sb->s_bdev);
 
-		if (sb->s_op->freeze_fs)
-			sb->s_op->freeze_fs(sb);
+		if (sb->s_op->freeze_fs) {
+			error = sb->s_op->freeze_fs(sb);
+			if (error) {
+				printk(KERN_ERR
+					"VFS:Filesystem freeze failed\n");
+				sb->s_frozen = SB_UNFROZEN;
+				drop_super(sb);
+				up(&bdev->bd_mount_sem);
+				bdev->bd_fsfreeze_count--;
+				mutex_unlock(&bdev->bd_fsfreeze_mutex);
+				return ERR_PTR(error);
+			}
+		}
 	}
 
 	sync_blockdev(bdev);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+
 	return sb;	/* thaw_bdev releases s->s_umount and bd_mount_sem */
 }
 EXPORT_SYMBOL(freeze_bdev);
@@ -229,20 +257,48 @@ EXPORT_SYMBOL(freeze_bdev);
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-void thaw_bdev(struct block_device *bdev, struct super_block *sb)
+int thaw_bdev(struct block_device *bdev, struct super_block *sb)
 {
+	int error = 0;
+
+	mutex_lock(&bdev->bd_fsfreeze_mutex);
+	if (!bdev->bd_fsfreeze_count) {
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return -EINVAL;
+	}
+
+	bdev->bd_fsfreeze_count--;
+	if (bdev->bd_fsfreeze_count > 0) {
+		if (sb)
+			drop_super(sb);
+		mutex_unlock(&bdev->bd_fsfreeze_mutex);
+		return 0;
+	}
+
 	if (sb) {
 		BUG_ON(sb->s_bdev != bdev);
-
-		if (sb->s_op->unfreeze_fs)
-			sb->s_op->unfreeze_fs(sb);
-		sb->s_frozen = SB_UNFROZEN;
-		smp_wmb();
-		wake_up(&sb->s_wait_unfrozen);
+		if (!(sb->s_flags & MS_RDONLY)) {
+			if (sb->s_op->unfreeze_fs) {
+				error = sb->s_op->unfreeze_fs(sb);
+				if (error) {
+					printk(KERN_ERR
+						"VFS:Filesystem thaw failed\n");
+					sb->s_frozen = SB_FREEZE_TRANS;
+					bdev->bd_fsfreeze_count++;
+					mutex_unlock(&bdev->bd_fsfreeze_mutex);
+					return error;
+				}
+			}
+			sb->s_frozen = SB_UNFROZEN;
+			smp_wmb();
+			wake_up(&sb->s_wait_unfrozen);
+		}
 		drop_super(sb);
 	}
 
 	up(&bdev->bd_mount_sem);
+	mutex_unlock(&bdev->bd_fsfreeze_mutex);
+	return 0;
 }
 EXPORT_SYMBOL(thaw_bdev);
 
diff -puN fs/ioctl.c~filesystem-freeze-implement-generic-freeze-feature fs/ioctl.c
--- a/fs/ioctl.c~filesystem-freeze-implement-generic-freeze-feature
+++ a/fs/ioctl.c
@@ -441,6 +441,43 @@ static int ioctl_fioasync(unsigned int f
 	return error;
 }
 
+static int ioctl_fsfreeze(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If filesystem doesn't support freeze feature, return. */
+	if (sb->s_op->freeze_fs == NULL)
+		return -EOPNOTSUPP;
+
+	/* If a blockdevice-backed filesystem isn't specified, return. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	/* Freeze */
+	sb = freeze_bdev(sb->s_bdev);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+	return 0;
+}
+
+static int ioctl_fsthaw(struct file *filp)
+{
+	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* If a blockdevice-backed filesystem isn't specified, return EINVAL. */
+	if (sb->s_bdev == NULL)
+		return -EINVAL;
+
+	/* Thaw */
+	return thaw_bdev(sb->s_bdev, sb);
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -482,6 +519,15 @@ int do_vfs_ioctl(struct file *filp, unsi
 		} else
 			error = -ENOTTY;
 		break;
+
+	case FIFREEZE:
+		error = ioctl_fsfreeze(filp);
+		break;
+
+	case FITHAW:
+		error = ioctl_fsthaw(filp);
+		break;
+
 	default:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
diff -puN include/linux/buffer_head.h~filesystem-freeze-implement-generic-freeze-feature include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~filesystem-freeze-implement-generic-freeze-feature
+++ a/include/linux/buffer_head.h
@@ -170,7 +170,7 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
-void thaw_bdev(struct block_device *, struct super_block *);
+int thaw_bdev(struct block_device *, struct super_block *);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,
diff -puN include/linux/fs.h~filesystem-freeze-implement-generic-freeze-feature include/linux/fs.h
--- a/include/linux/fs.h~filesystem-freeze-implement-generic-freeze-feature
+++ a/include/linux/fs.h
@@ -225,6 +225,8 @@ struct inodes_stat_t {
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
 #define FIGETBSZ   _IO(0x00,2)	/* get the block size used for bmap */
+#define FIFREEZE	_IOWR('X', 119, int)	/* Freeze */
+#define FITHAW		_IOWR('X', 120, int)	/* Thaw */
 
 #define	FS_IOC_GETFLAGS			_IOR('f', 1, long)
 #define	FS_IOC_SETFLAGS			_IOW('f', 2, long)
@@ -578,6 +580,11 @@ struct block_device {
 	 * care to not mess up bd_private for that case.
 	 */
 	unsigned long		bd_private;
+
+	/* The counter of freeze processes */
+	int			bd_fsfreeze_count;
+	/* Mutex for freeze */
+	struct mutex		bd_fsfreeze_mutex;
 };
 
 /*
_

Patches currently in -mm which might be from t-sato@yk.jp.nec.com are

filesystem-freeze-add-error-handling-of-write_super_lockfs-unlockfs.patch
filesystem-freeze-implement-generic-freeze-feature.patch
filesystem-freeze-remove-xfs-specific-ioctl-interfaces-for-freeze-feature.patch

