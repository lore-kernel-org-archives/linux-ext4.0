From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Time for "mkdir" on ext3.
Date: Thu, 10 Mar 2011 09:48:38 -0600
Message-ID: <4D78F2D6.7000208@redhat.com>
References: <20110310071119.GF31710@bitwizard.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1CJPsm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Mar 2011 10:48:42 -0500
In-Reply-To: <20110310071119.GF31710@bitwizard.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/10/11 1:11 AM, Rogier Wolff wrote:
> 
> Hi,
> 
> I have an ext3 filesystem. When I "cp -lr" a big tree there, it turns
> out that the "mkdir" calls take the bulk of the time. IIRC there are
> 325000 directories (and 4 million files). Each mkdir call takes about
> 50ms (*), so that accounts for about 4.5 hours of the running time.
> 
> Would ext4 perform significantly better?
> 
> 	Roger.
> 
> (*) I forgot about this Email while it was still in my editor. Now a
> day layter the mkdir calls all take around 17ms, and things run about
> 3x faster. On the other hand it's been running for over 5 hours. And
> yesterday I've seen a streak of >100ms mkdir calls... So apparently
> it depends on "something".... 
> 


There's a pretty pathological case in the directory allocator, where it
scans forward to find a free block group starting at the parent.   For
each new subdir, it re-scans starting at the parent, even if it found
those groups full last time.  I had experimented with an in-memory
"last free group" on each parent, which sped things up after the initial
scan.  That might be what you're seeing...

Here's the patch I had, untested since 2007 - if you're in a testing
mood... of course if it breaks you get to keep the pieces.  :)

-Eric

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 9724aef..2f7be0c 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -242,6 +242,7 @@ static int find_group_dir(struct super_block *sb, struct inode *parent)
 static int find_group_orlov(struct super_block *sb, struct inode *parent)
 {
 	int parent_group = EXT3_I(parent)->i_block_group;
+	unsigned int child_group = EXT3_I(parent)->i_child_block_group;
 	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	struct ext3_super_block *es = sbi->s_es;
 	int ngroups = sbi->s_groups_count;
@@ -269,7 +270,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
 		get_random_bytes(&group, sizeof(group));
 		parent_group = (unsigned)group % ngroups;
 		for (i = 0; i < ngroups; i++) {
-			group = (parent_group + i) % ngroups;
+			group = (child_group + i) % ngroups;
 			desc = ext3_get_group_desc (sb, group, NULL);
 			if (!desc || !desc->bg_free_inodes_count)
 				continue;
@@ -312,6 +313,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
 			continue;
 		if (le16_to_cpu(desc->bg_free_blocks_count) < min_blocks)
 			continue;
+		EXT3_I(parent)->i_child_block_group = group;
 		return group;
 	}
 
@@ -555,6 +557,8 @@ got:
 	ei->i_dtime = 0;
 	ei->i_block_alloc_info = NULL;
 	ei->i_block_group = group;
+	if (S_ISDIR(mode))
+		ei->i_child_block_group = group;
 
 	ext3_set_inode_flags(inode);
 	if (IS_DIRSYNC(inode))
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index ae94f6d..72b0c92 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2888,6 +2888,8 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 	ei->i_disksize = inode->i_size;
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 	ei->i_block_group = iloc.block_group;
+	if (S_ISDIR(inode->i_mode))
+		ei->i_child_block_group = ei->i_block_group;
 	/*
 	 * NOTE! The in-memory inode i_data array is in little-endian order
 	 * even on big-endian machines: we do NOT byteswap the block numbers!
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index f42c098..79f3a72 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -87,6 +87,7 @@ struct ext3_inode_info {
 	 * near to their parent directory's inode.
 	 */
 	__u32	i_block_group;
+	__u32	i_child_block_group;	/* last bg children allocated to */
 	unsigned long	i_state_flags;	/* Dynamic state flags for ext3 */
 
 	/* block reservation info */
