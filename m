Return-Path: <SRS0=EHOS=ON=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:56899 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725764AbeLDKvj (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2018 05:51:39 -0500
Subject: Re: jbd2 bh_shadow issue
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, fisherthepooh@protonmail.com,
        tytso@mit.edu
References: <871f4cbf-f7bc-35d8-bd42-32721b44c458@linux.alibaba.com>
 <20181129180439.GA11089@quack2.suse.cz>
From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <ff170504-2c35-a8c6-69fc-a930e4bdec96@linux.alibaba.com>
Date: Tue, 4 Dec 2018 18:49:49 +0800
MIME-Version: 1.0
In-Reply-To: <20181129180439.GA11089@quack2.suse.cz>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

hi,
> Hi,
> 
> On Tue 27-11-18 19:48:28, Xiaoguang Wang wrote:
>> I also meet this issue in our server, sometimes we got big latency for
>> buffered writes. Using fio, I have done some tests to reproduce this issue,
>> Please see test results in this mail:
>> https://www.spinics.net/lists/linux-ext4/msg62885.html
>>
>> I agree that doing buffer copy-out for every journaled buffer wastes cpu
>> time, so here I wonder whether we can only do buffer copy-out when buffer
>> is BH_SHADOW state. The core idea is simple:
>>      In do_get_write_access(), if buffer has already been in BH_SHADOW state,
>>      we allocate a new page, make buffer's b_page point to this new page, and
>>      following journal dirty work can be done in this patch. When transaction
>>      commits, in jbd2_journal_write_metadata_buffer(), we copy new page's conten
>>      to primary page, make buffer point to primary page and free the temporary
>>      page.
> 
> This isn't going to work. That are places in the kernel that assume that
> the page bh points to is the page stored in the page cache. Also you need
> to make sure that functions like sb_getblk() are going to return your new
> bh etc. So it is not really simple. On the other hand if we speak only
> about metadata buffers, the potential for breakage is certainly much
> smaller (but you'd have to then make sure data=journal case does not use
> your optimization) and there aren't that many ways how bh can be accessed
> so maybe you could make something like this working. But it certainly isn't
> going to work in the form you've presented here...
I had thought some of your mentioned cases and only just considered meta
buffer before, thanks you for pointing more cases. Do you have any suggestions
for this bh_shadow issue, sometimes it really caused app's long tail latency.

Regards,
Xiaoguang Wang

> 
> 								Honza
> 
> 
>>
>> I have written a test patch, the big long latency will disapper. Do you think
>> the method is useful? If you think so, I can submit a formal patch and do fstests.
>> Anyway I think this issue is not good, maybe we should fix it:)
>>
>> Here I attach my test patch here:
>> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> I think that replacing the buffer_head is harder than you think.
> 
>> ---
>>   fs/jbd2/journal.c            | 26 ++++++++++++++++++++++++--
>>   fs/jbd2/transaction.c        | 31 +++++++++++++++++++++++++++----
>>   include/linux/buffer_head.h  |  1 +
>>   include/linux/jbd2.h         |  7 +++++++
>>   include/linux/journal-head.h |  4 ++++
>>   5 files changed, 63 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
>> index 8ef6b6daaa7a..bb0612cf5447 100644
>> --- a/fs/jbd2/journal.c
>> +++ b/fs/jbd2/journal.c
>> @@ -393,8 +393,30 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
>>   		new_page = virt_to_page(jh_in->b_frozen_data);
>>   		new_offset = offset_in_page(jh_in->b_frozen_data);
>>   	} else {
>> -		new_page = jh2bh(jh_in)->b_page;
>> -		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
>> +		if (buffer_lege(bh_in)) {
>> +			char *primary, *temp_primary = jh_in->b_temp_data;
>> +			struct page *temp_page;
>> +			unsigned temp_offset;
>> +
>> +			new_page = jh_in->page;
>> +			new_offset = jh_in->page_offset;
>> +
>> +			temp_page = virt_to_page(temp_primary);
>> +			temp_offset = offset_in_page(temp_primary);
>> +			primary = kmap_atomic(new_page);
>> +			mapped_data = kmap_atomic(temp_page);
>> +
>> +			memcpy(primary + new_offset, mapped_data + temp_offset,
>> +			       bh_in->b_size);
>> +			set_bh_page(bh_in, new_page, new_offset);
>> +			kunmap_atomic(primary);
>> +			kunmap_atomic(temp_primary);
>> +			jbd2_free(temp_primary, bh_in->b_size);
>> +			clear_buffer_primarycopied(bh_in);
>> +		} else {
>> +			new_page = jh2bh(jh_in)->b_page;
>> +			new_offset = offset_in_page(jh2bh(jh_in)->b_data);
>> +		}
>>   	}
>>
>>   	mapped_data = kmap_atomic(new_page);
>> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
>> index c0b66a7a795b..6ad8ec94c7b8 100644
>> --- a/fs/jbd2/transaction.c
>> +++ b/fs/jbd2/transaction.c
>> @@ -827,6 +827,7 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
>>   	journal_t *journal;
>>   	int error;
>>   	char *frozen_buffer = NULL;
>> +	char *tmp_primary = NULL;
>>   	unsigned long start_lock, time_lock;
>>
>>   	if (is_handle_aborted(handle))
>> @@ -956,10 +957,29 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
>>   	 * here.
>>   	 */
>>   	if (buffer_shadow(bh)) {
>> -		JBUFFER_TRACE(jh, "on shadow: sleep");
>> -		jbd_unlock_bh_state(bh);
>> -		wait_on_bit_io(&bh->b_state, BH_Shadow, TASK_UNINTERRUPTIBLE);
>> -		goto repeat;
>> +		char *mapped_data;
>> +		struct page *new_page;
>> +		unsigned int primary_offset, new_offset;
>> +
>> +		if (!tmp_primary) {
>> +			jbd_unlock_bh_state(bh);
>> +			tmp_primary = jbd2_alloc(bh->b_size, GFP_NOFS |
>> +						 __GFP_NOFAIL);
>> +			goto repeat;
>> +		}
>> +
>> +		primary_offset = offset_in_page(bh->b_data);
>> +		mapped_data = kmap_atomic(bh->b_page);
>> +		memcpy(tmp_primary, mapped_data + primary_offset, bh->b_size);
>> +		kunmap_atomic(mapped_data);
>> +
>> +		new_page = virt_to_page(tmp_primary);
>> +		new_offset = offset_in_page(tmp_primary);
>> +		jh->b_temp_data = tmp_primary;
>> +		jh->page = bh->b_page;
>> +		jh->page_offset = primary_offset;
>> +		set_bh_page(bh, new_page, new_offset);
>> +		set_buffer_primarycopied(bh);
>>   	}
>>
>>   	/*
>> @@ -1009,6 +1029,9 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
>>   	if (unlikely(frozen_buffer))	/* It's usually NULL */
>>   		jbd2_free(frozen_buffer, bh->b_size);
>>
>> +	if (tmp_primary)
>> +		jbd2_free(frozen_buffer, bh->b_size);
>> +
>>   	JBUFFER_TRACE(jh, "exit");
>>   	return error;
>>   }
>> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
>> index 96225a77c112..88fbe345d291 100644
>> --- a/include/linux/buffer_head.h
>> +++ b/include/linux/buffer_head.h
>> @@ -66,6 +66,7 @@ struct buffer_head {
>>   	struct page *b_page;		/* the page this bh is mapped to */
>>
>>   	sector_t b_blocknr;		/* start block number */
>> +	sector_t orig_blocknr;		/* start block number */
>>   	size_t b_size;			/* size of mapping */
>>   	char *b_data;			/* pointer to data within the page */
>>
>> diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
>> index b708e5169d1d..0928f9bea8f4 100644
>> --- a/include/linux/jbd2.h
>> +++ b/include/linux/jbd2.h
>> @@ -321,6 +321,12 @@ enum jbd_state_bits {
>>   	BH_Shadow,		/* IO on shadow buffer is running */
>>   	BH_Verified,		/* Metadata block has been verified ok */
>>   	BH_JBDPrivateStart,	/* First bit available for private use by FS */
>> +	/*
>> +	 * We can not dirty a bh while it's going to disk with BH_Shadow flag.
>> +	 * In this case, we can copy this bh and let later fs dirty operations
>> +	 * go to this new bh.
>> +	 */
>> +	BH_PrimaryCopied,
>>   };
>>
>>   BUFFER_FNS(JBD, jbd)
>> @@ -334,6 +340,7 @@ TAS_BUFFER_FNS(RevokeValid, revokevalid)
>>   BUFFER_FNS(Freed, freed)
>>   BUFFER_FNS(Shadow, shadow)
>>   BUFFER_FNS(Verified, verified)
>> +BUFFER_FNS(PrimaryCopied, primarycopied)
>>
>>   static inline struct buffer_head *jh2bh(struct journal_head *jh)
>>   {
>> diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
>> index 9fb870524314..0fa317124d9a 100644
>> --- a/include/linux/journal-head.h
>> +++ b/include/linux/journal-head.h
>> @@ -51,6 +51,10 @@ struct journal_head {
>>   	 */
>>   	char *b_frozen_data;
>>
>> +	struct page *page;
>> +	unsigned int page_offset;
>> +	char *b_temp_data;
>> +
>>   	/*
>>   	 * Pointer to a saved copy of the buffer containing no uncommitted
>>   	 * deallocation references, so that allocations can avoid overwriting
>> -- 
>> 2.14.4.44.g2045bb6
>>
>>
>>
>>
>>
>> Regards,
>> Xiaoguang Wang
