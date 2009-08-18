From: Theodore Tso <tytso@mit.edu>
Subject: Re: fsck infinite loop on corrupt ext4 file system
Date: Tue, 18 Aug 2009 12:01:55 -0400
Message-ID: <20090818160155.GC28560@mit.edu>
References: <1250294105.6221.24.camel@bobble.smo.corp.google.com> <1250557822.23227.9.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Frank Mayhar <fmayhar@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:48976 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908AbZHRQCA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Aug 2009 12:02:00 -0400
Content-Disposition: inline
In-Reply-To: <1250557822.23227.9.camel@bobble.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 17, 2009 at 06:10:22PM -0700, Frank Mayhar wrote:
> It's clear that fsck is neither correcting the block groups nor is it
> detecting the bad entries properly (a sanity check might be in order
> here).  It's not even noticing that it's looping, it just keeps failing
> the allocation and retrying.  While it may be that fsck can't recover
> the file system in this case, it should at least notice and abort.
> 
> My thinking is that the location of the inode tables should be invariant
> over the life of the file system.  Certainly there's no place in ext4
> itself that changes those fields (that I can see, anyway).  Why couldn't
> fsck compute the proper values and compare those against what's there?

So there are a couple of things going on here.  The first is that the
code which tries to allocate new inode/block allocation bitmaps or
inode tables wasn't taught that filesystems with the FLEX_BG feature
should have the metadata located at the beginning of the
flex-blockgroup, but if we can't find space for it there (allocating
the inode table is tricky since it requires possibly up to a few
hundred contiguous free blocks), we should try to find the space
anywhere in the filesystem.  If it can't find the space, we should
indeed abort.  Please find attached a patch which should fix e2fsck to
handle this case correctly.  Could you test it and let me know if it
works correctly?

As far as assuming the inode tables are invariant over the life of the
filesystem --- this is normally true, but inode tables can be located
in places other than the default; for example if bad blocks located
where the inode tables should be, then the inode tables can be pushed
to non-standard locations.  So this makes calculating where the inode
table "should" be a little tricky, especially since the contents of
the bad blocks can change after the filesystem is formatted.

In addition, e2fsck tries very hard not to destroy data, and so there
is the question of what to do if there are data blocks located where
the inode table "should" be.  In theory e2fsck should be able to move
the inode data blocks elsewhere, or if there is no space, potentially
the offer to delete a user file to make room for the inode table ---
after all, better sacrifice one or two data files rather than lose
potentially several hundred or thousand files.  But this is a level of
complexity that I never had a chance to add to e2fsck, and in truth
the case where we run into this level of lossage is very rare.

After all, most of the time we have so many copies of the block group
descriptors, and the backup group descripts are rarely written, so
most of the time this level of corruption should be quite rare.
Making e2fsck smarter to deal with the most extreme cases of loss is
therefore desirable, but it's always been a "nice to have".

In any case, with ext4 and the flex_bg feature, the ability to
allocate the inode table anywhere in the filesystem should make the
case where the really complex recovery code even more rarely required.

Please try this patch and see if it fixes things up for you or not.

Thanks!!

						- Ted

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 518c2ff..203468b 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2376,9 +2376,10 @@ static void new_table_block(e2fsck_t ctx, blk_t first_block, int group,
 			    const char *name, int num, blk_t *new_block)
 {
 	ext2_filsys fs = ctx->fs;
+	dgrp_t		last_grp;
 	blk_t		old_block = *new_block;
 	blk_t		last_block;
-	int		i;
+	int		i, is_flexbg, flexbg, flexbg_size;
 	char		*buf;
 	struct problem_context	pctx;
 
@@ -2388,19 +2389,44 @@ static void new_table_block(e2fsck_t ctx, blk_t first_block, int group,
 	pctx.blk = old_block;
 	pctx.str = name;
 
-	last_block = ext2fs_group_last_block(fs, group);
+	/*
+	 * For flex_bg filesystems, first try to allocate the metadata
+	 * within the flex_bg, and if that fails then try finding the
+	 * space anywhere in the filesystem.
+	 */
+	is_flexbg = EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+					      EXT4_FEATURE_INCOMPAT_FLEX_BG);
+	if (is_flexbg) {
+		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
+		flexbg = group / flexbg_size;
+		first_block = ext2fs_group_first_block(fs,
+						       flexbg_size * flexbg);
+		last_grp = group | (flexbg_size - 1);
+		if (last_grp > fs->group_desc_count)
+			last_grp = fs->group_desc_count;
+		last_block = ext2fs_group_last_block(fs, last_grp);
+	} else
+		last_block = ext2fs_group_last_block(fs, group);
 	pctx.errcode = ext2fs_get_free_blocks(fs, first_block, last_block,
-					num, ctx->block_found_map, new_block);
+					      num, ctx->block_found_map,
+					      new_block);
+	if (is_flexbg && (pctx.errcode = EXT2_ET_BLOCK_ALLOC_FAIL))
+		pctx.errcode = ext2fs_get_free_blocks(fs,
+				fs->super->s_first_data_block,
+				fs->super->s_blocks_count,
+				num, ctx->block_found_map, new_block);
 	if (pctx.errcode) {
 		pctx.num = num;
 		fix_problem(ctx, PR_1_RELOC_BLOCK_ALLOCATE, &pctx);
 		ext2fs_unmark_valid(fs);
+		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
 	pctx.errcode = ext2fs_get_mem(fs->blocksize, &buf);
 	if (pctx.errcode) {
 		fix_problem(ctx, PR_1_RELOC_MEMORY_ALLOCATE, &pctx);
 		ext2fs_unmark_valid(fs);
+		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
 	ext2fs_mark_super_dirty(fs);
