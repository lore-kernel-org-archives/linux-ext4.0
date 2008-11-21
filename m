From: <Solofo.Ramangalahy@bull.net>
Subject: [RFC 2/2] ext4: module to initialize the inode table when using mkfs
 option lazy_itable_init
Date: Fri, 21 Nov 2008 11:23:11 +0100
Message-ID: <20081121102309.767264362@bull.net>
References: <20081121102309.182113793@bull.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:57747 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYKUKje (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 05:39:34 -0500
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 1D5B21A1C23
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 11:39:33 +0100 (CET)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 05454-01 for <linux-ext4@vger.kernel.org>;
 Fri, 21 Nov 2008 11:39:29 +0100 (CET)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id AEA2C1A1C2C
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 11:39:26 +0100 (CET)
Content-Disposition: inline; filename=SR-ext4_init_table_module.patch
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The idea is to reuse the code from resize since initializing a group
(hence the inode table) is also done during resize.

The code of the main function zero_itable_blocks() is extracted from
setup_new_group_blocks().

---
 fs/ext4/Makefile           |    2 
 fs/ext4/balloc.c           |    2 
 fs/ext4/ext4_itable_init.c |  190 +++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4_jbd2.c        |    3 
 fs/ext4/resize.c           |    8 -
 fs/ext4/super.c            |    6 +
 6 files changed, 205 insertions(+), 6 deletions(-)

Index: linux-2.6.28-rc4-itable_init/fs/ext4/ext4_itable_init.c
===================================================================
--- /dev/null
+++ linux-2.6.28-rc4-itable_init/fs/ext4/ext4_itable_init.c
@@ -0,0 +1,190 @@
+/*
+ * ext4_itable_init: module to initialize the inode tables for
+ * filesystem formatted with the lazy_itable_init option.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/nsproxy.h>
+#include <linux/mount.h>
+#include <linux/mnt_namespace.h>
+#include <linux/fs.h>
+#include <linux/kthread.h>
+#include "ext4_jbd2.h"
+#include "group.h"
+#include "ext4.h"
+
+#define MAX_ITABLE_INIT_THREADS  1
+struct task_struct *init_itable_thread[MAX_ITABLE_INIT_THREADS];
+static int threads_nb;
+
+/* Functions from resize.c */
+struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
+			   ext4_fsblk_t blk);
+int extend_or_restart_transaction(handle_t *handle, int thresh,
+				  struct buffer_head *bh);
+__le16 ext4_group_desc_csum(struct ext4_sb_info *sbi, __u32 block_group,
+			    struct ext4_group_desc *gdp);
+
+/* Zero out all of the inode table blocks */
+/* FIXME: refactor this function with resize.c::setup_new_group_blocks()? */
+/* checkpatch: ERROR: do not use assignment in if condition */
+static int ext4_zero_itable_blocks(ext4_group_t group, ext4_fsblk_t inode_table,
+			      struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_fsblk_t block;
+	ext4_grpblk_t bit;
+	int i;
+	int err = 0;
+	int err2 = 0;
+	ext4_fsblk_t start = ext4_group_first_block_no(sb, group);
+	handle_t *handle;
+	struct buffer_head *bh;
+	struct ext4_group_desc *gdp;
+	struct buffer_head *gdp_bh;
+
+printk(KERN_INFO "SR: ext4_zero_itable_blocks(ext4_group_t group: %lu, ext4_fsblk_t inode_table: %llu, super_block: %p)\n", group, inode_table, sb);
+	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
+	lock_super(sb);
+	if (IS_ERR(bh = bclean(handle, sb, inode_table))) {
+		err = PTR_ERR(bh);
+		goto exit_journal;
+	}
+	for (i = 0, block = inode_table+1, bit = block - start;
+	     i < sbi->s_itb_per_group; i++, bit++, block++) {
+		struct buffer_head *it;
+
+		ext4_debug("clear inode block %#04llx (+%d)\n", block, bit);
+		if ((err = extend_or_restart_transaction(handle, 1, bh)))
+			goto exit_bh;
+		if (IS_ERR(it = bclean(handle, sb, block))) {
+			err = PTR_ERR(it);
+			goto exit_bh;
+		}
+		ext4_journal_dirty_metadata(handle, it);
+		brelse(it);
+		ext4_set_bit(bit, bh->b_data);
+	}
+	if ((err = extend_or_restart_transaction(handle, 2, bh)))
+		goto exit_bh;
+	ext4_journal_dirty_metadata(handle, bh);
+	/* Flag the group EXT4_BG_INODE_ZEROED */
+	gdp = ext4_get_group_desc(sb, group, &gdp_bh);
+
+	spin_lock(sb_bgl_lock(sbi, group));
+	if ((err = ext4_journal_get_write_access(handle, gdp_bh)))
+		goto exit_journal;
+	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
+	spin_unlock(sb_bgl_lock(sbi, group));
+
+	err = ext4_journal_dirty_metadata(handle, gdp_bh);
+exit_bh:
+	brelse(bh);
+exit_journal:
+	unlock_super(sb);
+	if ((err2 = ext4_journal_stop(handle)) && !err)
+		err = err2;
+	return err;
+}
+
+/* Detect empty groups for which inode tables can be simply zeroed */
+/* use inode bitmap instead? */
+static bool has_no_inode(struct super_block *sb, struct ext4_sb_info *sbi,
+			 struct ext4_group_desc *gdp)
+{
+	bool result;
+	result = (EXT4_BLOCK_SIZE(sb) * sbi->s_itb_per_group ==
+		  gdp->bg_free_inodes_count * sbi->s_inode_size);
+	return result;
+}
+/* Function launched by the threads. */
+static int ext4_thread_init_itable(void *data)
+{
+	struct super_block *sb = data;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_group_t i;
+	int err = 0;
+	int groups_count = sbi->s_groups_count;
+
+	for (i = 0; i < groups_count; i++) {
+		struct ext4_group_desc *gdp =
+			ext4_get_group_desc(sb, i, NULL);
+		ext4_fsblk_t inode_table = ext4_inode_table(sb, gdp);
+		if (kthread_should_stop())
+			break;
+		if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
+		    && has_no_inode(sb, sbi, gdp)) {
+			err = ext4_zero_itable_blocks(i, inode_table, sb);
+		} else {
+			/* TODO: non-empty groups  */
+			/* Do it elsewhere?:       */
+			/* . mount-time?           */
+			/* . group (first) access? */
+		}
+	}
+	return err;
+}
+/* Get the ext4 file_system_type to walk its instances. */
+static struct file_system_type *ext4_fs_type(void)
+{
+	struct vfsmount *mnt;
+	struct list_head list;
+	int i = 0;
+
+	list =  current->nsproxy->mnt_ns->root->mnt_list;
+	list_for_each_entry(mnt, &list, mnt_list) {
+		if (mnt && mnt->mnt_sb && mnt->mnt_sb->s_type) {
+			struct file_system_type *t = mnt->mnt_sb->s_type;
+
+			if (!strcmp(t->name, "ext4"))
+				return t;
+		} else {
+			/* FIXME: NULL: which valid case is this? */
+		}
+		i++;
+		if (i > 15) /* FIXME: which case does it loop? */
+			break;
+	}
+	return NULL;
+}
+
+/*
+ * itable_init_init  the init function, called when the module is loaded.
+ * Returns zero if successfully loaded, nonzero otherwise.
+ */
+static int itable_init_init(void)
+{
+	struct file_system_type *t = ext4_fs_type();
+	struct super_block *sb;
+	struct list_head list;
+
+	printk(KERN_INFO "EXT4: starting inode tables initialization.\n");
+
+	threads_nb = 0;
+	if (t != NULL) {
+		list = t->fs_supers;
+		list_for_each_entry(sb, &list, s_instances) {
+printk(KERN_INFO "itable_init_init() sb: %p name: %s.\n", sb, sb->s_type->name);
+			init_itable_thread[threads_nb] =
+				kthread_run(ext4_thread_init_itable,
+					    sb, "ext4_thread_init");
+			threads_nb++;
+			if (threads_nb >= MAX_ITABLE_INIT_THREADS)
+				break;
+		}
+	}
+	return 0;
+}
+/*
+ * itable_init_exit the exit function, called when the module is removed.
+ */
+static void itable_init_exit(void)
+{
+//	kthread_stop(init_itable_thread); //FIXME
+	printk(KERN_INFO "EXT4: end of inode table initialization.\n");
+}
+module_init(itable_init_init);
+module_exit(itable_init_exit);
+MODULE_LICENSE("GPL");
Index: linux-2.6.28-rc4-itable_init/fs/ext4/Makefile
===================================================================
--- linux-2.6.28-rc4-itable_init.orig/fs/ext4/Makefile
+++ linux-2.6.28-rc4-itable_init/fs/ext4/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the linux ext4-filesystem routines.
 #
 
