From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] ext4: fix premature freeing of partial clusters split across
Date: Tue, 1 Apr 2014 19:36:46 -0400
Message-ID: <20140401233646.GA6549@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qc0-f171.google.com ([209.85.216.171]:46792 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaDAXgu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Apr 2014 19:36:50 -0400
Received: by mail-qc0-f171.google.com with SMTP id c9so11533635qcz.16
        for <linux-ext4@vger.kernel.org>; Tue, 01 Apr 2014 16:36:50 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Xfstests generic/311 and shared/298 fail when run on a bigalloc file
system.  Kernel error messages produced during the tests report that
blocks to be freed are already on the to-be-freed list.  When e2fsck
is run at the end of the tests, it typically reports bad i_blocks and
bad free blocks counts.

The bug that causes these failures is located in ext4_ext_rm_leaf().
Code at the end of the function frees a partial cluster if it's not
shared with an extent remaining in the leaf.  However, if all the
extents in the leaf have been removed, the code dereferences an
invalid extent pointer (off the front of the leaf) when the check for
sharing is made.  This generally has the effect of unconditionally
freeing the partial cluster, which leads to the observed failures
when the partial cluster is shared with the last extent in the next
leaf.

Fix this by attempting to free the cluster only if extents remain in
the leaf.  Any remaining partial cluster will be freed if possible
when the next leaf is processed or when leaf removal is complete.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 fs/ext4/extents.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 243a02e..340fadd 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2743,10 +2743,15 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		err = ext4_ext_correct_indexes(handle, inode, path);
 
 	/*
-	 * Free the partial cluster only if the current extent does not
-	 * reference it. Otherwise we might free used cluster.
+	 * If there's a partial cluster and at least one extent remains in
+	 * the leaf, free the partial cluster if it isn't shared with the
+	 * current extent.  If there's a partial cluster and no extents
+	 * remain in the leaf, it can't be freed here.  It can only be
+	 * freed when it's possible to determine if it's not shared with
+	 * any other extent - when the next leaf is processed or when space
+	 * removal is complete.
 	 */
-	if (*partial_cluster > 0 &&
+	if (*partial_cluster > 0 && eh->eh_entries &&
 	    (EXT4_B2C(sbi, ext4_ext_pblock(ex) + ex_ee_len - 1) !=
 	     *partial_cluster)) {
 		int flags = get_default_free_blocks_flags(inode);
-- 
1.8.3.2

