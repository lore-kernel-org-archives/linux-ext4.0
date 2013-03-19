From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] ext4: Try to prepend extent to the existing one
Date: Tue, 19 Mar 2013 14:13:38 +0100
Message-ID: <1363698818-15760-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110Ab3CSNNl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Mar 2013 09:13:41 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2JDDfc8029269
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 09:13:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently when inserting extent in ext4_ext_insert_extent() we would
only try to to see if we can append new extent to the found extent. If
we can not, then we proceed with adding new extent into the extent tree,
but then possibly merging it back again.

We can avoid this situation by trying to append and prepend new extent
to the existing ones. However since the new extent can be on either
sides of the existing extent, we have to pick the right extent to try to
append/prepend to.

This patch adds the conditions to pick the right extent to
append/prepend to and adds the actual prepending condition as well. This
will also eliminate the need to use "reserved" block for possibly
growing extent tree.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |  108 +++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 85 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 28dd8ee..d6600f9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1811,39 +1811,101 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	}
 	depth = ext_depth(inode);
 	ex = path[depth].p_ext;
+	eh = path[depth].p_hdr;
 	if (unlikely(path[depth].p_hdr == NULL)) {
 		EXT4_ERROR_INODE(inode, "path[%d].p_hdr == NULL", depth);
 		return -EIO;
 	}
 
 	/* try to insert block into found extent and return */
-	if (ex && !(flag & EXT4_GET_BLOCKS_PRE_IO)
-		&& ext4_can_extents_be_merged(inode, ex, newext)) {
-		ext_debug("append [%d]%d block to %u:[%d]%d (from %llu)\n",
-			  ext4_ext_is_uninitialized(newext),
-			  ext4_ext_get_actual_len(newext),
-			  le32_to_cpu(ex->ee_block),
-			  ext4_ext_is_uninitialized(ex),
-			  ext4_ext_get_actual_len(ex),
-			  ext4_ext_pblock(ex));
-		err = ext4_ext_get_access(handle, inode, path + depth);
-		if (err)
-			return err;
+	if (ex && !(flag & EXT4_GET_BLOCKS_PRE_IO)) {
 
 		/*
-		 * ext4_can_extents_be_merged should have checked that either
-		 * both extents are uninitialized, or both aren't. Thus we
-		 * need to check only one of them here.
+		 * Try to see whether we should rather test the extent on
+		 * right from ex, or from the left of ex. This is because
+		 * ext4_ext_find_extent() can return either extent on the
+		 * left, or on the right from the searched position. This
+		 * will make merging more effective.
 		 */
-		if (ext4_ext_is_uninitialized(ex))
-			uninitialized = 1;
-		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
+		if (ex < EXT_LAST_EXTENT(eh) &&
+		    (le32_to_cpu(ex->ee_block) +
+		    ext4_ext_get_actual_len(ex) <
+		    le32_to_cpu(newext->ee_block))) {
+			ex += 1;
+			goto prepend;
+		} else if ((ex > EXT_FIRST_EXTENT(eh)) &&
+			   (le32_to_cpu(newext->ee_block) +
+			   ext4_ext_get_actual_len(newext) <
+			   le32_to_cpu(ex->ee_block)))
+			ex -= 1;
+
+		/* Try to append newex to the ex */
+		if (ext4_can_extents_be_merged(inode, ex, newext)) {
+			ext_debug("append [%d]%d block to %u:[%d]%d"
+				  "(from %llu)\n",
+				  ext4_ext_is_uninitialized(newext),
+				  ext4_ext_get_actual_len(newext),
+				  le32_to_cpu(ex->ee_block),
+				  ext4_ext_is_uninitialized(ex),
+				  ext4_ext_get_actual_len(ex),
+				  ext4_ext_pblock(ex));
+			err = ext4_ext_get_access(handle, inode,
+						  path + depth);
+			if (err)
+				return err;
+
+			/*
+			 * ext4_can_extents_be_merged should have checked
+			 * that either both extents are uninitialized, or
+			 * both aren't. Thus we need to check only one of
+			 * them here.
+			 */
+			if (ext4_ext_is_uninitialized(ex))
+				uninitialized = 1;
+			ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
 					+ ext4_ext_get_actual_len(newext));
-		if (uninitialized)
-			ext4_ext_mark_uninitialized(ex);
-		eh = path[depth].p_hdr;
-		nearex = ex;
-		goto merge;
+			if (uninitialized)
+				ext4_ext_mark_uninitialized(ex);
+			eh = path[depth].p_hdr;
+			nearex = ex;
+			goto merge;
+		}
+
+prepend:
+		/* Try to prepend newex to the ex */
+		if (ext4_can_extents_be_merged(inode, newext, ex)) {
+			ext_debug("prepend %u[%d]%d block to %u:[%d]%d"
+				  "(from %llu)\n",
+				  le32_to_cpu(newext->ee_block),
+				  ext4_ext_is_uninitialized(newext),
+				  ext4_ext_get_actual_len(newext),
+				  le32_to_cpu(ex->ee_block),
+				  ext4_ext_is_uninitialized(ex),
+				  ext4_ext_get_actual_len(ex),
+				  ext4_ext_pblock(ex));
+			err = ext4_ext_get_access(handle, inode,
+						  path + depth);
+			if (err)
+				return err;
+
+			/*
+			 * ext4_can_extents_be_merged should have checked
+			 * that either both extents are uninitialized, or
+			 * both aren't. Thus we need to check only one of
+			 * them here.
+			 */
+			if (ext4_ext_is_uninitialized(ex))
+				uninitialized = 1;
+			ex->ee_block = newext->ee_block;
+			ext4_ext_store_pblock(ex, ext4_ext_pblock(newext));
+			ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
+					+ ext4_ext_get_actual_len(newext));
+			if (uninitialized)
+				ext4_ext_mark_uninitialized(ex);
+			eh = path[depth].p_hdr;
+			nearex = ex;
+			goto merge;
+		}
 	}
 
 	depth = ext_depth(inode);
-- 
1.7.7.6

