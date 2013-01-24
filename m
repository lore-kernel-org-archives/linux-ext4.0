From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext4: call WARN_ON after the debug message
Date: Thu, 24 Jan 2013 17:30:43 +0100
Message-ID: <1359045044-31435-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3AXQa7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2013 11:30:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In two places we call WARN_ON() before we print out the debug message,
however the custom is to print such messages before we call WARN_ON() so
change that.

Also use ext4_msg() instead of plain printk().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5ae1674..b23e1aa 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4459,11 +4459,12 @@ retry:
 		ret = ext4_map_blocks(handle, inode, &map, flags);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
-			WARN_ON(ret <= 0);
-			printk(KERN_ERR "%s: ext4_ext_map_blocks "
-				    "returned error inode#%lu, block=%u, "
-				    "max_blocks=%u", __func__,
-				    inode->i_ino, map.m_lblk, max_blocks);
+			ext4_msg(inode->i_sb, KERN_ERR,
+				 "%s:%d: inode #%lu: block %u: len %u: "
+				 "ext4_ext_map_blocks returned %d",
+				 __func__, __LINE__, inode->i_ino, map.m_lblk,
+				 map.m_len, ret);
+			WARN_ON(1);
 #endif
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
@@ -4537,12 +4538,12 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 		ret = ext4_map_blocks(handle, inode, &map,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT);
 		if (ret <= 0) {
-			WARN_ON(ret <= 0);
 			ext4_msg(inode->i_sb, KERN_ERR,
 				 "%s:%d: inode #%lu: block %u: len %u: "
 				 "ext4_ext_map_blocks returned %d",
 				 __func__, __LINE__, inode->i_ino, map.m_lblk,
 				 map.m_len, ret);
+			WARN_ON(1);
 		}
 		ext4_mark_inode_dirty(handle, inode);
 		ret2 = ext4_journal_stop(handle);
-- 
1.7.7.6

