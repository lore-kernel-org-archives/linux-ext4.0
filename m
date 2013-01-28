From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: remove explicit WARN_ON when ext4_map_blocks() fails
Date: Mon, 28 Jan 2013 10:14:07 +0100
Message-ID: <1359364447-4699-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab3A1JOM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 04:14:12 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In two places we call WARN_ON() before we print out the debug message,
however we agreed that the WARN_ON() is unnecessary at those places so
remove them.

Also use ext4_warning() instead of ext4_msg() and printk().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5ae1674..88d31f5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4459,11 +4459,11 @@ retry:
 		ret = ext4_map_blocks(handle, inode, &map, flags);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
-			WARN_ON(ret <= 0);
-			printk(KERN_ERR "%s: ext4_ext_map_blocks "
-				    "returned error inode#%lu, block=%u, "
-				    "max_blocks=%u", __func__,
-				    inode->i_ino, map.m_lblk, max_blocks);
+			ext4_warning(inode->i_sb,
+				     "inode #%lu: block %u: len %u: "
+				     "ext4_ext_map_blocks returned %d",
+				     inode->i_ino, map.m_lblk,
+				     map.m_len, ret);
 #endif
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
@@ -4536,14 +4536,12 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 		}
 		ret = ext4_map_blocks(handle, inode, &map,
 				      EXT4_GET_BLOCKS_IO_CONVERT_EXT);
-		if (ret <= 0) {
-			WARN_ON(ret <= 0);
-			ext4_msg(inode->i_sb, KERN_ERR,
-				 "%s:%d: inode #%lu: block %u: len %u: "
-				 "ext4_ext_map_blocks returned %d",
-				 __func__, __LINE__, inode->i_ino, map.m_lblk,
-				 map.m_len, ret);
-		}
+		if (ret <= 0)
+			ext4_warning(inode->i_sb,
+				     "inode #%lu: block %u: len %u: "
+				     "ext4_ext_map_blocks returned %d",
+				     inode->i_ino, map.m_lblk,
+				     map.m_len, ret);
 		ext4_mark_inode_dirty(handle, inode);
 		ret2 = ext4_journal_stop(handle);
 		if (ret <= 0 || ret2 )
-- 
1.7.7.6

