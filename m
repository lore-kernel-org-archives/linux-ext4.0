From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Use of consistent types in e2fsprogs
Date: Tue, 17 May 2011 09:26:57 -0500
Message-ID: <4DD285B1.60909@redhat.com>
References: <DC591D7D-86E5-4FA6-BC8F-859F1965C51D@dilger.ca> <20110517011648.GC4953@thunk.org> <DAA9FED5-9ACE-40A0-8AF4-70B4C7648976@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab1EQO1C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 May 2011 10:27:02 -0400
In-Reply-To: <DAA9FED5-9ACE-40A0-8AF4-70B4C7648976@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/17/11 12:04 AM, Andreas Dilger wrote:
> On May 16, 2011, at 19:16, Ted Ts'o wrote:
>> On Mon, May 16, 2011 at 03:55:54PM -0600, Andreas Dilger wrote:
>>>
>>> There are uses of blk64_t, ext2_off64_t, long long, (unsigned) long,
>>> etc. in the libext2fs code.  The currently defined types are:
>>>
>>> typedef __u32           blk_t;
>>> typedef __u64           blk64_t;
>>> typedef __u32           dgrp_t;
>>> typedef __u32           ext2_off_t;
>>> typedef __u64           ext2_off64_t;
>>> typedef __s64           e2_blkcnt_t;
>>>
>>> It would be nice to get some consistent naming for these types, like
>>> ext2_blk_t, ext2_blk64_t (or possibly ext2_fsblk_t to match the
>>> kernel), ext2_group_t, and ext2_blkcnt_t (this appears to be
>>> negative in some places, so isn't easily replaced with ext2_blk64_t.
>>
>> You're raising two issues here.  One is the fact that the names of the
>> types aren't completely consistent.  Yes, that's true, but I'm not
>> entirely convinced the code churn in renaming all of the types is worth
>> the pain.   That to me is purely aesthetics.
> 
> It is partly aesthetics, but it also relates to making the code logic
> easier to follow, and also being able to more easily determine if the
> code is actually correct.
> 
>> Note, by the way, that e2_blkcnt_t is quite different from blk64_t;
>> the first is used for logical block numbers (and we use negative
>> numbers to signal indirect blocks), where as blk64_t is used for
>> physical block numbers.
> 
> Using a better type name, like "ext2_logblk_t" to distinguish it from
> "ext2_fsblk_t" would make that distinction more clear, IMHO.

If you're going for consistency that'd be "ext2_lblk_t" I think.

(logblk differs from the kernel and might imply something about the log itself...)

I too agree that better type consistency would help.  When I fixed the signed
block containers way back when, it was Not Fun searching through the mishmash of
apparently random type selections.  And having "int blocknr," besides often
being wrong, doesn't make it obvious if you're talking about a physical block,
a logical block, a block offset within a group, or what.

Having typedefs doesn't necessarily enforce correctness but it makes it
easier to get right, IMHO.

-Eric

