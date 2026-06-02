Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E649C281530
	for <linux-ext4@vger.kernel.org>; Tue,  2 Jun 2026 03:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780371415; cv=none; b=FMhjaPMZmau9SufcmsiYgqZExAuI2UHnQnCgiln3m9x0rMYvuQ8X6ioCQ1aYPCT6EHJXFbrC8Geh9UEaqmb/ThNmTJjK+OXstaROl8hlB5a2rTW70lC2Ev6XQinqwmj5fs/Kw5R12k1xkaa3EorsSuIFBeGUScgg8WPelDD8fKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780371415; c=relaxed/simple;
	bh=HzWrcZRhikyHZO1KQuR2xxSU98C+sfJR/pfcFElNOlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XRq/+7460rqE3n1w4lkr7mpIGBfaluBNj/QB0QfxwOuVF6Qc7Tr3QvO+sn2WKjbqqGR6D+C4aiUjpmKxq3WmDlGziwVYa359yuSBmkWOHeJ+4tA22g4h3Wr2LOTJJADPwbxE3uChkQCPBGgZPaCHlxpCgNewtU0rZV7s9OR/VeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d7eswxus; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d7eswxus"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36b9b15af73so4598912a91.0
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2026 20:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780371413; x=1780976213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8HrFhQYOL+V2Ix8YLj7ZYbBUgXAeeOEX4rxh1Y4PXgY=;
        b=d7eswxusJFeCSdKceCC4XIx3Yq0qRE6OIO6NAIy+g/yb36gHAA2/AHNwCdk00j29s3
         CY7UPlhSWOGunUbRG1jilbUbAKN+TOzZH3NOlD/wm5zDzgfldatrORM6Fc9W47fn35OE
         yQF2Hp0AA4jAXuuYjg0eoJ7Us4/Dlakk775Bo0iNZK58JmsrqD2jRZ6aL9y7Mv4RQXjW
         wEhH/wTHno2h7plkDVtpkxo9K+FganVUI6me3l45Jy4I8bn0q71Bi+XOP064q9VHYw91
         +T65F3wOYcOTJBp90GGP+H0iuIPeYzcmGncyEyFzCn6Gd5pXV2a/LSP+g3jMzqa62ign
         fDkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780371413; x=1780976213;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8HrFhQYOL+V2Ix8YLj7ZYbBUgXAeeOEX4rxh1Y4PXgY=;
        b=An4Zgn0IOgIiTKLEVBuA7expKAvQqP0kTBfAkYnTq7oULB0+2h19w8Dz3OzUnXLSmD
         mIakkgorbNblpYSkN6OTLB7lrEYvTSBzSWHoqGCWydKg3A1E2q+jXuKtId9HUdq+HRZK
         JrX22CSL8ectTc+6Yefl2rFIF5DCTYqlpw+vpcB9oxHnMNQ0B7YSDgxw9SgRLBw92JwF
         OStKYqAxtdedDauwRB2kIcmGhfDKcFvFdTwKpG1HOzUU0OZB/gVNYE+yeED9HmvQOLzQ
         nvyHZ0UPQPUxRhsth2tj+4PCiJ+2pw7GPCigNqnvTCP5Q1F69597x7uN2FbEeQ6qi1my
         JN8Q==
X-Forwarded-Encrypted: i=1; AFNElJ84x6CmOK2kmQ5HwSE4CAqEhKTn8DDY+sn9krbTqQ087+D6aOYkxzp1QjSSQH+sTg/n5zLBWoeSjQ+M@vger.kernel.org
X-Gm-Message-State: AOJu0YwLX9x/dPQdbCeobkEw0ojOoBZ/Sl/BNytr06nKS3FrUriofVxU
	TwbLph1kX10xnuCwl3vqW6CfzJEVUUCKLOEKb4WBKqba9graVrwET0U+
