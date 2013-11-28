From: Jan Kara <jack@suse.cz>
Subject: [PATCH] ext4: Do not reserve clusters when fs doesn't support extents
Date: Thu, 28 Nov 2013 12:42:45 +0100
Message-ID: <1385638965-14674-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561Ab3K1Lm7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Nov 2013 06:42:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When filesystem doesn't support extents (like in ext2/3 compatibility
modes), there is no need to reserve any clusters. Space estimates for
writing are exact, hole punching doesn't need new metadata, and there
are no unwritten extents to convert.

This fixes a problem when filesystem still having some free space when
accessed with a native ext2/3 driver suddently reports ENOSPC when
accessed with ext4 driver.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c977f4e4e63b..0561713cd6d8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3316,11 +3316,19 @@ int ext4_calculate_overhead(struct super_block *sb)
 }
 
 
-static ext4_fsblk_t ext4_calculate_resv_clusters(struct ext4_sb_info *sbi)
+static ext4_fsblk_t ext4_calculate_resv_clusters(struct super_block *sb)
 {
 	ext4_fsblk_t resv_clusters;
 
 	/*
+	 * There's no need to reserve anything when we aren't using extents.
+	 * The space estimates are exact, there are no unwritten extents,
+	 * hole punching doesn't need new metadata... This is needed especially
+	 * to keep ext2/3 backward compatibility.
+	 */
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS))
+		return 0;
+	/*
 	 * By default we reserve 2% or 4096 clusters, whichever is smaller.
 	 * This should cover the situations where we can not afford to run
 	 * out of space like for example punch hole, or converting
@@ -3328,7 +3336,8 @@ static ext4_fsblk_t ext4_calculate_resv_clusters(struct ext4_sb_info *sbi)
 	 * allocation would require 1, or 2 blocks, higher numbers are
 	 * very rare.
 	 */
-	resv_clusters = ext4_blocks_count(sbi->s_es) >> sbi->s_cluster_bits;
+	resv_clusters = ext4_blocks_count(EXT4_SB(sb)->s_es) >>
+			EXT4_SB(sb)->s_cluster_bits;
 
 	do_div(resv_clusters, 50);
 	resv_clusters = min_t(ext4_fsblk_t, resv_clusters, 4096);
@@ -4071,10 +4080,10 @@ no_journal:
 			 "available");
 	}
 
-	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sbi));
+	err = ext4_reserve_clusters(sbi, ext4_calculate_resv_clusters(sb));
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to reserve %llu clusters for "
-			 "reserved pool", ext4_calculate_resv_clusters(sbi));
+			 "reserved pool", ext4_calculate_resv_clusters(sb));
 		goto failed_mount4a;
 	}
 
-- 
1.8.1.4

