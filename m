From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH, RFC] ext4: don't use quota reservation for speculative
 metadata blocks
Date: Wed, 24 Feb 2010 09:00:57 -0600
Message-ID: <4B853F29.5080102@redhat.com>
References: <4B846241.7050205@redhat.com> <20100224132947.GA18470@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0BXPBP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2010 10:01:15 -0500
In-Reply-To: <20100224132947.GA18470@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Jan Kara wrote:
>> Because we can badly over-reserve metadata when we
>> calculate worst-case, it complicates things for quota, since
>> we must reserve and then claim later, retry on EDQUOT, etc.
>> Quota is also a generally smaller pool than fs free blocks,
>> so this over-reservation hurts more, and more often.
>   Yes, it's kind of nasty...
> 
>> I'm of the opinion that it's not the worst thing to allow
>> metadata to push a user slightly over quota, if we can simplify
>> the code by doing so.
>   Well, the code simplification isn't be such a big deal in this particular
> case at least for me - the false failures / warnings seem like a worse
> problem to me.

Well, good point.  :)

>> In the longer run I'd like to even consider not charging
>> speculative metadata against the superblock counters, and use
>> a reserved space pool similar to what XFS does, but this change
>> could maybe stand on its own, too.
>   This is going to be tough because you just cannot afford to fail
> an allocation as soon as you've accepted data to write. So you have to
> do some computations anyway to make sure you can always find space
> for metadata.
> 
>> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
>> index 22bc743..e11e5b0 100644
>> --- a/fs/ext4/balloc.c
>> +++ b/fs/ext4/balloc.c
>> @@ -604,13 +604,14 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
>>  	ret = ext4_mb_new_blocks(handle, &ar, errp);
>>  	if (count)
>>  		*count = ar.len;
>> -
>>  	/*
>> -	 * Account for the allocated meta blocks
>> +	 * Account for the allocated meta blocks.  We will never
>> +	 * fail EDQUOT for metdata, but we do account for it.
>>  	 */
>>  	if (!(*errp) && EXT4_I(inode)->i_delalloc_reserved_flag) {
>>  		spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
>>  		EXT4_I(inode)->i_allocated_meta_blocks += ar.len;
>> +		vfs_dq_alloc_block(inode, ar.len);
>   This won't work - vfs_dq_alloc_block just refuses to allocate blocks
> if you'd go over limit. You probably have to introduce new flag to

Oh, missed that.  Bummer, ok.

> the function to don't do limit checks... BTW: Christoph Hellwig and Dmitry
> are doing some quota cleanups which change the interface so it'd be better
> if you based quota patches on top of my linux-fs-2.6 tree.

OK

>   Also you shouldn't call vfs_dq_alloc_block inside a spinlock since it
> can sleep.

Oh, oops, I guess I knew that ...

>   Otherwise the patch looks fine, although all the counter stuff looks messy
> so I'm not so sure I didn't miss some subtlety.

The counter stuff is still messy because the superblock needs it - 
if that's the messiness you refer to ...

Thanks,
-Eric
 
> 								Honza

