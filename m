From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Fix initalization of s_flex_groups
Date: Fri, 11 Sep 2009 16:57:17 -0400
Message-ID: <1252702637-11958-1-git-send-email-tytso@mit.edu>
References: <20090911183540.GB28764@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Damien Guibouret <damien.guibouret@partition-saving.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:54451 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbZIKU5Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Sep 2009 16:57:16 -0400
In-Reply-To: <20090911183540.GB28764@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The s_flex_groups array should have been initialized using atomic_add
to sum up the free counts from the block groups that make up a
flex_bg.  By using atomic_set, the value of the s_flex_groups array
was set to the values of the last block group in the flex_bg.

The impact of this bug is that the block and inode allocation
algorithms might not pick the best flex_bg for new allocation.

Thanks to Damien Guibouret for pointing out this problem!

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/super.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9f6fa3f..04c6933 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1694,12 +1694,12 @@ static int ext4_fill_flex_info(struct super_block *sb)
 		gdp = ext4_get_group_desc(sb, i, NULL);
 
 		flex_group = ext4_flex_group(sbi, i);
-		atomic_set(&sbi->s_flex_groups[flex_group].free_inodes,
-			   ext4_free_inodes_count(sb, gdp));
-		atomic_set(&sbi->s_flex_groups[flex_group].free_blocks,
-			   ext4_free_blks_count(sb, gdp));
-		atomic_set(&sbi->s_flex_groups[flex_group].used_dirs,
-			   ext4_used_dirs_count(sb, gdp));
+		atomic_add(ext4_free_inodes_count(sb, gdp),
+			   &sbi->s_flex_groups[flex_group].free_inodes);
+		atomic_add(ext4_free_blks_count(sb, gdp),
+			   &sbi->s_flex_groups[flex_group].free_blocks);
+		atomic_add(ext4_used_dirs_count(sb, gdp),
+			   &sbi->s_flex_groups[flex_group].used_dirs);
 	}
 
 	return 1;
-- 
1.6.3.2.1.gb9f7d.dirty

