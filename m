From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: Add more sanity checks
Date: Thu, 27 May 2010 15:17:41 +0400
Message-ID: <1274959061-8043-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62470 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab0E0LRp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 27 May 2010 07:17:45 -0400
Received: by mail-fx0-f46.google.com with SMTP id 16so68788fxm.19
        for <linux-ext4@vger.kernel.org>; Thu, 27 May 2010 04:17:45 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- It is reasonable to return EIO from ext4_remove_blocks() if extent is
  incorrect.
- Check that reservation counters are consistent at the on inode drop.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   13 +++++--------
 fs/ext4/super.c   |   14 +++++++++++++-
 2 files changed, 18 insertions(+), 9 deletions(-)

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
index 49d88c0..e5166e5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -770,7 +770,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 
 static void ext4_destroy_inode(struct inode *inode)
 {
-	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
+	if (unlikely(!list_empty(&(EXT4_I(inode)->i_orphan)))) {
 		ext4_msg(inode->i_sb, KERN_ERR,
 			 "Inode %lu (%p): orphan list check failed!",
 			 inode->i_ino, EXT4_I(inode));
@@ -779,6 +779,18 @@ static void ext4_destroy_inode(struct inode *inode)
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

