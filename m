From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v1 04/22] libext2fs: handle inline data in dir iterator
 function
Date: Sun, 13 Oct 2013 18:51:12 -0400
Message-ID: <20131013225112.GA9609@thunk.org>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-5-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45604 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab3JMWvQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Oct 2013 18:51:16 -0400
Content-Disposition: inline
In-Reply-To: <1375436989-18948-5-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:49:31PM +0800, Zheng Liu wrote:
> +int ext2fs_process_dir_inline_data(ext2_filsys	fs,
> +				   char		*buf,
> +				   unsigned int	buf_len,
> +				   e2_blkcnt_t	blockcnt,
> +				   struct ext2_inode_large *inode,
> +				   void		*priv_data)
> +{

It looks like there is a lot of code in this function which is in
common with ext2fs_process_dir_block(), so I'd suggest refactoring out
the common code to reduce duplication.  This will reduce code size,
and more importantly, improve maintenance of the code.

> +errcode_t ext2fs_inline_data_iterate(ext2_filsys fs,
> +			       ext2_ino_t ino,
> +			       int flags,
> +			       char *block_buf,
> +			       int (*func)(ext2_filsys fs,
> +					   char *buf,
> +					   unsigned int buf_len,
> +					   e2_blkcnt_t blockcnt,
> +					   struct ext2_inode_large *inode,
> +					   void *priv_data),
> +			       void *priv_data)

This function is misnamed, which worries me a little.  First of all,
it only makes sense when called on directories, so some name that
indicates that it is meant to iterate over directories is a good idea.
so some name such as ext2fs_process_inline_data_dir might be a better
choice.

Secondly, it would a really good idea if there was a check to make
sure it was passed an inode number which corresponds to an directory
and that the inline data flag is set.  A little paranoia is really
healthy thing --- if we have some application bug where this function
gets called accidentally on an inappropriate inode, we want to return
a clean error code and not stumble on until something bad happens.

> +	dirent.inode = (__u32)*inode->i_block;

I'd be much happier with:

	dirent.inode = inode->i_block[0];

We shouldn't use casts unless absolutely necessary, and it's not
necessary here.

Also, I suspect we have some byte-swapping problems here.  It doesn't
appear there is any allownaces for byte swapping in the inline data
patches.  Currently, the ext2fs_read_inode() function will take care
of byte swapping i_blocks[], so that will be OK here, but in the case
of an inode with inline data, if we byte swap all of i_blocks[] then
ext2fs_read_inline_data() will malfunction since the data bytes stored
in the rest of i_blocks[] will be byte swapped.  And that would be
wrong.

So I think what you will need to do is to avoid byte swapping the
i_blocks[] array if the inode contains inline_data, and then in the
case where this is a directory, we will need to byte swap i_block[0]
if we are running on a big-endian system.

Cheers,

						- Ted
