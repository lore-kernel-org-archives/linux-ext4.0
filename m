From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/39] e2fsck: opportunistically recalculate unused inode
 count and inode_uninit after pass 5
Date: Mon, 27 Oct 2014 13:18:38 -0700
Message-ID: <20141027201838.GB10057@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
 <20141025205819.532.37434.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31252 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaJ0USn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Oct 2014 16:18:43 -0400
Content-Disposition: inline
In-Reply-To: <20141025205819.532.37434.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Oct 25, 2014 at 01:58:19PM -0700, Darrick J. Wong wrote:
> At the end of pass5, update the unused inode count to cover any newly
> unused inodes and set inode_uninit if none of the inodes in the group
> are used.  This will save us time on future fsck runs since we don't
> need to scan those inodes any more.
> 
> Since it's not an error for the unused inode count to be smaller than
> necessary, don't bother if the fs is mounted and we're not fixing
> anything else.
> 
> On an aged filesystem that has experienced at least one massive inode
> die-off, this has been shown to reduce future e2fsck times by around
> 10%.  The effect is diluted on less heavily used filesystems.

I didn't notice that ext2fs_set_gdt_csum() quietly takes care of this if the
filesystem's open for writes.  Therefore, I withdraw this patch and apologize
for the noise.

However, the BLOCK_UNINIT piece is still needed, so I'll issue a new patch #19.

