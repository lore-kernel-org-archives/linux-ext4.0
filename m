From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ext4: Remove empty index blocks when punching holes
Date: Wed, 29 Feb 2012 00:37:28 -0700
Message-ID: <1330501048-14109-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39627 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793Ab2B2HhV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Feb 2012 02:37:21 -0500
Received: from /spool/local
	by e1.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 29 Feb 2012 02:37:20 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id A784D6E8049
	for <linux-ext4@vger.kernel.org>; Wed, 29 Feb 2012 02:37:03 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q1T7b2733072250
	for <linux-ext4@vger.kernel.org>; Wed, 29 Feb 2012 02:37:03 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q1T7b2dQ029821
	for <linux-ext4@vger.kernel.org>; Wed, 29 Feb 2012 04:37:02 -0300
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When punching holes, it is possible that all the entries of an
index block may be removed.  These empty index blocks need to
be removed once punch hole completes.  This patch adds some extra
logic to the punch hole code to remove empty index blocks.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 ad39627... 6bb2f55... M	fs/ext4/extents.c
 fs/ext4/extents.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ad39627..6bb2f55 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3709,7 +3709,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_extent newex, *ex, *ex2;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	ext4_fsblk_t newblock = 0;
-	int free_on_err = 0, err = 0, depth, ret;
+	int free_on_err = 0, err = 0, depth, ret, i;
 	unsigned int allocated = 0, offset = 0;
 	unsigned int allocated_clusters = 0, reserved_clusters = 0;
 	unsigned int punched_out = 0;
@@ -3880,6 +3880,21 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			err = ext4_ext_rm_leaf(handle, inode, path,
 					       &partial_cluster, map->m_lblk,
 					       map->m_lblk + punched_out);
+			if (err)
+				goto out2;
+
+			/*
+			 * Walk back up the path and remove
+			 * empty index blocks
+			 */
+			for (i = depth - 1; i > 0; i--) {
+				if (path[i].p_hdr->eh_entries == 0) {
+					err = ext4_ext_rm_idx(handle, inode,
+								path + i);
+					if (err)
+						goto out2;
+				}
+			}
 
 			if (!err && path->p_hdr->eh_entries == 0) {
 				/*
-- 
1.7.1

