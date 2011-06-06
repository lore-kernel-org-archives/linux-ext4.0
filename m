From: Allison Henderson <achender@vnet.ibm.com>
Subject: PATCH 1/2 v2] EXT4: Skip un-needed extent lookup
Date: Mon, 06 Jun 2011 16:43:41 -0700
Message-ID: <4DED662D.2090109@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:36738 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1FFXnp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Jun 2011 19:43:45 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p56NW7sc027298
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:32:07 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p56Nhgl9164858
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:43:42 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p56NmubM031120
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:48:56 -0600
Received: from lc4eb0185863151.ibm.com (sig-9-65-175-246.mts.ibm.com [9.65.175.246])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p56Nmt9X031104
	for <linux-ext4@vger.kernel.org>; Mon, 6 Jun 2011 17:48:56 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch optimizes the punch hole operation by skipping the
tree walking code that is used by truncate.  Since punch hole
is done through map blocks, the path to the extent is already
known in this function, so we do not need to look it up again.

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 5199bac... ecaa767... M	fs/ext4/extents.c
 fs/ext4/extents.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5199bac..ecaa767 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3497,8 +3497,27 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 
 			ext4_ext_mark_uninitialized(ex);
 
-			err = ext4_ext_remove_space(inode, map->m_lblk,
-				map->m_lblk + punched_out);
+			ext4_ext_invalidate_cache(inode);
+
+			err = ext4_ext_rm_leaf(handle, inode, path,
+				map->m_lblk, map->m_lblk + punched_out);
+
+			if (!err && path->p_hdr->eh_entries == 0) {
+				/*
+				 * Punch hole freed all of this sub tree,
+				 * so we need to correct eh_depth
+				 */
+				err = ext4_ext_get_access(handle, inode, path);
+				if (err == 0) {
+					ext_inode_hdr(inode)->eh_depth = 0;
+					ext_inode_hdr(inode)->eh_max =
+					cpu_to_le16(ext4_ext_space_root(
+						inode, 0));
+
+					err = ext4_ext_dirty(
+						handle, inode, path);
+				}
+			}
 
 			goto out2;
 		}
-- 
1.7.1

