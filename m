From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/5] ext4: Find the group descriptors on a 1k-block bigalloc,
 meta_bg filesystem
Date: Thu, 01 May 2014 16:17:27 -0700
Message-ID: <20140501231727.892.45729.stgit@birch.djwong.org>
References: <20140501231720.892.58712.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39886 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaEAXRc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:17:32 -0400
In-Reply-To: <20140501231720.892.58712.stgit@birch.djwong.org>
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
index 6f9e6fa..32967cb 100644
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
 

