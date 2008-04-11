From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [RFC][PATCH 2/2] convert alloc.c to use blk64_t
Date: Fri, 11 Apr 2008 11:55:12 -0500
Message-ID: <20080411115512.02167595@gara.konoha.net>
References: <20080411153616.GB32661@unused.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54519 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760440AbYDKQze (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 12:55:34 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3BGtUh8031114
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 12:55:30 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3BGtUVX241488
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 12:55:30 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3BGtU3q000881
	for <linux-ext4@vger.kernel.org>; Fri, 11 Apr 2008 12:55:30 -0400
In-Reply-To: <20080411153616.GB32661@unused.rdu.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 11 Apr 2008 11:36:16 -0400
Josef Bacik <jbacik@redhat.com> wrote:

> Hello,
> 
> 
> commit 0b80dee54f94f13210ae87a504e3b49d3dc284d4
> Author: Josef Bacik <jbacik@redhat.com>
> Date:   Fri Apr 11 18:23:13 2008 -0400
> 
>     Convert the block alloc functions to be 64bit capable.
>     
>     Signed-off-by: Josef Bacik <jbacik@redhat.com>
> 
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index 65f3ea1..6924457 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -73,10 +73,10 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
>   * Stupid algorithm --- we now just search forward starting from the
>   * goal.  Should put in a smarter one someday....
>   */
> -errcode_t ext2fs_new_block(ext2_filsys fs, blk_t goal,
> -			   ext2fs_block_bitmap map, blk_t *ret)
> +errcode_t ext2fs_new_block64(ext2_filsys fs, blk64_t goal,
> +			     ext2fs_block_bitmap map, blk64_t *ret)

This should be ext2fs_new_blocks2() to make it easier to expand the API
in the future.  Using ext2fs_new_block64_2() just looks weird if we
ever needed to change the ABI requiring a new call.

> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index a60e28b..058dea7 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1385,6 +1385,17 @@ _INLINE_ blk64_t ext2fs_inode_data_blocks64(ext2_filsys fs,
>  	return ret;
>  }
> 
> +/*
> + * Return the s_blocks_count in 64 bit
> + */
> +_INLINE_ blk64_t ext2fs_super_blocks_count(ext2_filsys fs)
> +{
> +	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
> +		return (((blk64_t)fs->super->s_blocks_count << 32) |
> +			fs->super->s_blocks_count);
> +	return fs->super->s_blocks_count;
> +}
> +
>  #undef _INLINE_
>  #endif

Shouldn't this pe bart of your previous patch?


-JRS
