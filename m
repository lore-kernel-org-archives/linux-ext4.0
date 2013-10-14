From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 05/22] libext2fs: handle inline_data in block iterator
 function
Date: Mon, 14 Oct 2013 10:49:57 +0800
Message-ID: <20131014024957.GB12010@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-6-git-send-email-wenqing.lz@taobao.com>
 <20131013035523.GC28064@thunk.org>
 <20131014004407.GB9609@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36309 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab3JNCsB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Oct 2013 22:48:01 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so6965863pad.9
        for <linux-ext4@vger.kernel.org>; Sun, 13 Oct 2013 19:48:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131014004407.GB9609@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 13, 2013 at 08:44:07PM -0400, Theodore Ts'o wrote:
> On Sat, Oct 12, 2013 at 11:55:23PM -0400, Theodore Ts'o wrote:
> except I wonder if we might be better to
> > have ext2fs_block_iterate3() return an error code if it is called on a
> > file that has inline data.
> 
> Thinking about this some more, I've convinced myself this is what we
> really should do.  So I've added the following to the next branch.

Sorry for my late reply.  Yes, this is better.  I will add this patch
into my inline data patch set.

Thanks,
                                                - Zheng

> 
>        	      	      	   	     - Ted
> 
> commit 9d2244320f9ea94f035c16b1146282c6ecf3a68c
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Sun Oct 13 17:42:25 2013 -0400
> 
>     libext2fs: handle inline_data in block iterator by returning an error code
>     
>     An inode with inline data has no data blocks, so we can not iterate
>     over such an inode.  Return an error code which indicates this fact;
>     callers can use this to determine whether or not the inode has inline
>     data, and then call some routine to iterate over the directory intries
>     in the line data or read the inline data, as appropriate.
>     
>     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
> index b8c6879..601129d 100644
> --- a/lib/ext2fs/block.c
> +++ b/lib/ext2fs/block.c
> @@ -345,6 +345,13 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
>  		return ctx.errcode;
>  
>  	/*
> +	 * An inode with inline data has no blocks over which to
> +	 * iterate, so return an error code indicating this fact.
> +	 */
> +	if (inode.i_flags & EXT4_INLINE_DATA_FL)
> +		return EXT2_ET_INLINE_DATA_CANT_ITERATE;
> +
> +	/*
>  	 * Check to see if we need to limit large files
>  	 */
>  	if (flags & BLOCK_FLAG_NO_LARGE) {
> diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
> index c547a2c..5be1f32 100644
> --- a/lib/ext2fs/ext2_err.et.in
> +++ b/lib/ext2fs/ext2_err.et.in
> @@ -479,4 +479,7 @@ ec	EXT2_ET_FILE_EXISTS,
>  ec	EXT2_ET_BLOCK_BITMAP_CSUM_INVALID,
>  	"Block bitmap checksum does not match bitmap"
>  
> +ec	EXT2_ET_INLINE_DATA_CANT_ITERATE
> +	"Cannot block iterate on an inode containing inline data"
> +
>  	end
