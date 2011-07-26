From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH] ext4: add action of moving index in ext4_ext_rm_idx for Punch Hole
Date: Tue, 26 Jul 2011 15:34:59 +0800
Message-ID: <1311665699-22023-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60702 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1GZHfH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 26 Jul 2011 03:35:07 -0400
Received: by pzk37 with SMTP id 37so394727pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 26 Jul 2011 00:35:06 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

The old function ext4_ext_rm_idx is used only for truncate case because
it just remove last index in extent-index-block. When punching hole,
it usually needed to remove "middle" index, therefore we must move indexes
which after it forward.

(I create a file with 1 depth extent tree and punch hole in the middle of it,
the last index in index-block strangly gone, so I find out this bug)

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/extents.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4d73e11..a25bbdc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2101,8 +2101,6 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
 /*
  * ext4_ext_rm_idx:
  * removes index from the index block.
- * It's used in truncate case only, thus all requests are for
- * last index in the block only.
  */
 static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path)
@@ -2120,6 +2118,13 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 	err = ext4_ext_get_access(handle, inode, path);
 	if (err)
 		return err;
+
+	if (path->p_idx != EXT_LAST_INDEX(path->p_hdr)) {
+		int len = EXT_LAST_INDEX(path->p_hdr) - path->p_idx;
+		len *= sizeof(struct ext4_extent_idx);
+		memmove(path->p_idx, path->p_idx + 1, len);
+	}
+
 	le16_add_cpu(&path->p_hdr->eh_entries, -1);
 	err = ext4_ext_dirty(handle, inode, path);
 	if (err)
-- 
1.7.3.2