+obj-m += ext4_itable_init.o
+
 obj-$(CONFIG_EXT4_FS) += ext4.o
 
 ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
Index: linux-2.6.28-rc4-itable_init/fs/ext4/balloc.c
===================================================================
--- linux-2.6.28-rc4-itable_init.orig/fs/ext4/balloc.c
+++ linux-2.6.28-rc4-itable_init/fs/ext4/balloc.c
@@ -21,6 +21,7 @@
 #include "ext4_jbd2.h"
 #include "group.h"
 
+
 /*
  * balloc.c contains the blocks allocation and deallocation routines
  */
@@ -237,6 +238,7 @@ struct ext4_group_desc * ext4_get_group_
 		*bh = sbi->s_group_desc[group_desc];
 	return desc;
 }
+EXPORT_SYMBOL_GPL(ext4_get_group_desc);
 
 static int ext4_valid_block_bitmap(struct super_block *sb,
 					struct ext4_group_desc *desc,
Index: linux-2.6.28-rc4-itable_init/fs/ext4/super.c
===================================================================
--- linux-2.6.28-rc4-itable_init.orig/fs/ext4/super.c
+++ linux-2.6.28-rc4-itable_init/fs/ext4/super.c
@@ -47,6 +47,7 @@
 #include "namei.h"
 #include "group.h"
 
+
 struct proc_dir_entry *ext4_proc_root;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
@@ -92,6 +93,7 @@ ext4_fsblk_t ext4_inode_table(struct sup
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
 		(ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0);
 }
+EXPORT_SYMBOL_GPL(ext4_inode_table);
 
 void ext4_block_bitmap_set(struct super_block *sb,
 			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
@@ -144,7 +146,7 @@ handle_t *ext4_journal_start_sb(struct s
 
 	return jbd2_journal_start(journal, nblocks);
 }
-
+EXPORT_SYMBOL_GPL(ext4_journal_start_sb);
 /*
  * The only special thing we need to do here is to make sure that all
  * jbd2_journal_stop calls result in the superblock being marked dirty, so
@@ -167,6 +169,7 @@ int __ext4_journal_stop(const char *wher
 		__ext4_std_error(sb, where, err);
 	return err;
 }
+EXPORT_SYMBOL_GPL(__ext4_journal_stop);
 
 void ext4_journal_abort_handle(const char *caller, const char *err_fn,
 		struct buffer_head *bh, handle_t *handle, int err)
@@ -1511,6 +1514,7 @@ __le16 ext4_group_desc_csum(struct ext4_
 
 	return cpu_to_le16(crc);
 }
+EXPORT_SYMBOL_GPL(ext4_group_desc_csum);
 
 int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 block_group,
 				struct ext4_group_desc *gdp)
Index: linux-2.6.28-rc4-itable_init/fs/ext4/ext4_jbd2.c
===================================================================
--- linux-2.6.28-rc4-itable_init.orig/fs/ext4/ext4_jbd2.c
+++ linux-2.6.28-rc4-itable_init/fs/ext4/ext4_jbd2.c
@@ -21,7 +21,7 @@ int __ext4_journal_get_write_access(cons
 		ext4_journal_abort_handle(where, __func__, bh, handle, err);
 	return err;
 }
-
+EXPORT_SYMBOL_GPL(__ext4_journal_get_write_access);
 int __ext4_journal_forget(const char *where, handle_t *handle,
 				struct buffer_head *bh)
 {
@@ -57,3 +57,4 @@ int __ext4_journal_dirty_metadata(const 
 		ext4_journal_abort_handle(where, __func__, bh, handle, err);
 	return err;
 }
+EXPORT_SYMBOL_GPL(__ext4_journal_dirty_metadata);
Index: linux-2.6.28-rc4-itable_init/fs/ext4/resize.c
===================================================================
--- linux-2.6.28-rc4-itable_init.orig/fs/ext4/resize.c
+++ linux-2.6.28-rc4-itable_init/fs/ext4/resize.c
@@ -117,7 +117,7 @@ static int verify_group_input(struct sup
 	return err;
 }
 
-static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
+struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 				  ext4_fsblk_t blk)
 {
 	struct buffer_head *bh;
@@ -138,13 +138,13 @@ static struct buffer_head *bclean(handle
 
 	return bh;
 }
-
+EXPORT_SYMBOL_GPL(bclean);
 /*
  * If we have fewer than thresh credits, extend by EXT4_MAX_TRANS_DATA.
  * If that fails, restart the transaction & regain write access for the
  * buffer head which is used for block_bitmap modifications.
  */
-static int extend_or_restart_transaction(handle_t *handle, int thresh,
+int extend_or_restart_transaction(handle_t *handle, int thresh,
 					 struct buffer_head *bh)
 {
 	int err;
@@ -164,7 +164,7 @@ static int extend_or_restart_transaction
 
 	return 0;
 }
