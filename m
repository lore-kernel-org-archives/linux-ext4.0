From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/24] e2fsck: fix off-by-one bounds check on group number
Date: Fri, 18 Jul 2014 15:53:48 -0700
Message-ID: <20140718225348.31374.59045.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35636 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946059AbaGRWx4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:53:56 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since fs->group_desc_count is the number of block groups, the number
of the last group is always one less than this count.  Fix the bounds
check to reflect that.

This flaw shouldn't have any user-visible side effects, since the
block bitmap test based on last_grp later on can handle overbig block
numbers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5ad7fe5..eec93c3 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2916,8 +2916,8 @@ static void new_table_block(e2fsck_t ctx, blk64_t first_block, dgrp_t group,
 		first_block = ext2fs_group_first_block2(fs,
 							flexbg_size * flexbg);
 		last_grp = group | (flexbg_size - 1);
-		if (last_grp > fs->group_desc_count)
-			last_grp = fs->group_desc_count;
+		if (last_grp >= fs->group_desc_count)
+			last_grp = fs->group_desc_count - 1;
 		last_block = ext2fs_group_last_block2(fs, last_grp);
 	} else
 		last_block = ext2fs_group_last_block2(fs, group);

