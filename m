From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch] fix up lock order reversal in writeback
Date: Tue, 16 Nov 2010 22:30:37 -0600
Message-ID: <4CE35A6D.2040906@redhat.com>
References: <20101116110058.GA4298@amd> <20101116130146.GG4757@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nick Piggin <npiggin@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20101116130146.GG4757@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11/16/10 7:01 AM, Jan Kara wrote:
> On Tue 16-11-10 22:00:58, Nick Piggin wrote:
>> I saw a lock order warning on ext4 trigger. This should solve it.
>> Raciness shouldn't matter much, because writeback can stop just
>> after we make the test and return anyway (so the API is racy anyway).
>   Hmm, for now the fix is OK. Ultimately, we probably want to call
> writeback_inodes_sb() directly from all the callers. They all just want to
> reduce uncertainty of delayed allocation reservations by writing delayed
> data and actually wait for some of the writeback to happen before they
> retry again the allocation.

For ext4, at least, it's just best-effort.  We're not actually out of
space yet when this starts pushing.  But it helps us avoid enospc:

commit c8afb44682fcef6273e8b8eb19fab13ddd05b386
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Dec 23 07:58:12 2009 -0500

    ext4: flush delalloc blocks when space is low
    
    Creating many small files in rapid succession on a small
    filesystem can lead to spurious ENOSPC; on a 104MB filesystem:
    
    for i in `seq 1 22500`; do
        echo -n > $SCRATCH_MNT/$i
        echo XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX > $SCRATCH_MNT/$i
    done
    
    leads to ENOSPC even though after a sync, 40% of the fs is free
    again.

    <snip>

We don't need it to be synchronous - in fact I didn't think it was ...

ext4 should probably use btrfs's new variant and just get rid of the
one I put in, for a very large system/filesystem it could end up doing
a rather insane amount of IO when the fs starts to get full.

as for the locking problems ... sorry about that!

-Eric

> Although the callers generally cannot get umount_sem because they hold
> other locks, they have the superblock well pinned so grabbing umount_sem
> makes sense mostly to make assertions happy. But as I'm thinking about it,
> trylock *is* maybe the right answer to this anyway...
> 
> So
> Acked-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
>>
>> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
>>
>> Index: linux-2.6/fs/fs-writeback.c
>> ===================================================================
>> --- linux-2.6.orig/fs/fs-writeback.c	2010-11-16 21:44:32.000000000 +1100
>> +++ linux-2.6/fs/fs-writeback.c	2010-11-16 21:49:37.000000000 +1100
>> @@ -1125,16 +1125,20 @@ EXPORT_SYMBOL(writeback_inodes_sb);
>>   *
>>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>>   * Returns 1 if writeback was started, 0 if not.
>> + *
>> + * May be called inside i_lock. May not start writeback if locks cannot
>> + * be acquired.
>>   */
>>  int writeback_inodes_sb_if_idle(struct super_block *sb)
>>  {
>>  	if (!writeback_in_progress(sb->s_bdi)) {
>> -		down_read(&sb->s_umount);
>> -		writeback_inodes_sb(sb);
>> -		up_read(&sb->s_umount);
>> -		return 1;
>> -	} else
>> -		return 0;
>> +		if (down_read_trylock(&sb->s_umount)) {
>> +			writeback_inodes_sb(sb);
>> +			up_read(&sb->s_umount);
>> +			return 1;
>> +		}
>> +	}
>> +	return 0;
>>  }
>>  EXPORT_SYMBOL(writeback_inodes_sb_if_idle);
>>  
>> @@ -1145,17 +1149,21 @@ EXPORT_SYMBOL(writeback_inodes_sb_if_idl
>>   *
>>   * Invoke writeback_inodes_sb if no writeback is currently underway.
>>   * Returns 1 if writeback was started, 0 if not.
>> + *
>> + * May be called inside i_lock. May not start writeback if locks cannot
>> + * be acquired.
>>   */
>>  int writeback_inodes_sb_nr_if_idle(struct super_block *sb,
>>  				   unsigned long nr)
>>  {
>>  	if (!writeback_in_progress(sb->s_bdi)) {
>> -		down_read(&sb->s_umount);
>> -		writeback_inodes_sb_nr(sb, nr);
>> -		up_read(&sb->s_umount);
>> -		return 1;
>> -	} else
>> -		return 0;
>> +		if (down_read_trylock(&sb->s_umount)) {
>> +			writeback_inodes_sb_nr(sb, nr);
>> +			up_read(&sb->s_umount);
>> +			return 1;
>> +		}
>> +	}
>> +	return 0;
>>  }
>>  EXPORT_SYMBOL(writeback_inodes_sb_nr_if_idle);
>>  
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

