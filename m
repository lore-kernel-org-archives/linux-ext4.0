From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 05/22] libext2fs: handle inline_data in block iterator
 function
Date: Sat, 12 Oct 2013 23:55:23 -0400
Message-ID: <20131013035523.GC28064@thunk.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-6-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45345 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab3JMDz1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Oct 2013 23:55:27 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-6-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
> index b8c6879..b194ca8 100644
> --- a/lib/ext2fs/block.c
> +++ b/lib/ext2fs/block.c
> @@ -345,6 +345,13 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
>  		return ctx.errcode;
>  
>  	/*
> +	 * If an inode has inline data, we needn't traverse its blocks
> +	 * because no block belong to this inode.
> +	 */
> +	if (inode.i_flags & EXT4_INLINE_DATA_FL)
> +		return ctx.errcode;

ctx.errcode is guaranteed to be zero here.  So it would be better to
return zero explicitly --- except I wonder if we might be better to
have ext2fs_block_iterate3() return an error code if it is called on a
file that has inline data.  If we did this, then in nearly all of the
places where we call ext2fs_has_inline_data(), the call could be
obviated, and replaced with a check for the error code from
ext2fs_block_iterate3() --- which gets called in nearly every single
place where we call ext2fs_has_inline_data().

I'm not that fond of ext2fs_has_inline_data() because it doesn't
actually do that much, and it also might encourage application
programmers to use it even when they have access to inode data
structure, but instead of doing something like this:

	   if (inode.i_flags & EXT4_INLINE_DATA_FL)

they'll out of laziness, do this instead

	if (ext2fs_has_inline_data(fs, ino)

Which is less efficient, since it means an extra call to
ext2fs_read_inode()

							- Ted
