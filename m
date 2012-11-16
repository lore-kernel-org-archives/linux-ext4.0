From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Thu, 15 Nov 2012 19:54:52 -0700
Message-ID: <D4A8F4D6-0744-41E9-8339-1D0E1271F0E9@dilger.ca>
References: <50A546D8.3020500@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:57725 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2KPCyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Nov 2012 21:54:55 -0500
In-Reply-To: <50A546D8.3020500@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-11-15, at 12:47 PM, Eric Sandeen wrote:
> An index node's logical start (ei_block) should
> match the logical start of the first node (index
> or leaf) below it.  If we find a node whose start
> does not match its parent, fix all of its parents
> accordingly.

Eric,
could you please provide some background on why you were looking at this
and why it is a problem?  I could definitely understand that it would be
a problem if the parent index did not cover the child extent, but if the
parent extent is covering the child and has a "hole" at the start (maybe
due to some extent there being punched out) does this confuse the extent
handling logic in some manner?

I'd imagine that if there is a "hole" in the extent tree that it may get
filled in some time later, so updating one or more parent extents during
e2fsck will just need to be changed again later.  If I miss some obvious
point, then maybe I'll end up a bit more informed from your explanation.

Cheers, Andreas

> If it finds such a problem, we'll see:
> 
> Pass 1: Checking inodes, blocks, and sizes
> Interior extent node level 0 of inode 274258:
> Logical start 3666 does not match logical start 4093 at next level.  Fix<y>?
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> p.s. this works for me, but I am emphatically not an e2fsck
> guru.  Please do review.  :)
> 
> I'm not sure if this should trigger re-traversal of the
> entire extent tree after the fixup?
> 
> diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
> index a4bd956..7ff4021 100644
> --- a/e2fsck/pass1.c
> +++ b/e2fsck/pass1.c
> @@ -1901,7 +1901,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
> 		}
> 
> 		if (problem) {
> -		report_problem:
> +report_problem:
> 			pctx->blk = extent.e_pblk;
> 			pctx->blk2 = extent.e_lblk;
> 			pctx->num = extent.e_len;
> @@ -1927,7 +1927,10 @@ fix_problem_now:
> 		}
> 
> 		if (!is_leaf) {
> +			blk64_t lblk;
> +
> 			blk = extent.e_pblk;
> +			lblk = extent.e_lblk;
> 			pctx->errcode = ext2fs_extent_get(ehandle,
> 						  EXT2_EXTENT_DOWN, &extent);
> 			if (pctx->errcode) {
> @@ -1940,6 +1943,18 @@ fix_problem_now:
> 					goto report_problem;
> 				return;
> 			}
> +			/* The next extent should match this index's logical start */
> +			if (extent.e_lblk != lblk) {
> +				struct ext2_extent_info info;
> +
> +				ext2fs_extent_get_info(ehandle, &info);
> +				pctx->blk = lblk;
> +				pctx->blk2 = extent.e_lblk;
> +				pctx->num = info.curr_level - 1;
> +				problem = PR_1_EXTENT_INDEX_START_INVALID;
> +				if (fix_problem(ctx, problem, pctx))
> +					ext2fs_extent_fix_parents(ehandle);
> +			}
> 			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
> 			if (pctx->errcode)
> 				return;
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index 78b05bb..9d4cd5f 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1000,6 +1000,14 @@ static struct e2fsck_problem problem_table[] = {
> 	     "@i %i does not match.  "),
> 	  PROMPT_FIX, 0 },
> 
> +	/*
> +	 * Interior extent node logical offset doesn't match first node below it
> +	 */
> +	{ PR_1_EXTENT_INDEX_START_INVALID,
> +	  N_("Interior @x node level %N of @i %i:\n"
> +	     "Logical start %b does not match logical start %c at next level.  "),
> +	  PROMPT_FIX, 0 },
> +
> 	/* Pass 1b errors */
> 
> 	/* Pass 1B: Rescan for duplicate/bad blocks */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 5caade4..a57b104 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -586,6 +586,8 @@ struct problem_context {
> /* ea block passes checks, but checksum invalid */
> #define PR_1_EA_BLOCK_ONLY_CSUM_INVALID        0x01006C
> 
> +/* Index start doesn't match start of next extent down */
> +#define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
> 
> /*
> * Pass 1b errors
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 9148d4e..ccd0936 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1157,6 +1157,7 @@ extern errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
> 					struct ext2_extent_info *info);
> extern errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
> 				    blk64_t blk);
> +extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
> 
> /* fileio.c */
> extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
> diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
> index da82a2a..8c3b7b9 100644
> --- a/lib/ext2fs/extent.c
> +++ b/lib/ext2fs/extent.c
> @@ -722,7 +722,7 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
> * Safe to call for any position in node; if not at the first entry,
> * will  simply return.
> */
> -static errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
> +errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
> {
> 	int				retval = 0;
> 	blk64_t				start;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





