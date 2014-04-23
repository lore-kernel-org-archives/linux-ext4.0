From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] ext4: Find the group descriptors on a 1k-block
 bigalloc,meta_bg filesystem
Date: Tue, 22 Apr 2014 20:30:26 -0700
Message-ID: <20140423033026.GC8434@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50177 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaDWDac (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2014 23:30:32 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a filesystem with a 1k block size, the group descriptors live in
block 2, not block 1.  If the filesystem has bigalloc,meta_bg set,
however, the calculation of the group descriptor table location does
not take this into account and returns the wrong block number.  Fix
the calculation to return the correct value for this case.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/super.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f3c6670..ef78d13 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2404,6 +2404,16 @@ static ext4_fsblk_t descriptor_loc(struct super_block *sb,
 	if (ext4_bg_has_super(sb, bg))
 		has_super = 1;
 
+	/*
+	 * If we have a meta_bg fs with 1k blocks, group 0's GDT is at
+	 * block 2, not 1.  If s_first_data_block == 0 (bigalloc is enabled
+	 * on modern mke2fs or blksize > 1k on older mke2fs) then we must
+	 * compensate.
+	 */
+	if (sb->s_blocksize == 1024 && nr == 0 &&
+	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) == 0)
+		has_super++;
+
 	return (has_super + ext4_group_first_block_no(sb, bg));
 }
 
