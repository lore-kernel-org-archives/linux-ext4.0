Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309C3FD131
	for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781701251; cv=none; b=u3VDgvFMpEAghcfDvDJJRaHWsrA5O0nl8WDPj9qG47d53dPHYfcgjPm1HgU7BYhkinLS4bqZiABh6DVT7YZH+zVnj7EEifE0Q98nHGTCBlzwlGdil2BUnxwCVQc1Bk1xliRrD3kE7LgERZZDgJyDnbFAYq6c215FL+jY9t7MVA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781701251; c=relaxed/simple;
	bh=UEOqeZy4nuSiMcJbDnhYvbNKPHX4GO6itY+DAaN4aYY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ov9EWPNJs31CemA7pq+5nU54kwfNgNZHPPFMwLyf0yH886p/Q1NG6ysPUaZSLRDH7Vp9eGIppe8YExob7GnVa6H8ZJR7ZAIX/qPZxswr+J9RsLZRxF0g49/8AzFNsUirZTPNAG1nw/lu3CZ29ANOPdCLSXZNJeMkVRc1IBmLNHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HtjdaZGI; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HtjdaZGI"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-37c5b9d42efso457972a91.1
        for <linux-ext4@vger.kernel.org>; Wed, 17 Jun 2026 06:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781701250; x=1782306050; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1k2m3aSHTjqA6bdTXWu0OZg7gZ+wtGbmj+2TwUuz208=;
        b=HtjdaZGIt71DANrlStykmIbZJ6NYy7wf4Bmf/+FsHNupNMZm/GLQ/lzmVbVJ1788VY
         fadHx6vLegwJ9JJkLUemxjcwqoFI11carrj+pvsurlHfpFP7TLwy0bC2t6VQji3nYvGT
         qz+Gv+joHGjaLs9jLZcXD6zThrUhh33ZQ5FngmR/uFaaR1gSknEPDfr3CpYIJHpcytXP
         8bLwv+MDqC3YR2y791vbtXPLZaGqZfoCyVBZDrGFUnowqkBmlnI+YqzjSSfYhVovqbkd
         dpuXAP6MZWEyq7ILgKKNLpt5MmEIIfVlDg2/65djQfsA6LtRboNhNSXbKO9a7NLWUeex
         c0zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781701250; x=1782306050;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1k2m3aSHTjqA6bdTXWu0OZg7gZ+wtGbmj+2TwUuz208=;
        b=mNzAzzmqX7eHtuzCXTZpjfeAHgwbJC0hq+jlLR891EdfPL7+Yee0TPwyXOk0Dm5I0e
         3Llf8eAobC1aEz7etE/guhsGyqe48KpDXcWliENoVSktjpSrsEOxLVm8j9jQTUXQ3WTW
         YePAo7OffgMjZFO38MlphDH/jecfhKuJjn9PEJOGeFGagJj9lEVEnfR0mA2TDdBTM5Xf
         xYXft6otSXekyE83VaAMGJ5NwaNkkXg2CQP8TXM9de+fnVX2MrqgSVaY1Pg4DKowaLpt
         MHDI/8/snwy10Pszw2I1jrzKI2HbRjbwesqwBUL7XunNKICirCwZrbqPjuihRihaD5MN
         Ctyw==
X-Gm-Message-State: AOJu0YxpgAHiGajpZbm4qwsQ/xQQhpSn4S/hR2Xb+gvlrkjEJ1qAMCmY
	ulC514e72Ow9vq82OpYbzsJkJezIPM8S6NymbeL8DRoTuYLjoJu/AMld
X-Gm-Gg: AfdE7ckYMqzCXls2OipRnRGGEBIbjhQ2xOFS9vgh4HqWb5QEJFKCIquZd0lveRSqVIf
	01+fj9EJY4U5AX2gDjK/BpkI6FWEGCtm/OguusyrAHedHiJymvBvXMnNI08yYXUkrU4mzxUsYP4
	/LxhgaVntVCltjJCYAbnU/WCOb7Gn4dSAaDmVTi+qQt9tFYepz4v/mtgfKzPZxgojCvvba+nCxT
	DB02gjFC3ZXTZLCK39dU/Nl+HsbR7hcN88irprP+BfjX/IPUsD8F/WmD6UDbSfPFy4kM3cNP+n9
	hzjF/i5B47zuBxJ4dQ1jmRtR6qb7h9MvKYUdXp42DxUrsAJpIUX7I7/CHPNmTbmNOcqVxtFwAQX
	GHU+uMyDV6OIqZbfCEr8lGQ4w+KSUkEcK3vV4BOuLRgAbXc72YXqNYuKhNxXwTixZdV4OykpDYo
	Cpx5/Twmkrn+2L/TjmePSgurDnL5DnXxC689ms/AFuWkiG3mDWm5h4Qf2HmqKpmrE=
X-Received: by 2002:a17:90b:2704:b0:37c:543f:b7c with SMTP id 98e67ed59e1d1-37ca718e760mr2033578a91.10.1781701248124;
        Wed, 17 Jun 2026 06:00:48 -0700 (PDT)
Received: from ?IPV6:240e:390:a92:e6d1:ed78:8bd4:5db9:c767? ([240e:390:a92:e6d1:ed78:8bd4:5db9:c767])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c70aa47f0sm3238095a91.13.2026.06.17.06.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 06:00:47 -0700 (PDT)
Message-ID: <070f205c-11d6-4f7f-8b15-a928e37bb37e@gmail.com>
Date: Wed, 17 Jun 2026 21:00:35 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/23] ext4: implement partial block zero range path
 using iomap
To: Jan Kara <jack@suse.cz>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, yukuai@fnnas.com, Brian Foster <bfoster@redhat.com>
References: <20260511072344.191271-1-yi.zhang@huaweicloud.com>
 <20260511072344.191271-15-yi.zhang@huaweicloud.com>
 <c2q54d6u724xctkzwm6x7sbmg5cpvcackfz3toc47qts6iaj77@ci2czn4fqjik>
 <16cccb83-cdad-4113-8182-e8ea9e3049a2@huaweicloud.com>
 <n3bxam2j3iwdo3u6od5esn4pjqrtgxbdzdyemzpufpor4u2lbh@itrun3kmz52e>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <n3bxam2j3iwdo3u6od5esn4pjqrtgxbdzdyemzpufpor4u2lbh@itrun3kmz52e>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/17/2026 6:50 PM, Jan Kara wrote:
> On Wed 17-06-26 16:14:40, Zhang Yi wrote:
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
> 
> Ah, I see. I still find it hacky but apparently it is an established hack
> in iomap :). Fair.
> 
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
> 
> Thanks for the summary! So I was confused because somehow I thought this is
> about fallocate(FALLOC_FL_ZERO_RANGE) and so I was wondering why we just
> cannot evict the page cache and be done with that. Only after reading
> everything again I've realized this is about zeroing partial blocks on hole
> punch etc. And we may need to really handle multiple folios because XFS
> also uses this mechanism to implement FALLOC_FL_ZERO_RANGE for zoned
> storage. Ugh. OK, anyway for now this looks like your patch is following
> how things are expected to be done so feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
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
> 
> So maybe write in the comment explicitely, that this may result in
> unnecessary flushing of folios if zeroing happened in
> delayed-not-yet-allocated blocks?
> 
> 								Honza

Sure, I'll include it in the next iteration. :)

Thanks,
Yi.



