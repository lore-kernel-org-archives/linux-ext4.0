Received: from omta003.cacentral1.a.cloudfilter.net (omta001.cacentral1.a.cloudfilter.net [3.97.99.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11031F91F6
	for <linux-ext4@vger.kernel.org>; Fri,  3 Jul 2026 23:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.97.99.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783121523; cv=none; b=FHJJqD9RMlBrxRqSeKStfz/8NHbhWkNJtpxfe19YG8wl79BWj2y0Vq5FdG/OzcQHHTaJOemg1EDAwkICYxU3+blVspM1xKq9ec6m0NVxPAACz/uqd9S6wnqXLsHiW0O2pNziNXhnWBQ4+vNkwZghF4cqIaK/z8FNBcoqZn8fmUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783121523; c=relaxed/simple;
	bh=7mlAtpFW4hDGrlFMwGeFUZ3koOA78cC0FMAw8+GRFhk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TL3ydis+QxNl10auLfoHX7te4WB9TyYCQkakW7Nzo0V1/AIsu/0el478h+WgS6mt/aYNFREZs1h/k8jBV6+bpWv5+3wpD/L7RfsOHzEIMJm46q+Zu7DMGHTIf7e8A3h3YI6lpWqT4MYWAaSyYPgq8zsTRAs18Jalnm9TILW91YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca; spf=pass smtp.mailfrom=dilger.ca; arc=none smtp.client-ip=3.97.99.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dilger.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dilger.ca
Received: from shw-obgw-4002b.ext.cloudfilter.net ([10.228.9.233])
	by cmsmtp with ESMTPS
	id fdeVwBPcvYhkUfnKywrYa6; Fri, 03 Jul 2026 23:30:24 +0000
Received: from cabot.adilger.int ([70.77.200.158])
	by cmsmtp with ESMTP
	id fnKxw5uqbDkZufnKxweBzc; Fri, 03 Jul 2026 23:30:24 +0000
X-Authority-Analysis: v=2.4 cv=IP4PywvG c=1 sm=1 tr=0 ts=6a484610
 a=0Thh8+fbYSyN3T2vM72L7A==:117 a=0Thh8+fbYSyN3T2vM72L7A==:17 a=RPJ6JBhKAAAA:8
 a=NQubAXW-KNysZy_nRmAA:9 a=fa_un-3J20JGBB2Tu-mn:22
From: Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH v2 1/2] e2fsck: limit blocks_per_group in get_backup_sb()
Date: Fri,  3 Jul 2026 17:29:32 -0600
Message-ID: <20260703233023.666459-1-adilger@dilger.ca>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfDVWDEuGwbTGDYL8/RqToP3l41BQ6JPfl7RIONu9YjZFZlgSOBBLCxOm1mnmff1JRXkQV+uOjqonRN5i7g+/RPi7dWJygazCoFbOX9ftxnjRIYCHhzDO
 IgEeYorVhd/+bfnIvQ3QS/k37kWhLyGblzKAbZm7IwXkia/2KtozJtBe18hnpK7nQfmkawjLLOOuZbpNhiQG8D/gQvk8ENcbyX2prmFLPH4IxPqxgmnwklCM
 hBd7VX0hA9Zs65adiVC+4A==

When e2fsck calls get_backup_sb() to scanning for backup superblocks
with large block sizes, it should limit the number of blocks per group
estimate of (blocksize * 8), otherwise it misses backup superblocks.

The bpg = (blocksize * 8) guess works for blocksize <= 4096, but with
large blocks this is limited by the __u16 bg_free_blocks_count field,
so at most any group will have ((1 << 16) - 8) = 65528 blocks.

Fixes: f7ef5f3e35 ("e2fsck: check all sparse_super backups")
Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/util.c        | 11 +++++++++--
 lib/ext2fs/ext2_fs.h |  6 +++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/e2fsck/util.c b/e2fsck/util.c
index 7c17a3bad8..54b58369c6 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -562,13 +562,18 @@ blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
 	void			*buf = NULL;
 	unsigned int		blocksize = EXT2_MIN_BLOCK_SIZE;
 	int			blocksize_known = 0;
-	blk_t			bpg = 0;
+	blk_t			bpg = 0, bpg_max;
 	blk64_t			ret_sb = 8193;
 
 	if (fs && fs->super) {
 		blocksize = fs->blocksize;
 		blocksize_known = 1;
 		bpg = fs->super->s_blocks_per_group;
+		bpg_max = EXT2_MAX_BLOCKS_PER_GROUP(fs->super);
+		if (bpg > bpg_max)
+			bpg = 0;
+	} else {
+		bpg_max = EXT2_MAX_CLUSTERS_PER_GROUP(NULL);
 	}
 
 	if (ctx && ctx->blocksize) {
@@ -588,10 +593,12 @@ blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
 
 	for (; blocksize <= EXT2_MAX_BLOCK_SIZE; blocksize *= 2) {
 		dgrp_t grp, three = 1, five = 5, seven = 7;
-		dgrp_t limit;
 		blk_t this_bpg = bpg ? bpg : blocksize * 8;
+		dgrp_t limit;
 		blk64_t	num_blocks;
 
+		if (this_bpg > bpg_max)
+			this_bpg = bpg_max;
 		if (fs && fs->super) {
 			limit = ext2fs_blocks_count(fs->super) / this_bpg;
 		} else if (ctx && ext2fs_get_device_size2(ctx->filesystem_name,
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index fcd4205566..b1b0c179f3 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -287,11 +287,11 @@ struct ext2_dx_tail {
 #define EXT2_INODES_PER_GROUP(s)	(EXT2_SB(s)->s_inodes_per_group)
 #define EXT2_CLUSTERS_PER_GROUP(s)	(EXT2_SB(s)->s_clusters_per_group)
 #define EXT2_INODES_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s)/EXT2_INODE_SIZE(s))
-/* limits imposed by 16-bit value gd_free_{blocks,inode}_count */
-#define EXT2_MAX_BLOCKS_PER_GROUP(s)	((((unsigned) 1 << 16) - 8) *	\
+/* limits imposed by 16-bit value bg_free_{blocks,inode}_count */
+#define EXT2_MAX_CLUSTERS_PER_GROUP(s)	(((unsigned) 1 << 16) - 8)
+#define EXT2_MAX_BLOCKS_PER_GROUP(s)	(EXT2_MAX_CLUSTERS_PER_GROUP(super) * \
 					 (EXT2_CLUSTER_SIZE(s) / \
 					  EXT2_BLOCK_SIZE(s)))
-#define EXT2_MAX_CLUSTERS_PER_GROUP(s)	(((unsigned) 1 << 16) - 8)
 #define EXT2_MAX_INODES_PER_GROUP(s)	(((unsigned) 1 << 16) - \
 					 EXT2_INODES_PER_BLOCK(s))
 #ifdef __KERNEL__
-- 
2.52.0

