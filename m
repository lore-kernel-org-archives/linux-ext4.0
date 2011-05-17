From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: Use of consistent types in e2fsprogs
Date: Mon, 16 May 2011 23:04:10 -0600
Message-ID: <DAA9FED5-9ACE-40A0-8AF4-70B4C7648976@dilger.ca>
References: <DC591D7D-86E5-4FA6-BC8F-859F1965C51D@dilger.ca> <20110517011648.GC4953@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:2913 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab1EQFEL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 17 May 2011 01:04:11 -0400
In-Reply-To: <20110517011648.GC4953@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On May 16, 2011, at 19:16, Ted Ts'o wrote:
> On Mon, May 16, 2011 at 03:55:54PM -0600, Andreas Dilger wrote:
>> 
>> There are uses of blk64_t, ext2_off64_t, long long, (unsigned) long,
>> etc. in the libext2fs code.  The currently defined types are:
>> 
>> typedef __u32           blk_t;
>> typedef __u64           blk64_t;
>> typedef __u32           dgrp_t;
>> typedef __u32           ext2_off_t;
>> typedef __u64           ext2_off64_t;
>> typedef __s64           e2_blkcnt_t;
>> 
>> It would be nice to get some consistent naming for these types, like
>> ext2_blk_t, ext2_blk64_t (or possibly ext2_fsblk_t to match the
>> kernel), ext2_group_t, and ext2_blkcnt_t (this appears to be
>> negative in some places, so isn't easily replaced with ext2_blk64_t.
> 
> You're raising two issues here.  One is the fact that the names of the
> types aren't completely consistent.  Yes, that's true, but I'm not
> entirely convinced the code churn in renaming all of the types is worth
> the pain.   That to me is purely aesthetics.

It is partly aesthetics, but it also relates to making the code logic
easier to follow, and also being able to more easily determine if the
code is actually correct.

> Note, by the way, that e2_blkcnt_t is quite different from blk64_t;
> the first is used for logical block numbers (and we use negative
> numbers to signal indirect blocks), where as blk64_t is used for
> physical block numbers.

Using a better type name, like "ext2_logblk_t" to distinguish it from
"ext2_fsblk_t" would make that distinction more clear, IMHO.

> We have two different types in the kernel for these two concept, as well.
> 
>> For example, io_channel_read_blk64() uses "long long", while both
>> ext2fs_{read,write}_inode_full() _incorrectly_ use "unsigned long".
>> I guess this wasn't noticed because > 16TB isn't directly usable on
>> 32-bit Linux due to the block device limits, but it doesn't seem
>> right to leave it as-is.
> 
> Well, that's not an example, a big (at least in the case of
> ext2fs_{read,write}_inode_full().  They should be using blk64_t
> instead.
> 
> The reason why the io_* functions use long long was because
> conceptually they're a HAL that doesn't was considered logically
> separate from the ext2fs library.  So they don't #include ext2_fs.h,
> which is why they use unsigned long long instead of blk64_t.

OK, I can accept this.

>> I understand it would be a lot of code churn, but I think it would
>> be valuable to fix up the types used in e2fsprogs in order to
>> clarify usage and remove errors, just like we did with the kernel
>> code.  Is there any interest in accepting patches like this
>> upstream?  Both ext2fs_{read,write}_inode_full() need to be fixed,
>> and I expect even more places will need fixing.
> 
> I'm not convinced that a mass renaming of all the types is really
> necessary to find these sorts of bugs.  A human has to look at the
> types and decide whether they are correct; renaming the types via a
> global search and replace isn't going to help find them....

I'm not suggesting a global search & replace of "long long" or anything.
However, the current mish-mash of int vs. long vs. dgrp_t for group numbers,
__u64 vs blk64_t, etc doesn't make it clear when something is intentionally
that type, or just happens to be working for now.  Having separate types
for groups vs. physical blocks vs. logical blocks as we do in the kernel
will improve the quality of the code itself, I think.

Cheers, Andreas





