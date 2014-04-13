From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] ext4: Fix error handling in ext4_ext_shift_extents
Date: Sun, 13 Apr 2014 19:35:59 +0400
Message-ID: <1397403361-20459-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:18559 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577AbaDMPgT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 11:36:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 96e0a4b..38be063 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5314,11 +5314,18 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * enough to accomodate the shift.
 	 */
 	path = ext4_ext_find_extent(inode, start - 1, NULL, 0);
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 	depth = path->p_depth;
 	extent =  path[depth].p_ext;
-	ex_start = le32_to_cpu(extent->ee_block);
-	ex_end = le32_to_cpu(extent->ee_block) +
+	if (extent) {
+		ex_start = le32_to_cpu(extent->ee_block);
+		ex_end = le32_to_cpu(extent->ee_block) +
 			ext4_ext_get_actual_len(extent);
+	} else {
+		ex_start = 0;
+		ex_end = 0;
+	}
 	ext4_ext_drop_refs(path);
 	kfree(path);
 
-- 
1.7.1

