From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 6/7] ext4: punch hole should be restarted after transaction restart
Date: Fri, 28 Oct 2011 21:00:09 +0400
Message-ID: <1319821210-7374-7-git-send-email-dmonakhov@openvz.org>
References: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45611 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1J1RA1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 13:00:27 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so624020bkb.19
        for <linux-ext4@vger.kernel.org>; Fri, 28 Oct 2011 10:00:26 -0700 (PDT)
In-Reply-To: <1319821210-7374-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_ext_rm_leaf() may return -EAGAIN due to transaction restart,
repeat attempt in that case.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5cce39a..a77cde2 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3795,7 +3795,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			struct ext4_map_blocks *map, int flags)
 {
-	struct ext4_ext_path *path = NULL;
+	struct ext4_ext_path *path;
 	struct ext4_extent newex, *ex, *ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
@@ -3811,6 +3811,9 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 		  map->m_lblk, map->m_len, inode->i_ino);
 	trace_ext4_ext_map_blocks_enter(inode, map->m_lblk, map->m_len, flags);
 
+again:
+	path = NULL;
+
 	/* check in cache */
 	if (!(flags & EXT4_GET_BLOCKS_PUNCH_OUT_EXT) &&
 		ext4_ext_in_cache(inode, map->m_lblk, &newex)) {
@@ -3904,6 +3907,8 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			}
 			ret = ext4_ext_handle_punched_extent(handle, inode,
 							map, path);
+			if (ret == -EAGAIN)
+				goto again;
 			return ret;
 		}
 	}
-- 
1.7.1

