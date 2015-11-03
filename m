From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: don't brelse error pointers
Date: Tue, 3 Nov 2015 11:22:31 -0800
Message-ID: <20151103192231.GB2213@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44735 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbbKCTWg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Nov 2015 14:22:36 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we fail to read the block bitmap, we're returned an error
pointer.  It is incorrect to pass this to brelse, so save the error
code and set the pointer to NULL before jumping out of the function.
This avoids brelse()ing a nonpointer.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/mballoc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 19b8104..f185c97 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2906,6 +2906,7 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	bitmap_bh = ext4_read_block_bitmap(sb, ac->ac_b_ex.fe_group);
 	if (IS_ERR(bitmap_bh)) {
 		err = PTR_ERR(bitmap_bh);
+		bitmap_bh = NULL;
 		goto out_err;
 	}
 
@@ -4774,6 +4775,7 @@ do_more:
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
 	if (IS_ERR(bitmap_bh)) {
 		err = PTR_ERR(bitmap_bh);
+		bitmap_bh = NULL;
 		goto error_return;
 	}
 	gdp = ext4_get_group_desc(sb, block_group, &gd_bh);
@@ -4944,6 +4946,7 @@ int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 	bitmap_bh = ext4_read_block_bitmap(sb, block_group);
 	if (IS_ERR(bitmap_bh)) {
 		err = PTR_ERR(bitmap_bh);
+		bitmap_bh = NULL;
 		goto error_return;
 	}
 
