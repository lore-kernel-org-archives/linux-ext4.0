From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 3/7]ext4: Add EXT4_IOC_ADD_INODE_ALLOC_RULE sets inode
 preferred range of blocks
Date: Tue, 23 Jun 2009 17:25:27 +0900
Message-ID: <4A409177.2030403@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4: Add EXT4_IOC_ADD_INODE_ALLOC_RULE sets inode preferred range of blocks

From: Akira Fujita <a-fujita@rs.jp.nec.com>

This ioctl provides the interface which associates with an inode preferred
range of blocks which the block allocator will try using first.

  #define EXT4_IOC_ADD_INODE_ALLOC_RULE  _IOW('f', 18, struct ext4_alloc_rule);

  struct ext4_inode_alloc_rule {
        struct ext4_alloc_rule alloc_rule;
        pid_t alloc_pid;
  };

  struct ext4_alloc_rule {
        __u64 start;            /* first physical block this rule covers */
        __u64 len;              /* number of blocks covered by this rule */
        __u32 alloc_flag;       /* 0: mandatory 1: advisory  */
  };

alloc_pid of ext4_inode_alloc_rule structure is set process id of this ioctl.
When current process id and ext4_inode->info->i_alloc_rule->alloc_pid is same,
block allocator acts on inode preferred range of blocks.

alloc_flag of ext4_alloc_rule structure is set 0 (mandatory) or 1 (advisory),
and it defines the behavior of block allocator if blocks allocator
can not use blocks from inode preferred range of blocks.

If "mandatory" is set, just return -ENOSPC when block allocator
can not use blocks from preferred range of blocks.
On the other hand in "advisory" case, block allocator retries to use blocks
from the out of preferred range of blocks when it gets -ENOSPC.

Release preferred range of blocks:
(1) no process refers to the inode (inode reference counter is 0)
(2) preferred range of blocks are used by block allocator

And you can overwrite (extend / shrink) preferred range of blocks
with re-calling this ioctl to the same inode.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/ext4.h    |   11 +++++++++++
 fs/ext4/file.c    |    1 +
 fs/ext4/ialloc.c  |    2 ++
 fs/ext4/ioctl.c   |   26 ++++++++++++++++++++++++++
 fs/ext4/mballoc.c |   33 +++++++++++++++++++++++++++++++++
 fs/ext4/super.c   |    2 ++
 6 files changed, 75 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d2cac27..40f1577 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -358,6 +358,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
 #define EXT4_IOC_ADD_GLOBAL_ALLOC_RULE	_IOW('f', 16, struct ext4_alloc_rule)
 #define EXT4_IOC_CLR_GLOBAL_ALLOC_RULE	_IOW('f', 17, struct ext4_alloc_rule)
+#define EXT4_IOC_ADD_INODE_ALLOC_RULE	_IOW('f', 18, struct ext4_alloc_rule)

 /*
  * ioctl commands in 32 bit emulation
@@ -403,6 +404,11 @@ struct ext4_bg_alloc_rule {
 	int alloc_flag;			/* 0(mandatory) or 1(advisory) */
 };

+struct ext4_inode_alloc_rule {
+	struct ext4_alloc_rule alloc_rule;
+	pid_t alloc_pid;
+};
+
 /*
  *  Mount options
  */
@@ -689,6 +695,8 @@ struct ext4_inode_info {
 	__u16 i_extra_isize;

 	spinlock_t i_block_reservation_lock;
+
+	struct ext4_inode_alloc_rule *i_alloc_rule;
 };

 /*
@@ -1389,6 +1397,9 @@ extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
 extern int ext4_mb_add_global_arule(struct inode *, struct ext4_alloc_rule *);
 extern int ext4_mb_del_global_arule(struct inode *, struct ext4_alloc_rule *);
 extern void ext4_mb_release_arule_list(struct ext4_sb_info *);
+extern int ext4_mb_add_inode_arule(struct inode *inode,
+					struct ext4_alloc_rule *arule);
+extern void ext4_mb_del_inode_arule(struct inode *inode);

 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 3f1873f..a407823 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -46,6 +46,7 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 	{
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
+		ext4_mb_del_inode_arule(inode);
 		up_write(&EXT4_I(inode)->i_data_sem);
 	}
 	if (is_dx(inode) && filp->private_data)
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 2f64573..7f330ca 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1033,6 +1033,8 @@ got:

 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;

+	ei->i_alloc_rule = NULL;
+
 	ret = inode;
 	if (vfs_dq_alloc_inode(inode)) {
 		err = -EDQUOT;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 955bb08..b009132 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -292,6 +292,32 @@ setversion_out:
 		return err;
 	}

+	case EXT4_IOC_ADD_INODE_ALLOC_RULE: {
+		struct ext4_alloc_rule arule;
+		int err;
+
+		/*
+		 * If we do not have the permission to access the inode,
+		 * just skip it.
+		 */
+		if (!is_owner_or_cap(inode))
+			return -EACCES;
+
+		if (!(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+
+		if (copy_from_user(&arule,
+				(struct ext4_alloc_rule __user *)arg,
+				sizeof(arule)))
+			return -EFAULT;
+
+		down_write(&ei->i_data_sem);
+		err = ext4_mb_add_inode_arule(inode, &arule);
+		up_write(&ei->i_data_sem);
+
+		return err;
+	}
+
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 29a25d6..031b37f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5482,3 +5482,36 @@ out:
 	write_unlock(&sbi->s_bg_arule_lock);
 	return ret;
 }
+
+int ext4_mb_add_inode_arule(struct inode *inode,
+			struct ext4_alloc_rule *arule)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	int err;
+
+	err = ext4_mb_check_arule(inode, arule);
+	if (err)
+		return err;
+	if (!ei->i_alloc_rule) {
+		ei->i_alloc_rule = kmalloc(
+			sizeof(struct ext4_inode_alloc_rule), GFP_KERNEL);
+		if (!ei->i_alloc_rule)
+			return -ENOMEM;
+	} else if (ei->i_alloc_rule->alloc_pid != current->pid) {
+		ext4_debug("using allocation rule\n");
+		return -EINVAL;
+	}
+
+	memcpy(&ei->i_alloc_rule->alloc_rule, arule, sizeof(*arule));
+	ei->i_alloc_rule->alloc_pid = current->pid;
+
+	return 0;
+}
+
+void ext4_mb_del_inode_arule(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	kfree(ei->i_alloc_rule);
+	ei->i_alloc_rule = NULL;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e5fe18a..e3d6b2c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -686,6 +686,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_reserved_meta_blocks = 0;
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
+	ei->i_alloc_rule = NULL;
 	spin_lock_init(&(ei->i_block_reservation_lock));

 	return &ei->vfs_inode;
@@ -749,6 +750,7 @@ static void ext4_clear_inode(struct inode *inode)
 	}
 #endif
 	ext4_discard_preallocations(inode);
+	ext4_mb_del_inode_arule(inode);
 	if (EXT4_JOURNAL(inode))
 		jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
 				       &EXT4_I(inode)->jinode);
