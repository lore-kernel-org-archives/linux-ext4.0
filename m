Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B55A3385B6
	for <linux-ext4@vger.kernel.org>; Mon, 22 Jun 2026 03:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782099513; cv=none; b=BJpuHHTLaDeN40jgj97Xl4EKNX9pC2oYqRu4vekw97darmaEH4dORbJO9eVH+sxhNrCCx7HNVBK9k6PsZNB7YqyEhgMp/ZzExdqriySC6Qj8ciGr6HvdPJFCnPmLexHauRanhcPumGzLjfBzUPcgJ8+MhpeI0dkhYak92RrQ1Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782099513; c=relaxed/simple;
	bh=H7afWWfu5uNgSXx2NriXLdmoV25KtPtAlIU98HeDlxI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8dcKddBqf7RtFrqqJX3UrBcYzNbwsrYsMgjoBlIjAbQ4ZTKBFHJoM9VV7Mn9xNgZ/WAJHaX/E+U34x/me99qkFZxtJXzJIlC/1KWQxc6jmHcAoyZUz3Q1YXNp7dcPRBT2L5ipJeVHj7qV7G7wGzfCfhwE8sjJFbYCwJzuSwnW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DfOwVPGj; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DfOwVPGj"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-845438a46d4so1918487b3a.3
        for <linux-ext4@vger.kernel.org>; Sun, 21 Jun 2026 20:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782099511; x=1782704311; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N290XLoNQNDnfT2OryzZL0nfNOdWYLd50pEyDauXty8=;
        b=DfOwVPGjId50Y1C1odLRE/i6mUD5uSFSbjWR/Tp85fv6xUBCk8Ug5qkFieYhUMGSkc
         re1cTIJF22BeVBVn9ie/vvatkasrjA9o9oc7LFvRnaBJ39zs/jBML/nfD8x1BIZnplxG
         Gn+cKpb+/QqOiwBQJj4kySpL4ErVQzYMhouR7VerNKilUFjJ+kM5jwElGeFtjKwNrndi
         9z4FZezyrFDqZfGIV+MDVIFJXruurO/r02dTbkiRfK2e4F2XaMruKj8D9fEg4oQ+freo
         mcGHMTHQJmSNn6VXEpBEdSav5Cu9Jly8m735LQwXAtKG2Y9G8al0hefo5iDvLNPR7vC3
         8UsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782099511; x=1782704311;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N290XLoNQNDnfT2OryzZL0nfNOdWYLd50pEyDauXty8=;
        b=COoWVFQ1SxLkJlFqy88x/86OHXpCltm/iYfoXAFtiFNE+OSI7GkNUfLzjIoqIDFcGV
         +4ooNrXj7exH3P3MQnmfSaik9XSJDu93lNypwvq1izYZf3uqPTBlfr53qbXOHdU/XAyQ
         xBREEeJkXKESi8BFjeqha1alGB8UCysLMC0DUcETTf1Fp5DCka0pQCJ8zHhDBj+Byd9Q
         QP7l7loCHrkQGGnRKOfVa+LYSP0+APru2EqQU+4FTB/CVzwMKwc9CRE0p3ggtfbwL+IH
         0JWhn4Xv3w2Azwt9yKN8eKJZ8A4rG+oHx0rwZZH6HiQzQnWkEHX5zqxNE7xU5Fln7Nvt
         u8VA==
X-Gm-Message-State: AOJu0YzZ5V2o0E7xvWXVefwOf2iB+jD0amFxMh00GcAp6fIPKtY3cHf0
	An8H6CF21g5XpXm7w7cP3CRoeOiAaI1QDkjZ3B5jw2+ZpSDtdJerCIAA
