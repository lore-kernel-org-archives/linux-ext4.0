From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] ext4: use more strict checks for inodes_per_block on mount
Date: Thu, 17 Nov 2016 23:26:10 -0500
Message-ID: <20161118042610.13464-3-tytso@mit.edu>
References: <5ce3de05-2f37-6758-1178-ecf520c87d4f@kyup.com>
 <20161118042610.13464-1-tytso@mit.edu>
Cc: kernel@kyup.com, bp@alien8.de, Theodore Ts'o <tytso@mit.edu>,
        stable@vger.kernel.org
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20161118042610.13464-1-tytso@mit.edu>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Centralize the checks for inodes_per_block and be more strict to make
sure the inodes_per_block_group can't end up being zero.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
---
 fs/ext4/super.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3009c03220d6..6638a0415997 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3666,12 +3666,16 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
-	if (EXT4_INODE_SIZE(sb) == 0 || EXT4_INODES_PER_GROUP(sb) == 0)
-		goto cantfind_ext4;
 
 	sbi->s_inodes_per_block = blocksize / EXT4_INODE_SIZE(sb);
 	if (sbi->s_inodes_per_block == 0)
 		goto cantfind_ext4;
+	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
+	    sbi->s_inodes_per_group > blocksize * 8) {
+		ext4_msg(sb, KERN_ERR, "invalid inodes per group: %lu\n",
+			 sbi->s_blocks_per_group);
+		goto failed_mount;
+	}
 	sbi->s_itb_per_group = sbi->s_inodes_per_group /
 					sbi->s_inodes_per_block;
 	sbi->s_desc_per_block = blocksize / EXT4_DESC_SIZE(sb);
@@ -3754,13 +3758,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	sbi->s_cluster_ratio = clustersize / blocksize;
 
-	if (sbi->s_inodes_per_group > blocksize * 8) {
-		ext4_msg(sb, KERN_ERR,
-		       "#inodes per group too big: %lu",
-		       sbi->s_inodes_per_group);
-		goto failed_mount;
-	}
-
 	/* Do we have standard group size of clustersize * 8 blocks ? */
 	if (sbi->s_blocks_per_group == clustersize << 3)
 		set_opt2(sb, STD_GROUP_SIZE);
-- 
2.11.0.rc0.7.gbe5a750
