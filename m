From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH FOR-STABLE-2.6.28 20/24] ext4: Add sanity checks for the superblock before mounting the filesystem
Date: Tue, 17 Feb 2009 10:32:38 -0500
Message-ID: <1234884762-13580-21-git-send-email-tytso@mit.edu>
References: <1234884762-13580-1-git-send-email-tytso@mit.edu>
 <1234884762-13580-2-git-send-email-tytso@mit.edu>
 <1234884762-13580-3-git-send-email-tytso@mit.edu>
 <1234884762-13580-4-git-send-email-tytso@mit.edu>
 <1234884762-13580-5-git-send-email-tytso@mit.edu>
 <1234884762-13580-6-git-send-email-tytso@mit.edu>
 <1234884762-13580-7-git-send-email-tytso@mit.edu>
 <1234884762-13580-8-git-send-email-tytso@mit.edu>
 <1234884762-13580-9-git-send-email-tytso@mit.edu>
 <1234884762-13580-10-git-send-email-tytso@mit.edu>
 <1234884762-13580-11-git-send-email-tytso@mit.edu>
 <1234884762-13580-12-git-send-email-tytso@mit.edu>
 <1234884762-13580-13-git-send-email-tytso@mit.edu>
 <1234884762-13580-14-git-send-email-tytso@mit.edu>
 <1234884762-13580-15-git-send-email-tytso@mit.edu>
 <1234884762-13580-16-git-send-email-tytso@mit.edu>
 <1234884762-13580-17-git-send-email-tytso@mit.edu>
 <1234884762-13580-18-git-send-email-tytso@mit.edu>
 <1234884762-13580-19-git-send-email-tytso@mit.edu>
 <1234884762-13580-20-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Thiemo Nagel <thiemo.nagel@ph.tum.de>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33282 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbZBQQMQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Feb 2009 11:12:16 -0500
In-Reply-To: <1234884762-13580-20-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This avoids insane superblock configurations that could lead to kernel
oops due to null pointer derefences.

http://bugzilla.kernel.org/show_bug.cgi?id=12371

Thanks to David Maciejak at Fortinet's FortiGuard Global Security
Research Team who discovered this bug independently (but at
approximately the same time) as Thiemo Nagel, who submitted the patch.

Signed-off-by: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
(cherry picked from commit 4ec110281379826c5cf6ed14735e47027c3c5765)
---
 fs/ext4/super.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4aa2040..d38e3e1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1869,8 +1869,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	char *cp;
 	int ret = -EINVAL;
 	int blocksize;
-	int db_count;
-	int i;
+	unsigned int db_count;
+	unsigned int i;
 	int needs_recovery, has_huge_files;
 	__le32 features;
 	__u64 blocks_count;
@@ -2153,20 +2153,30 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT4_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext4;
 
-	/* ensure blocks_count calculation below doesn't sign-extend */
-	if (ext4_blocks_count(es) + EXT4_BLOCKS_PER_GROUP(sb) <
-	    le32_to_cpu(es->s_first_data_block) + 1) {
-		printk(KERN_WARNING "EXT4-fs: bad geometry: block count %llu, "
-		       "first data block %u, blocks per group %lu\n",
-			ext4_blocks_count(es),
-			le32_to_cpu(es->s_first_data_block),
-			EXT4_BLOCKS_PER_GROUP(sb));
+        /*
+         * It makes no sense for the first data block to be beyond the end
+         * of the filesystem.
+         */
+        if (le32_to_cpu(es->s_first_data_block) >= ext4_blocks_count(es)) {
+                printk(KERN_WARNING "EXT4-fs: bad geometry: first data"
+		       "block %u is beyond end of filesystem (%llu)\n",
+		       le32_to_cpu(es->s_first_data_block),
+		       ext4_blocks_count(es));
 		goto failed_mount;
 	}
 	blocks_count = (ext4_blocks_count(es) -
 			le32_to_cpu(es->s_first_data_block) +
 			EXT4_BLOCKS_PER_GROUP(sb) - 1);
 	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
+	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
+		printk(KERN_WARNING "EXT4-fs: groups count too large: %u "
+		       "(block count %llu, first data block %u, "
+		       "blocks per group %lu)\n", sbi->s_groups_count,
+		       ext4_blocks_count(es),
+		       le32_to_cpu(es->s_first_data_block),
+		       EXT4_BLOCKS_PER_GROUP(sb));
+		goto failed_mount;
+	}
 	sbi->s_groups_count = blocks_count;
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
 		   EXT4_DESC_PER_BLOCK(sb);
-- 
1.5.6.3

