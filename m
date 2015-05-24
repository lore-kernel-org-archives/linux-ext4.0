From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH] resize2fs: fix minimum size calculation
Date: Sat, 23 May 2015 23:02:21 -0400
Message-ID: <1432436541-16990-1-git-send-email-psusi@ubuntu.com>
References: <20150524013431.GB3270@thunk.org>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:33009 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbbEXDC1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 May 2015 23:02:27 -0400
Received: by yhcb70 with SMTP id b70so14509710yhc.0
        for <linux-ext4@vger.kernel.org>; Sat, 23 May 2015 20:02:26 -0700 (PDT)
In-Reply-To: <20150524013431.GB3270@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The size calculation adds an initial number of block groups needed to hold
the inodes on the fs, then augments them with additional groups needed to
reach the minimum number of data blocks, and then calculates the size of
the last block group ( which should be a fraction of one block group ).  It
was calculating a last bg size of several block groups because when adding
the supplementary bgs, it only advanced the position of the start of the
last group by one group, even though it was adding multiple groups.  Add
the missing multiplier to move the last bg start position up to the correct
location, thus computing a proper fractional last bg size.
---
 resize/resize2fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 041ff75..3359a8f 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2870,7 +2870,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 
 		/* ok we have to account for the last group */
 		overhead = calc_group_overhead(fs, groups-1, old_desc_blocks);
-		last_start += EXT2_BLOCKS_PER_GROUP(fs->super) - overhead;
+		last_start += (EXT2_BLOCKS_PER_GROUP(fs->super) * extra_grps) - overhead;
 
 		grp = flex_groups;
 		groups += extra_grps;
-- 
2.1.4

