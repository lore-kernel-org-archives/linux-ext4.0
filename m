From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH, e2fsprogs] libext2fs: Add ext2fs_block_iterate3() which has 64-bit support
Date: Fri, 10 Oct 2008 16:43:43 -0400
Message-ID: <E1KoOpr-0003FT-2f@closure.thunk.org>
Cc: linux-ext4@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49755 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758159AbYJJUnp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Oct 2008 16:43:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


There was discussion about how to do 64-bit ABI conversation, and an
assertion that it might be hard to do ext2fs_block_iterate3.  So I
decided give an example of how I believe the most efficient way to do
this sort of thing.

Each interface when coverted over to 64-bit should be its own patch; for
example, this one adds a new 64-bit version of ext2fs_block_iterate3.
The patch simply modified ext2fs_block_iterate2() to be
ext2fs_block_iterate3(), changing types as needed.  

I then created a backwards compatibility function for
ext2fs_block_iterate2() which calls ext2fs_block_iterate3().

Total time to create the initial version of the patch was about 10
minutes.  I then ran it through the (32-bit only) regression test, which
flagged some failures because I didn't quite do the first version of the
patch correctly.  (I started the patch by doing a global search and
replace of blk_t with blk64_t, and that screwed up the code which
depended on the on-disk format of an indirect block really being a
32-bit blk_t.)  Total time for a tested, functional patch was about 30
minutes.

						- Ted

