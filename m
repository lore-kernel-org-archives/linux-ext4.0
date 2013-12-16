From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 47/74] resize2fs: during shrink, don't free in-use bg
 data clusters
Date: Mon, 16 Dec 2013 00:01:47 -0500
Message-ID: <20131216050147.GJ28536@thunk.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
 <20131211012333.30655.80931.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40383 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3LPFBt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Dec 2013 00:01:49 -0500
Content-Disposition: inline
In-Reply-To: <20131211012333.30655.80931.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 10, 2013 at 05:23:33PM -0800, Darrick J. Wong wrote:
> When freeing a group's metadata blocks, be careful not to free
> clusters belonging to other groups!
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  resize/resize2fs.c |   78 +++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 49 insertions(+), 29 deletions(-)
> 
> 
> diff --git a/resize/resize2fs.c b/resize/resize2fs.c
> index ff5e6a2..49fe986 100644
> --- a/resize/resize2fs.c
> +++ b/resize/resize2fs.c
> @@ -270,40 +270,60 @@ static void fix_uninit_block_bitmaps(ext2_filsys fs)
>   * release them in the new filesystem data structure, and mark them as
>   * reserved so the old inode table blocks don't get overwritten.
>   */
> -static void free_gdp_blocks(ext2_filsys fs,
> -			    ext2fs_block_bitmap reserve_blocks,
> -			    ext2_filsys old_fs,
> -			    dgrp_t group)
> +static errcode_t free_gdp_blocks(ext2_filsys fs,
> +				 ext2fs_block_bitmap reserve_blocks,
> +				 ext2_filsys old_fs,
> +				 dgrp_t group, dgrp_t count)

This function is only used in one place, and "count" is calculated
using values from fs and old_fs.

	old_fs->group_desc_count - fs->group_desc_count

Wouldn't it be clearer to do this calculation in free_gdp_blocks, i.e:

	dgrp_t count = old_fs->group_desc_count - fs->group_desc_count;

This makes it clearer what's going on, instead of using a generic
parameter name such as "count" which isn't as clear...

	       	       	       	     - Ted
