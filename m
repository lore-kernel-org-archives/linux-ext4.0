From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 1/6][64-bit] Eliminate erroneous blk_t casts in ext2fs_get_free_blocks2().
Date: Mon, 4 May 2009 02:20:15 -0400
Message-ID: <20090504062015.GC9151@shell>
References: <15553.1241167573@gamaville.dokosmarshall.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Nick Dokos <nicholas.dokos@hp.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:32799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbZEDGUX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 May 2009 02:20:23 -0400
Content-Disposition: inline
In-Reply-To: <15553.1241167573@gamaville.dokosmarshall.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 01, 2009 at 04:46:13AM -0400, Nick Dokos wrote:
> Running e2fsck -n -f <device> on a brand-new, never-mounted 32Tib fs
> was producing checksum errors on half the groups (the lower half)
> before it got to pass1 and block or inode bitmap conflicts on some
> groups in the upper half. The checksum errors were actually caused by
> the conflicts: e2fsck does a sanity check on block allocations, finds
> a conflict, and uses the backup superblock at 32768. But when it does
> that, it assumes the worst: it clears the UNINIT FLAGS and zeroes the
> free inode count for each group, assuming that it will fix them up
> during the run. That triggers the checksum errors (although it's not
> clear to me why only the lower half of the groups get checksum
> errors.)
> 
> dumpe2fs showed that the conflicts were not artifacts of e2fsck
> processing: they existed on disk. In fact, the block bitmap of a group
> conflicted with the inode bitmap of the group fifteen steps further
> along. That smelled like flex_bg, so I remade the fs with flex_bg
> off and then *every* group in the upper half (more precisely, with
> blocks above the 32-bit boundary) had a conflict with itself: the
> block bitmap and inode bitmap were allocated on top of each other.
> That led to ext2fs_get_free_blocks2() which was truncating 64-bit block
> numbers by casting them to blk_t.
> 
> This patch eliminates the casts. The resulting file system is free of
> the conflicts (with or without flex_bg.) However, it does not fsck
> cleanly yet: there are block bitmap differences  in the very last group.
> 
> Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
> ---
>  lib/ext2fs/alloc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index b1d1f9c..9f11673 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -272,8 +272,7 @@ errcode_t ext2fs_get_free_blocks2(ext2_filsys fs, blk64_t start, blk64_t finish,
>  	do {
>  		if (b+num-1 > ext2fs_blocks_count(fs->super))
>  			b = fs->super->s_first_data_block;
> -		if (ext2fs_fast_test_block_bitmap_range2(map, (blk_t) b,
> -							(blk_t) num)) {
> +		if (ext2fs_fast_test_block_bitmap_range2(map, b, num)) {
>  			*ret = b;
>  			return 0;
>  		}
> -- 
> 1.6.0.6

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>

-VAL