--D

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  e2fsck/pass5.c                          |   38 +++++++++++++++++++++++++++++++
>  e2fsck/problem.c                        |    5 ++++
>  e2fsck/problem.h                        |    3 ++
>  tests/f_bad_bbitmap/expect.1            |    3 ++
>  tests/f_bad_bmap_csum/expect.1          |    3 ++
>  tests/f_bad_gdt_csum/expect.1           |    7 +++++-
>  tests/f_bad_ibitmap/expect.1            |    3 ++
>  tests/f_bad_inode_csum/expect.1         |    3 ++
>  tests/f_idata_and_extents/expect.1      |    3 ++
>  tests/f_illitable_flexbg/expect.1       |   12 ++++++++++
>  tests/f_inlinedata_repair/expect.1      |    3 ++
>  tests/f_invalid_extent_symlink/expect.1 |    3 ++
>  tests/f_jnl_64bit/expect.1              |    6 +++++
>  tests/f_super_bad_csum/expect.1         |    8 +++++--
>  tests/f_unused_itable/expect.1          |    6 +++++
>  15 files changed, 103 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index 64fb7fe..1a225fb 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -821,6 +821,44 @@ do_counts:
>  			} else
>  				ext2fs_unmark_valid(fs);
>  		}
> +
> +		/*
> +		 * Opportunistically update the unused inodes count
> +		 * and set inode_uninit so we can skip scanning unused
> +		 * inodes during future fsck runs.  However, it's not
> +		 * an error if the unused inode count is smaller
> +		 * than necessary, so don't bother the user if FS is
> +		 * mounted and we haven't fixed anything else, to
> +		 * minimize unnecessary reboots.
> +		 */
> +		if (((ctx->options & E2F_OPT_NO) ||
> +		     !(ctx->mount_flags & EXT2_MF_MOUNTED) ||
> +		     ext2fs_test_changed(fs)) &&
> +		    ext2fs_has_group_desc_csum(fs) &&
> +		    !ext2fs_bg_flags_test(fs, i, EXT2_BG_INODE_UNINIT)) {
> +			ext2_ino_t start, end, j;
> +
> +			start = (fs->super->s_inodes_per_group * i) + 1;
> +			end = (fs->super->s_inodes_per_group * (i + 1));
> +			pctx.group = i;
> +			pctx.ino = ext2fs_bg_itable_unused(fs, i);
> +			end -= pctx.ino;
> +			for (j = end; j >= start; j--)
> +				if (ext2fs_test_inode_bitmap2(ctx->inode_used_map, j))
> +					break;
> +
> +			pctx.ino2 = fs->super->s_inodes_per_group -
> +						(j - start + 1);
> +			if (pctx.ino != pctx.ino2 &&
> +			    fix_problem(ctx, PR_5_UNUSED_INODES_COUNT_GROUP,
> +					&pctx)) {
> +				if (pctx.ino2 == fs->super->s_inodes_per_group)
> +					ext2fs_bg_flags_set(fs, i,
> +							EXT2_BG_INODE_UNINIT);
> +				ext2fs_bg_itable_unused_set(fs, i, pctx.ino2);
> +				ext2fs_mark_super_dirty(fs);
> +			}
> +		}
>  	}
>  	if (free_inodes != fs->super->s_free_inodes_count) {
>  		pctx.group = -1;
> diff --git a/e2fsck/problem.c b/e2fsck/problem.c
> index a4da64b..9c2b2e6 100644
> --- a/e2fsck/problem.c
> +++ b/e2fsck/problem.c
> @@ -1899,6 +1899,11 @@ static struct e2fsck_problem problem_table[] = {
>  	  N_("@g %g @b @B does not match checksum.\n"),
>  	  PROMPT_FIX, PR_LATCH_BBITMAP | PR_PREEN_OK },
>  
> +	/* Unused inode count for group wrong */
> +	{ PR_5_UNUSED_INODES_COUNT_GROUP,
> +	  N_("Unused @i count wrong for @g #%g (%i, counted=%j).\n"),
> +	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
> +
>  	/* Post-Pass 5 errors */
>  
>  	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
> diff --git a/e2fsck/problem.h b/e2fsck/problem.h
> index 3c28166..6a71fc8 100644
> --- a/e2fsck/problem.h
> +++ b/e2fsck/problem.h
> @@ -1139,6 +1139,9 @@ struct problem_context {
>  /* Block bitmap checksum does not match */
>  #define PR_5_BLOCK_BITMAP_CSUM_INVALID	0x05001B
>  
> +/* Unused inode count for group wrong */
> +#define PR_5_UNUSED_INODES_COUNT_GROUP	0x05001C
> +
>  /*
>   * Post-Pass 5 errors
>   */
> diff --git a/tests/f_bad_bbitmap/expect.1 b/tests/f_bad_bbitmap/expect.1
> index 71ad1bb..af3f632 100644
> --- a/tests/f_bad_bbitmap/expect.1
> +++ b/tests/f_bad_bbitmap/expect.1
> @@ -9,6 +9,9 @@ Pass 5: Checking group summary information
>  Block bitmap differences:  -(8--10) -(12--17) -(19--31)
>  Fix? yes
>  
> +Unused inode count wrong for group #0 (0, counted=117).
> +Fix? yes
> +
>  
>  test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
>  test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
> diff --git a/tests/f_bad_bmap_csum/expect.1 b/tests/f_bad_bmap_csum/expect.1
> index ca8f77f..7616751 100644
> --- a/tests/f_bad_bmap_csum/expect.1
> +++ b/tests/f_bad_bmap_csum/expect.1
> @@ -6,6 +6,9 @@ Pass 2: Checking directory structure
>  Pass 3: Checking directory connectivity
>  Pass 4: Checking reference counts
>  Pass 5: Checking group summary information
> +Unused inode count wrong for group #0 (0, counted=117).
> +Fix? yes
> +
>  Inode bitmap differences: Group 0 inode bitmap does not match checksum.
>  FIXED.
>  Block bitmap differences: Group 0 block bitmap does not match checksum.
> diff --git a/tests/f_bad_gdt_csum/expect.1 b/tests/f_bad_gdt_csum/expect.1
> index e14c897..0f496e0 100644
> --- a/tests/f_bad_gdt_csum/expect.1
> +++ b/tests/f_bad_gdt_csum/expect.1
> @@ -6,5 +6,10 @@ Pass 2: Checking directory structure
>  Pass 3: Checking directory connectivity
>  Pass 4: Checking reference counts
>  Pass 5: Checking group summary information
> +Unused inode count wrong for group #0 (0, counted=117).
> +Fix? yes
> +
> +
> +test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
>  test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
> -Exit status is 0
> +Exit status is 1
> diff --git a/tests/f_bad_ibitmap/expect.1 b/tests/f_bad_ibitmap/expect.1
> index ea17523..81689e0 100644
> --- a/tests/f_bad_ibitmap/expect.1
> +++ b/tests/f_bad_ibitmap/expect.1
> @@ -9,6 +9,9 @@ Pass 5: Checking group summary information
>  Inode bitmap differences:  -(12--32)
>  Fix? yes
>  
> +Unused inode count wrong for group #0 (0, counted=117).
> +Fix? yes
> +
>  
>  test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
>  test_filesys: 11/128 files (0.0% non-contiguous), 18/512 blocks
> diff --git a/tests/f_bad_inode_csum/expect.1 b/tests/f_bad_inode_csum/expect.1
> index b3c628d..b28a349 100644
> --- a/tests/f_bad_inode_csum/expect.1
> +++ b/tests/f_bad_inode_csum/expect.1
> @@ -117,6 +117,9 @@ Fix? yes
>  Free inodes count wrong for group #0 (0, counted=32).
>  Fix? yes
>  
> +Unused inode count wrong for group #0 (0, counted=32).
> +Fix? yes
> +
>  Free inodes count wrong (0, counted=32).
>  Fix? yes
>  
> diff --git a/tests/f_idata_and_extents/expect.1 b/tests/f_idata_and_extents/expect.1
> index 7f7fbf3..aba063a 100644
> --- a/tests/f_idata_and_extents/expect.1
> +++ b/tests/f_idata_and_extents/expect.1
> @@ -26,6 +26,9 @@ Fix? yes
>  Free inodes count wrong for group #0 (105, counted=106).
>  Fix? yes
>  
> +Unused inode count wrong for group #0 (103, counted=105).
> +Fix? yes
> +
>  Free inodes count wrong (105, counted=106).
>  Fix? yes
>  
> diff --git a/tests/f_illitable_flexbg/expect.1 b/tests/f_illitable_flexbg/expect.1
> index fa42a0f..04ce65b 100644
> --- a/tests/f_illitable_flexbg/expect.1
> +++ b/tests/f_illitable_flexbg/expect.1
> @@ -18,6 +18,18 @@ Pass 5: Checking group summary information
>  Inode bitmap differences:  -(65--128)
>  Fix? yes
>  
> +Unused inode count wrong for group #0 (0, counted=52).
> +Fix? yes
> +
> +Unused inode count wrong for group #1 (0, counted=64).
> +Fix? yes
> +
> +Unused inode count wrong for group #2 (0, counted=64).
> +Fix? yes
> +
> +Unused inode count wrong for group #3 (0, counted=64).
> +Fix? yes
> +
>  
>  test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
>  test_filesys: 12/256 files (0.0% non-contiguous), 31163/32768 blocks
> diff --git a/tests/f_inlinedata_repair/expect.1 b/tests/f_inlinedata_repair/expect.1
> index faba192..f7eebd3 100644
> --- a/tests/f_inlinedata_repair/expect.1
> +++ b/tests/f_inlinedata_repair/expect.1
> @@ -69,6 +69,9 @@ Pass 5: Checking group summary information
>  Directories count wrong for group #0 (7, counted=8).
>  Fix? yes
>  
> +Unused inode count wrong for group #0 (90, counted=91).
> +Fix? yes
> +
>  
>  test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
>  test_filesys: 28/128 files (0.0% non-contiguous), 18/512 blocks
> diff --git a/tests/f_invalid_extent_symlink/expect.1 b/tests/f_invalid_extent_symlink/expect.1
> index 7bda0b7..cbb2ac5 100644
> --- a/tests/f_invalid_extent_symlink/expect.1
> +++ b/tests/f_invalid_extent_symlink/expect.1
> @@ -6,6 +6,9 @@ Clear? yes
>  Pass 3: Checking directory connectivity
>  Pass 4: Checking reference counts
>  Pass 5: Checking group summary information
> +Unused inode count wrong for group #0 (4, counted=5).
> +Fix? yes
> +
>  
>  test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
>  test_filesys: 11/16 files (9.1% non-contiguous), 21/100 blocks
> diff --git a/tests/f_jnl_64bit/expect.1 b/tests/f_jnl_64bit/expect.1
> index e360e2f..915076b 100644
> --- a/tests/f_jnl_64bit/expect.1
> +++ b/tests/f_jnl_64bit/expect.1
> @@ -7,6 +7,12 @@ Pass 5: Checking group summary information
>  Free blocks count wrong (14059, counted=12712).
>  Fix? yes
>  
> +Unused inode count wrong for group #0 (0, counted=2876).
> +Fix? yes
> +
> +Unused inode count wrong for group #1 (1395, counted=3958).
> +Fix? yes
> +
>  Free inodes count wrong (8181, counted=6834).
>  Fix? yes
>  
> diff --git a/tests/f_super_bad_csum/expect.1 b/tests/f_super_bad_csum/expect.1
> index 25ced5c..a606fab 100644
> --- a/tests/f_super_bad_csum/expect.1
> +++ b/tests/f_super_bad_csum/expect.1
> @@ -5,8 +5,12 @@ Pass 2: Checking directory structure
>  Pass 3: Checking directory connectivity
>  Pass 4: Checking reference counts
>  Pass 5: Checking group summary information
> -Inode bitmap differences: Group 1 inode bitmap does not match checksum.
> -FIXED.
> +Unused inode count wrong for group #0 (0, counted=501).
> +Fix? yes
> +
> +Unused inode count wrong for group #1 (0, counted=512).
> +Fix? yes
> +
>  
>  test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
>  test_filesys: 11/1024 files (0.0% non-contiguous), 1557/16384 blocks
> diff --git a/tests/f_unused_itable/expect.1 b/tests/f_unused_itable/expect.1
> index a4da987..fbc6538 100644
> --- a/tests/f_unused_itable/expect.1
> +++ b/tests/f_unused_itable/expect.1
> @@ -19,9 +19,15 @@ Pass 5: Checking group summary information
>  Free inodes count wrong for group #0 (53, counted=51).
>  Fix? yes
>  
> +Unused inode count wrong for group #0 (0, counted=51).
> +Fix? yes
> +
>  Free inodes count wrong for group #1 (64, counted=58).
>  Fix? yes
>  
> +Unused inode count wrong for group #1 (0, counted=58).
> +Fix? yes
> +
>  
>  test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
>  test_filesys: 19/128 files (0.0% non-contiguous), 165/1000 blocks
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
