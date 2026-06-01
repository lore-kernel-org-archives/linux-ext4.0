Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C27B3750BC
	for <linux-ext4@vger.kernel.org>; Mon,  1 Jun 2026 12:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780316550; cv=none; b=ncicLsAX7wZJ++KHWxCkzUnXNUfmQ5cH9J+IlmNX46k5zyIICxrVkezQqQRprPvWg/fR4Id3yGWkj84wcof506gOVldKfo5BrR92/ixUhVy2B3hV3x3AsGV6SsEAIxBUZu7ReFDwZVedX4WL+maeEilP2NOXSiDpzyp9Fgjnusw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780316550; c=relaxed/simple;
	bh=qr+ZADQdTtreyNtYLYbmfGb5sfBUNGgMCIB7iGepugc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BFGrBTnGlb/sOUo1qjy1JKViqpDfHq9hXzJPS+EMPy6k3kyBG3dkL1f9bhNlexUGAhOGQK/G57IzF8sOexRZa3f6TRPaoh1pmDXMHVcM++eVWc4RO/6Afyah2AvT74++eZ5M2Mr+WaiPK2T7WM48DASMaJL4PI1vfBFf0KGqPCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2xvZa4M; arc=none smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2xvZa4M"
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-6607e80a846so817585d50.2
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2026 05:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780316548; x=1780921348; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xOJ0/eEH4HV7V4yICSstAKsuloY/M8S0cVa3XNBBW3w=;
        b=D2xvZa4MvCstbhRxnrui7NlhcFWsegqgBUEdM/duHgaocCWuI6yErQVT7aTQY+FQHV
         nzPtCTKxMOCZVysrdoM1CiPyYwhLtTzaQftSgC8oSEG//fJ9TccaJVC58nR43GpVOnse
         mQTCoH3+8u30LZMa0fHtMkd7e0eOMP6hybg0EnjOelnNf6zociv9rOS/Xa41DQg0uBgO
         TFZ/2h+7kREC92OEAo6zT20dE2QHj05L2s/6g/ajy/6xCWmIZrnwJtvll5zvuVUQDnh4
         GuQ61DeSp4OZSirzoHcAQ/iBCuAKFFzjcphNAsRaM5EyG8fKHS8d7fsJtWVRHnlBwF9n
         AMZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780316548; x=1780921348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xOJ0/eEH4HV7V4yICSstAKsuloY/M8S0cVa3XNBBW3w=;
        b=ekNDWdonvpYoRj5Tb1QWU34FNPRZZffvoAZHVTPorFYCxrlxZaJdgprK72juLdVHWc
         LzSKwbGiXY8AKJ+IYyMVVyN43DZ2dJzC1TzP6gEi1nrKpGN3cqWMLFjpU40wldrE7vLM
         bHJ2/byTQolBZFDA31yccgIRkkL63igMMT5EbNHuqunbKXVU4P0oirPCMOpS2ZVvlIkq
         USPF7W/Ye3drOdcutWhMyfOEc6IM2f4movkzXlq0FdUCyZHNC/kpVCOySp24oR4rXXxy
         x8hdxJF1/BhBIZOMGxhPn0vinsrb42cjSk7LxJXG6CHuXOnAwXxqVgUKUAnSEH0Zb7de
         4C+Q==
X-Gm-Message-State: AOJu0Yxpcf/ylvbzEOKl94unDAHPTqQ+WKMPhc/yBHMxg4rAedKumLzQ
	tz/YVK01HeDwArDckeLmzZ3qA4hPdCrf0lumY3or14uoqaaqzvyuk8US
X-Gm-Gg: Acq92OGwVwE0pqDWMe1DGUvlULX0qdpTPsPQ298Ic7ya7rEirHd1JNkvzgzLO1SB+f0
	7eQpo0H8eC3i8kSakpZRXTG7jWEOaocwez9+Jy0yt5d1e8QgUoiU/gG2h0AJw0altA8OFm+QLQr
	lDPzQEU+jyouOU/CkQb6zLiw8oP6uDMSsQus3R0lWSWN0QErVmZ4zJoSlVDi9NuAMS3/YGcPCrh
	8Q9ARA/Fb9nm1jNizRWz0EUTfLyyOI7LBrbJK+o72SFEr4JE9wQnNE3S84xEji6jzz9R5zolV5o
	BNsQaSotyyeKrn4dr6o/Qd4AD/0r+/4SqftaO79SDnMkMaViC6ogVKUgqV6FhOuURCwuwA8sXB4
	m8gR7bwUOLwOfrNXH5ln2ruVtA+XvWzucfxHt1GjU/ZBNjA3Ridx6Fbr+CsSRP2iOIJ7x3Nih1N
	hzoKCBb1r44oVhvozuoB9Rf8aKEcMqiZAwUo8uY8M75O5lbvvPzwBOTg==
