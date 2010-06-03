From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: Add more sanity checks V2
Date: Thu, 03 Jun 2010 14:17:24 +0400
Message-ID: <87aarc1kuj.fsf@openvz.org>
References: <1274959061-8043-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49030 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab0FCKRa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 3 Jun 2010 06:17:30 -0400
Received: by bwz11 with SMTP id 11so609316bwz.19
        for <linux-ext4@vger.kernel.org>; Thu, 03 Jun 2010 03:17:28 -0700 (PDT)
In-Reply-To: <1274959061-8043-1-git-send-email-dmonakhov@openvz.org> (Dmitry
	Monakhov's message of "Thu, 27 May 2010 15:17:41 +0400")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=


Dmitry Monakhov <dmonakhov@openvz.org> writes:
> - It is reasonable to return EIO from ext4_remove_blocks() if extent is
>   incorrect.
> - Check that reservation counters are consistent at the on inode drop.
Please ignore old version, and take a look in to new version instead.

Changes from v1:
 Perform self-consistency checks for all counters on final put.


--=-=-=
Content-Disposition: inline;
 filename=0001-ext4-Add-more-sanity-checks-v2.patch

>From ef9fe639882499b42e78d53e7ee7b013d656813f Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Thu, 3 Jun 2010 13:53:37 +0400
Subject: [PATCH] ext4: Add more sanity checks v2

- It is reasonable to return EIO from ext4_remove_blocks() if extent is
  incorrect.
- Check that reservation counters are self-consistent.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   13 +++++--------
 fs/ext4/super.c   |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e3cc230..c39cb39 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2189,14 +2189,11 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 		start = ext_pblock(ex) + ee_len - num;
 		ext_debug("free last %u blocks starting %llu\n", num, start);
 		ext4_free_blocks(handle, inode, 0, start, num, flags);
-	} else if (from == le32_to_cpu(ex->ee_block)
-		   && to <= le32_to_cpu(ex->ee_block) + ee_len - 1) {
-		printk(KERN_INFO "strange request: removal %u-%u from %u:%u\n",
-			from, to, le32_to_cpu(ex->ee_block), ee_len);
-	} else {
-		printk(KERN_INFO "strange request: removal(2) "
-				"%u-%u from %u:%u\n",
-				from, to, le32_to_cpu(ex->ee_block), ee_len);
+	} else  {
+		EXT4_ERROR_INODE(inode, "strange request: removal %u-%u from"
+				" %u:%u\n", from, to,
+				le32_to_cpu(ex->ee_block), ee_len);
+		return -EIO;
 	}
 	return 0;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 49d88c0..2b072c9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -40,6 +40,7 @@
 #include <linux/log2.h>
 #include <linux/crc16.h>
 #include <asm/uaccess.h>
+#include <linux/stringify.h>
 
 #include "ext4.h"
 #include "ext4_jbd2.h"
@@ -640,6 +641,18 @@ static void dump_orphan_list(struct super_block *sb, struct ext4_sb_info *sbi)
 	}
 }
 
+#define CHECK_COUNTER(sb, counter, val)					\
+	do {								\
+		if (percpu_counter_sum_positive(&EXT4_SB(sb)->counter) != \
+			(s64)(val))					\
+			ext4_warning((sb), "Counter %s contain unexpected " \
+				"value %lld, expected %lld\n",		\
+				__stringify(counter),			\
+				percpu_counter_sum_positive(		\
+					&EXT4_SB(sb)->counter),		\
+				(s64)(val));				\
+	} while(0);
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -677,6 +690,11 @@ static void ext4_put_super(struct super_block *sb)
 	}
 	kobject_del(&sbi->s_kobj);
 
+	CHECK_COUNTER(sb, s_dirs_counter, ext4_count_dirs(sb));
+	CHECK_COUNTER(sb, s_dirtyblocks_counter, 0UL);
+	CHECK_COUNTER(sb, s_freeblocks_counter, ext4_count_free_blocks(sb));
+	CHECK_COUNTER(sb, s_freeinodes_counter, ext4_count_free_inodes(sb));
+
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
@@ -770,7 +788,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 
 static void ext4_destroy_inode(struct inode *inode)
 {
-	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
+	if (unlikely(!list_empty(&(EXT4_I(inode)->i_orphan)))) {
 		ext4_msg(inode->i_sb, KERN_ERR,
 			 "Inode %lu (%p): orphan list check failed!",
 			 inode->i_ino, EXT4_I(inode));
@@ -779,6 +797,18 @@ static void ext4_destroy_inode(struct inode *inode)
 				true);
 		dump_stack();
 	}
+	if (unlikely(EXT4_I(inode)->i_reserved_data_blocks) ||
+		EXT4_I(inode)->i_reserved_meta_blocks ||
+		EXT4_I(inode)->i_allocated_meta_blocks)  {
+		ext4_msg(inode->i_sb, KERN_ERR, "Inode %lu (%p): Destroyed"
+			" inode still has reserved blocks and probably would"
+			" leak, rsv_data=%u, rsv_mdata=%u, alloc_mblk=%u",
+			inode->i_ino, EXT4_I(inode),
+			EXT4_I(inode)->i_reserved_data_blocks,
+			EXT4_I(inode)->i_reserved_meta_blocks,
+			EXT4_I(inode)->i_allocated_meta_blocks);
+		dump_stack();
+	}
 	kmem_cache_free(ext4_inode_cachep, EXT4_I(inode));
 }
 
-- 
1.6.6.1


--=-=-=--
