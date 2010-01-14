From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [REPOST][PATCH][RFC] vfs: add message print mechanism for the
 mount/umount into the VFS layer
Date: Thu, 14 Jan 2010 15:48:37 +0900
Message-ID: <20100114154837.734fff60.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: viro@zeniv.linux.org.uk, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56449 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab0ANHIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Jan 2010 02:08:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi. 

Now, on the VFS-layer any messages aren't printed at mount/umount time 
(when the operation normally terminates).
But there are some filesystems which print their own specific messages at those
times.

For the purpose of the system management and so on, users (especially, 
enterprise users) want to observe their system operations from the system logs.
We may manage to observe some filesystems' operations (mount/umount) from the 
logs. But the filesystems of which we can observe the operations are not all.

Therefore to achieve the observations for all filesystems is to add the common
message mechanism into the VFS layer. If any filesystems' specific messages at 
mount/umount time are added into this, we can distinguish more easily each 
message among the system logs for our systems' observations. 

This patch provides the following:
- message output of common format from VFS at mount/umount time
- the functions of printing the filesystem's specific information at 
  mount/umount time

(NOTE: This mechanism becomes effective only when the users call
       the mount system call because they don't want to observe the pseudo 
       filesystems.)

Example of display:
--------------------------------------------------------------------------------
Device sda1 mounted file system type ext3 read-write
Device sda2 mounted file system type ext3 read-write
Device sdd2 mounted file system type ext3 read-write
Device sdd2 unmounted
--------------------------------------------------------------------------------

P.S.
This concept derives from the following:
- http://marc.info/?l=linux-ext4&m=125429349122986&w=2
- http://marc.info/?l=linux-ext4&m=125436936109125&w=2 

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
--
 fs/namespace.c        |   19 ++++++++++++++++++-
 fs/super.c            |   18 ++++++++++++++++--
 include/linux/fs.h    |    3 +++
 include/linux/mount.h |    3 +++
 4 files changed, 40 insertions(+), 3 deletions(-)