X-Received: by 2002:a05:690e:1687:b0:65d:7ffc:bcdd with SMTP id 956f58d0204a3-6605f03c2d9mr8168943d50.25.1780316548267;
        Mon, 01 Jun 2026 05:22:28 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6606999de08sm3527011d50.15.2026.06.01.05.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 05:22:27 -0700 (PDT)
Message-ID: <cc458b0f-4637-4313-a2cd-45db4cdaa250@gmail.com>
Date: Mon, 1 Jun 2026 20:22:09 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/23] ext4: submit zeroed post-EOF data immediately in
 the iomap buffered I/O path
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-18-yi.zhang@huaweicloud.com>
 <ahb0fqVCige08_--@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7c24dc47-0c3e-4ee9-b113-f9ca9f3a6ebf@huaweicloud.com>
 <ah1MG1b89ELKM-Fl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <ah1MG1b89ELKM-Fl@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/1/2026 5:08 PM, Ojaswin Mujoo wrote:
> On Sat, May 30, 2026 at 10:53:24AM +0800, Zhang Yi wrote:
>> On 5/27/2026 9:41 PM, Ojaswin Mujoo wrote:
>>> On Mon, May 11, 2026 at 03:23:37PM +0800, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> In the generic buffered_head I/O path, we rely on the data=order mode to
>>>> ensure that the zeroed EOF block data is written before updating
>>>> i_disksize, thus preventing stale data from being exposed.
>>>>
>>>> However, the iomap buffered I/O path cannot use this mechanism. Instead,
>>>> we issue the I/O immediately after performing the zero operation
>>>> (without synchronous waiting for performance). This can reduce the risk
>>>> of exposing stale data, but it does not guarantee that the zero data
>>>> will be flushed to disk before the metadata of i_disksize is updated.
>>>> The subsequent patches will wait for this I/O to complete before
>>>> updating i_disksize.
>>>>
>>>> Suggested-by: Jan Kara <jack@suse.cz>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>
>>> I think we discussed that we may not need to do this [1] but I guess
>>> you've decided to make the tradeoff of issuing the IO to avoid having to
>>> wait for bg flush to complete the tail page zeroing
>>>

I'm glad to hear that, thanks.

>>
>> Yes. For truncate up and append fallocate, originally i_disksize would
>> be updated immediately, and the change would be persisted via the
>> journal within default 5 seconds. But now, if the tail page is not
>> committed immediately, the update to i_disksize will be delayed by about
>> 30 seconds, and persistence will be postponed to around 35 seconds. I'm
>> not sure what impact this change might have — I just don't really want
>> to introduce it.
> 
>> For normal append writes, the impact is minimal, unless we call
>> sync_range to sync the portion of data that extends beyond EOF.
> 
> Hmm while trying to retain the behavior for falloc and truncate up,
> we end up changing it for append writes :) But anyways, I understand
> your reasoning and don't have any strong opinions against it. I'll let
> Jan pitch in since he had some comments around this.
> 
>>
>> In addition, if the zeroed page is not issued here immediately, the
>> logic will become more complex because we need to more careful about the
>> order of write-back IOs to prevent deadlock issues caused by mutual
>> waiting.
> 
> You mean an endio completion waiting for ordered IO to complete but
> ordered IO writeback is somehow waiting for this endio completion? Is that
> actually possible?

Well, after thinking it over more carefully, it seems this is
impossible, I cannot think of a scenario that could trigger this kind of
issue. The generic writeback process always executes writeback in folio
index order, so there would be no situation where a later data I/O
depends on an earlier ordered I/O. Even if both kinds of IOs are placed
in the same ioend, there should be no problem. I was confused and 
overthinking it.

 From this perspective, if we can accept that truncate up and fallocate
will have longer persistence time by default(I guess this is
acceptable), we can avoid writing back zeroed data immediately. To
achieve this, we only need to consider the case of sync file range. :-)

