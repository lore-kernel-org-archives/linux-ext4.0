From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH] ext4: modify block allocation algorithm for the last group
Date: Wed, 13 Feb 2008 17:26:19 +0100
Message-ID: <1202919979.3260.6.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:40744 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbYBMQUv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2008 11:20:51 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Modify the block allocation algorithm for the last group

From: Valerie Clement <valerie.clement@bull.net>

When a directory inode is allocated in the last group and the last group
contains less than s_blocks_per_group blocks, the initial block allocated
for the directory is not always allocated in the same group as the
directory inode, but in one of the first groups of the filesystem (group 1
for example).
Depending on the current process's pid, ext4_find_near() and 
ext4_ext_find_goal() can return a block number greater than the maximum
blocks count in the filesystem and in that case the block will be not
allocated in the same group as the inode.

The following patch fixes the problem.

Comments?
Should the modification also be done in ext2/3 code?

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 fs/ext4/extents.c |    8 +++++++-
 fs/ext4/inode.c   |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5c4af51..1391ded 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -148,6 +148,7 @@ ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	ext4_fsblk_t bg_start;
+	ext4_fsblk_t last_block;
 	ext4_grpblk_t colour;
 	int depth;
 
@@ -169,8 +170,13 @@ ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 	/* OK. use inode's group */
 	bg_start = (ei->i_block_group * EXT4_BLOCKS_PER_GROUP(inode->i_sb)) +
 		le32_to_cpu(EXT4_SB(inode->i_sb)->s_es->s_first_data_block);
-	colour = (current->pid % 16) *
+	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
+
+	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
+		colour = (current->pid % 16) *
 			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
+	else
+		colour = (current->pid % 16) * ((last_block - bg_start) / 16);
 	return bg_start + colour + block;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 51bf3b5..c4f8ace 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -405,6 +405,7 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
 	__le32 *start = ind->bh ? (__le32*) ind->bh->b_data : ei->i_data;
 	__le32 *p;
 	ext4_fsblk_t bg_start;
+	ext4_fsblk_t last_block;
 	ext4_grpblk_t colour;
 
 	/* Try to find previous block */
@@ -422,8 +423,13 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
 	 * into the same cylinder group then.
 	 */
 	bg_start = ext4_group_first_block_no(inode->i_sb, ei->i_block_group);
-	colour = (current->pid % 16) *
+	last_block = ext4_blocks_count(EXT4_SB(inode->i_sb)->s_es) - 1;
+
+	if (bg_start + EXT4_BLOCKS_PER_GROUP(inode->i_sb) <= last_block)
+		colour = (current->pid % 16) *
 			(EXT4_BLOCKS_PER_GROUP(inode->i_sb) / 16);
+	else
+		colour = (current->pid % 16) * ((last_block - bg_start) / 16);
 	return bg_start + colour;
 }
 
