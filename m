Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290BC3F1AC1
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 13:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781702539; cv=none; b=Sy87ct0Yypxn6JOM7zBF1e81xxkp2YbJ3G4RfvDMjRHghinLz/OZeAj/XkVSs1MBgg1jsK1r4sK6qWuI+TRe2xItkaq2TO4FdYGTgkGQmeomDnV3t0vce19vvvqsTIQsnSWg8TIGo3xFgmcqkcb21ZJHJ7oi3ViSXkxwDkas5Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781702539; c=relaxed/simple;
	bh=cl9Zq1MYYIwqx/qUH20r2SBwJINs5XA50B3Ivl1XHi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cjeMepw/zVi8Gog6CXS+qC/4IbZ2MaZWdalNq6z6RTgQW0bilk6YmNKF5gJB49vFX5jM2o6v90sloLpjBorgg/O38Zns6+j18RmcTxEjarq8XLC0+exNkQScp5tAMJBZLL90Bry6N+KCmXa47z7x4W3B0dSFziF4TWbXoc6g4Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PZkO5XRe; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PZkO5XRe"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2c6ab886da6so9892675ad.0
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 06:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781702536; x=1782307336; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VEWyYTJkFHrNJL0Tf6CUABwXAes876mCeFHO3nb8fr4=;
        b=PZkO5XReUhIo+uFKC1BWc5C2HRdyRHskFUkKqTM/yVU5QcBQKUqIkFvjqmXE6sQES6
         2AimmAsdbiLSl7l5KuAuXiJ6w+IaY9uxwB+18d8fO29yGzUYCSJPi2gmXw2jpcK2meKM
         Oi+CVqSoAHJ7M/i87DmdPqNv1aKFuqH/TYJ6Mf/d/TjQHb2Xv0MSprl9IvHMcFFqmOlS
         Q+yMvxCgU/PgDEchCk8NLnYKm79qDJznoKbHh4ew/2FebJVMo7bOul9CXREzKaiZKXrx
         G76vIkbjRexxeHgGMLnC/3sQnwS9Jkm8q1bXCVPYz2Blymg1Lqpa/t9rOI7CIrMCusHE
         yMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702536; x=1782307336;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VEWyYTJkFHrNJL0Tf6CUABwXAes876mCeFHO3nb8fr4=;
        b=KncMyWNm6KCmfBioayWSCDLPA/7n+MxPS3Hq18+hq89vp7bJpRx2Avxe0b1TIZfah3
         le/7OxTKUDFbmO8LWtD5LVip14VzZKUc9BM5x3tRUqZhC+Nyl6XRvAqJmVI+38LbwLyJ
         CY9vSr3NASQOCbGPIHlYwDLWRAGxqtWWmZuU+IxgS+/R/bL/gz1QQCKNwe0KgzuLyxJF
         ufu2/JCDy+mWLqhdzYJYft/AhmDRlPTwpJaYcg/+XlxYMy7zlZJyoUdUGm7fDpnfhkAE
         s6nyAS9Terrg2kzucHoznocGxdiSs6/9/j1gS3Nh+XRuDjNvnVEyxbDVKDJZOf+SFUR3
         lDbA==
X-Forwarded-Encrypted: i=1; AFNElJ8HdRIhyMoFC/u3oJ/AEj2wnz5YzpEEiwRpK3+SlbVp3TCQxIQws67PAhjGB75zdcfrGU9S1jq8zgoD@vger.kernel.org
X-Gm-Message-State: AOJu0Yza81Bo14Grwn/rIRinYeoFbTxmY8RXJFQH2c5Jv8OPFN7V4Ubs
	X7faByYCbyadsh3vMW+Cet+jhMhkiGMDZJCUUmZ5b/22R3V5Mqbm82ji
X-Gm-Gg: AfdE7cmu7sacQAudgODorefo+4IIRmpEOUILi2bVzlLnDKNTzm4it5E1hTQWTqdZDEU
	rwMgWa373M/7jS4DJEQ7tjYEfx2OVG07ngy4udiTepJqp9+VLNi5s1gZ4dGuYmCl8ncWpWlfLKS
	F6YZn3UST0wz5iVZjNF6n21ZTymeb9jntMj7O0f8vNpmMFokNf7ypN9bDPs8HKhYS2CeZa2rlOw
	xfvMxyPMBnsct3VWrp9G2WfbOiI29gBk2doIB0vrJPP9zmu5PxtzPorqF+BJnib4ZEE5JJFMMQp
	Nqp1lWM9NNzQ4frf23ml1gN62jgZeQeL5UcP3t7pEya7Z8v0vwihLqhYNUO3++MQRH5tdi6y0uL
	RU6MyJ0t45V5p60GqLiLXc4e+T1R6GzSRfss591hTILAsbwAYmNOpFKbJpm8ZdrGDdaesOoACLE
	Q6Zibl6eG8sl0sDKOQ4ERJXu/tJhIpAsWM+YuSyNaCaR7ihAJ8hL/IW41AIsjY9rI=
