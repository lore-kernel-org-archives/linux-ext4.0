From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix FLEX_BG and uninit group usage.
Date: Thu, 15 May 2008 11:32:18 -0500
Message-ID: <20080515113218.6bc1dcb1@gara>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1210790832-20680-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20080514140802.5621167d@gara>
	<20080515040658.GA15128@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53914 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754715AbYEOQcX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 May 2008 12:32:23 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4FGWIlW003406
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 12:32:18 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4FGWGv9156414
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 12:32:18 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4FGWGEV006809
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 12:32:16 -0400
In-Reply-To: <20080515040658.GA15128@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 15 May 2008 09:36:58 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> On Wed, May 14, 2008 at 02:08:02PM -0500, Jose R. Santos wrote:
> > On Thu, 15 May 2008 00:17:12 +0530
> > "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > 
> > > With FLEX_BG we allocate block bitmap, inode bitmap, and
> > > inode table outside the group. So when initialzing the
> > > uninit block group we don't need to set bits corresponding
> > > to these meta-data in the bitmaps. Also return the right
> > > number of free blocks when counting the available free
> > > blocks in uninit group.
> > > 
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > ---
> > >  fs/ext4/balloc.c |   15 ++++++++++++++-
> > >  1 files changed, 14 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> > > index 5c80eb5..fb63f01 100644
> > > --- a/fs/ext4/balloc.c
> > > +++ b/fs/ext4/balloc.c
> > > @@ -109,7 +109,14 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
> > > 
> > >  		for (bit = 0; bit < bit_max; bit++)
> > >  			ext4_set_bit(bit, bh->b_data);
> > > -
> > > +		/*
> > > +		 * With FLEX_BG uninit group we have all the
> > > +		 * blocks available for use. So no need
> > > +		 * to set any bits in bitmap
> > > +		 */
> > > +		 if (EXT4_HAS_INCOMPAT_FEATURE(sb,
> > > +					 EXT4_FEATURE_INCOMPAT_FLEX_BG))
> > > +			return free_blocks;
> > >  		start = ext4_group_first_block_no(sb, block_group);
> > > 
> > >  		/* Set bits for block and inode bitmaps, and inode table */
> > > @@ -126,6 +133,12 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
> > >  		 */
> > >  		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
> > >  	}
> > > +	/*
> > > +	 * With FLEX_BG uninit group we have all the
> > > +	 * blocks available for use.
> > > +	 */
> > > +	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
> > > +		return free_blocks;
> > > 
> > >  	return free_blocks - sbi->s_itb_per_group - 2;
> > >  }
> > 
> > This assumes that if the FLEX_BG feature is enable that all block
> > groups have no bitmaps or inode tables (which is wrong).
> > 
> > Something like this (ignore the fact that doesnt handle hi bits) should be better.
> > 
> > 	used_blocks = sbi->s_itb_per_group + 2;
> > 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> > 		ext4_get_group_no_and_offset(sbi, bgd->bg_block_bitmap_lo, tmp, 0);
> > 		if (tmp != block_group)
> > 			used_blocks--;
> > 		ext4_get_group_no_and_offset(sbi, bgd->bg_inode_bitmap_lo, tmp, 0);
> > 		if (tmp != block_group)
> > 			used_blocks--;
> > 		ext4_get_group_no_and_offset(sbi, bgd->bg_inode_table_lo, tmp, 0);
> > 		if (tmp != block_group)
> > 			used_blocks -= sbi->s_itb_per_group;
> > 	}
> > 
> >  	return free_blocks - used_blocks;
> >  }
> 
> But with FLEX_BG won't we mark the group as initialized if we are
> placing the bitmap or inode table in the group ?

The problem is that we define FLEX_BG to mean that bitmpas and inode
tables may not reside in the same block group regardless of whether we
use bg meta-data grouping.  Your patch cover the only the meta-data
grouping case but it may break if someone writes another usage case for
flex_bg.

There was also a bug on your patch since it skipped setting bits at the
end of the bitmap if the blocks within the group were less than
blocksize * 8.

How does the following (untested) patch look to you?

-JRS



With FLEX_BG block bitmaps, inode bitmaps and inode tables
_MAY_ be allocated outside the group.  So, when initializing
the uninit block group, we need to check the location of this
blocks before setting the corresponding bits in the block
bitmap of the newly initialized group.  Also return the right
number of free blocks when counting the available free blocks
in uninit group.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
---

 fs/ext4/balloc.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index da99437..38367f4 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -43,6 +43,44 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 
 }
 
+int ext4_block_in_group(struct super_block *sb, ext4_fsblk_t block,
+			ext4_group_t block_group)
+{
+	ext4_group_t actual_group;
+	ext4_get_group_no_and_offset(sb, block, &actual_group, 0);
+	if (actual_group == block_group)
+		return 1;
+	return 0;
+}
+
+int ext4_group_used_meta_blocks(struct super_block *sb,
+				ext4_group_t block_group)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int used_blocks = sbi->s_itb_per_group + 2;
+
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		struct ext4_group_desc *gdp;
+		struct buffer_head *bh;
+		
+		gdp = ext4_get_group_desc(sb, block_group, &bh);
+
+		if (ext4_block_in_group(sb, ext4_block_bitmap(sb, gdp),
+					block_group))
+			used_blocks--;
+
+		if (ext4_block_in_group(sb, ext4_inode_bitmap(sb, gdp),
+					block_group))
+			used_blocks--;
+
+		if (ext4_block_in_group(sb, ext4_inode_table(sb, gdp),
+					block_group))
+			used_blocks -= sbi->s_itb_per_group;
+
+	}
+
+	return used_blocks;
+}
 /* Initializes an uninitialized block bitmap if given, and returns the
  * number of blocks free in the group. */
 unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
@@ -105,19 +143,33 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 	free_blocks = group_blocks - bit_max;
 
 	if (bh) {
-		ext4_fsblk_t start;
+		ext4_fsblk_t start, tmp;
+		int flex_bg = 0;
 
 		for (bit = 0; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
 
 		start = ext4_group_first_block_no(sb, block_group);
 
+		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					      EXT4_FEATURE_INCOMPAT_FLEX_BG))
+			flex_bg = 1;
+
 		/* Set bits for block and inode bitmaps, and inode table */
-		ext4_set_bit(ext4_block_bitmap(sb, gdp) - start, bh->b_data);
-		ext4_set_bit(ext4_inode_bitmap(sb, gdp) - start, bh->b_data);
-		for (bit = (ext4_inode_table(sb, gdp) - start),
-		     bit_max = bit + sbi->s_itb_per_group; bit < bit_max; bit++)
-			ext4_set_bit(bit, bh->b_data);
+		tmp = ext4_block_bitmap(sb, gdp);
+		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
+			ext4_set_bit(tmp - start, bh->b_data);
+
+		tmp = ext4_inode_bitmap(sb, gdp);
+		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
+			ext4_set_bit(tmp - start, bh->b_data);
+
+		tmp = ext4_inode_table(sb, gdp);
+		if (!flex_bg || ext4_block_in_group(sb, tmp, block_group))
+			for (bit = (tmp - start),
+				     bit_max = bit + sbi->s_itb_per_group;
+			     bit < bit_max; bit++)
+				ext4_set_bit(bit, bh->b_data);
 
 		/*
 		 * Also if the number of blocks within the group is
@@ -127,7 +179,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
 	}
 
-	return free_blocks - sbi->s_itb_per_group - 2;
+	return free_blocks - ext4_group_used_meta_blocks(sb, block_group);
 }
 
 
