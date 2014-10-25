From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/39] resize2fs: don't interpret bitmap shift while
 crossing flexbg as raid stride
Date: Sat, 25 Oct 2014 13:57:40 -0700
Message-ID: <20141025205740.532.89599.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, TR Reardon <thomas_reardon@hotmail.com>
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43875 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaJYU6F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:58:05 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

resize2fs tries to infer the RAID stride by observing differences between the
locations of adjacent block groups' block and inode bitmaps within the block
group.  If the two block groups being compared belong to different flexbgs,
however, it'll be fooled by the large offset into thinking that the FS has an
abnormally large RAID stride.

Therefore, teach it not to get confused by crossing a flexbg.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: TR Reardon <thomas_reardon@hotmail.com>
---
 resize/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/resize/main.c b/resize/main.c
index 983d8c2..e017792 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -105,6 +105,7 @@ static void determine_fs_stride(ext2_filsys fs)
 	unsigned long long sum;
 	unsigned int	has_sb, prev_has_sb = 0, num;
 	int		i_stride, b_stride;
+	int		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
 
 	if (fs->stride)
 		return;
@@ -120,7 +121,8 @@ static void determine_fs_stride(ext2_filsys fs)
 			ext2fs_inode_bitmap_loc(fs, group - 1) -
 			fs->super->s_blocks_per_group;
 		if (b_stride != i_stride ||
-		    b_stride < 0)
+		    b_stride < 0 ||
+		    (flexbg_size > 1 && (group % flexbg_size == 0)))
 			goto next;
 
 		/* printf("group %d has stride %d\n", group, b_stride); */

