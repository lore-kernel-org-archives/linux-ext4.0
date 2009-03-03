From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [RFC][PATCH 2/3] ext4: Exchange the blocks between two inodes
Date: Tue, 03 Mar 2009 17:36:05 +0900
Message-ID: <49ACEBF5.8020407@rs.jp.nec.com>
References: <49829A91.8000800@rs.jp.nec.com> <20090204152029.GE14762@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43532 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbZCCX1H (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Mar 2009 18:27:07 -0500
In-Reply-To: <20090204152029.GE14762@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,
Thank you for comment. :-)

Theodore Tso wrote:
>> +
>> +	up_write(&EXT4_I(org_inode)->i_data_sem);
>> +	ret = a_ops->write_begin(o_filp, mapping, offs, data_len, w_flags,
>> +								&page, &fsdata);
>> +	down_write(&EXT4_I(org_inode)->i_data_sem);
>>     
>
> This is going to be a problem.  Once we release i_data_sem, there is
> the possibility that other processes which might be running and
> accessing the file at the same time that the defragger is running
> could be blocked waiting for i_data_sem to be released.  The moment it
> gets released, they will grab the lock then start to modify extent
> tree --- either allocating new blocks to it, or worse, truncating or
> unlinking the target inode.
>
> This is going to be a mess to fix, since Linux doesn't have recursive
> locking primitives.  We do take i_mutex, which will protect us against
> truncates, but it won't protect against a write() system call.  Also,
> if there inode has delayed allocation blocks pending, those could get
> written out by the page cleaner, and i_mutex won't protect us against
> changes to i_data_sem, either.
>
>   
As you said, we take i_mutex at the start of ext4_defrag()
and hold it until the end of this function,
so orig file is protected against truncates and
it never be shrunk during defrag.

On the other hand, semaphore is released/taken around write_begin()
in ext4_defrag_partial() every page, so it does not protect orig file
against a write() system call from other process.  
So that defrag result (fragmentation) might not be best,
but data corruption does not occur at least.
So I think it is not a serious problem.

As above, it is not necessary to lock the whole of ext4_defrag()
with semaphore, we should just lock only a necessary point.
Therefore defrag V1's lock seems have unneeded lock points.
I will change lock point and semaphore type in the next version.

Do I overlook something?

Regards,
Akira Fujita


> We could add special-case kludgery to wrap around all of the places
> that takes or release the i_data_sem so that we get recursive locking
> support --- but that would be very ugly indeed.
>
> I'm not sure what's the best way to deal with this; maybe if we sleep
> on it someone will come up with a better suggestion --- but it's
> something that we have to figure out.
>
> 	  					- Ted
>
>   


