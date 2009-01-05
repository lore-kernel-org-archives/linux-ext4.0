From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Mon, 5 Jan 2009 16:39:38 -0500
Message-ID: <20090105213938.GG8939@mit.edu>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:57680 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZAEVjk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Jan 2009 16:39:40 -0500
Content-Disposition: inline
In-Reply-To: <49627285.8060407@ph.tum.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 05, 2009 at 09:50:13PM +0100, Thiemo Nagel wrote:
>
> I have chosen unsigned long for the sole reason to avoid truncation in  
> the assignment
>
> db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
> 	   EXT4_DESC_PER_BLOCK(sb);
>
> where the operands on the right side are of type unsigned long and  
> ext4_group_t (which is typedef unsigned long), so I don't think to make  
> db_count an unsigned long is hurting anything.

Err, no.  ext4_group_t is typedef'ed to be an unsigned int.  And there
are plenty of places in both the kernel and userspace code where the
number of groups is assumed to a quantity that can be held in a 2**32
bit field.  This isn't a problem, because normally the number of
blocks per group is fs->blocksize*8.  So for a 4k block filesystem,
the number of blocks per group is 32768, or 2**15.  So that means an
effective limit of 2**47 blocks before we overflow 2**32 block group
type width, and with 4k blocks, that means a max volume size of 512
petabytes.   

> But maybe it's not desireable to allow filesystems which are mountable  
> on x86_64 but not on x86_32?  Then a different solution would be to  
> enforce s_groups_count < (1<<31).

I'd say enforce s_groups_count < 2**32, because that's the limit we
have everywhere else.

> But there is another caveat:  We also need to take care of the overflow  
> in the argument to kmalloc(), and that further reduces the allowed range  
> of s_groups_count for x86_32 (but not for x86_64):
>
> sbi->s_group_desc = kmalloc(db_count * sizeof(struct buffer_head *),
> 			    GFP_KERNEL);
>
> So, which approach do you think would be best?

Well, obviously we need to check for this restriction, too.  At the
end of the day, though, we simply shouldn't allow s_blocks_count to be
bigger than either 2**32, or a limit which causes the above kmalloc
from overflowing on 32-bit systems.  Given that ext4_group_t is an
unsigned int, on 32-bit systems there will definitely be problems.

>> If it isn't we need to have better checks;
>> it sounds like the checks we need are ones that do a better job
>> checking s_blocks_per_group; am I right in assuming that
>> s_blocks_per_group was something ridiculous and that is what caused
>> the overflow?
>
> No, it was a very large block count (but the small blocks per group  
> helped, too):
>
> block count 562949953423360, first data block 8257, blocks per group 512
>

Well, as I pointed out, for 4k block filesystems, the number of blocks
per group is normally 32768.  There are times when we will use a
smaller number of blocks per group just to test how scalable various
filesystems will be at large sizes without having to create a huge
filesystem, 

						- Ted