Regards,
Yi.
>>
>>> However, I think one side effect might be many threads calling the
>>> writeback mechanism to issue zero IOs which might not scale well. I
>>> don't know if it'll be a huge problem though, I guess it's a sort of
>>> thing we will have to deal with in case we see it in real world
>>> workloads.
>>>
>>
>> I agree with you. However, I suspect that unless we run some specific
>> benchmark tests, it should be difficult to encounter a large number of
>> post-EOF append writes and truncate up operations in real-world usage
>> scenarios — and I haven't come across such scenarios yet. For
>> simplicity, I'd like to proceed with this implementation for now. If we
>> do run into actual problems later, we can consider not issuing I/O
>> directly here, but instead: 1) find the ordered block in
>> ext4_sync_file() and perform writeback; 2) ensure writeback ordering
>> for normal background writeback as well — otherwise, there is a risk of
>> deadlock (mutual waiting). What do you think?
> 
> Yes sounds good Yi, we can deal with performance tuning later.
> 
> Regards,
> Ojaswin
> 
>>
>> Cheers,
>> Yi.
>>
>>> [1] https://lore.kernel.org/linux-ext4/yhy4cgc4fnk7tzfejuhy6m6ljo425ebpg6khss6vtvpidg6lyp@5xcyabxrl6zm/
>>>
>>>> ---
>>>>   fs/ext4/inode.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
>>>>   1 file changed, 55 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index 239d387ffaf2..e013aeb03d7b 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -4742,6 +4742,32 @@ static int ext4_block_zero_range(struct inode *inode,
>>>>   					zero_written);
>>>>   }
>>>>   
>>>> +static int ext4_iomap_submit_zero_block(struct inode *inode,
>>>> +					loff_t from, loff_t end)
>>>> +{
>>>> +	struct address_space *mapping = inode->i_mapping;
>>>> +	struct folio *folio;
>>>> +	bool do_submit = false;
>>>> +
>>>> +	folio = filemap_lock_folio(mapping, from >> PAGE_SHIFT);
>>>> +	if (IS_ERR(folio))
>>>> +		/* Already writeback and clear? */
>>>> +		return PTR_ERR(folio) == -ENOENT ? 0 : PTR_ERR(folio);
>>>> +
>>>> +	folio_wait_writeback(folio);
>>>> +	WARN_ON_ONCE(folio_test_writeback(folio));
>>>> +
>>>> +	if (likely(folio_test_dirty(folio)))
>>>> +		do_submit = true;
>>>> +	folio_unlock(folio);
>>>> +	folio_put(folio);
>>>> +
>>>> +	/* Submit zeroed block. */
>>>> +	if (do_submit)
>>>> +		return filemap_fdatawrite_range(mapping, from, end - 1);
>>>> +	return 0;
>>>> +}
>>>> +
>>>>   /*
>>>>    * Zero out a mapping from file offset 'from' up to the end of the block
>>>>    * which corresponds to 'from' or to the given 'end' inside this block.
>>>> @@ -4765,8 +4791,10 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>>>   	if (IS_ENCRYPTED(inode) && !fscrypt_has_encryption_key(inode))
>>>>   		return 0;
>>>>   
>>>> -	if (length > blocksize - offset)
>>>> +	if (length > blocksize - offset) {
>>>>   		length = blocksize - offset;
>>>> +		end = from + length;
>>>> +	}
>>>>   
>>>>   	err = ext4_block_zero_range(inode, from, length,
>>>>   				    &did_zero, &zero_written);
>>>> @@ -4781,18 +4809,34 @@ int ext4_block_zero_eof(struct inode *inode, loff_t from, loff_t end)
>>>>   	 * TODO: In the iomap path, handle this by updating i_disksize to
>>>>   	 * i_size after the zeroed data has been written back.
>>>>   	 */
>>>> -	if (ext4_should_order_data(inode) &&
>>>> -	    did_zero && zero_written && !IS_DAX(inode)) {
>>>> -		handle_t *handle;
>>>> +	if (did_zero && zero_written && !IS_DAX(inode)) {
>>>> +		if (ext4_should_order_data(inode)) {
>>>> +			handle_t *handle;
>>>>   
>>>> -		handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>>> -		if (IS_ERR(handle))
>>>> -			return PTR_ERR(handle);
>>>> +			handle = ext4_journal_start(inode, EXT4_HT_MISC, 1);
>>>> +			if (IS_ERR(handle))
>>>> +				return PTR_ERR(handle);
>>>>   
>>>> -		err = ext4_jbd2_inode_add_write(handle, inode, from, length);
>>>> -		ext4_journal_stop(handle);
>>>> -		if (err)
>>>> -			return err;
>>>> +			err = ext4_jbd2_inode_add_write(handle, inode, from,
>>>> +							length);
>>>> +			ext4_journal_stop(handle);
>>>> +			if (err)
>>>> +				return err;
>>>> +		/*
>>>> +		 * inodes using the iomap buffered I/O path do not use the
>>>> +		 * data=ordered mode. We submit zeroed range directly here.
>>>> +		 * Do not wait for I/O completion for performance.
>>>> +		 *
>>>> +		 * TODO: Any operation that extends i_disksize (including
>>>> +		 * append write end io past the zeroed boundary, truncate up,
>>>> +		 * and append fallocate) must wait for the relevant I/O to
>>>> +		 * complete before updating i_disksize.
>>>> +		 */
>>>> +		} else if (ext4_inode_buffered_iomap(inode)) {
>>>> +			err = ext4_iomap_submit_zero_block(inode, from, end);
>>>> +			if (err)
>>>> +				return err;
>>>> +		}
>>>>   	}
>>>>   
>>>>   	return 0;
>>>> -- 
>>>> 2.52.0
>>>>
>>

