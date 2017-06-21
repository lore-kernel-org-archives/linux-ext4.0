From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: fix off-by-one fsmap error on 1k block filesystems
Date: Wed, 21 Jun 2017 11:29:40 -0700
Message-ID: <20170621182940.GB4728@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18259 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbdFUS3y (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Jun 2017 14:29:54 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For 1k-block filesystems, the filesystem starts at block 1, not block 0.
This fact is recorded in s_first_data_block, so use that to bump up the
start_fsb before we start querying the filesystem for its space map.
Without this, ext4/026 fails on 1k block ext4 because various functions
(notably ext4_get_group_no_and_offset) don't know what to do with an
fsblock that is "before" the start of the filesystem and return garbage
results (blockgroup 2^32-1, etc.) that confuse fsmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/fsmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ext4/fsmap.c b/fs/ext4/fsmap.c
index b194360..7ec3408 100644
--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -480,6 +480,7 @@ static int ext4_getfsmap_datadev(struct super_block *sb,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_fsblk_t start_fsb;
 	ext4_fsblk_t end_fsb;
+	ext4_fsblk_t bofs;
 	ext4_fsblk_t eofs;
 	ext4_group_t start_ag;
 	ext4_group_t end_ag;
@@ -487,9 +488,12 @@ static int ext4_getfsmap_datadev(struct super_block *sb,
 	ext4_grpblk_t last_cluster;
 	int error = 0;
 
+	bofs = le32_to_cpu(sbi->s_es->s_first_data_block);
 	eofs = ext4_blocks_count(sbi->s_es);
 	if (keys[0].fmr_physical >= eofs)
 		return 0;
+	else if (keys[0].fmr_physical < bofs)
+		keys[0].fmr_physical = bofs;
 	if (keys[1].fmr_physical >= eofs)
 		keys[1].fmr_physical = eofs - 1;
 	start_fsb = keys[0].fmr_physical;