X-Gm-Gg: AfdE7cmvNjtlgUyzyWCFpTU+EqCmaKmq9gl+4d1v/Uj762QLqLYAWIR8C84h6iCCKqL
	HbckcUcvVwlZjLmVEKijCgcXfOtij6O7FYtYuuF1RLTsQCmXqzDkeKXe4dqwP3WiWdgA847PIv9
	Cb4GeHeNVEhxd+61XqblFzi6dO8SAe2xTBy/f7lyFb7EwvXOagLb8WwVDXOiy5tsKRhAawnM5J3
	0BgiYaCu0DSTH6CoEvlWIMKFwPIKC67hELayweJDfEg0ci8HzuxOnefa2ISWeUzGB9fURdxjfTt
	t5HUU74HVgu5aT4G28brSfk+lkixjKLnx/MhJeg/cw1Pnqrdvk7/uytRZTCo2MFbk55uIGOdSfe
	uVx4P+ya/nh0NfaiEsbH4wxpKyGBFMG06sQ1Wxcoc0trgfBth0HtXkd3S0+RfAGwvXCLfZcIt4J
	aHPf9UcjYs0qEenUS6gLdL82IZUSyM2yYR
X-Received: by 2002:a05:6a20:12d6:b0:39f:9eb3:1d09 with SMTP id adf61e73a8af0-3bb34d6c0dcmr14628591637.37.1782099511339;
        Sun, 21 Jun 2026 20:38:31 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c8bbffc2329sm5721594a12.0.2026.06.21.20.38.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2026 20:38:30 -0700 (PDT)
Message-ID: <70c35fb8-95fa-41c6-a22b-40b680da2a72@gmail.com>
Date: Mon, 22 Jun 2026 11:37:57 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/23] ext4: submit zeroed post-EOF data immediately in
 the iomap buffered I/O path
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-18-yi.zhang@huaweicloud.com>
 <g6jho4eosvuwuaw6sxzvyrahl43vbhuznqtr2fbd2nhukd6a3v@fx5udwaepwrx>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <g6jho4eosvuwuaw6sxzvyrahl43vbhuznqtr2fbd2nhukd6a3v@fx5udwaepwrx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/2026 8:59 PM, Jan Kara wrote:
> On Mon 11-05-26 15:23:37, Zhang Yi wrote:
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
> Two nits below:
> 
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 239d387ffaf2..e013aeb03d7b 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -4742,6 +4742,32 @@ static int ext4_block_zero_range(struct inode *inode,
>>   					zero_written);
>>   }
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
> 		   ^^^ Already written back and reclaimed
> 
>> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
>> +
>> +	folio_wait_writeback(folio);
>> +	WARN_ON_ONCE(folio_test_writeback(folio));
>> +
>> +	if (likely(folio_test_dirty(folio)))
>> +		do_submit = true;
>> +	folio_unlock(folio);
>> +	folio_put(folio);
> 
> So how is what you do here more efficient than just:
> 
> 	filemap_fdatawrite_range(mapping, from, end - 1)
> 
> ? That will also do nothing if the folio isn't dirty, won't it?
> 
> 								Honza

Yeah, we can just call filemap_fdatawrite_range() in this patch. These
logic for locking/unlocking and checking writeback is only needed in
patch 18, and should be moved to a later patch. It is used to avoid
setting ordered block on folios that have already been concurrently
written back. Sorry for confusing.

Thanks,
Yi.

> 
>> +
>> +	/* Submit zeroed block. */
>> +	if (do_submit)
>> +		return filemap_fdatawrite_range(mapping, from, end - 1);
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Zero out a mapping from file offset 'from' up to the end of the block
>>    * which corresponds to 'from' or to the given 'end' inside this block.
>> @@ -4765,8 +4791,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>   	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>>   		return 0;
>>   
>> -	if (length > blocksize - offset)
>> +	if (length > blocksize - offset) {
>>   		length = blocksize - offset;
>> +		end = from + length;
>> +	}
>>   
>>   	err = ext4_block_zero_range(inode, from, length,
>>   				    &did_zero, &zero_written);
>> @@ -4781,18 +4809,34 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>   	 * TODO: In the iomap path, handle this by updating i_disksize to
>>   	 * i_size after the zeroed data has been written back.
>>   	 */
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
>>   	}
>>   
>>   	return 0;
>> -- 
>> 2.52.0
>>