X-Received: by 2002:a17:903:19ed:b0:2c2:50c7:58a4 with SMTP id d9443c01a7336-2c6bc223ee0mr37937805ad.22.1781702536299;
        Wed, 17 Jun 2026 06:22:16 -0700 (PDT)
Received: from ?IPV6:240e:390:a92:e6d1:ed78:8bd4:5db9:c767? ([240e:390:a92:e6d1:ed78:8bd4:5db9:c767])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c4327acca5sm149502475ad.51.2026.06.17.06.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 06:22:15 -0700 (PDT)
Message-ID: <22315c1e-d13f-440c-b944-138ce4b7caa0@gmail.com>
Date: Wed, 17 Jun 2026 21:22:10 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/23] ext4: implement partial block zero range path
 using iomap
To: Brian Foster <bfoster@redhat.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, djwong@kernel.org, hch@infradead.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, yukuai@fnnas.com
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-15-yi.zhang@huaweicloud.com>
 <c2q54d6u724xctkzwm6x7sbmg5cpvcackfz3toc47qts6iaj77@ci2czn4fqjik>
 <16cccb83-cdad-4113-8182-e8ea9e3049a2@huaweicloud.com>
 <ajJ9b91fTbM6qApg@bfoster>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <ajJ9b91fTbM6qApg@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/17/2026 6:56 PM, Brian Foster wrote:
