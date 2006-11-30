From: Alex Tomas <alex@clusterfs.com>
Subject: [RFC] ext4-block-reservation patch
Date: Fri, 01 Dec 2006 02:58:14 +0300
Message-ID: <m3psb4tqng.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [80.71.248.82] ([80.71.248.82]:16336 "EHLO gw.home.net")
	by vger.kernel.org with ESMTP id S1031640AbWLAASY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Nov 2006 19:18:24 -0500
Received: from bzzz.home.net (gw.home.net [127.0.0.1])
	by gw.home.net (8.13.7/8.13.4) with ESMTP id kB11Jd8u005506
	for <linux-ext4@vger.kernel.org>; Fri, 1 Dec 2006 04:19:39 +0300
To: linux-ext4@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch implements free space management with
per-cpu reservation blocks for delayed allocation.

thanks, Alex


Index: linux-2.6.19-rc6/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.19-rc6.orig/include/linux/ext4_fs.h	2006-11-30 02:08:35.000000000 +0300
+++ linux-2.6.19-rc6/include/linux/ext4_fs.h	2006-12-01 02:20:01.000000000 +0300
@@ -201,6 +201,7 @@ struct ext4_group_desc
 #define EXT4_STATE_JDATA		0x00000001 /* journaled data exists */
 #define EXT4_STATE_NEW			0x00000002 /* inode is newly created */
 #define EXT4_STATE_XATTR		0x00000004 /* has in-inode xattrs */
