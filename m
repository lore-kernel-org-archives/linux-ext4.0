From: Maxim Patlasov <mpatlasov@parallels.com>
Subject: Re: [PATCH] ext4: avoid exposure of stale data in ext4_punch_hole()
Date: Fri, 27 Sep 2013 17:05:18 +0400
Message-ID: <5245828E.3060501@parallels.com>
References: <20130926173113.23276.77451.stgit@dhcp-10-30-17-2.sw.ru> <20130926185341.GA21811@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
	<adilger.kernel@dilger.ca>, <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:46956 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab3I0NFY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Sep 2013 09:05:24 -0400
In-Reply-To: <20130926185341.GA21811@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

On 09/26/2013 10:53 PM, Jan Kara wrote:
>    Hello,
>
> On Thu 26-09-13 21:32:07, Maxim Patlasov wrote:
>> While handling punch-hole fallocate, it's useless to truncate page cache
>> before removing the range from extent tree (or block map in indirect case)
>> because page cache can be re-populated (by read-ahead or read(2) or mmap-ed
>> read) immediately after truncating page cache, but before updating extent
>> tree (or block map). In that case the user will see stale data even after
>> fallocate is completed.
>    Yes, this is a known problem. The trouble is there isn't a reliable fix
> currently possible. If we don't truncate page cache before removing blocks,
> we will have pages in memory being backed by already freed blocks - not
> good as that can lead to data corruption. So you should't really remove the
> truncation from before we remove the blocks.

I'd like to understand the problem better. Could you please provide any 
details about that data corruption? And if it was already discussed 
somewhere, please point me to there.

>
> You are right that if punch hole races with page fault or read, we can
> create again pages with block mapping which will become stale soon and the
> same problem as I wrote above applies. Truncating pagecache after we
> removed blocks only narrows the race window but doesn't really fix the
> problem.

There seems to be two different problems: 1) pages backed by already 
freed blocks; 2) keeping page-cache populated by pages with stale data 
after fallocate completes. Your concerns refer to the first problem. My 
patch was intended to resolve the second. It seems to me that my patch 
really fixes the second problem and it doesn't make things worse w.r.t. 
the fisrt problem. Do I miss something?

Thanks,
Maxim

>
> Properly fixing the problem requires significant overhaul in how mmap_sem
> is used in page fault. I'm working on patches to do that but it will take
> some time.
>
> 								Honza
>   
>> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
>> ---
>>   fs/ext4/inode.c |   17 +++++++++--------
>>   1 file changed, 9 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 0d424d7..6b71116 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -3564,14 +3564,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>>   
>>   	}
>>   
>> -	first_block_offset = round_up(offset, sb->s_blocksize);
>> -	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
>> -
>> -	/* Now release the pages and zero block aligned part of pages*/
>> -	if (last_block_offset > first_block_offset)
>> -		truncate_pagecache_range(inode, first_block_offset,
>> -					 last_block_offset);
>> -
>>   	/* Wait all existing dio workers, newcomers will block on i_mutex */
>>   	ext4_inode_block_unlocked_dio(inode);
>>   	inode_dio_wait(inode);
>> @@ -3621,6 +3613,15 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>>   	up_write(&EXT4_I(inode)->i_data_sem);
>>   	if (IS_SYNC(inode))
>>   		ext4_handle_sync(handle);
>> +
>> +	first_block_offset = round_up(offset, sb->s_blocksize);
>> +	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
>> +
>> +	/* Now release the pages and zero block aligned part of pages */
>> +	if (last_block_offset > first_block_offset)
>> +		truncate_pagecache_range(inode, first_block_offset,
>> +					 last_block_offset);
>> +
>>   	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>>   	ext4_mark_inode_dirty(handle, inode);
>>   out_stop:
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

