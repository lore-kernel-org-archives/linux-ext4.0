From: Maxim Patlasov <mpatlasov@parallels.com>
Subject: Re: [PATCH] ext4: avoid exposure of stale data in ext4_punch_hole()
Date: Fri, 27 Sep 2013 19:16:10 +0400
Message-ID: <5245A13A.1070207@parallels.com>
References: <20130926173113.23276.77451.stgit@dhcp-10-30-17-2.sw.ru> <20130926185341.GA21811@quack.suse.cz> <5245828E.3060501@parallels.com> <20130927144304.GA3873@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <tytso@mit.edu>, <linux-ext4@vger.kernel.org>,
	<adilger.kernel@dilger.ca>, <linux-kernel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130927144304.GA3873@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

On 09/27/2013 06:43 PM, Jan Kara wrote:
> On Fri 27-09-13 17:05:18, Maxim Patlasov wrote:
>> On 09/26/2013 10:53 PM, Jan Kara wrote:
>>>    Hello,
>>>
>>> On Thu 26-09-13 21:32:07, Maxim Patlasov wrote:
>>>> While handling punch-hole fallocate, it's useless to truncate page cache
>>>> before removing the range from extent tree (or block map in indirect case)
>>>> because page cache can be re-populated (by read-ahead or read(2) or mmap-ed
>>>> read) immediately after truncating page cache, but before updating extent
>>>> tree (or block map). In that case the user will see stale data even after
>>>> fallocate is completed.
>>>    Yes, this is a known problem. The trouble is there isn't a reliable fix
>>> currently possible. If we don't truncate page cache before removing blocks,
>>> we will have pages in memory being backed by already freed blocks - not
>>> good as that can lead to data corruption. So you should't really remove the
>>> truncation from before we remove the blocks.
>> I'd like to understand the problem better. Could you please provide
>> any details about that data corruption? And if it was already
>> discussed somewhere, please point me to there.
>    It was discussed at linux-ext4 / linux-fsdevel sometime in spring but I'm
> not sure to which extent we covered details of the races. Anyway if you
> have blocks in pagecache which point to already freed blocks (lets say they
> belong to file foo), the following
> can happen:
>    1) Someone reallocates freed blocks for another file bar. And writes new
>       data to them. Writeback flushes the data to disk.
>    2) Someone dirties pages with stale mapping data in file foo.
>    3) Writeback writes dirty pages of foo, overwriting data in bar.

That's clear now. Thanks a lot for the explanation.

>>> You are right that if punch hole races with page fault or read, we can
>>> create again pages with block mapping which will become stale soon and the
>>> same problem as I wrote above applies. Truncating pagecache after we
>>> removed blocks only narrows the race window but doesn't really fix the
>>> problem.
>> There seems to be two different problems: 1) pages backed by already
>> freed blocks; 2) keeping page-cache populated by pages with stale
>> data after fallocate completes. Your concerns refer to the first
>> problem. My patch was intended to resolve the second. It seems to me
>> that my patch really fixes the second problem and it doesn't make
>> things worse w.r.t. the fisrt problem. Do I miss something?
>    IMHO these are different aspects of the same problem but that's not
> important. Your patch actually makes things worse because currently if the
> file isn't written to via mmap while punch_hole is running, everything is
> fine. After your patch writeback of old data could race with punch hole
> freeing blocks resulting in data corruption I have described above. The
> 'no-harm' solution would be to add another truncation of pagecache after
> punch hole is done. I think that would be a good way to reduce the race
> window before the problem gets fixed properly.

Yes, I agree. I also think there is another reason making 'no-harm' 
patch worthwhile. Because currently, even users who write nothing suffer 
(any read may re-populate PC in the window). I'll resend corrected patch 
just in case somebody else is interested.

Thanks,
Maxim

>>>> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
>>>> ---
>>>>   fs/ext4/inode.c |   17 +++++++++--------
>>>>   1 file changed, 9 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index 0d424d7..6b71116 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -3564,14 +3564,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>>>>   	}
>>>> -	first_block_offset = round_up(offset, sb->s_blocksize);
>>>> -	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
>>>> -
>>>> -	/* Now release the pages and zero block aligned part of pages*/
>>>> -	if (last_block_offset > first_block_offset)
>>>> -		truncate_pagecache_range(inode, first_block_offset,
>>>> -					 last_block_offset);
>>>> -
>>>>   	/* Wait all existing dio workers, newcomers will block on i_mutex */
>>>>   	ext4_inode_block_unlocked_dio(inode);
>>>>   	inode_dio_wait(inode);
>>>> @@ -3621,6 +3613,15 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
>>>>   	up_write(&EXT4_I(inode)->i_data_sem);
>>>>   	if (IS_SYNC(inode))
>>>>   		ext4_handle_sync(handle);
>>>> +
>>>> +	first_block_offset = round_up(offset, sb->s_blocksize);
>>>> +	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
>>>> +
>>>> +	/* Now release the pages and zero block aligned part of pages */
>>>> +	if (last_block_offset > first_block_offset)
>>>> +		truncate_pagecache_range(inode, first_block_offset,
>>>> +					 last_block_offset);
>>>> +
>>>>   	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
>>>>   	ext4_mark_inode_dirty(handle, inode);
>>>>   out_stop:
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
