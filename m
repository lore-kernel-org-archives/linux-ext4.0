From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 4/4] ext4: Speed up FITRIM by recording flags in ext4_group_info.
Date: Thu, 10 Feb 2011 09:36:34 +0800
Message-ID: <4D534122.90907@tao.ma>
References: <4D522B9B.5070707@tao.ma> <1297231048-3458-4-git-send-email-tm@tao.ma> <alpine.LFD.2.00.1102091445580.5596@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:44012 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751790Ab1BJBhP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Feb 2011 20:37:15 -0500
In-Reply-To: <alpine.LFD.2.00.1102091445580.5596@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/09/2011 10:01 PM, Lukas Czerner wrote:
> On Wed, 9 Feb 2011, Tao Ma wrote:
>
>    
>> From: Tao Ma<boyu.mt@taobao.com>
>>
>> In ext4, when FITRIM is called every time, we iterate all the
>> groups and do trim one by one. It is a bit time wasting if the
>> group has been trimmed and there is no change since the last
>> trim.
>>
>> So this patch adds a new flag in ext4_group_info->bb_state to
>> indicate that the group has been trimmed, and it will be cleared
>> if some blocks is freed(in release_blocks_on_commit). Another
>> trim_minlen is added in ext4_sb_info to record the last minlen
>> we use to trim the volume, so that if the caller provide a small
>> one, we will go on the trim regardless of the bb_state. The idea
>> is inspired by Andreas  and Lukas Czerner.
>>      
> Hi Tao,
>
> This is great, thanks for the patch! Do you have any benchmark numbers
> showing how much does it improve FSTRIM time ? It seems it might help a
> lot. Couple of comments bellow.
>    
I have a intel x25m ssd. I will try to collect some data about it and 
update them in the commit log.
>    
>> Cc: Andreas Dilger<adilger.kernel@dilger.ca>
>> Cc: Lukas Czerner<lczerner@redhat.com>
>> Signed-off-by: Tao Ma<boyu.mt@taobao.com>
>> ---
>>   fs/ext4/ext4.h    |    8 +++++++-
>>   fs/ext4/mballoc.c |   22 ++++++++++++++++++++++
>>   2 files changed, 29 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
>> index 0c8d97b..684f48e 100644
>> --- a/fs/ext4/ext4.h
>> +++ b/fs/ext4/ext4.h
>> @@ -1200,6 +1200,9 @@ struct ext4_sb_info {
>>   	struct ext4_li_request *s_li_request;
>>   	/* Wait multiplier for lazy initialization thread */
>>   	unsigned int s_li_wait_mult;
>> +
>> +	/* record the last minlen when FITRIM is called. */
>> +	u64 trim_minlen;
>>      
> Maybe this is a bit nitpicking, but it is not very clear what is the
> "trim_minlen" for. I would rather use something like
> "last_trim_minblks", or similar.
>    
ok, I will change it in the next round.
>    
>>   };
>>
>>   static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
>> @@ -1970,10 +1973,13 @@ struct ext4_group_info {
>>   					 * 5 free 8-block regions. */
>>   };
>>
>> -#define EXT4_GROUP_INFO_NEED_INIT_BIT	0
>> +#define EXT4_GROUP_INFO_NEED_INIT_BIT		0
>> +#define EXT4_GROUP_INFO_HAS_BEEN_TRIMMED	1
>>
>>   #define EXT4_MB_GRP_NEED_INIT(grp)	\
>>   	(test_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,&((grp)->bb_state)))
>> +#define EXT4_MB_GRP_HAS_BEEN_TRIMMED(grp)	\
>> +	(test_bit(EXT4_GROUP_INFO_HAS_BEEN_TRIMMED,&((grp)->bb_state)))
>>
>>   #define EXT4_MAX_CONTENTION		8
>>   #define EXT4_CONTENTION_THRESHOLD	2
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 4eadac8..3f6b809 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -1563,6 +1563,9 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
>>   	mb_set_bits(EXT4_MB_BITMAP(e4b), ex->fe_start, len0);
>>   	mb_check_buddy(e4b);
>>
>> +	if (!ret)
>> +		EXT4_SB(sb)->trim_minlen = minlen;
>> +
>>      
> Did you even tried to compile it ? "minlen" is not defined in
> mb_mark_used(), also it does make sense to set trim_minlen there. Did
> not you meant it to be in ext4_trim_fs ?
>    
oh, sorry, this line should be in the function ext4_trim_fs. I just 
rebased my branch to the lastest kernel to see whether it conflicts.
I don't know why they are moved here.  So the right position is:
@@ -4892,6 +4911,9 @@ int ext4_trim_fs(struct super_block *sb, struct 
fstrim_range *range)
         }
         range->len = trimmed * sb->s_blocksize;

+       if (!ret)
+               EXT4_SB(sb)->trim_minlen = minlen;
+
  out:
         return ret;
  }

Sorry for the trouble.
>    
>>   	return ret;
>>   }
>>
>> @@ -2687,6 +2690,16 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
>>   		rb_erase(&entry->node,&(db->bb_free_root));
>>   		mb_free_blocks(NULL,&e4b, entry->start_blk, entry->count);
>>
>> +		/*
>> +		 * Clear the trimmed flag for the group so that the next
>> +		 * ext4_trim_fs can trim it.
>> +		 * If the volume is mounted with -o discard, online discard
>> +		 * is supported and the free blocks will be trimmed online.
>> +		 */
>> +		if (!test_opt(sb, DISCARD))
>> +			clear_bit(EXT4_GROUP_INFO_HAS_BEEN_TRIMMED,
>> +				&(db->bb_state));
>> +
>>   		if (!db->bb_free_root.rb_node) {
>>   			/* No more items in the per group rb tree
>>   			 * balance refcounts from ext4_mb_free_metadata()
>> @@ -4772,6 +4785,10 @@ ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
>>
>>   	ext4_lock_group(sb, group);
>>
>> +	if (EXT4_MB_GRP_HAS_BEEN_TRIMMED(e4b->bd_info)&&
>> +	    minblocks>= EXT4_SB(sb)->trim_minlen)
>> +		goto out;
>> +
>>      
> I think this can be placed in the ext4_trim_fs() in the for() loop so we can
> avoid unnecessary call to ext4_trim_all_free.
>    
fair enough. I will update it.

Regards,
Tao
