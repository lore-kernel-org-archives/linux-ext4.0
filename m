Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECE138AC90
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2026 06:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182077; cv=none; b=GYJ6AXfn5+4Mc11hSEjdWO69mT0W56HcxwG2p5aLdgYbUV5KrwqKowFBDzhKsGypsOmHYkNfrEX2qfVM0EbOjwIVj7ZajnlTWRPdW6xnfP7Cve6SUr+On1MNn5LObF2t4Ver07QgorOt/ncYqd2aZat4F0DXVOeXm2dXrz1NNJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182077; c=relaxed/simple;
	bh=e0k4x68dB9cAgLZE7AmuvoP6CrC/x2w61+UhaBUyNPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aqFaw+pmpax0k7FATPLhiY4S1sdw5+C/rdwnt3+Z6LiRxyVcVtENwIU+O8ljK1cRblbTNZSX8rfgDp53wnU6DiK0dU/+lBFEis9JLCnOl2YwzegyM1dqHrgb837ONbqlDg3+/A8gtUd6HvkDScXhVzWGifg6j5bRAW5BXyfHCVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZSf/tdeu; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZSf/tdeu"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-848882fdb18so3127712b3a.0
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jul 2026 23:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784182074; x=1784786874; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uFARVDxnaLYq1Hsj3BLFZsGf+AzuTyY74rHw87BzBP4=;
        b=ZSf/tdeubCTTiToJusapM2/H5gpZvF/AZ9fN6LXJPaUY21LHdUFIzPK2x4fvsvsumi
         NjYoZBRfzvAioELWNe4Dxrp/XNswnRzpGGvoaOP6oYez3Z0xHq67AVowpTW6Vxh/jEog
         cYNHWwlIU7pdl0e7bhV6Z8jClaE7dGy9FSrsZLTF4nFULGmSQFU4CcomfYmlf/vIlCZr
         Oc2o8HZM6XwrK2qwKmgftVsWyGMJs7L49kfDJi/LoozxilF0pe5uT7fN+j06tueaoDyR
         uTCGwoPTqC8pF21G9YcbCCSivR7kjn+aGrYVT4u3qWv7URNaPxVaZ2qTkgPw4uQcvNT4
         CFXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784182074; x=1784786874;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uFARVDxnaLYq1Hsj3BLFZsGf+AzuTyY74rHw87BzBP4=;
        b=RWYfYfL57G66jsby03gdZBGgsTXaeGI+QOERfz0EgFO+0kYcHaOvrN0PCGtTMSUT4I
         pFfLoO5/rt4u4MdZfkcPl4Tn8bskQ+g/Sl1vaFEkl+AY/i4XyT5A3BmH4ohummxihHzC
         4lITzI/8faIA7Qx1aCA5L4SfhkLjYNOeLwuIR5J3SGJtJ1FWzaQtHaySW6KOcQaGdrJA
         uolCK648kq8tS26EK/lAGzaqmu2jg94r4mFZKDnBWLu0smZPRLT7F5SHtLJ0UZt+otf2
         25CzNm/uA/lNCpsVX9v5tjxSzPLiNNQ6D9PpWphnzVY5O7JaT5gmAYrElpQY+EljHt1N
         3Jfg==
X-Forwarded-Encrypted: i=1; AHgh+Rrh3juOiRvzTk7kUWbADVIrwgdw+92zvcp6SBNcuUh98Du3OrKh8SPRcsyNvatF12DICWW+AFCIGL3a@vger.kernel.org
X-Gm-Message-State: AOJu0YyRzeF1/ci5PGZI3FFKjo573qyzszJTgHlUELy/zDLJW4zsATQ8
	HPPLaxJSawovYht8JuN/eNiN/H4y5DaXEpj/Qsv0QTa7It1J0T4O1+wK
X-Gm-Gg: AfdE7cnzz5//fRjze4ZVxAH/K05kCJrxrt4lv3LAEZQRvxRXbfWSoByE8nYyutC/3Av
	CSSQ2apxW5QCSXK/FQu1CQknlEA21smAn/gxF26uwpLnB0URAdKzct9NC8Vo7weHVc/JiMzFCLM
	dAuRJiDLdxvRJFAb2xbtAA8ro58wU//D0bsJw3hjNX8Hb8x5qC84Qvq8duINXmC3N3sCTozzK/U
	x1yS3EO5YYcDjEgFDGR4WSpR3+WsEehw2XFFOtlxswnnE+gr4GWz4/0gDD4f2ATLHYzaolKEvTB
	W5heFUbbSad5hcUCWvY38QBDwEnHSFnOLX0v6yollGvd2BSWp+zbmdquB4j0X6evl5njM6zDDRP
	ARsp80INXzS06wgChpT93cB3GN6YfVUUMnJckxcamtqe/tx+TCpYrtDgWZpbqWfSvGeYYDxQGK6
	13LKvshMlw0IgwtjknO0bPWRmJr5S9OQB/
X-Received: by 2002:a05:6a00:14c8:b0:84a:2c9b:21bc with SMTP id d2e1a72fcca58-84a6736d396mr5152875b3a.62.1784182073810;
        Wed, 15 Jul 2026 23:07:53 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a6be1d301sm1897924b3a.21.2026.07.15.23.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 23:07:53 -0700 (PDT)
