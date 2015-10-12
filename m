From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/12] libext2fs: fix maximum bg overhead calculation with
 meta_bg enabled
Date: Mon, 12 Oct 2015 14:56:35 -0700
Message-ID: <20151012215635.29065.41295.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39879 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbbJLV4l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:56:41 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
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

