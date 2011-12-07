From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: check flags's EXT4_GET_BLOCKS_DELALLOC_RESERVE before call ext4_find_delalloc_cluster()
Date: Wed,  7 Dec 2011 14:04:39 +0800
Message-ID: <1323237879-31800-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34396 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1LGGFN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2011 01:05:13 -0500
Received: by ggnr5 with SMTP id r5so250425ggn.19
        for <linux-ext4@vger.kernel.org>; Tue, 06 Dec 2011 22:05:12 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

We found performance regression when using bigalloc with "nodelalloc"  (1MB cluster size):

1. mke2fs -C 1048576 -O ^has_journal,bigalloc /dev/sda
2. mount -o nodelalloc /dev/sda /test/
3. time dd if=/dev/zero of=/test/io bs=1048576 count=1024

The "dd" will cost about 2 seconds to finish, but if we mke2fs without "bigalloc",
"dd" will only cost lesss than 1 second.

The reason is:  when using ext4 with "nodelalloc", it will call ext4_find_delalloc_cluster() nearly
everytime it call ext4_ext_map_blocks(), and ext4_find_delalloc_cluster() will also scan all pages
in cluster because no buffer is "delayed".
A cluster has 256 pages (1MB cluster), so it will scan 256 * 256k pags when creating a 1G file. That
severely hurts the performance.

Therefore, we don't call ext4_find_delalloc_cluster() when use "nodelalloc".

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..e15d32b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3724,7 +3724,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
 		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
 		if (!newex.ee_start_lo && !newex.ee_start_hi) {
-			if ((sbi->s_cluster_ratio > 1) &&
+			if ((flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
+			    (sbi->s_cluster_ratio > 1) &&
 			    ext4_find_delalloc_cluster(inode, map->m_lblk, 0))
 				map->m_flags |= EXT4_MAP_FROM_CLUSTER;
 
@@ -3900,7 +3901,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		}
 	}
 
-	if ((sbi->s_cluster_ratio > 1) &&
+	if ((flags & EXT4_GET_BLOCKS_DELALLOC_RESERVE) &&
+	    (sbi->s_cluster_ratio > 1) &&
 	    ext4_find_delalloc_cluster(inode, map->m_lblk, 0))
 		map->m_flags |= EXT4_MAP_FROM_CLUSTER;
 
-- 
1.7.4.1

