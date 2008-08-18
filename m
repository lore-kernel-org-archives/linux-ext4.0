From: Jan Kara <jack@suse.cz>
Subject: Re: [Bugme-new] [Bug 11266] New: unable to handle kernel paging request in ext2_free_blocks
Date: Mon, 18 Aug 2008 16:58:41 +0200
Message-ID: <20080818145841.GC10621@atrey.karlin.mff.cuni.cz>
References: <bug-11266-10286@http.bugzilla.kernel.org/> <0K5800031SEDU2@smtp02.hut-mail> <20080807200717.GB26307@lh.kyla.fi> <20080807202840.GC26307@lh.kyla.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	bugme-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Sami Liedes <sliedes@cc.hut.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37087 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbYHRO6m (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 10:58:42 -0400
Content-Disposition: inline
In-Reply-To: <20080807202840.GC26307@lh.kyla.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> On Thu, Aug 07, 2008 at 11:07:17PM +0300, Sami Liedes wrote:
> > On Thu, Aug 07, 2008 at 10:52:51AM -0700, Andrew Morton wrote:
> > > Yes, please do test 2.6.26.
> > 
> > Did that. I can reproduce the same crash on 2.6.26 and 2.6.26.2.
> 
> 2.6.25.15 crashes too, so I might have been wrong about 2.6.25.4
> working (unless something changed between those two versions).
  I think this is the same problem Vegard reported in
http://marc.info/?l=linux-ext4&m=121637999611618&w=2.
  The problem seems to be in ext2_valid_block_bitmap() which does

  bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
  offset = bitmap_blk - group_first_block;
  if (!ext2_test_bit(offset, bh->b_data))

  (and similarly for inode bitmap). Now when the group descriptor is
corrupted, this simply accesses beyond the bh->b_data...
  The patch below should hopefully fix the issue. Can you test it
please?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
---

>From 06953717138efe3ad535e78343beb7204ac0d274 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 18 Aug 2008 16:45:11 +0200
Subject: [PATCH] ext2: Check for corrupted group descriptor before using data in it

We have to check whether a group descriptor isn't corrupted in
read_block_bitmap(). Otherwise ext2_valid_block_bitmap() will try
to access bits outside of bitmap and Oops happens.

CC: Vegard Nossum <vegard.nossum@gmail.com>
CC: Sami Liedes <sliedes@cc.hut.fi>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/balloc.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index 10bb02c..9104712 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -113,6 +113,17 @@ err_out:
 	return 0;
 }
 
+static int ext2_block_in_group(struct super_block *sb,
+			unsigned int block_group, ext2_fsblk_t block)
+{
+	if (block < ext2_group_first_block_no(sb, block_group))
+		return 0;
+	if (block >= ext2_group_first_block_no(sb, block_group) +
+	    EXT2_BLOCKS_PER_GROUP(sb))
+		return 0;
+	return 1;
+}
+
 /*
  * Read the bitmap for a given block_group,and validate the
  * bits for block/inode/inode tables are set in the bitmaps
@@ -129,6 +140,24 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	desc = ext2_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		return NULL;
+	if (!ext2_block_in_group(sb, block_group,
+				le32_to_cpu(desc->bg_block_bitmap)) ||
+	    !ext2_block_in_group(sb, block_group,
+				le32_to_cpu(desc->bg_inode_bitmap)) ||
+	    !ext2_block_in_group(sb, block_group,
+				le32_to_cpu(desc->bg_inode_table)) ||
+	    !ext2_block_in_group(sb, block_group,
+				le32_to_cpu(desc->bg_inode_table) +
+				EXT2_SB(sb)->s_itb_per_group - 1)) {
+		ext2_error(sb, __func__, "Corrupted group descriptor - "
+				"block_group = %u, block_bitmap = %u, "
+				"inode_bitmap = %u, inode_table = %u",
+				block_group,
+				le32_to_cpu(desc->bg_block_bitmap),
+				le32_to_cpu(desc->bg_inode_bitmap),
+				le32_to_cpu(desc->bg_inode_table));
+		return NULL;
+	}
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
-- 
1.5.2.4