diff -Nurp linux-2.6.33-rc3.org/fs/namespace.c linux-2.6.33-rc3/fs/namespace.c
--- linux-2.6.33-rc3.org/fs/namespace.c	2010-01-06 09:02:46.000000000 +0900
+++ linux-2.6.33-rc3/fs/namespace.c	2010-01-12 16:41:00.000000000 +0900
@@ -599,6 +599,7 @@ static struct vfsmount *clone_mnt(struct
 static inline void __mntput(struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
+	int silent = !(mnt->mnt_flags & MNT_VERBOSE_MSG);
 	/*
 	 * This probably indicates that somebody messed
 	 * up a mnt_want/drop_write() pair.  If this
@@ -612,7 +613,7 @@ static inline void __mntput(struct vfsmo
 	WARN_ON(count_mnt_writers(mnt));
 	dput(mnt->mnt_root);
 	free_vfsmnt(mnt);
-	deactivate_super(sb);
+	__deactivate_super(sb, silent);
 }
 
 void mntput_no_expire(struct vfsmount *mnt)
@@ -1653,6 +1654,9 @@ static int do_new_mount(struct path *pat
 	if (IS_ERR(mnt))
 		return PTR_ERR(mnt);
 
+	/* for verbose messages on VFS layer at mount/umount */
+	if (!(flags & MS_SILENT))
+		mnt_flags |= MNT_VERBOSE_MSG;
 	return do_add_mount(mnt, path, mnt_flags, NULL);
 }
 
@@ -1664,6 +1668,7 @@ int do_add_mount(struct vfsmount *newmnt
 		 int mnt_flags, struct list_head *fslist)
 {
 	int err;
+	struct super_block *sb = newmnt->mnt_sb;
 
 	down_write(&namespace_sem);
 	/* Something was mounted here while we slept */
@@ -1692,10 +1697,22 @@ int do_add_mount(struct vfsmount *newmnt
 		list_add_tail(&newmnt->mnt_expire, fslist);
 
 	up_write(&namespace_sem);
+	/* 
+	 * message output at mount for log observers
+	 */
+	if (newmnt->mnt_flags & MNT_VERBOSE_MSG) {
+		printk(KERN_INFO "Device %s mounted file system type %s read-%s\n",
+					sb->s_id, sb->s_type->name,
+					sb->s_flags & MS_RDONLY ? "only" : "write");
+		/* fs specific messages for mount */
+		if (sb->s_op != NULL && sb->s_op->mount_msg != NULL)
+			sb->s_op->mount_msg(sb);
+	}
 	return 0;
 
 unlock:
 	up_write(&namespace_sem);
+	newmnt->mnt_flags &= ~MNT_VERBOSE_MSG;
 	mntput(newmnt);
 	return err;
 }
diff -Nurp linux-2.6.33-rc3.org/fs/super.c linux-2.6.33-rc3/fs/super.c
--- linux-2.6.33-rc3.org/fs/super.c	2010-01-06 09:02:46.000000000 +0900
+++ linux-2.6.33-rc3/fs/super.c	2010-01-12 16:41:00.000000000 +0900
@@ -177,15 +177,16 @@ void put_super(struct super_block *sb)
 
 
 /**
- *	deactivate_super	-	drop an active reference to superblock
+ *	__deactivate_super	-	drop an active reference to superblock
  *	@s: superblock to deactivate
+ *	@silent: disable verbose messages for umount from mount-tree
  *
  *	Drops an active reference to superblock, acquiring a temprory one if
  *	there is no active references left.  In that case we lock superblock,
  *	tell fs driver to shut it down and drop the temporary reference we
  *	had just acquired.
  */
-void deactivate_super(struct super_block *s)
+void __deactivate_super(struct super_block *s, int silent)
 {
 	struct file_system_type *fs = s->s_type;
 	if (atomic_dec_and_lock(&s->s_active, &sb_lock)) {
@@ -193,12 +194,25 @@ void deactivate_super(struct super_block
 		spin_unlock(&sb_lock);
 		vfs_dq_off(s, 0);
 		down_write(&s->s_umount);
+		/* fs specific messages for umount */
+		if (!silent && s->s_op != NULL && s->s_op->umount_msg != NULL)
+			s->s_op->umount_msg(s);
 		fs->kill_sb(s);
+		/*
+		 * message output at umount for log observers
+		 */ 
+		if (!silent)
+			printk(KERN_INFO "Device %s unmounted\n", s->s_id);
 		put_filesystem(fs);
 		put_super(s);
 	}
 }
 
+void deactivate_super(struct super_block *s)
+{
+	__deactivate_super(s, !0);
+}
+
 EXPORT_SYMBOL(deactivate_super);
 
 /**
diff -Nurp linux-2.6.33-rc3.org/include/linux/fs.h linux-2.6.33-rc3/include/linux/fs.h
--- linux-2.6.33-rc3.org/include/linux/fs.h	2010-01-06 09:02:46.000000000 +0900
+++ linux-2.6.33-rc3/include/linux/fs.h	2010-01-12 16:41:00.000000000 +0900
@@ -1575,6 +1575,8 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	void (*mount_msg)(struct super_block*);
+	void (*umount_msg)(struct super_block*);
 };
 
 /*
@@ -1766,6 +1768,7 @@ void kill_block_super(struct super_block
 void kill_anon_super(struct super_block *sb);
 void kill_litter_super(struct super_block *sb);
 void deactivate_super(struct super_block *sb);
+void __deactivate_super(struct super_block *sb, int silent);
 void deactivate_locked_super(struct super_block *sb);
 int set_anon_super(struct super_block *s, void *data);
 struct super_block *sget(struct file_system_type *type,
diff -Nurp linux-2.6.33-rc3.org/include/linux/mount.h linux-2.6.33-rc3/include/linux/mount.h
--- linux-2.6.33-rc3.org/include/linux/mount.h	2010-01-06 09:02:46.000000000 +0900
+++ linux-2.6.33-rc3/include/linux/mount.h	2010-01-12 16:41:00.000000000 +0900
@@ -36,6 +36,9 @@ struct mnt_namespace;
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
 
+#define MNT_VERBOSE_MSG	0x10000 /* verbose messages on the VFS layer at mount
+				   /umount only when called from do_new_mount */
+
 struct vfsmount {
 	struct list_head mnt_hash;
 	struct vfsmount *mnt_parent;	/* fs we are mounted on */
