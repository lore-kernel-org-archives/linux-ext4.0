From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] ext4: always check ext4_ext_find_extent result
Date: Sun, 13 Apr 2014 19:36:00 +0400
Message-ID: <1397403361-20459-2-git-send-email-dmonakhov@openvz.org>
References: <1397403361-20459-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:18948 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbaDMPgU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Apr 2014 11:36:20 -0400
In-Reply-To: <1397403361-20459-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Where are some places where logic guaranties us that extent we are
searching exits, but this may not be true due to on-disk data
corruption. If such corruption happens we must prevent possible
null pointer dereferences.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 38be063..f20effb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3313,6 +3313,10 @@ static int ext4_split_extent(handle_t *handle,
 		return PTR_ERR(path);
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
+	if (!ex) {
+		EXT4_ERROR_INODE(inode, "unexpected hole at %lu", map->m_lblk);
+		return -EIO;
+	}
 	uninitialized = ext4_ext_is_uninitialized(ex);
 	split_flag1 = 0;
 
@@ -3694,6 +3698,12 @@ static int ext4_convert_initialized_extents(handle_t *handle,
 		}
 		depth = ext_depth(inode);
 		ex = path[depth].p_ext;
+		if (!ex) {
+			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
+					 map->m_lblk);
+			err = -EIO;
+			goto out;
+		}
 	}
 
 	err = ext4_ext_get_access(handle, inode, path + depth);
@@ -5340,6 +5350,12 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 			return PTR_ERR(path);
 		depth = path->p_depth;
 		extent = path[depth].p_ext;
+		if (!extent) {
+			EXT4_ERROR_INODE(inode, "unexpected hole at %lu",
+					 start);
+			return -EIO;
+		}
+
 		current_block = le32_to_cpu(extent->ee_block);
 		if (start > current_block) {
 			/* Hole, move to the next extent */
-- 
1.7.1

