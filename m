Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F8D20ED;
	Sat, 30 May 2026 02:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780109616; cv=none; b=SWP/lQVNvoNOzUGAQqMxWP4hoR3fk4DLw21zj7cJjonBv7Y6so5LR09yuBgLNTdqeaCDKaJxcQNNV2SkDGWiUqcdf6kyZKJYtMGhwWgOroaG39DJVgxrEBAvvcCh6tzfaaXSowdU4+bTbyQIHZQ/uqchODhe5H1fILJa0kn8Ni4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780109616; c=relaxed/simple;
	bh=+RrbvzphV5ySRuMPQFOO4z0xJPHt6h3cOAdnSe46O8o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lZYk4yWM+NYS+2Pu5t0q6KwwdbqVy2DyXIf5ae2B3gYzreWFmUe2MBmuusZ1auHM2efZZwPfDcPwYx69f5Hx43Xxcfuo412uybba6AQ8ymmjrwIqDpO/LIeXchVy8APlUGUo0M1XZ7I9AkHpLYtJCadGj7tvCokEDW/XEAxY4bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gS4Xj3TtgzKHMWX;
	Sat, 30 May 2026 10:53:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 485D44058F;
	Sat, 30 May 2026 10:53:28 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1skURpqPlSMEA--.54751S3;
	Sat, 30 May 2026 10:53:26 +0800 (CST)
Message-ID: <7c24dc47-0c3e-4ee9-b113-f9ca9f3a6ebf@huaweicloud.com>
Date: Sat, 30 May 2026 10:53:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/23] ext4: submit zeroed post-EOF data immediately in
 the iomap buffered I/O path
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-18-yi.zhang@huaweicloud.com>
 <ahb0fqVCige08_--@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <ahb0fqVCige08_--@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1skURpqPlSMEA--.54751S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKFW7WFy3uFy5AFyUGr18Grg_yoWxXr4kpr
	W5K3WrAFWvqF9ruw4SvF42qF1avayfGr4UGFyxW34qyFZ0vrn7KFy7K3yruFW2yrsrGayj
	vF4UXFyDW3WqyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 5/27/2026 9:41 PM, Ojaswin Mujoo wrote:
> On Mon, May 11, 2026 at 03:23:37PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> In the generic buffered_head I/O path, we rely on the data=order mode to
>> ensure that the zeroed EOF block data is written before updating
>> i_disksize, thus preventing stale data from being exposed.
>>
>> However, the iomap buffered I/O path cannot use this mechanism. Instead,
>> we issue the I/O immediately after performing the zero operation
>> (without synchronous waiting for performance). This can reduce the risk
>> of exposing stale data, but it does not guarantee that the zero data
>> will be flushed to disk before the metadata of i_disksize is updated.
>> The subsequent patches will wait for this I/O to complete before
>> updating i_disksize.
>>
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> I think we discussed that we may not need to do this [1] but I guess
> you've decided to make the tradeoff of issuing the IO to avoid having to
> wait for bg flush to complete the tail page zeroing 
> 

Yes. For truncate up and append fallocate, originally i_disksize would
be updated immediately, and the change would be persisted via the
journal within default 5 seconds. But now, if the tail page is not
committed immediately, the update to i_disksize will be delayed by about
30 seconds, and persistence will be postponed to around 35 seconds. I'm
not sure what impact this change might have — I just don't really want
to introduce it.

For normal append writes, the impact is minimal, unless we call
sync_range to sync the portion of data that extends beyond EOF.

In addition, if the zeroed page is not issued here immediately, the
logic will become more complex because we need to more careful about the
order of write-back IOs to prevent deadlock issues caused by mutual
waiting.

> However, I think one side effect might be many threads calling the
> writeback mechanism to issue zero IOs which might not scale well. I
> don't know if it'll be a huge problem though, I guess it's a sort of
> thing we will have to deal with in case we see it in real world
> workloads.
> 