Message-ID: <283ee8d1-4bd6-4956-a83c-ac3033ac6c9d@gmail.com>
Date: Thu, 16 Jul 2026 14:07:45 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] ext4: fix DIO read slowdown after extent status
 reclaim
To: Jan Kara <jack@suse.cz>, Fengnan Chang <changfengnan@bytedance.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, libaokun@linux.alibaba.com,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 linux-ext4@vger.kernel.org
References: <20260714114358.93335-1-changfengnan@bytedance.com>
 <osv5omv7siwplyisblmyxttwx7f52ptqsxfi72jmqujogfs4uv@fyhemkm6uwbe>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <osv5omv7siwplyisblmyxttwx7f52ptqsxfi72jmqujogfs4uv@fyhemkm6uwbe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi!

On 7/16/2026 12:19 AM, Jan Kara wrote:
> Hello!
> 
> On Tue 14-07-26 19:43:56, Fengnan Chang wrote:
>> This series fixes a slowdown in ext4 random direct reads that appears after
>> extent status entries are reclaimed.
>>
>> Problem:
>>
>> The extent status tree and the extent-tree leaf buffers do not have the same
>> lifetime.  Memory pressure can reclaim an extent status entry while the
>> corresponding metadata buffer_head stays in the buffer cache with its
>> "verified" flag set.  The next lookup then takes this path:
>>
>>    1. ext4_es_lookup_extent() misses--the entry was reclaimed.
>>    2. ext4_find_extent() reads the leaf, but __read_extent_tree_block()
>>       returns the already verified buffer without calling
>>       ext4_cache_extents().
>>    3. ext4_ext_map_blocks() returns the part of the extent starting at
>>       m_lblk, and ext4_map_query_blocks() caches only that suffix.
>>
>> Reads to earlier blocks in the same extent miss the extent status tree again
>> and walk the extent tree on every I/O.
>>
>> Testing with fio 4K random direct reads (io_uring, iodepth=128) on a
>> 128 GiB file (75 on-disk extents) after triggering extent status reclamation:
>>
>>    Baseline (full extent status cache): 525k IOPS, clat avg 241.96 us
>>    After extent status reclaim (no patch): 296k IOPS, clat avg 428.69 us
>>    Degradation:                      -43.6% IOPS, +77.2% latency
> 
> Good spotting!
> 
>> Fix:
>>
>> Patch 1 makes ext4_es_cache_extent() report whether the requested range is
>> cached when it returns.  The result is passed through ext4_find_extent() and
>> the internal map flags, so ext4_map_query_blocks() can skip the second cache
>> update when the leaf was fully cached.  If population was skipped or an
>> insertion failed, the existing query cache remains as a fallback.  This avoids
>> taking i_es_lock for writing a second time after a leaf read has already
>> populated the extent status tree.
> 
> Did you observe a measurable performance increase after this change or is
> this mostly a theoretical improvement?

I share the same concern. It would be great to see some test data to
back this up.

> 
>> Patch 2 handles the extent status lookup miss described above.
>> ext4_iomap_begin() opts into a new EXT4_GET_BLOCKS_CACHE_READ_EXTENT flag for
>> DIO reads.  If the leaf lookup did not populate the extent status tree,
>> ext4_ext_map_blocks() caches the full matching written extent (ee_block,
>> ee_len) before cropping the mapping to the requested block.  Later reads
>> within that extent can then use the extent status tree directly.
> 
> I kind of dislike the additional complexity these two patches add to the
> extent mapping path only for this corner case. As far as I have checked,
> maybe we would be better off to update the extent status tree with the
> found extent in ext4_ext_map_blocks() / ext4_ind_map_blocks() where we
> still have the full extent information available. And for start we could
> just check whether the extent is already there under read lock (as in the
> common case we expect it was already cached when reading extent tree block)
> and only if we don't find it, we grab the write lock and insert it. If this
> proves to be too slow, only then I'd bother with figuring out how to
> propagate the information from caching of the leaf block to the place
> adding extent to the extent status tree in the least painful manner...
> 
> Also it would be good to hear Yi's opinion as he was the last doing larger
> cleanups to the extent status tree handling.
> 
> 								Honza

I tend to agree with Jan here. The current approach adds quite a bit of
complexity that I think would hurt maintainability going forward, so I'm
more inclined to take Jan's idea.

In addition, one thing we do need to watch out for, though, is the
EXT4_EX_NOCACHE case. We should avoid adding unrelated extent range into
the cache, as that could lead to stale extent cache issues during
writeback.

Thanks,
Yi.

> 
>> Fengnan Chang (2):
>>    ext4: avoid caching an extent twice after a leaf read
>>    ext4: cache the full extent after a DIO extent status miss
>>
>>   fs/ext4/ext4.h           |  9 ++++++++-
>>   fs/ext4/ext4_extents.h   |  4 +++-
>>   fs/ext4/extents.c        | 43 ++++++++++++++++++++++++++++++++--------
>>   fs/ext4/extents_status.c | 20 +++++++++++++------
>>   fs/ext4/extents_status.h |  6 +++---
>>   fs/ext4/inode.c          | 40 ++++++++++++++++++++++++++-----------
>>   6 files changed, 91 insertions(+), 31 deletions(-)
>>
>> -- 
>> 2.39.5 (Apple Git-154)

