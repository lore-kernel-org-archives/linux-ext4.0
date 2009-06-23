From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 6/7]ext4: Add EXT4_IOC_PRINT_GLOBAL_ARULE for debug block
 allocation restriction
Date: Tue, 23 Jun 2009 17:26:05 +0900
Message-ID: <4A40919D.6000905@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38705 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbZFWI1t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2009 04:27:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Add EXT4_IOC_PRINT_GLOBAL_ARULE for debug block allocation restriction

From: Akira Fujita <a-fujita@rs.jp.nec.com>

This is a debug ioctl for block allocation restriction

EXT4_IOC_PRINT_GLOBAL_ARULE prints the information
of block allocation restriction to syslog.

  #define EXT4_IOC_PRINT_GLOBAL_ARULE     _IO('f', 19)

This information consists of following three entries.
  - start physical offset
  - end physical offset
  - flag (0: mandatory, 1:advisory)

e.g. ARULE: start=10000 end=13999 flag=1

The above means ext4 FS where target fd located in is set
block allocation restriction from 10000 to 13999 with advisory.
Block allocator use blocks from 10000 to 13999 with precedence,
if it can not use them, then block allocator tries to use
blocks from other range.


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/ioctl.c   |    5 +++++
 fs/ext4/mballoc.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b6469d5..4ed4b27 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -362,6 +362,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_ADD_GLOBAL_ALLOC_RULE	_IOW('f', 16, struct ext4_alloc_rule)
 #define EXT4_IOC_CLR_GLOBAL_ALLOC_RULE	_IOW('f', 17, struct ext4_alloc_rule)
 #define EXT4_IOC_ADD_INODE_ALLOC_RULE	_IOW('f', 18, struct ext4_alloc_rule)
+#define EXT4_IOC_PRINT_GLOBAL_ARULE	_IO('f', 19)

 /*
  * ioctl commands in 32 bit emulation
@@ -1404,6 +1405,7 @@ extern int ext4_mb_add_inode_arule(struct inode *inode,
 					struct ext4_alloc_rule *arule);
 extern void ext4_mb_del_inode_arule(struct inode *inode);
 extern void ext4_mb_dec_inode_arule(struct inode *inode, unsigned int len);
+extern void ext4_mb_print_global_arule(struct inode *inode);

 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index b009132..323e3d2 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -318,6 +318,11 @@ setversion_out:
 		return err;
 	}

+	case EXT4_IOC_PRINT_GLOBAL_ARULE: {
+		ext4_mb_print_global_arule(inode);
+		return 0;
+	}
+
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ff79189..cd5b833 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5814,3 +5814,48 @@ void ext4_mb_dec_inode_arule(struct inode *inode, unsigned int len)
 			ext4_mb_del_inode_arule(inode);
 	}
 }
+
+void ext4_mb_print_global_arule(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_bg_alloc_rule_list *bg_arule_list, *tmp_arule_list;
+	struct ext4_bg_alloc_rule *bg_arule, *tmp_arule;
+
+	if (list_empty(&sbi->s_bg_arule_list)) {
+		printk(KERN_ERR "ARULE: s_bg_arule_list is empty\n");
+		return;
+	}
+
+	list_for_each_entry_safe(bg_arule_list, tmp_arule_list,
+					&sbi->s_bg_arule_list, bg_arule_list) {
+		ext4_group_t bg;
+		ext4_fsblk_t bg_first_block_no;
+		if (list_empty(&bg_arule_list->arule_list)) {
+			printk(KERN_ERR "ARULE: bg_arule_list[bgnum=%u] "
+				"is empty\n", bg_arule_list->bg_num);
+			continue;
+		}
+
+		printk(KERN_ERR "bgnum %u: bg_arule_list mand %d adv %d\n",
+			bg_arule_list->bg_num,
+			bg_arule_list->mand_restricted_blks,
+			bg_arule_list->adv_restricted_blks);
+
+		bg = bg_arule_list->bg_num;
+		bg_first_block_no = ext4_group_first_block_no(sb, bg);
+		list_for_each_entry_safe(bg_arule, tmp_arule,
+				&bg_arule_list->arule_list, arule_list) {
+			ext4_grpblk_t g_start = bg_arule->start;
+			ext4_grpblk_t g_end = bg_arule->end;
+			ext4_fsblk_t fs_start, fs_end;
+
+			fs_start = bg_first_block_no + g_start;
+			fs_end = bg_first_block_no + g_end;
+			printk(KERN_ERR "ARULE: start=%llu end=%llu flag=%d\n",
+					fs_start, fs_end, bg_arule->alloc_flag);
+		}
+	}
+
+	return;
+}

