From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Use of consistent types in e2fsprogs
Date: Mon, 16 May 2011 21:16:48 -0400
Message-ID: <20110517011648.GC4953@thunk.org>
References: <DC591D7D-86E5-4FA6-BC8F-859F1965C51D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54124 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535Ab1EQBQu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 21:16:50 -0400
Content-Disposition: inline
In-Reply-To: <DC591D7D-86E5-4FA6-BC8F-859F1965C51D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 16, 2011 at 03:55:54PM -0600, Andreas Dilger wrote:
> 
> There are uses of blk64_t, ext2_off64_t, long long, (unsigned) long,
> etc. in the libext2fs code.  The currently defined types are:
> 
> typedef __u32           blk_t;
> typedef __u64           blk64_t;
> typedef __u32           dgrp_t;
> typedef __u32           ext2_off_t;
> typedef __u64           ext2_off64_t;
> typedef __s64           e2_blkcnt_t;
> 
> It would be nice to get some consistent naming for these types, like
> ext2_blk_t, ext2_blk64_t (or possibly ext2_fsblk_t to match the
> kernel), ext2_group_t, and ext2_blkcnt_t (this appears to be
> negative in some places, so isn't easily replaced with ext2_blk64_t.

You're raising two issues here.  One is the fact that the names of the
types aren't completely consistent.  Yes, that's true, but I'm not
entirely convinced the code churn in renaming all of the types is worth
the pain.   That to me is purely aesthetics.

Note, by the way, that e2_blkcnt_t is quite different from blk64_t;
the first is used for logical block numbers (and we use negative
numbers to signal indirect blocks), where as blk64_t is used for
physical block numbers.  We have two different types in the kernel for
these two concept, as well.

> For example, io_channel_read_blk64() uses "long long", while both
> ext2fs_{read,write}_inode_full() _incorrectly_ use "unsigned long".
> I guess this wasn't noticed because > 16TB isn't directly usable on
> 32-bit Linux due to the block device limits, but it doesn't seem
> right to leave it as-is.

Well, that's not an example, a big (at least in the case of
ext2fs_{read,write}_inode_full().  They should be using blk64_t
instead.

The reason why the io_* functions use long long was because
conceptually they're a HAL that doesn't was considered logically
separate from the ext2fs library.  So they don't #include ext2_fs.h,
which is why they use unsigned long long instead of blk64_t.

> I understand it would be a lot of code churn, but I think it would
> be valuable to fix up the types used in e2fsprogs in order to
> clarify usage and remove errors, just like we did with the kernel
> code.  Is there any interest in accepting patches like this
> upstream?  Both ext2fs_{read,write}_inode_full() need to be fixed,
> and I expect even more places will need fixing.

I'm not convinced that a mass renaming of all the types is really
necessary to find these sorts of bugs.  A human has to look at the
types and decide whether they are correct; renaming the types via a
global search and replace isn't going to help find them....

       	      	  	  	      	 - Ted
