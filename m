From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 7/7]ext4: Add EXT4_IOC_PRINT_INODE_ARULE for debug inode
 preferred range of blocks
Date: Tue, 23 Jun 2009 17:26:18 +0900
Message-ID: <4A4091AA.2040405@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38752 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076AbZFWI17 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2009 04:27:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Add EXT4_IOC_PRINT_INODE_ARULE for debug inode preferred range of blocks

From: Akira Fujita <a-fujita@rs.jp.nec.com>

# This is a debug ioctl for inode preferred range of blocks.

EXT4_IOC_PRINT_INODE_ARULE ioctl prints the information of
preferred block allocation for specified inode to syslog.

  #define EXT4_IOC_PRINT_INODE_ARULE      _IO('f', 20 )

This information consist of following four entries.
  - inode number (e.g. ino=11)
  - start physical offset of this rule
  - block length this rule covers
  - flag (0: mandatory, 1: advisory)

e.g.  ARULE: ino=11 start=6000 len=1000 flag=0

The above means the inode (ino=11) is set preferred block allocation
from 6000 to 6999 with mandatory.
Therefore block allocator is forced to use blocks from 6000 to 6999
and if could not use this range, return -ENOSPC.

Note: Preferred block allocation is disabled when inode reference
      counter is 0 or umount FS.


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/ext4.h    |    2 ++
 fs/ext4/ioctl.c   |    5 +++++
 fs/ext4/mballoc.c |   20 ++++++++++++++++++++
 3 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4ed4b27..4e94960 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -363,6 +363,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_CLR_GLOBAL_ALLOC_RULE	_IOW('f', 17, struct ext4_alloc_rule)
 #define EXT4_IOC_ADD_INODE_ALLOC_RULE	_IOW('f', 18, struct ext4_alloc_rule)
 #define EXT4_IOC_PRINT_GLOBAL_ARULE	_IO('f', 19)
+#define EXT4_IOC_PRINT_INODE_ARULE	_IO('f', 20)

 /*
  * ioctl commands in 32 bit emulation
@@ -1406,6 +1407,7 @@ extern int ext4_mb_add_inode_arule(struct inode *inode,
 extern void ext4_mb_del_inode_arule(struct inode *inode);
 extern void ext4_mb_dec_inode_arule(struct inode *inode, unsigned int len);
 extern void ext4_mb_print_global_arule(struct inode *inode);
+extern void ext4_mb_print_inode_arule(struct inode *inode);

 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 323e3d2..9808dd4 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -323,6 +323,11 @@ setversion_out:
 		return 0;
 	}

+	case EXT4_IOC_PRINT_INODE_ARULE: {
+		ext4_mb_print_inode_arule(inode);
+		return 0;
+	}
+
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index cd5b833..bfe633e 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5859,3 +5859,23 @@ void ext4_mb_print_global_arule(struct inode *inode)

 	return;
 }
+
+void ext4_mb_print_inode_arule(struct inode *inode)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_alloc_rule *arule = NULL;
+
+	if (ei->i_alloc_rule == NULL)
+		printk(KERN_ERR "ARULE: ino=%lu alloc_rule is empty\n",
+				inode->i_ino);
+	else {
+		arule = &(ei->i_alloc_rule)->alloc_rule;
+		printk(KERN_ERR "ARULE: ino=%lu start=%llu len=%llu "
+				"flag=%u\n", inode->i_ino,
+				(ext4_fsblk_t)arule->start,
+				(ext4_fsblk_t)arule->len,
+				(unsigned)arule->alloc_flag);
+	}
+
+	return;
+}