commit 54f130e7623a2a5affb0c27f5f4a42d8ace3acea
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Oct 10 16:36:22 2008 -0400

    libext2fs: Add ext2fs_block_iterate3() which has 64-bit support    
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index b19c450..eafb4cb 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -21,9 +21,9 @@
 struct block_context {
 	ext2_filsys	fs;
 	int (*func)(ext2_filsys	fs,
-		    blk_t	*blocknr,
+		    blk64_t	*blocknr,
 		    e2_blkcnt_t	bcount,
-		    blk_t	ref_blk,
+		    blk64_t	ref_blk,
 		    int		ref_offset,
 		    void	*priv_data);
 	e2_blkcnt_t	bcount;
@@ -62,13 +62,17 @@ static int block_iterate_ind(blk_t *ind_block, blk_t ref_block,
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
 	blk_t	*block_nr;
+	blk64_t	blk64;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
-	    !(ctx->flags & BLOCK_FLAG_DATA_ONLY))
-		ret = (*ctx->func)(ctx->fs, ind_block,
+	    !(ctx->flags & BLOCK_FLAG_DATA_ONLY)) {
+		blk64 = *ind_block;
+		ret = (*ctx->func)(ctx->fs, &blk64,
 				   BLOCK_COUNT_IND, ref_block,
 				   ref_offset, ctx->priv_data);
+		*ind_block = blk64;
+	}
 	check_for_ro_violation_return(ctx, ret);
 	if (!*ind_block || (ret & BLOCK_ABORT)) {
 		ctx->bcount += limit;
@@ -91,9 +95,11 @@ static int block_iterate_ind(blk_t *ind_block, blk_t ref_block,
 	offset = 0;
 	if (ctx->flags & BLOCK_FLAG_APPEND) {
 		for (i = 0; i < limit; i++, ctx->bcount++, block_nr++) {
-			flags = (*ctx->func)(ctx->fs, block_nr, ctx->bcount,
+			blk64 = *block_nr;
+			flags = (*ctx->func)(ctx->fs, &blk64, ctx->bcount,
 					     *ind_block, offset,
 					     ctx->priv_data);
+			*block_nr = blk64;
 			changed	|= flags;
 			if (flags & BLOCK_ABORT) {
 				ret |= BLOCK_ABORT;
@@ -105,9 +111,11 @@ static int block_iterate_ind(blk_t *ind_block, blk_t ref_block,
 		for (i = 0; i < limit; i++, ctx->bcount++, block_nr++) {
 			if (*block_nr == 0)
 				continue;
-			flags = (*ctx->func)(ctx->fs, block_nr, ctx->bcount,
+			blk64 = *block_nr;
+			flags = (*ctx->func)(ctx->fs, &blk64, ctx->bcount,
 					     *ind_block, offset,
 					     ctx->priv_data);
+			*block_nr = blk64;
 			changed	|= flags;
 			if (flags & BLOCK_ABORT) {
 				ret |= BLOCK_ABORT;
@@ -125,10 +133,13 @@ static int block_iterate_ind(blk_t *ind_block, blk_t ref_block,
 	}
 	if ((ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
 	    !(ctx->flags & BLOCK_FLAG_DATA_ONLY) &&
-	    !(ret & BLOCK_ABORT))
-		ret |= (*ctx->func)(ctx->fs, ind_block,
+	    !(ret & BLOCK_ABORT)) {
+		blk64 = *ind_block;
+		ret |= (*ctx->func)(ctx->fs, &blk64,
 				    BLOCK_COUNT_IND, ref_block,
 				    ref_offset, ctx->priv_data);
+		*ind_block = blk64;
+	}
 	check_for_ro_violation_return(ctx, ret);
 	return ret;
 }
@@ -139,13 +150,17 @@ static int block_iterate_dind(blk_t *dind_block, blk_t ref_block,
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
 	blk_t	*block_nr;
+	blk64_t	blk64;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & (BLOCK_FLAG_DEPTH_TRAVERSE |
-			    BLOCK_FLAG_DATA_ONLY)))
-		ret = (*ctx->func)(ctx->fs, dind_block,
+			    BLOCK_FLAG_DATA_ONLY))) {
+		blk64 = *dind_block;
+		ret = (*ctx->func)(ctx->fs, &blk64,
 				   BLOCK_COUNT_DIND, ref_block,
 				   ref_offset, ctx->priv_data);
+		*dind_block = blk64;
+	}
 	check_for_ro_violation_return(ctx, ret);
 	if (!*dind_block || (ret & BLOCK_ABORT)) {
 		ctx->bcount += limit*limit;
@@ -204,10 +219,13 @@ static int block_iterate_dind(blk_t *dind_block, blk_t ref_block,
 	}
 	if ((ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
 	    !(ctx->flags & BLOCK_FLAG_DATA_ONLY) &&
-	    !(ret & BLOCK_ABORT))
-		ret |= (*ctx->func)(ctx->fs, dind_block,
+	    !(ret & BLOCK_ABORT)) {
+		blk64 = *dind_block;
+		ret |= (*ctx->func)(ctx->fs, &blk64,
 				    BLOCK_COUNT_DIND, ref_block,
 				    ref_offset, ctx->priv_data);
+		*dind_block = blk64;
+	}
 	check_for_ro_violation_return(ctx, ret);
 	return ret;
 }
@@ -218,13 +236,17 @@ static int block_iterate_tind(blk_t *tind_block, blk_t ref_block,
 	int	ret = 0, changed = 0;
 	int	i, flags, limit, offset;
 	blk_t	*block_nr;
+	blk64_t	blk64;
 
 	limit = ctx->fs->blocksize >> 2;
 	if (!(ctx->flags & (BLOCK_FLAG_DEPTH_TRAVERSE |
-			    BLOCK_FLAG_DATA_ONLY)))
-		ret = (*ctx->func)(ctx->fs, tind_block,
+			    BLOCK_FLAG_DATA_ONLY))) {
+		blk64 = *tind_block;
+		ret = (*ctx->func)(ctx->fs, &blk64,
 				   BLOCK_COUNT_TIND, ref_block,
 				   ref_offset, ctx->priv_data);
+		*tind_block = blk64;
+	}
 	check_for_ro_violation_return(ctx, ret);
 	if (!*tind_block || (ret & BLOCK_ABORT)) {
 		ctx->bcount += limit*limit*limit;
@@ -283,22 +305,25 @@ static int block_iterate_tind(blk_t *tind_block, blk_t ref_block,
 	}
 	if ((ctx->flags & BLOCK_FLAG_DEPTH_TRAVERSE) &&
 	    !(ctx->flags & BLOCK_FLAG_DATA_ONLY) &&
-	    !(ret & BLOCK_ABORT))
-		ret |= (*ctx->func)(ctx->fs, tind_block,
+	    !(ret & BLOCK_ABORT)) {
+		blk64 = *tind_block;
+		ret |= (*ctx->func)(ctx->fs, &blk64,
 				    BLOCK_COUNT_TIND, ref_block,
 				    ref_offset, ctx->priv_data);
+		*tind_block = blk64;
+	}
 	check_for_ro_violation_return(ctx, ret);
 	return ret;
 }
 
-errcode_t ext2fs_block_iterate2(ext2_filsys fs,
+errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 				ext2_ino_t ino,
 				int	flags,
 				char *block_buf,
 				int (*func)(ext2_filsys fs,
-					    blk_t	*blocknr,
+					    blk64_t	*blocknr,
 					    e2_blkcnt_t	blockcnt,
-					    blk_t	ref_blk,
+					    blk64_t	ref_blk,
 					    int		ref_offset,
 					    void	*priv_data),
 				void *priv_data)
@@ -309,6 +334,7 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 	errcode_t	retval;
 	struct block_context ctx;
 	int	limit;
+	blk64_t	blk64;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
@@ -348,10 +374,11 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 	if ((fs->super->s_creator_os == EXT2_OS_HURD) &&
 	    !(flags & BLOCK_FLAG_DATA_ONLY)) {
 		if (inode.osd1.hurd1.h_i_translator) {
-			ret |= (*ctx.func)(fs,
-					   &inode.osd1.hurd1.h_i_translator,
+			blk64 = inode.osd1.hurd1.h_i_translator;
+			ret |= (*ctx.func)(fs, &blk64,
 					   BLOCK_COUNT_TRANSLATOR,
 					   0, 0, priv_data);
+			inode.osd1.hurd1.h_i_translator = (blk_t) blk64;
 			if (ret & BLOCK_ABORT)
 				goto abort_exit;
 			check_for_ro_violation_goto(&ctx, ret, abort_exit);
@@ -362,7 +389,7 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 		ext2_extent_handle_t	handle;
 		struct ext2fs_extent	extent;
 		e2_blkcnt_t		blockcnt = 0;
-		blk_t			blk, new_blk;
+		blk64_t			blk, new_blk;
 		int			op = EXT2_EXTENT_ROOT;
 		unsigned int		j;
 
@@ -432,7 +459,7 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 					ctx.errcode =
 						ext2fs_extent_set_bmap(handle,
 						       (blk64_t) blockcnt,
-						       (blk64_t) new_blk, 0);
+						       new_blk, 0);
 					if (ctx.errcode)
 						break;
 				}
@@ -452,15 +479,17 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 	 */
 	for (i = 0; i < EXT2_NDIR_BLOCKS ; i++, ctx.bcount++) {
 		if (inode.i_block[i] || (flags & BLOCK_FLAG_APPEND)) {
-			ret |= (*ctx.func)(fs, &inode.i_block[i],
-					    ctx.bcount, 0, i, priv_data);
+			blk64 = inode.i_block[i];
+			ret |= (*ctx.func)(fs, &blk64, ctx.bcount, 0, i, 
+					   priv_data);
+			inode.i_block[i] = (blk_t) blk64;
 			if (ret & BLOCK_ABORT)
 				goto abort_exit;
 		}
 	}
 	check_for_ro_violation_goto(&ctx, ret, abort_exit);
 	if (inode.i_block[EXT2_IND_BLOCK] || (flags & BLOCK_FLAG_APPEND)) {
-		ret |= block_iterate_ind(&inode.i_block[EXT2_IND_BLOCK],
+		ret |= block_iterate_ind(&inode.i_block[EXT2_IND_BLOCK], 
 					 0, EXT2_IND_BLOCK, &ctx);
 		if (ret & BLOCK_ABORT)
 			goto abort_exit;
@@ -497,6 +526,52 @@ errout:
  * Emulate the old ext2fs_block_iterate function!
  */
 
+struct xlate64 {
+	int (*func)(ext2_filsys fs,
+		    blk_t	*blocknr,
+		    e2_blkcnt_t	blockcnt,
+		    blk_t	ref_blk,
+		    int		ref_offset,
+		    void	*priv_data);
+	void *real_private;
+};
+
+static int xlate64_func(ext2_filsys fs, blk64_t	*blocknr,
+			e2_blkcnt_t blockcnt, blk64_t ref_blk,
+			int ref_offset, void *priv_data)
+{
+	struct xlate64 *xl = (struct xlate64 *) priv_data;
+	int		ret;
+	blk_t		block32 = *blocknr;
+	
+	ret = (*xl->func)(fs, &block32, blockcnt, (blk_t) ref_blk, ref_offset,
+			     xl->real_private);
+	*blocknr = block32;
+	return ret;
+}
+
+errcode_t ext2fs_block_iterate2(ext2_filsys fs,
+				ext2_ino_t ino,
+				int	flags,
+				char *block_buf,
+				int (*func)(ext2_filsys fs,
+					    blk_t	*blocknr,
+					    e2_blkcnt_t	blockcnt,
+					    blk_t	ref_blk,
+					    int		ref_offset,
+					    void	*priv_data),
+				void *priv_data)
+{
+	struct xlate64 xl;
+
+	xl.real_private = priv_data;
+	xl.func = func;
+
+	return ext2fs_block_iterate3(fs, ino, flags, block_buf, 
+				     xlate64_func, &xl);
+}
+
+
 struct xlate {
 	int (*func)(ext2_filsys	fs,
 		    blk_t	*blocknr,
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index e02a55f..aa58c23 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -703,6 +703,17 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 					    int		ref_offset,
 					    void	*priv_data),
 				void *priv_data);
+errcode_t ext2fs_block_iterate3(ext2_filsys fs,
+				ext2_ino_t ino,
+				int	flags,
+				char *block_buf,
+				int (*func)(ext2_filsys fs,
+					    blk64_t	*blocknr,
+					    e2_blkcnt_t	blockcnt,
+					    blk64_t	ref_blk,
+					    int		ref_offset,
+					    void	*priv_data),
+				void *priv_data);
 
 /* bmap.c */
 extern errcode_t ext2fs_bmap(ext2_filsys fs, ext2_ino_t ino,
