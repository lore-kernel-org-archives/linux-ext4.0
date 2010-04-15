From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext34_free_inode's mess
Date: Fri, 16 Apr 2010 02:01:35 +0400
Message-ID: <87sk6w2x4w.fsf@openvz.org>
References: <87pr2246y4.fsf@openvz.org> <20100414133440.GD3616@quack.suse.cz>
	<87d3y23xz9.fsf@openvz.org> <20100415213904.GA13293@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:4984 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830Ab0DOWBo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Apr 2010 18:01:44 -0400
In-Reply-To: <20100415213904.GA13293@quack.suse.cz> (Jan Kara's message of
	"Thu, 15 Apr 2010 23:39:04 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Wed 14-04-10 18:33:30, Dmitry Monakhov wrote:
>> Jan Kara <jack@suse.cz> writes:
>> 
>> > On Wed 14-04-10 15:19:47, Dmitry Monakhov wrote:
>> >> I've finally automated my favorite testcase (see attachment), 
>> >> before i've run it by hand.
>> >> And sometimes i've saw following complain from fsck:
>> >> fsck.ext4 -f -n /dev/sdb2
>> >> ...
>> >> Pass 5: Checking group summary information
>> >> Inode bitmap differences:  -93582
>> >> Fix? no
>> >> 
>> >> Free inodes count wrong for group #12 (4634, counted=4633).
>> >> Fix? no
>> >> 
>> >> Free inodes count wrong (35610, counted=35609).
>> >> Fix? no
>> >> ...
>> >   Interesting. So some inode is marked as free although it is in
>> > use, right? That sounds like a nasty bug - if you reproduce this
>> > again, could you use debugfs to find out what file type is that
>> > inode? It could help looking for the bug.
>> No problems, 
>> wget http://download.openvz.org/~dmonakhov/junk/sdb2-2.bz2
>> In fact i've had even better image (with only 1 free inode in a
>> group, but full bitmask) unfortunately i forgot to save it.
>   I've looked at it: So the problem is the other way around (I always
> confuse this). The inode is properly deleted but the bit remains set
> in the bitmap. What is strange is that group descriptor counts are
> correct so it's really only the bitmap bit that is wrong. I've looked
> through the inode allocation and freeing code back and forth but I could
> not find a place where this could realistically happen.
>   So just for record:
> Inode has mtime = ctime = atime = dtime (so it was really deleted), i_nlink
> = 0, it is a directory, i_disksize = 4096, i_blocks = 0. So indeed it looks
> that we were in ext4_mkdir, we failed to allocate the block for directory
> and went to out_clear_inode (thus i_disksize remained to be set to 4096,
> otherwise it would be set to 0)... But how it happened that the bit in the
> bitmap didn't get cleared while the group descriptors were updated is
> beyond me.
>   Alternatively the inode could have been deleted just fine and later we
> just set the bit in the inode bitmap and didn't update anything else. But
> even this does not seem to be possible to me...
>   Since you can reproduce it, good first step would be to 
I will, but for now i'm working on fix for OOPS
from fs/ext4/extents.c:3479  due to ex == NULL
I'll create new bug in bugzilla for this in a minute.
>
>> >> I've started to look an inode bitmap manipulation code paths
>> >> and found strange logic in ext{3,4}_free_inode functions
>> >> 
>> >> 1) Group lock acquired twice for bitmap and for group_desc.
>> >>    There are not any advantage from this double locking, only
>> >>    error path(where the bit is already cleared) takes an
>> >>    advantage from this locking schema.
>> >>    It is reasonable to batch it in to one locking block.
>> >   I guess you think that this happens because we pass the lock parameter
>> > to ext3_clear_bit_atomic. But if you would actually look at the definition
>> > of the function, you would see that it's hard to find an architecture that
>> > uses the lock. Most architectures just use atomic bitop to clear the bit.
>> > I actually fail to see why anyone would need the lock - probably Ted knows
>> > :).
>> >
>> >> 2) if we failed to read gdp then bh2 is undefined so
>> >>    may result in oops due to undefince pointer dereferance.
>> >   No, because during mount time we check that all gdp pointers exist so
>> > ext3_get_group_desc can never fail after the mount has succeeded.
>> Yes, that is right,  why we have to check gdp to NULL when?
>   Hmm, I've looked at the code again and I think the check is there mainly
> to avoid Oops in case filesystem got corrupted and we computed some bogus
> group number. Not that I would see how that could happen in this particular
> case but in some other uses of ext3_get_group_desc it could happen. So
> moving the gdp check before we use bh2 probably makes some sence (although
> it's probably just a style cleanup in this case).
Ok, if we know that any error result in EIO or panic when let's just
call it style cleanup(simplification), imho new code is more readable.
