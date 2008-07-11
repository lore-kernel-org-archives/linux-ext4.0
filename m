From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] e2fsprogs : Add stricter checks for blocksize in
	ext2fs_open
Date: Fri, 11 Jul 2008 08:55:06 -0400
Message-ID: <20080711125506.GB20099@mit.edu>
References: <ea11fea30807110149g31065f31k5231bbebc5133587@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:41409 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752882AbYGKMzI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 11 Jul 2008 08:55:08 -0400
Content-Disposition: inline
In-Reply-To: <ea11fea30807110149g31065f31k5231bbebc5133587@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 11, 2008 at 02:19:06PM +0530, Manish Katiyar wrote:
> Below patch adds stricter checks in ext2fs_open() so that we catch bad
> block sizes earlier than later.

That concept seems fine; I'm curious why you found this necessary?
Did you have a corrupted filesystem where this caused major problems?
If so, can I have more details?

>  	fs->blocksize = EXT2_BLOCK_SIZE(fs->super);
> -	if (fs->blocksize == 0) {
> +	if ((fs->blocksize < EXT2_MIN_BLOCK_SIZE) ||
> +	    (fs->blocksize > EXT2_MAX_BLOCK_SIZE) ||
> +	    (fs->blocksize % EXT2_MIN_BLOCK_SIZE != 0)) {

The first and last check is not necessary, given that EXT2_bLOCK_SIZE
is defined as:

#define EXT2_BLOCK_SIZE(s)	 (EXT2_MIN_BLOCK_SIZE << (s)->s_log_block_size)

So by definition, the blocksize will *always* be greater than or equal
to MIN_BLOCK_SIZE, and it always will be a multiple of EXT2_MIN_BLOCK_SIZE.

The more direct check which we could do would be something like this:

	if ((fs->super->s_log_block_size < EXT2_MIN_BLOCK_LOG_SIZE) ||
	    (fs->super->s_log_block_size > EXT2_MAX_BLOCK_LOG_SIZE))
  		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
  		goto cleanup;
  	}

... before setting fs->blocksize.

I'm curious what problem you were worried about that might happen if
fs->blocksize were greater than 64k, though.

							- Ted
