From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] ext4: optimize block allocation on grow indepth
Date: Tue, 23 Sep 2014 11:02:32 +0400
Message-ID: <1411455752-2332-3-git-send-email-dmonakhov@openvz.org>
References: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:46447 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641AbaIWHCm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 23 Sep 2014 03:02:42 -0400
In-Reply-To: <1411455752-2332-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It is reasonable to prepent newly created index to older one.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8170b32..37267ea 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1268,11 +1268,20 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 {
 	struct ext4_extent_header *neh;
 	struct buffer_head *bh;
-	ext4_fsblk_t newblock;
+	ext4_fsblk_t newblock, goal = 0;
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
 	int err = 0;
 
-	newblock = ext4_ext_new_meta_block(handle, inode, NULL,
-		newext, &err, flags);
+	/* Try to prepend new index to old one */
+	if (ext_depth(inode))
+		goal = ext4_idx_pblock(EXT_FIRST_INDEX(ext_inode_hdr(inode)));
+	if (goal > le32_to_cpu(es->s_first_data_block)) {
+		flags |= EXT4_MB_HINT_TRY_GOAL;
+		goal--;
+	} else
+		goal =  ext4_inode_to_goal_block(inode);
+	newblock = ext4_new_meta_blocks(handle, inode, goal, flags,
+					NULL, &err);
 	if (newblock == 0)
 		return err;
 
-- 
1.7.1

