Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F547083C
	for <linux-ext4@vger.kernel.org>; Thu, 18 Jun 2026 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781797871; cv=none; b=GE64tnYJJ2GVO4EF23LrJNgpAKwib/JvisG/ztHtMilNaNS0xrNlECXxLd7xg1B+UqiLzA8npypQLoUdgnrEl6e+1ETKsYz1lV3GEzVIBd10N+NNzZPgZ/+LM8nPdjmggJRFeVYpfTFBeZ6W73YwB+8YlswoSmEy+cC1Gtu63eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781797871; c=relaxed/simple;
	bh=jhvaEKYE2Dis2WU+Px8fjbBSLZYhYU3VY+oULWMnKfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RfUeYxFiQAdn4SuEaQSrZr41Abr84XYSPwANrWM+Iizcqy/L4SI7rgKCXg/e06qMKF/jmt63oYVDjoxJPqX2ag/QAnYzQ7G/n0gYKj/jro82YxOKtmWvamDpWLS8RbhhYrnfcLjn5a19NK71J2x0JL55tuD65vsWM8G6rY63Qbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=GlT+d3U5; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="GlT+d3U5"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781797865; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=aRo27/a/iGvrhQIhMvA5avQeWepXdayMIpCTAQ+GAtc=;
	b=GlT+d3U5EINM4UCAzdbhRO9kx02YYYQ7E5pKkmwgBrdT2PLUO/ZBNCETp5u3YIM+MZmCI0A8g9UYQVM4/4r+qIXWKz17ihZpovbqMUgVcexOqdGDcxhShsftTQ8GHWXqN1IqMPtO3igs/+IhuoSMRdAtsXDfKSgnlomu+9DVxVY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X57Pvqs_1781797863;
Received: from 30.170.105.22(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X57Pvqs_1781797863 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 23:51:04 +0800
Message-ID: <aa35f632-c49c-41a5-9bc6-c9583cb6a7c1@linux.alibaba.com>
Date: Thu, 18 Jun 2026 23:51:03 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/8] ext4: return -EAGAIN from ext4_map_blocks() in
 NOWAIT cache miss
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 yi.zhang@huawei.com, ojaswin@linux.ibm.com, ritesh.list@gmail.com,
 peng_wang@linux.alibaba.com
References: <20260618125735.4156639-1-libaokun@linux.alibaba.com>
 <20260618125735.4156639-7-libaokun@linux.alibaba.com>
 <ekslfvokadqeiqmfbhv7d3v4ayguuqt7z53i5ze4u55fqkvkjg@waocl7jdgpja>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <ekslfvokadqeiqmfbhv7d3v4ayguuqt7z53i5ze4u55fqkvkjg@waocl7jdgpja>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/6/18 22:09, Jan Kara wrote:
> On Thu 18-06-26 20:57:33, Baokun Li wrote:
>> Make ext4_map_blocks() return -EAGAIN instead of 0 when
>> EXT4_GET_BLOCKS_CACHED_NOWAIT is set and the extent status cache
>> misses. This allows callers to easily distinguish between a successful
>> cache lookup (positive return value) and a cache miss requiring disk
>> access (-EAGAIN), simplifying error handling in NOWAIT paths.
>>
>> The change affects two locations:
>> 1. After cache hit: return retval ? retval : -EAGAIN
>>    (return -EAGAIN if cache hit is hole/delayed)
> Are you sure about this case? -EAGAIN looks wrong here - we have the valid
> information cached and provide it to the caller without blocking. So at
> least from the POV of ext4_map_blocks() there's no reason to return -EAGAIN.
>
> 								Honza

You're right, there's no need to return -EAGAIN here. I only considered
the write path - even without returning -EAGAIN, ext4_iomap_alloc() 
would return it anyway. But I missed the read path, where this would cause
an unnecessary retry.

I'll remove this change in the next version and only keep the essential
second modification (for cache miss case).

Thanks for the review!


Cheers,
Baokun


>> 2. After cache miss: return -EAGAIN
>>    (instead of 0, indicating need for disk lookup)
>>
>> The only existing caller using EXT4_GET_BLOCKS_CACHED_NOWAIT is the
>> ext4_get_link() -> ext4_getblk() path. Although ext4_getblk() now
>> takes a different return branch (err < 0 instead of err == 0) and
>> propagates -EAGAIN instead of NULL, ext4_get_link() converts both
>> cases to -ECHILD via IS_ERR_OR_NULL(), so the final error seen by
>> the VFS remains unchanged.
>>
>> Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
>> ---
>>  fs/ext4/inode.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index 832794294ccf..03adbca3ec78 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -760,7 +760,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>  		}
>>  
>>  		if (flags & EXT4_GET_BLOCKS_CACHED_NOWAIT)
>> -			return retval;
>> +			return retval ? retval : -EAGAIN;
>> +
>>  #ifdef ES_AGGRESSIVE_TEST
>>  		ext4_map_blocks_es_recheck(handle, inode, map,
>>  					   &orig_map, flags);
>> @@ -776,7 +777,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>  	 * cannot find extent in the cache.
>>  	 */
>>  	if (flags & EXT4_GET_BLOCKS_CACHED_NOWAIT)
>> -		return 0;
>> +		return -EAGAIN;
>>  
>>  	/*
>>  	 * Try to see if we can get the block without requesting a new
>> -- 
>> 2.43.7
>>