X-Gm-Gg: Acq92OEKklxOYpRXCa7PSRJgojTd3QQUjpPrBsA+igIXXF7hvIDpAEM2yEVEENFGieg
	SCJYM3IEc85rQ2pLu9EtpmzwlBIIYqFceLlf4s5cjGhYo2miimW0EBtT8WmARETjF2vza9bTcFz
	akgXbUj3rxDxC96IwSEnpqkRgCPE+vy/Qt/eXfUtWpwS2krLxp/JjG9bnGvoYcJeLvSTqDJwZzO
	6BWOTw/v6Wrsubw2bjnFDL1i9jsiHoC0LIXYORJEK17+4P5vreKoWs++6GuKoDVR3A31SXVWQsz
	0647VjqDFV27KxT/H5LcBsRVaduz/3qnMdcpZEycApfvB+Zpa5MKr0dspNov1QQDtjcVI/wf/Ig
	wum5/P9OQFR2ay1Sm0ut2wWh4qHZauXInj25xgV/ry9sRAKUHLcR/mjYezCji+sIjrWytDxMWmZ
	zzz2eWyRdnCUkYaF+kXfniy+B2PBsDUYj29GWS7dYjQCvZv1KmM/yi6w==
X-Received: by 2002:a17:90b:2f46:b0:36b:bb66:fbc3 with SMTP id 98e67ed59e1d1-36c4ff25303mr12651419a91.4.1780371413088;
        Mon, 01 Jun 2026 20:36:53 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36dd92029d5sm1212578a91.13.2026.06.01.20.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 20:36:52 -0700 (PDT)
Message-ID: <d09da737-eea4-4b9a-8f25-faac50758528@gmail.com>
Date: Tue, 2 Jun 2026 11:36:38 +0800
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
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-18-yi.zhang@huaweicloud.com>
 <ahb0fqVCige08_--@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7c24dc47-0c3e-4ee9-b113-f9ca9f3a6ebf@huaweicloud.com>
 <ah1MG1b89ELKM-Fl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <cc458b0f-4637-4313-a2cd-45db4cdaa250@gmail.com>
 <ah3MR1gYMm3nKe5f@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <ah3MR1gYMm3nKe5f@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/2/2026 2:15 AM, Ojaswin Mujoo wrote:
> On Mon, Jun 01, 2026 at 08:22:09PM +0800, Zhang Yi wrote:
>> On 6/1/2026 5:08 PM, Ojaswin Mujoo wrote:
>>> On Sat, May 30, 2026 at 10:53:24AM +0800, Zhang Yi wrote:
>>>> On 5/27/2026 9:41 PM, Ojaswin Mujoo wrote:
>>>>> On Mon, May 11, 2026 at 03:23:37PM +0800, Zhang Yi wrote:
>>>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>>>
>>>>>> In the generic buffered_head I/O path, we rely on the data=order mode to
>>>>>> ensure that the zeroed EOF block data is written before updating
>>>>>> i_disksize, thus preventing stale data from being exposed.
>>>>>>
>>>>>> However, the iomap buffered I/O path cannot use this mechanism. Instead,
>>>>>> we issue the I/O immediately after performing the zero operation
>>>>>> (without synchronous waiting for performance). This can reduce the risk
>>>>>> of exposing stale data, but it does not guarantee that the zero data
>>>>>> will be flushed to disk before the metadata of i_disksize is updated.
>>>>>> The subsequent patches will wait for this I/O to complete before
>>>>>> updating i_disksize.
>>>>>>
>>>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>>>
>>>>> I think we discussed that we may not need to do this [1] but I guess
>>>>> you've decided to make the tradeoff of issuing the IO to avoid having to
>>>>> wait for bg flush to complete the tail page zeroing
>>>>>
>>
>> I'm glad to hear that, thanks.
>>
>>>>
>>>> Yes. For truncate up and append fallocate, originally i_disksize would
>>>> be updated immediately, and the change would be persisted via the
>>>> journal within default 5 seconds. But now, if the tail page is not
>>>> committed immediately, the update to i_disksize will be delayed by about
>>>> 30 seconds, and persistence will be postponed to around 35 seconds. I'm
>>>> not sure what impact this change might have — I just don't really want
>>>> to introduce it.
>>>
>>>> For normal append writes, the impact is minimal, unless we call
>>>> sync_range to sync the portion of data that extends beyond EOF.
>>>
>>> Hmm while trying to retain the behavior for falloc and truncate up,
>>> we end up changing it for append writes :) But anyways, I understand
>>> your reasoning and don't have any strong opinions against it. I'll let
>>> Jan pitch in since he had some comments around this.
>>>
>>>>
>>>> In addition, if the zeroed page is not issued here immediately, the
>>>> logic will become more complex because we need to more careful about the
>>>> order of write-back IOs to prevent deadlock issues caused by mutual
>>>> waiting.
>>>
>>> You mean an endio completion waiting for ordered IO to complete but
>>> ordered IO writeback is somehow waiting for this endio completion? Is that
>>> actually possible?
>>
>> Well, after thinking it over more carefully, it seems this is
>> impossible, I cannot think of a scenario that could trigger this kind of
>> issue. The generic writeback process always executes writeback in folio
>> index order, so there would be no situation where a later data I/O
>> depends on an earlier ordered I/O. Even if both kinds of IOs are placed
>> in the same ioend, there should be no problem. I was confused and
>> overthinking it.
>>
>>  From this perspective, if we can accept that truncate up and fallocate
>> will have longer persistence time by default(I guess this is
>> acceptable), we can avoid writing back zeroed data immediately. To
>> achieve this, we only need to consider the case of sync file range. :-)
> 
> Yeah, I think during writeback we will have to submit the ordered data
> if we are writing back data beyond the i_disksize.
> 
> If this is straightforward enough to implement, I think this approach
> would be a safer choice cause we will avoid overheads due to small,
> random ordered IOs overworking the writeback layer.

Indeed, Let me investigate further to ensure there are no other side
effects.

Thanks,
Yi.

