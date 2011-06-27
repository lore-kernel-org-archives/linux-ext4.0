From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/2] EXT4: Punch Hole Optimizations: Skip un-needed extent lookup
Date: Mon, 27 Jun 2011 15:49:50 -0700
Message-ID: <1309214991-31141-2-git-send-email-achender@linux.vnet.ibm.com>
References: <1309214991-31141-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57968 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257Ab1F0Wrc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 18:47:32 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5RMZWrY001597
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:35:32 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5RMlVHC141858
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:47:31 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5RMlU3v014671
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 18:47:31 -0400
In-Reply-To: <1309214991-31141-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch optimizes the punch hole operation by skipping the
tree walking code that is used by truncate.  Since punch hole
is done through map blocks, the path to the extent is already
known in this function, so we do not need to look it up again.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
v2->v3
Rebased to apply onto latest ext4 code

:100644 100644 f815cc8... dc5a077... M	fs/ext4/extents.c
 fs/ext4/extents.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f815cc8..dc5a077 100644
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

