From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: fix partial cluster handling for bigalloc file systems
Date: Wed, 12 Mar 2014 17:27:36 -0400
Message-ID: <20140312212736.GA2284@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:42998 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaCLV1l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Mar 2014 17:27:41 -0400
Received: by mail-qc0-f169.google.com with SMTP id i17so148360qcy.14
        for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2014 14:27:40 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 9cb00419fa, which enables hole punching for bigalloc file
systems, exposed a bug introduced by commit 6ae06ff51e in an earlier
release.  When run on a bigalloc file system, xfstests generic/013, 068,
075, 083, 091, 100, 112, 127, 263, 269, and 270 fail with e2fsck errors
or cause kernel error messages indicating that previously freed blocks
are being freed again.

The latter commit optimizes the selection of the starting extent in
ext4_ext_rm_leaf() when hole punching by beginning with the extent
supplied in the path argument rather than with the last extent in the
leaf node (as is still done when truncating).  However, the code in
rm_leaf that initially sets partial_cluster to track cluster sharing on
extent boundaries is only guaranteed to run if rm_leaf starts with the
last node in the leaf.  Consequently, partial_cluster is not correctly
initialized when hole punching, and a cluster on the boundary of a
punched region that should be retained may instead be deallocated.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 74bc2d5..f9459cb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2585,7 +2585,27 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	ex_ee_block = le32_to_cpu(ex->ee_block);
 	ex_ee_len = ext4_ext_get_actual_len(ex);
 
+	/*
+	 * If we're starting with an extent other than the last one in the
+	 * node, we need to see if it shares a cluster with the extent to
+	 * the right (towards the end of the file). If its leftmost cluster
+	 * is this extent's rightmost cluster and it is not cluster aligned,
+	 * we'll mark it as a partial that is not to be deallocated.
+	 */
+
+	if (ex != EXT_LAST_EXTENT(eh)) {
+		ext4_fsblk_t current_pblk, right_pblk;
+		long long current_cluster, right_cluster;
+
+		current_pblk = ext4_ext_pblock(ex) + ex_ee_len - 1;
+		current_cluster = (long long)EXT4_B2C(sbi, current_pblk);
+		right_pblk = ext4_ext_pblock(ex + 1);
+		right_cluster = (long long)EXT4_B2C(sbi, right_pblk);
+		if (current_cluster == right_cluster &&
+			EXT4_PBLK_COFF(sbi, right_pblk))
+			*partial_cluster = -right_cluster;
+	}
+
 	trace_ext4_ext_rm_leaf(inode, start, ex, *partial_cluster);
 
 	while (ex >= EXT_FIRST_EXTENT(eh) &&
-- 
1.8.3.2