> On Wed, Jun 17, 2026 at 04:14:40PM +0800, Zhang Yi wrote:
>> On 6/16/2026 8:28 PM, Jan Kara wrote:
>>> On Mon 11-05-26 15:23:34, Zhang Yi wrote:
>>>> From: Zhang Yi <yi.zhang@huawei.com>
>>>>
>>>> Introduce a new iomap_ops instance, ext4_iomap_zero_ops, along with
>>>> ext4_iomap_block_zero_range() to implement block zeroing via the iomap
>>>> infrastructure for ext4.
>>>>
>>>> ext4_iomap_block_zero_range() calls iomap_zero_range() with
>>>> ext4_iomap_zero_begin() as the callback. The callback locates and zeros
>>>> out either a mapped partial block or a dirty, unwritten partial block.
>>>>
>>>> Important constraints:
>>>>
>>>> Zeroing out under an active journal handle can cause deadlock, because
>>>> the order of acquiring the folio lock and starting a handle is
>>>> inconsistent with the iomap writeback path.
>>>>
>>>> Therefore, ext4_iomap_block_zero_range():
>>>> - Must NOT be called under an active handle.
>>>> - Cannot rely on data=ordered mode to ensure zeroed data persistence
>>>>    before updating i_disksize (for the cases of post-EOF append write,
>>>>    post-EOF fallocate, and truncate up). In subsequent patches, we will
>>>>    address this by synchronizing commit I/O but doesn't waiting for
>>>>    completion, and updating i_disksize to i_size only after the zeroed
>>>>    data has been written back.
>>>>
>>>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>>>> ---
>>>>   fs/ext4/inode.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
>>>>   1 file changed, 92 insertions(+)
>>>>
>>>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>>>> index c6fe42d012fc..e0dae2501292 100644
>>>> --- a/fs/ext4/inode.c
>>>> +++ b/fs/ext4/inode.c
>>>> @@ -4101,6 +4101,51 @@ static int ext4_iomap_buffered_da_write_end(struct inode *inode, loff_t offset,
>>>>   	return 0;
>>>>   }
>>>>   
>>>> +static int ext4_iomap_zero_begin(struct inode *inode,
>>>> +		loff_t offset, loff_t length, unsigned int flags,
>>>> +		struct iomap *iomap, struct iomap *srcmap)
>>>> +{
>>>> +	struct iomap_iter *iter = container_of(iomap, struct iomap_iter, iomap);
>>>
>>> This looks like a layering violation to me. I don't think you can safely
>>> assume the iomap you're passed is a part of iomap_iter...
>>>
>>>> +	struct ext4_map_blocks map;
>>>> +	u8 blkbits = inode->i_blkbits;
>>>> +	unsigned int iomap_flags = 0;
>>>> +	int ret;
>>>> +
>>>> +	ret = ext4_emergency_state(inode->i_sb);
>>>> +	if (unlikely(ret))
>>>> +		return ret;
>>>> +
>>>> +	if (WARN_ON_ONCE(!(flags & IOMAP_ZERO)))
>>>> +		return -EINVAL;
>>>> +
>>>> +	ret = ext4_iomap_map_blocks(inode, offset, length, NULL, &map);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	/*
>>>> +	 * Look up dirty folios for unwritten mappings within EOF. Providing
>>>> +	 * this bypasses the flush iomap uses to trigger extent conversion
>>>> +	 * when unwritten mappings have dirty pagecache in need of zeroing.
>>>> +	 */
>>>> +	if (map.m_flags & EXT4_MAP_UNWRITTEN) {
>>>> +		loff_t start = ((loff_t)map.m_lblk) << blkbits;
>>>> +		loff_t end = ((loff_t)map.m_lblk + map.m_len) << blkbits;
>>>> +
>>>> +		iomap_fill_dirty_folios(iter, &start, end, &iomap_flags);
>>>> +		if ((start >> blkbits) < map.m_lblk + map.m_len)
>>>> +			map.m_len = (start >> blkbits) - map.m_lblk;
>>>> +	}
>>>
>>> ... and you need access to iter only for this which seems to be really a
>>> hack that's trying to outsmart the iomap code. I have to admit I don't
>>> fully understand what you are trying to achieve here. Are you trying to
>>> avoid flushing of the range that will be zeroed out?
>>
>> This logic is copied from the XFS and iomap infrastructure. Its primary
>> purpose is to optimize the zeroing operations on dirty written extents.
>> It was introduced by Brian in [1].
>>
>> The history as I understand it: originally, the iomap infrastructure
>> could not zero dirty unwritten extents during zero range processing,
>> which led to stale data exposure. XFS had to flush dirty ranges itself
>> before zeroing — a workaround that was not generic.
>>
>> In c5c810b94cf ("iomap: fix handling of dirty folios over unwritten
>> extents"), Brian added an unconditional flush in the iomap
>> infrastructure, ensuring that by the time zeroing runs the extent has
>> already been converted to written so the zero can proceed correctly.
>> However, this flush was too heavy and introduced noticeable performance
>> overhead.
>>
>> This was then optimized in 7d9b474ee4cc3 ("iomap: make zero range flush
>> conditional on unwritten mappings"), which restricts flushing to only
>> dirty pagecache over unwritten or hole mappings.
>>
>> Brian later proposed a different approach: rather than relying on flush
>> to convert the extent type, find dirty folios ahead of the zero range
>> and zero the dirty unwritten extents directly. In [1] he added this
>> lookup logic. The filesystem now supplies a folio batch (a collection of
>> dirty folios) via the iomap begin callback, and zero range iterates over
>> these dirty folios to perform zeroing. Clean regions not covered by the
>> batch are simply skipped. This entirely eliminates the need to flush.
>>
>> [1] https://lore.kernel.org/linux-xfs/20251003134642.604736-1-bfoster@redhat.com/
>>
>> If I understand correctly, the current approach is a compromise, and
>> Brian is still working on this. Perhaps ext4 and XFS could work together
>> on improvements in the future?
>>
> 
> I think that about covers it!
> 
> I do agree wrt to the iomap_iter thing in that it doesn't seem like the
> most elegant thing. I considered that a bit of a roadblock when first
> hacking on the batch stuff, but IIRC somebody pointed out that there was
> precedent already so I didn't think too hard about it after that. Indeed
> if you poke around, other filesystems use a similar pattern to access
> iter->private for whatever private context is carried around.
> 
> FWIW, one of the longer term thoughts for the dirty folio stuff was to
> eventually lift it out of the callback and just have iomap do it for the
> fs. That would eliminate this particular pattern and probably clean
> things up a bit, but there were also some other caveats with that that
> aren't top of mind atm (IIRC, things like dealing with map trimming,
> etc., but I haven't had a chance to think about it in a while).

Thanks for the additional information. This looks like a promising
direction. The usage on the ext4 side is relatively simple at the
moment, so the main concern is whether this would cause any issues for
XFS and other filesystems. This can be investigated later when time
permits — it's not urgent at this point.

> 
> Also note that this isn't necessarily a hard requirement. It's an
> optional optimization. iomap will flush and retry in the dirty
> pagecache+unwritten extent case if the fs hasn't otherwised provided
> folios to make sure it zeroes properly, it's just that performance of
> that may or may not be acceptable for your use case.
> 
> Brian

Yes, we will try to adopt the folio batch approach as much as possible,
hoping to reduce unnecessary performance overhead through it.

Thanks,
Yi.

> 
>>>
>>>> +	ret = iomap_zero_range(inode, from, length, did_zero,
>>>> +			       &ext4_iomap_zero_ops, &ext4_iomap_write_ops,
>>>> +			       NULL);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	/*
>>>> +	 * TODO: The iomap does not distinguish between different types of
>>>> +	 * zeroing and always sets zero_written if a zeroing operation is
>>>> +	 * performed, which may result in unnecessary order operations.
>>>> +	 */
>>>
>>> Is this still true after your fix to did_zero handling?
>>
>> Yeah. Currently, iomap_zero_range() can only report whether a zeroing
>> operation has occurred through did_zero parameter, but it cannot
>> distinguish whether the zeroed range is a written extent that already
>> exists on disk. That is, even if the zeroing is performed on a delalloc
>> extent, did_zero will still return true.
>>
>> Thanks,
>> Yi.
>>
>>>
>>>> +	if (did_zero && zero_written)
>>>> +		*zero_written = *did_zero;
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>   /*
>>>>    * Zeros out a mapping of length 'length' starting from file offset
>>>>    * 'from'.  The range to be zero'd must be contained with in one block.
>>>
>>> 								Honza
>>
> 