> 
>>
>> Regards,
>> Yi.
>>>>
>>>>> However, I think one side effect might be many threads calling the
>>>>> writeback mechanism to issue zero IOs which might not scale well. I
>>>>> don't know if it'll be a huge problem though, I guess it's a sort of
>>>>> thing we will have to deal with in case we see it in real world
>>>>> workloads.
>>>>>
>>>>
>>>> I agree with you. However, I suspect that unless we run some specific
>>>> benchmark tests, it should be difficult to encounter a large number of
>>>> post-EOF append writes and truncate up operations in real-world usage
>>>> scenarios — and I haven't come across such scenarios yet. For
>>>> simplicity, I'd like to proceed with this implementation for now. If we
>>>> do run into actual problems later, we can consider not issuing I/O
>>>> directly here, but instead: 1) find the ordered block in
>>>> ext4_sync_file() and perform writeback; 2) ensure writeback ordering
>>>> for normal background writeback as well — otherwise, there is a risk of
>>>> deadlock (mutual waiting). What do you think?
>>>
>>> Yes sounds good Yi, we can deal with performance tuning later.
>>>
>>> Regards,
>>> Ojaswin
>>>
>>>>
>>>> Cheers,
>>>> Yi.
>>>>
>>>>> [1] https://lore.kernel.org/linux-ext4/yhy4cgc4fnk7tzfejuhy6m6ljo425ebpg6khss6vtvpidg6lyp@5xcyabxrl6zm/
>>>>>
>>>>>> ---
>>>>>>    fs/ext4/inode.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
>>>>>>    1 file changed, 55 insertions(+), 11 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>>>> index 239d387ffaf2..e013aeb03d7b 100644
>>>>>> --- a/fs/ext4/inode.c
>>>>>> +++ b/fs/ext4/inode.c
>>>>>> @@ -4742,6 +4742,32 @@ static int ext4_block_zero_range(struct inode *inode,
>>>>>>    					zero_written);
>>>>>>    }
>>>>>> +static int ext4_iomap_submit_zero_block(struct inode *inode,
>>>>>> +					loff_t from, loff_t end)
>>>>>> +{
>>>>>> +	struct address_space *mapping = inode->i_mapping;
>>>>>> +	struct folio *folio;
>>>>>> +	bool do_submit = false;
>>>>>> +
>>>>>> +	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
>>>>>> +	if (IS_ERR(folio))
>>>>>> +		/* Already writeback and clear? */
>>>>>> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
>>>>>> +
>>>>>> +	folio_wait_writeback(folio);
>>>>>> +	WARN_ON_ONCE(folio_test_writeback(folio));
>>>>>> +
>>>>>> +	if (likely(folio_test_dirty(folio)))
>>>>>> +		do_submit = true;
>>>>>> +	folio_unlock(folio);
>>>>>> +	folio_put(folio);
>>>>>> +
>>>>>> +	/* Submit zeroed block. */
>>>>>> +	if (do_submit)
>>>>>> +		return filemap_fdatawrite_range(mapping, from, end - 1);
>>>>>> +	return 0;
>>>>>> +}
>>>>>> +
>>>>>>    /*
>>>>>>     * Zero out a mapping from file offset 'from' up to the end of the block
>>>>>>     * which corresponds to 'from' or to the given 'end' inside this block.
>>>>>> @@ -4765,8 +4791,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>>>>>    	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>>>>>>    		return 0;
>>>>>> -	if (length > blocksize - offset)
>>>>>> +	if (length > blocksize - offset) {
>>>>>>    		length = blocksize - offset;
>>>>>> +		end = from + length;
>>>>>> +	}
>>>>>>    	err = ext4_block_zero_range(inode, from, length,
>>>>>>    				    &did_zero, &zero_written);
>>>>>> @@ -4781,18 +4809,34 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>>>>>    	 * TODO: In the iomap path, handle this by updating i_disksize to
>>>>>>    	 * i_size after the zeroed data has been written back.
>>>>>>    	 */
>>>>>> -	if (ext4_should_order_data(inode) &&
>>>>>> -	    did_zero && zero_written && !IS_DAX(inode)) {
>>>>>> -		handle_t *handle;
>>>>>> +	if (did_zero && zero_written && !IS_DAX(inode)) {
>>>>>> +		if (ext4_should_order_data(inode)) {
>>>>>> +			handle_t *handle;
>>>>>> -		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>>>>> -		if (IS_ERR(handle))
>>>>>> -			return PTR_ERR(handle);
>>>>>> +			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>>>>> +			if (IS_ERR(handle))
>>>>>> +				return PTR_ERR(handle);
>>>>>> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
>>>>>> -		ext4_journal_stop(handle);
>>>>>> -		if (err)
>>>>>> -			return err;
>>>>>> +			err = ext4_jbd2_inode_add_write(handle, inode, from,
>>>>>> +							length);
>>>>>> +			ext4_journal_stop(handle);
>>>>>> +			if (err)
>>>>>> +				return err;
>>>>>> +		/*
>>>>>> +		 * inodes using the iomap buffered I/O path do not use the
>>>>>> +		 * data=ordered mode. We submit zeroed range directly here.
>>>>>> +		 * Do not wait for I/O completion for performance.
>>>>>> +		 *
>>>>>> +		 * TODO: Any operation that extends i_disksize (including
>>>>>> +		 * append write end io past the zeroed boundary, truncate up,
>>>>>> +		 * and append fallocate) must wait for the relevant I/O to
>>>>>> +		 * complete before updating i_disksize.
>>>>>> +		 */
>>>>>> +		} else if (ext4_inode_buffered_iomap(inode)) {
>>>>>> +			err = ext4_iomap_submit_zero_block(inode, from, end);
>>>>>> +			if (err)
>>>>>> +				return err;
>>>>>> +		}
>>>>>>    	}
>>>>>>    	return 0;
>>>>>> -- 
>>>>>> 2.52.0
>>>>>>
>>>>
>>

