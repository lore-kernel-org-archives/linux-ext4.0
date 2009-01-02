From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH 0/3] freeze feature ver 1.14
Date: Thu, 01 Jan 2009 23:22:16 -0600
Message-ID: <495DA488.7080702@sandeen.net>
References: <20081027215811t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081027215811t-sato@mail.jp.nec.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In lieu of the timeout feature which was originally proposed, how
about access to an emergency un-freeze via magic sysrq, maybe
piggy-backed on emergency sync... something like this (not
tested or even built yet...), would this be a good compromise to
help save people from frozen roots?

-Eric

Index: linux-2.6/drivers/char/sysrq.c
===================================================================
--- linux-2.6.orig/drivers/char/sysrq.c
+++ linux-2.6/drivers/char/sysrq.c
@@ -151,6 +151,7 @@ static struct sysrq_key_op sysrq_reboot_
 
 static void sysrq_handle_sync(int key, struct tty_struct *tty)
 {
+	emergency_thaw();
 	emergency_sync();
 }
 static struct sysrq_key_op sysrq_sync_op = {
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1477,7 +1477,7 @@ static void unlock_fs(struct mapped_devi
 	if (!test_bit(DMF_FROZEN, &md->flags))
 		return;
 
-	thaw_bdev(md->suspended_bdev, md->frozen_sb);
+	thaw_bdev(md->suspended_bdev, md->frozen_sb, 0);
 	md->frozen_sb = NULL;
 	clear_bit(DMF_FROZEN, &md->flags);
 }
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -259,13 +259,29 @@ struct super_block *freeze_bdev(struct b
 EXPORT_SYMBOL(freeze_bdev);
 
 /**
+ * emergency_thaw -- force thaw every filesystem
+ *
+ * Used for emergency unfreeze of all filesystems via SysRq
+ */
+void emergency_thaw(void)
+{
+	struct super_block *sb;
+
+	list_for_each_entry(sb, &super_blocks, s_list) {
+		if (sb->s_bdev)
+			(void)thaw_bdev(sb->s_bdev, sb, 1);
+	}
+}
+
+/**
  * thaw_bdev  -- unlock filesystem
  * @bdev:	blockdevice to unlock
  * @sb:		associated superblock
+ * force:	force unfreeze regardless of freezer count
  *
  * Unlocks the filesystem and marks it writeable again after freeze_bdev().
  */
-int thaw_bdev(struct block_device *bdev, struct super_block *sb)
+int thaw_bdev(struct block_device *bdev, struct super_block *sb, int force)
 {
 	int error = 0;
 
@@ -275,7 +291,11 @@ int thaw_bdev(struct block_device *bdev,
 		return -EINVAL;
 	}
 
-	bdev->bd_fsfreeze_count--;
+	if (force)
+		bdev->bd_fsfreeze_count = 0;
+	else
+		bdev->bd_fsfreeze_count--;
+
 	if (bdev->bd_fsfreeze_count > 0) {
 		if (sb)
 			drop_super(sb);
Index: linux-2.6/fs/ioctl.c
===================================================================
--- linux-2.6.orig/fs/ioctl.c
+++ linux-2.6/fs/ioctl.c
@@ -449,7 +449,7 @@ static int ioctl_fsthaw(struct file *fil
 		return -EINVAL;
 
 	/* Thaw */
-	return thaw_bdev(sb->s_bdev, sb);
+	return thaw_bdev(sb->s_bdev, sb, 0);
 }
 
 /*
Index: linux-2.6/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fsops.c
+++ linux-2.6/fs/xfs/xfs_fsops.c
@@ -634,7 +634,7 @@ xfs_fs_goingdown(
 
 		if (sb && !IS_ERR(sb)) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
-			thaw_bdev(sb->s_bdev, sb);
+			thaw_bdev(sb->s_bdev, sb, 0);
 		}
 
 		break;
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h
+++ linux-2.6/include/linux/buffer_head.h
@@ -171,7 +171,8 @@ void __wait_on_buffer(struct buffer_head
 wait_queue_head_t *bh_waitq_head(struct buffer_head *bh);
 int fsync_bdev(struct block_device *);
 struct super_block *freeze_bdev(struct block_device *);
-int thaw_bdev(struct block_device *, struct super_block *);
+void emergency_thaw(void);
+int thaw_bdev(struct block_device *, struct super_block *, int);
 int fsync_super(struct super_block *);
 int fsync_no_super(struct block_device *);
 struct buffer_head *__find_get_block(struct block_device *bdev, sector_t block,


