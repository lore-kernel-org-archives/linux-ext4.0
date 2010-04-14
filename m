From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: ext34_free_inode's mess
Date: Wed, 14 Apr 2010 18:33:30 +0400
Message-ID: <87d3y23xz9.fsf@openvz.org>
References: <87pr2246y4.fsf@openvz.org> <20100414133440.GD3616@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:21741 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab0DNOdn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 14 Apr 2010 10:33:43 -0400
In-Reply-To: <20100414133440.GD3616@quack.suse.cz> (Jan Kara's message of
	"Wed, 14 Apr 2010 15:34:40 +0200")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara <jack@suse.cz> writes:

> On Wed 14-04-10 15:19:47, Dmitry Monakhov wrote:
>> I've finally automated my favorite testcase (see attachment), 
>> before i've run it by hand.
>> And sometimes i've saw following complain from fsck:
>> fsck.ext4 -f -n /dev/sdb2
>> ...
>> Pass 5: Checking group summary information
>> Inode bitmap differences:  -93582
>> Fix? no
>> 
>> Free inodes count wrong for group #12 (4634, counted=4633).
>> Fix? no
>> 
>> Free inodes count wrong (35610, counted=35609).
>> Fix? no
>> ...
>   Interesting. So some inode is marked as free although it is in
> use, right? That sounds like a nasty bug - if you reproduce this
> again, could you use debugfs to find out what file type is that
> inode? It could help looking for the bug.
No problems, 
wget http://download.openvz.org/~dmonakhov/junk/sdb2-2.bz2
In fact i've had even better image (with only 1 free inode in a
group, but full bitmask) unfortunately i forgot to save it.
>
>> I've started to look an inode bitmap manipulation code paths
>> and found strange logic in ext{3,4}_free_inode functions
>> 
>> 1) Group lock acquired twice for bitmap and for group_desc.
>>    There are not any advantage from this double locking, only
>>    error path(where the bit is already cleared) takes an
>>    advantage from this locking schema.
>>    It is reasonable to batch it in to one locking block.
>   I guess you think that this happens because we pass the lock parameter
> to ext3_clear_bit_atomic. But if you would actually look at the definition
> of the function, you would see that it's hard to find an architecture that
> uses the lock. Most architectures just use atomic bitop to clear the bit.
> I actually fail to see why anyone would need the lock - probably Ted knows
> :).
>
>> 2) if we failed to read gdp then bh2 is undefined so
>>    may result in oops due to undefince pointer dereferance.
>   No, because during mount time we check that all gdp pointers exist so
> ext3_get_group_desc can never fail after the mount has succeeded.
Yes, that is right,  why we have to check gdp to NULL when?
>> 3) if we failed to get write_access to gdp we skip
>>    handle_dirty_metadata for inode_bitmap which is also a bug.
>   It doesn't matter. At the moment ext3_journal_get_write_access fails we
> abort the journal so no writes are allowed to the filesystem anyway. So
> modified bitmap has hardly any chance to get to disk and you have to
> run fsck to clean up the mess anyway...
>
> 								Honza