I agree with you. However, I suspect that unless we run some specific
benchmark tests, it should be difficult to encounter a large number of
post-EOF append writes and truncate up operations in real-world usage
scenarios — and I haven't come across such scenarios yet. For
simplicity, I'd like to proceed with this implementation for now. If we
do run into actual problems later, we can consider not issuing I/O
directly here, but instead: 1) find the ordered block in
ext4_sync_file() and perform writeback; 2) ensure writeback ordering
for normal background writeback as well — otherwise, there is a risk of
deadlock (mutual waiting). What do you think?

Cheers,
Yi.

> [1] https://lore.kernel.org/linux-ext4/yhy4cgc4fnk7tzfejuhy6m6ljo425ebpg6khss6vtvpidg6lyp@5xcyabxrl6zm/
> 
>> ---
>>  fs/ext4/inode.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 55 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 239d387ffaf2..e013aeb03d7b 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4742,6 +4742,32 @@ static int ext4_block_zero_range(struct inode *inode,
>>  					zero_written);
>>  }
>>  
>> +static int ext4_iomap_submit_zero_block(struct inode *inode,
>> +					loff_t from, loff_t end)
>> +{
>> +	struct address_space *mapping = inode->i_mapping;
>> +	struct folio *folio;
>> +	bool do_submit = false;
>> +
>> +	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
>> +	if (IS_ERR(folio))
>> +		/* Already writeback and clear? */
>> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
>> +
>> +	folio_wait_writeback(folio);
>> +	WARN_ON_ONCE(folio_test_writeback(folio));
>> +
>> +	if (likely(folio_test_dirty(folio)))
>> +		do_submit = true;
>> +	folio_unlock(folio);
>> +	folio_put(folio);
>> +
>> +	/* Submit zeroed block. */
>> +	if (do_submit)
>> +		return filemap_fdatawrite_range(mapping, from, end - 1);
>> +	return 0;
>> +}
>> +
>>  /*
>>   * Zero out a mapping from file offset 'from' up to the end of the block
>>   * which corresponds to 'from' or to the given 'end' inside this block.
>> @@ -4765,8 +4791,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>  	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>>  		return 0;
>>  
>> -	if (length > blocksize - offset)
>> +	if (length > blocksize - offset) {
>>  		length = blocksize - offset;
>> +		end = from + length;
>> +	}
>>  
>>  	err = ext4_block_zero_range(inode, from, length,
>>  				    &did_zero, &zero_written);
>> @@ -4781,18 +4809,34 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>  	 * TODO: In the iomap path, handle this by updating i_disksize to
>>  	 * i_size after the zeroed data has been written back.
>>  	 */
>> -	if (ext4_should_order_data(inode) &&
>> -	    did_zero && zero_written && !IS_DAX(inode)) {
>> -		handle_t *handle;
>> +	if (did_zero && zero_written && !IS_DAX(inode)) {
>> +		if (ext4_should_order_data(inode)) {
>> +			handle_t *handle;
>>  
>> -		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>> -		if (IS_ERR(handle))
>> -			return PTR_ERR(handle);
>> +			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>> +			if (IS_ERR(handle))
>> +				return PTR_ERR(handle);
>>  
>> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
>> -		ext4_journal_stop(handle);
>> -		if (err)
>> -			return err;
>> +			err = ext4_jbd2_inode_add_write(handle, inode, from,
>> +							length);
>> +			ext4_journal_stop(handle);
>> +			if (err)
>> +				return err;
>> +		/*
>> +		 * inodes using the iomap buffered I/O path do not use the
>> +		 * data=ordered mode. We submit zeroed range directly here.
>> +		 * Do not wait for I/O completion for performance.
>> +		 *
>> +		 * TODO: Any operation that extends i_disksize (including
>> +		 * append write end io past the zeroed boundary, truncate up,
>> +		 * and append fallocate) must wait for the relevant I/O to
>> +		 * complete before updating i_disksize.
>> +		 */
>> +		} else if (ext4_inode_buffered_iomap(inode)) {
>> +			err = ext4_iomap_submit_zero_block(inode, from, end);
>> +			if (err)
>> +				return err;
>> +		}
>>  	}
>>  
>>  	return 0;
>> -- 
>> 2.52.0
>>

