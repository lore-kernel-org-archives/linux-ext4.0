From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Remove unused local variable
Date: Wed, 30 Nov 2011 14:02:04 -0800
Message-ID: <1322690524-25028-1-git-send-email-curtw@google.com>
Cc: linux-ext4@vger.kernel.org, Curt Wohlgemuth <curtw@google.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:37720 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1K3WCI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Nov 2011 17:02:08 -0500
Received: by ggnp2 with SMTP id p2so149383ggn.1
        for <linux-ext4@vger.kernel.org>; Wed, 30 Nov 2011 14:02:07 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In get_implied_cluster_alloc(), rr_cluster_end was being
defined and set, but was never used.  Removed this.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---
 fs/ext4/extents.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 61fa9e1..fc5a673 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3626,7 +3626,7 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_lblk_t c_offset = map->m_lblk & (sbi->s_cluster_ratio-1);
 	ext4_lblk_t ex_cluster_start, ex_cluster_end;
-	ext4_lblk_t rr_cluster_start, rr_cluster_end;
+	ext4_lblk_t rr_cluster_start;
 	ext4_lblk_t ee_block = le32_to_cpu(ex->ee_block);
 	ext4_fsblk_t ee_start = ext4_ext_pblock(ex);
 	unsigned short ee_len = ext4_ext_get_actual_len(ex);
@@ -3637,7 +3637,6 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 
 	/* The requested region passed into ext4_map_blocks() */
 	rr_cluster_start = EXT4_B2C(sbi, map->m_lblk);
-	rr_cluster_end = EXT4_B2C(sbi, map->m_lblk + map->m_len - 1);
 
 	if ((rr_cluster_start == ex_cluster_end) ||
 	    (rr_cluster_start == ex_cluster_start)) {
-- 
1.7.3.1