+#define EXT4_STATE_BLOCKS_RESERVED	0x00000008 /* blocks reserved */
 
 /* Used to pass group descriptor data when online resize is done */
 struct ext4_new_group_input {
@@ -846,6 +847,12 @@ extern int ext4_should_retry_alloc(struc
 extern void ext4_init_block_alloc_info(struct inode *);
 extern void ext4_rsv_window_add(struct super_block *sb, struct ext4_reserve_window_node *rsv);
 
+/* reservation.c */
+int ext4_reserve_init(struct super_block *sb);
+void ext4_reserve_release(struct super_block *sb);
+void ext4_release_blocks(struct super_block *sb, int blocks);
+int ext4_reserve_blocks(struct super_block *sb, int blocks);
+
 /* dir.c */
 extern int ext4_check_dir_entry(const char *, struct inode *,
 				struct ext4_dir_entry_2 *,
Index: linux-2.6.19-rc6/include/linux/ext4_fs_sb.h
===================================================================
--- linux-2.6.19-rc6.orig/include/linux/ext4_fs_sb.h	2006-11-30 02:08:35.000000000 +0300
+++ linux-2.6.19-rc6/include/linux/ext4_fs_sb.h	2006-12-01 02:20:01.000000000 +0300
@@ -24,6 +24,8 @@
 #endif
 #include <linux/rbtree.h>
 
+struct ext4_reservation_slot;
+
 /*
  * third extended-fs super-block data in memory
  */
@@ -65,6 +67,9 @@ struct ext4_sb_info {
 	struct rb_root s_rsv_window_root;
 	struct ext4_reserve_window_node s_rsv_window_head;
 
+	/* global reservation structures */
+	struct ext4_reservation_slot *s_reservation_slots;
+
 	/* Journaling */
 	struct inode * s_journal_inode;
 	struct journal_s * s_journal;
Index: linux-2.6.19-rc6/fs/ext4/super.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/super.c	2006-11-30 02:08:35.000000000 +0300
+++ linux-2.6.19-rc6/fs/ext4/super.c	2006-12-01 02:20:01.000000000 +0300
@@ -439,6 +439,7 @@ static void ext4_put_super (struct super
 	struct ext4_super_block *es = sbi->s_es;
 	int i;
 
+	ext4_reserve_release(sb);
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
 	jbd2_journal_destroy(sbi->s_journal);
@@ -1866,6 +1867,7 @@ static int ext4_fill_super (struct super
 
 	ext4_lg_init(sb);
 	ext4_ext_init(sb);
+	ext4_reserve_init(sb);
 
 	lock_kernel();
 	return 0;
Index: linux-2.6.19-rc6/fs/ext4/Makefile
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/Makefile	2006-11-30 02:08:35.000000000 +0300
+++ linux-2.6.19-rc6/fs/ext4/Makefile	2006-12-01 02:20:01.000000000 +0300
@@ -5,7 +5,8 @@
 obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o
 
 ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
-	   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o lg.o
+	   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o lg.o \
+	   reservation.o
 
 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
Index: linux-2.6.19-rc6/fs/ext4/reservation.c
===================================================================
--- linux-2.6.19-rc6.orig/fs/ext4/reservation.c	2006-11-30 15:32:10.563465031 +0300
+++ linux-2.6.19-rc6/fs/ext4/reservation.c	2006-12-01 02:20:01.000000000 +0300
@@ -0,0 +1,190 @@
+/*
+ * Copyright (c) 2006, Cluster File Systems, Inc, info@clusterfs.com
+ * Written by Alex Tomas <alex@clusterfs.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public Licens
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-
+ */
+
+
+/*
+ * reservation.c contains routines to reserve blocks.
+ * we need this for delayed allocation, otherwise we
+ * could meet -ENOSPC at flush time
+ */
+
+/*
+ * as ->commit_write() where we're going to reserve
+ * non-allocated-yet blocks is well known hotpath,
+ * we have to make it scalable and avoid global
+ * data as much as possible
+ *
+ * there is per-sb array
+ */
+
+#include <linux/time.h>
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/ext4_jbd2.h>
+#include <linux/jbd.h>
+#include <linux/ext4_fs.h>
+#include <linux/quotaops.h>
+#include <linux/buffer_head.h>
+#include <linux/module.h>
+#include <linux/swap.h>
+#include <linux/proc_fs.h>
+#include <linux/pagemap.h>
+
+
+struct ext4_reservation_slot {
+	__u64		rs_reserved;
+	spinlock_t	rs_lock;
+} ____cacheline_aligned;
+
+
+int ext4_reserve_local(struct super_block *sb, int blocks)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+	int rc = -ENOSPC;
+
+	preempt_disable();
+	rs = sbi->s_reservation_slots + smp_processor_id();
+
+	spin_lock(&rs->rs_lock);
+	if (likely(rs->rs_reserved >= blocks)) {
+		rs->rs_reserved -= blocks;
+		rc = 0;
+	}
+	spin_unlock(&rs->rs_lock);
+
+	preempt_enable();
+	return rc;
+}
+
+
+void ext4_rebalance_reservation(struct ext4_reservation_slot *rs, __u64 free)
+{
+	int i, used_slots = 0;
+	__u64 chunk;
+
+	/* let's know what slots have been used */
+	for (i = 0; i < NR_CPUS; i++)
+		if (rs[i].rs_reserved || i == smp_processor_id())
+			used_slots++;
+
+	/* chunk is a number of block every used
+	 * slot will get. make sure it isn't 0 */
+	chunk = free + used_slots - 1;
+	do_div(chunk, used_slots);
+
+	for (i = 0; i < NR_CPUS; i++) {
+		if (free < chunk)
+			chunk = free;
+		if (rs[i].rs_reserved || i == smp_processor_id()) {
+			rs[i].rs_reserved = chunk;
+			free -= chunk;
+			BUG_ON(free < 0);
+		}
+	}
+	BUG_ON(free);
+}
+
+int ext4_reserve_global(struct super_block *sb, int blocks)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+	int i, rc = -ENOENT;
+	__u64 free = 0;
+
+	rs = sbi->s_reservation_slots;
+
+	/* lock all slots */
+	for (i = 0; i < NR_CPUS; i++) {
+		spin_lock(&rs[i].rs_lock);
+		free += rs[i].rs_reserved;
+	}
+
+	if (free >= blocks) {
+		free -= blocks;
+		ext4_rebalance_reservation(rs, free);
+		rc = 0;
+	}
+
+	for (i = 0; i < NR_CPUS; i++)
+		spin_unlock(&rs[i].rs_lock);
+
+	return rc;
+}
+
+int ext4_reserve_blocks(struct super_block *sb, int blocks)
+{
+	int ret;
+
+	BUG_ON(blocks <= 0);
+
+	ret = ext4_reserve_local(sb, blocks);
+	if (likely(ret == 0))
+		return 0;
+
+	return ext4_reserve_global(sb, blocks);
+}
+
+void ext4_release_blocks(struct super_block *sb, int blocks)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+
+	BUG_ON(blocks <= 0);
+
+	preempt_disable();
+	rs = sbi->s_reservation_slots + smp_processor_id();
+
+	spin_lock(&rs->rs_lock);
+	rs->rs_reserved += blocks;
+	spin_unlock(&rs->rs_lock);
+
+	preempt_enable();
+}
+
+int ext4_reserve_init(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+	int i;
+
+	rs = kmalloc(sizeof(struct ext4_reservation_slot) * NR_CPUS, GFP_KERNEL);
+	if (rs == NULL)
+		return -ENOMEM;
+	sbi->s_reservation_slots = rs;
+
+	for (i = 0; i < NR_CPUS; i++) {
+		spin_lock_init(&rs[i].rs_lock);
+		rs[i].rs_reserved = 0;
+	}
+	rs[0].rs_reserved = percpu_counter_sum(&sbi->s_freeblocks_counter);
+
+	return 0;
+}
+
+void ext4_reserve_release(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_reservation_slot *rs;
+
+	rs = sbi->s_reservation_slots;
+	BUG_ON(sbi->s_reservation_slots == NULL);
+	kfree(sbi->s_reservation_slots);
+	sbi->s_reservation_slots = NULL;
+}
+
