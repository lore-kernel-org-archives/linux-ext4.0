From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 47/74] resize2fs: during shrink, don't free in-use bg
 data clusters
Date: Mon, 16 Dec 2013 12:10:56 -0800
Message-ID: <20131216201056.GI10143@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012333.30655.80931.stgit@birch.djwong.org>
 <20131216050147.GJ28536@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49410 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3LPULB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Dec 2013 15:11:01 -0500
Content-Disposition: inline
In-Reply-To: <20131216050147.GJ28536@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 16, 2013 at 12:01:47AM -0500, Theodore Ts'o wrote:
> On Tue, Dec 10, 2013 at 05:23:33PM -0800, Darrick J. Wong wrote:
> > When freeing a group's metadata blocks, be careful not to free
> > clusters belonging to other groups!
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  resize/resize2fs.c |   78 +++++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 49 insertions(+), 29 deletions(-)
> > 
> > 
> > diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> > index ff5e6a2..49fe986 100644
> > --- a/resize/resize2fs.c
> > +++ b/resize/resize2fs.c
> > @@ -270,40 +270,60 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
> >   * release them in the new filesystem data structure, and mark them as
> >   * reserved so the old inode table blocks don't get overwritten.
> >   */
> > -static void free_gdp_blocks(ext2_filsys fs,
> > -			    ext2fs_block_bitmap reserve_blocks,
> > -			    ext2_filsys old_fs,
> > -			    dgrp_t group)
> > +static errcode_t free_gdp_blocks(ext2_filsys fs,
> > +				 ext2fs_block_bitmap reserve_blocks,
> > +				 ext2_filsys old_fs,
> > +				 dgrp_t group, dgrp_t count)
> 
> This function is only used in one place, and "count" is calculated
> using values from fs and old_fs.
> 
> 	old_fs->group_desc_count - fs->group_desc_count
> 
> Wouldn't it be clearer to do this calculation in free_gdp_blocks, i.e:
> 
> 	dgrp_t count = old_fs->group_desc_count - fs->group_desc_count;
> 
> This makes it clearer what's going on, instead of using a generic
> parameter name such as "count" which isn't as clear...

Yep, that makes sense.  How about something like this?

---
resize2fs: during shrink, don't free in-use bg data clusters

When freeing a group's metadata blocks, be careful not to free
clusters belonging to other groups!

v2: Remove unnecessary parameters, per Ted's suggestion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |   77 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 48 insertions(+), 29 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index ff5e6a2..fce5a70 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -270,40 +270,61 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
  * release them in the new filesystem data structure, and mark them as
  * reserved so the old inode table blocks don't get overwritten.
  */
-static void free_gdp_blocks(ext2_filsys fs,
-			    ext2fs_block_bitmap reserve_blocks,
-			    ext2_filsys old_fs,
-			    dgrp_t group)
+static errcode_t free_gdp_blocks(ext2_filsys fs,
+				 ext2fs_block_bitmap reserve_blocks,
+				 ext2_filsys old_fs,
+				 dgrp_t group)
 {
 	blk64_t	blk;
 	int	j;
+	dgrp_t	i;
+	ext2fs_block_bitmap bg_map = NULL;
+	errcode_t retval = 0;
+	dgrp_t count = old_fs->group_desc_count - fs->group_desc_count;
+
+	/* If bigalloc, don't free metadata living in the same cluster */
+	if (EXT2FS_CLUSTER_RATIO(fs) > 1) {
+		retval = ext2fs_allocate_block_bitmap(fs, "bgdata", &bg_map);
+		if (retval)
+			goto out;
 
-	blk = ext2fs_block_bitmap_loc(old_fs, group);
-	if (blk &&
-	    (blk < ext2fs_blocks_count(fs->super))) {
-		ext2fs_block_alloc_stats2(fs, blk, -1);
-		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		retval = mark_table_blocks(fs, bg_map);
+		if (retval)
+			goto out;
 	}
 
-	blk = ext2fs_inode_bitmap_loc(old_fs, group);
-	if (blk &&
-	    (blk < ext2fs_blocks_count(fs->super))) {
-		ext2fs_block_alloc_stats2(fs, blk, -1);
-		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
-	}
+	for (i = group; i < group + count; i++) {
+		blk = ext2fs_block_bitmap_loc(old_fs, i);
+		if (blk &&
+		    (blk < ext2fs_blocks_count(fs->super)) &&
+		    !(bg_map && ext2fs_test_block_bitmap2(bg_map, blk))) {
+			ext2fs_block_alloc_stats2(fs, blk, -1);
+			ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		}
 
-	blk = ext2fs_inode_table_loc(old_fs, group);
-	if (blk == 0 ||
-	    (blk >= ext2fs_blocks_count(fs->super)))
-		return;
+		blk = ext2fs_inode_bitmap_loc(old_fs, i);
+		if (blk &&
+		    (blk < ext2fs_blocks_count(fs->super)) &&
+		    !(bg_map && ext2fs_test_block_bitmap2(bg_map, blk))) {
+			ext2fs_block_alloc_stats2(fs, blk, -1);
+			ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		}
 
-	for (j = 0;
-	     j < fs->inode_blocks_per_group; j++, blk++) {
-		if (blk >= ext2fs_blocks_count(fs->super))
-			break;
-		ext2fs_block_alloc_stats2(fs, blk, -1);
-		ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		blk = ext2fs_inode_table_loc(old_fs, i);
+		for (j = 0;
+		     j < fs->inode_blocks_per_group; j++, blk++) {
+			if (blk >= ext2fs_blocks_count(fs->super) ||
+			    (bg_map && ext2fs_test_block_bitmap2(bg_map, blk)))
+				continue;
+			ext2fs_block_alloc_stats2(fs, blk, -1);
+			ext2fs_mark_block_bitmap2(reserve_blocks, blk);
+		}
 	}
+
+out:
+	if (bg_map)
+		ext2fs_free_block_bitmap(bg_map);
+	return retval;
 }
 
 /*
@@ -467,10 +488,8 @@ retry:
 		 * Check the block groups that we are chopping off
 		 * and free any blocks associated with their metadata
 		 */
-		for (i = fs->group_desc_count;
-		     i < old_fs->group_desc_count; i++)
-			free_gdp_blocks(fs, reserve_blocks, old_fs, i);
-		retval = 0;
+		retval = free_gdp_blocks(fs, reserve_blocks, old_fs,
+					 fs->group_desc_count);
 		goto errout;
 	}
 
