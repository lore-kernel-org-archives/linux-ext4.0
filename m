From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libext2fs: fix maximum bg overhead calculation with meta_bg
 enabled in ext2fs_initialize
Date: Fri, 18 Sep 2015 22:26:35 -0700
Message-ID: <20150919052635.GG10390@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38520 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbbISF0k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Sep 2015 01:26:40 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When meta_bg is enabled at mkfs time, we put at most one group
descriptor block in each blockgroup.  Unfortunately, the calculation
of max overhead per bg doesn't know this, so mkfs fails when it isn't
strictly necessary.  Fix it, since Dave reported that he couldn't
create a 500TB ext4 filesystem.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/initialize.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 75fbf8e..f672a27 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -379,7 +379,12 @@ ipg_retry:
 	 * table, and the reserved gdt blocks.
 	 */
 	overhead = (int) (3 + fs->inode_blocks_per_group +
-			  fs->desc_blocks + super->s_reserved_gdt_blocks);
+			  super->s_reserved_gdt_blocks);
+
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+		overhead++;
+	else
+		overhead += fs->desc_blocks;
 
 	/* This can only happen if the user requested too many inodes */
 	if (overhead > super->s_blocks_per_group) {
