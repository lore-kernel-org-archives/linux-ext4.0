From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] ext4: add WARN_ON to check the length of allocated blocks
Date: Sun, 24 Mar 2013 17:42:53 +0800
Message-ID: <1364118173-12354-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:41583 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3CXJ1y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 Mar 2013 05:27:54 -0400
Received: by mail-da0-f47.google.com with SMTP id s35so2796954dak.6
        for <linux-ext4@vger.kernel.org>; Sun, 24 Mar 2013 02:27:54 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

In this commit (921f266b) a sanity check is added in map_blocks to make
sure 'retval == map->m_len'.  But we need to define a macro to enable
it.  This commit uses a WARN_ON to do the same thing.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c | 27 +++------------------------
 1 file changed, 3 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 85e41a2..4513e9a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -613,14 +613,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 		int ret;
 		unsigned long long status;
 
-#ifdef ES_AGGRESSIVE_TEST
-		if (retval != map->m_len) {
-			printk("ES len assertation failed for inode: %lu "
-			       "retval %d != map->m_len %d "
-			       "in %s (lookup)\n", inode->i_ino, retval,
-			       map->m_len, __func__);
-		}
-#endif
+		WARN_ON(retval != map->m_len);
 
 		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
@@ -714,14 +707,7 @@ found:
 		int ret;
 		unsigned long long status;
 
-#ifdef ES_AGGRESSIVE_TEST
-		if (retval != map->m_len) {
-			printk("ES len assertation failed for inode: %lu "
-			       "retval %d != map->m_len %d "
-			       "in %s (allocation)\n", inode->i_ino, retval,
-			       map->m_len, __func__);
-		}
-#endif
+		WARN_ON(retval != map->m_len);
 
 		/*
 		 * If the extent has been zeroed out, we don't need to update
@@ -2030,14 +2016,7 @@ add_delayed:
 		int ret;
 		unsigned long long status;
 
-#ifdef ES_AGGRESSIVE_TEST
-		if (retval != map->m_len) {
-			printk("ES len assertation failed for inode: %lu "
-			       "retval %d != map->m_len %d "
-			       "in %s (lookup)\n", inode->i_ino, retval,
-			       map->m_len, __func__);
-		}
-#endif
+		WARN_ON(retval != map->m_len);
 
 		status = map->m_flags & EXT4_MAP_UNWRITTEN ?
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
-- 
1.7.12.rc2.18.g61b472e

