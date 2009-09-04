From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH] resize2fs: fix minimum resize size calculation with flex_bg
Date: Fri,  4 Sep 2009 17:15:40 +0800
Message-ID: <1252055740-9993-1-git-send-email-bergwolf@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:60028 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbZIDJRX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Sep 2009 05:17:23 -0400
Received: by pzk28 with SMTP id 28so658499pzk.27
        for <linux-ext4@vger.kernel.org>; Fri, 04 Sep 2009 02:17:25 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When flex_bg is on, calculate_minimum_resize_size() should add more meta
blocks for newly added flex_bg.

Addresses-Red-Hat-Bug: #519131
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 resize/resize2fs.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index c0b00b6..648e1f9 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1900,6 +1900,8 @@ blk_t calculate_minimum_resize_size(ext2_filsys fs)
 	blk_t inode_count, blks_needed, groups, data_blocks;
 	blk_t grp, data_needed, last_start;
 	int overhead = 0, num_of_superblocks = 0;
+	int extra_groups = 0;
+	int flexbg_size = 1 << fs->super->s_log_groups_per_flex;
 
 	/*
 	 * first figure out how many group descriptors we need to
@@ -1934,11 +1936,9 @@ blk_t calculate_minimum_resize_size(ext2_filsys fs)
 		 * of inode tables of slack space so the resize
 		 * operation can be guaranteed to finish.
 		 */
-		int flexbg_size = 1 << fs->super->s_log_groups_per_flex;
-		int extra_groups;
-
 		extra_groups = flexbg_size - (groups & (flexbg_size - 1));
 		data_needed += META_OVERHEAD(fs) * extra_groups;
+		extra_groups = groups % flexbg_size;
 	}
 
 	/*
@@ -2002,6 +2002,20 @@ blk_t calculate_minimum_resize_size(ext2_filsys fs)
 		}
 
 		groups += extra_grps;
+		extra_groups += extra_grps;
+		if (fs->super->s_feature_incompat
+			& EXT4_FEATURE_INCOMPAT_FLEX_BG
+		    && extra_groups > flexbg_size) {
+			/*
+			 * For ext4 we need to allow for up to a flex_bg worth
+			 * of inode tables of slack space so the resize
+			 * operation can be guaranteed to finish.
+			 */
+			extra_groups = flexbg_size -
+						(groups & (flexbg_size - 1));
+			data_needed += META_OVERHEAD(fs) * extra_groups;
+			extra_groups = groups % flexbg_size;
+		}
 	}
 
 	/* now for the fun voodoo */
-- 
1.6.4.2.446.gbd046

