From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: [PATCH 1/3] ext4: nonda_switch prevent deadlock
Date: Thu, 30 Aug 2012 20:12:49 +0900
Message-ID: <503F4AB1.4050501@rs.jp.nec.com>
References: <1346170903-7563-1-git-send-email-dmonakhov@openvz.org> <20120829132816.GB21169@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44627 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab2H3LNN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2012 07:13:13 -0400
In-Reply-To: <20120829132816.GB21169@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

(2012/08/29 22:28), Jan Kara wrote:
> On Tue 28-08-12 20:21:41, Dmitry Monakhov wrote:
>> Currently ext4_da_write_begin may deadlock if called with opened journal
>> transaction. Real life example:
>> ->move_extent_per_page()
>>    ->ext4_journal_start()-> hold journal transaction
>>    ->write_begin()
>>      ->ext4_da_write_begin()
>>        ->ext4_nonda_switch()
>>          ->writeback_inodes_sb_if_idle()  --> will wait for journal_stop()
>>
>> This bug may be easily fixed by code reordering,
>> But in some cases it should be possible to call write_begin()
>> while holding journal's transaction, in this case caller may avoid
>> recoursion by passing AOP_FLAG_NOFS flag.
>    Well, I find calling ext4_write_begin() with a transaction started a bug.
> Possibly ext4_write_begin() can be tweaked to handle that but things would
> be simpler if we didn't have to.
> 
> Looking into move_extent_per_page(), calling ->write_begin() doesn't seem
> to be quite right there anyway. For example it results in filling holes
> under that page which is not desirable. I'm not even sure why do we call
> ->write_begin() there at all. The data in the page is unchanged. So it
> should be enough to just remap buffers and mark the page dirty (but I might
> be missing some subtlety here). Fujita-san, can you possibly explain?

Originally, calling write_begin/end in move_extent_per_page() was
to get a page and mark bh which exchanged by mext_replace_branches() as dirty.
But if there is a better way to do this, it makes sense to fix.

Regards,
Akira Fujita

> 								Honza
> 
>> ---
>>   fs/ext4/inode.c |   28 +++++++++++++++++-----------
>>   1 files changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 6324f74..d12d30e 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -889,6 +889,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
>>   	struct page *page;
>>   	pgoff_t index;
>>   	unsigned from, to;
>> +	int nofs = flags & AOP_FLAG_NOFS;
>> +
>> +	/* We cannot recurse into the filesystem if the transaction is already
>> +	 * started */
>> +	BUG_ON(!nofs && journal_current_handle());
>>   
>>   	trace_ext4_write_begin(inode, pos, len, flags);
>>   	/*
>> @@ -906,9 +911,6 @@ retry:
>>   		ret = PTR_ERR(handle);
>>   		goto out;
>>   	}
>> -
>> -	/* We cannot recurse into the filesystem as the transaction is already
>> -	 * started */
>>   	flags |= AOP_FLAG_NOFS;
>>   
>>   	page = grab_cache_page_write_begin(mapping, index, flags);
>> @@ -957,7 +959,8 @@ retry:
>>   		}
>>   	}
>>   
>> -	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>> +	if (!nofs && ret == -ENOSPC &&
>> +	    ext4_should_retry_alloc(inode->i_sb, &retries))
>>   		goto retry;
>>   out:
>>   	return ret;
>> @@ -2447,7 +2450,7 @@ out_writepages:
>>   }
>>   
>>   #define FALL_BACK_TO_NONDELALLOC 1
>> -static int ext4_nonda_switch(struct super_block *sb)
>> +static int ext4_nonda_switch(struct super_block *sb, int writeback_allowed)
>>   {
>>   	s64 free_blocks, dirty_blocks;
>>   	struct ext4_sb_info *sbi = EXT4_SB(sb);
>> @@ -2475,7 +2478,7 @@ static int ext4_nonda_switch(struct super_block *sb)
>>   	 * Even if we don't switch but are nearing capacity,
>>   	 * start pushing delalloc when 1/2 of free blocks are dirty.
>>   	 */
>> -	if (free_blocks < 2 * dirty_blocks)
>> +	if (writeback_allowed && free_blocks < 2 * dirty_blocks)
>>   		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
>>   
>>   	return 0;
>> @@ -2490,10 +2493,14 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
>>   	pgoff_t index;
>>   	struct inode *inode = mapping->host;
>>   	handle_t *handle;
>> +	int nofs = flags & AOP_FLAG_NOFS;
>>   
>>   	index = pos >> PAGE_CACHE_SHIFT;
>> +	/* We cannot recurse into the filesystem if the transaction is already
>> +	 * started */
>> +	BUG_ON(!nofs && journal_current_handle());
>>   
>> -	if (ext4_nonda_switch(inode->i_sb)) {
>> +	if (ext4_nonda_switch(inode->i_sb, !nofs)) {
>>   		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
>>   		return ext4_write_begin(file, mapping, pos,
>>   					len, flags, pagep, fsdata);
>> @@ -2512,8 +2519,6 @@ retry:
>>   		ret = PTR_ERR(handle);
>>   		goto out;
>>   	}
>> -	/* We cannot recurse into the filesystem as the transaction is already
>> -	 * started */
>>   	flags |= AOP_FLAG_NOFS;
>>   
>>   	page = grab_cache_page_write_begin(mapping, index, flags);
>> @@ -2538,7 +2543,8 @@ retry:
>>   			ext4_truncate_failed_write(inode);
>>   	}
>>   
>> -	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
>> +	if (!nofs && ret == -ENOSPC &&
>> +	    ext4_should_retry_alloc(inode->i_sb, &retries))
>>   		goto retry;
>>   out:
>>   	return ret;
>> @@ -4791,7 +4797,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
>>   	/* Delalloc case is easy... */
>>   	if (test_opt(inode->i_sb, DELALLOC) &&
>>   	    !ext4_should_journal_data(inode) &&
>> -	    !ext4_nonda_switch(inode->i_sb)) {
>> +	    !ext4_nonda_switch(inode->i_sb, 1)) {
>>   		do {
>>   			ret = __block_page_mkwrite(vma, vmf,
>>   						   ext4_da_get_block_prep);
>> -- 
>> 1.7.7.6
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Akira Fujita <a-fujita@rs.jp.nec.com>

The First Fundamental Software Development Group,
Platform Division, NEC Software Tohoku, Ltd.

