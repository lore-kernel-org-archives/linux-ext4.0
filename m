Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB044B7A41
	for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 11:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790596664; cv=none; b=aOXEqAx0UGJ4pR4aO1NaDAVkn5epmbOfOM7oXZ/DepqWro9AaIei3AOM/PxWDszQ7PkHk5Hq+S0Jyle+asIZ6Rjb4jXDCWxP5FXSfelBRZGXHAR5oex942z3JqlKRJcj8H5libr/1RM2a4eLdSKkwlYwIeP6+5VY4WXwuWMqwsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790596664; c=relaxed/simple;
	bh=r3puRPhMmBtKKfqB3F2kZ+pMBLHUDRnlSFFiHevX7BM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IYME836Psuu93WZnC9HYkczx7e6zhORFuYzIUXO6VbfGE5MxqK3hA/YVGjU1ni+wzNrXfUac+fhW99QVwhG03S7VJfTsbG+zMuZ+7Op/eQQWxDREegNd4lvcUNVcpk8h3s+gVZV9mFrxC21rZZTsG4kmRPPTcp2MkR0L7ltU8CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nJhlIgvm; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nJhlIgvm"
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc7979d1deaso613141a12.1
        for <linux-ext4@vger.kernel.org>; Mon, 28 Sep 2026 04:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790596662; x=1791201462; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uznnGClxpoNxhfkd79ZikolqPxxdalAG+z6oc7/n6sw=;
        b=nJhlIgvmMM6qT8Rn+B/S3jByqrCvylSpJWrbeVoYGvYQL4hXRq5tKVN01FO6SFVOUS
         O6BPMo58k+SA+PJGrOC/2/LUyUt5eXvJpgCJEwgFb0uNPuC7X8zqTq5V0//kMQMNqRKI
         pVOF58DkFPDrPq2uKIPd3AL56DehROE75ACnRU7aPVzXcQAJgHgpdFDW+G5Gm0AvN5hi
         vjjmjPbhtTOuDz6RN/0eCs9NgxWKygYX6QUw9obJzazw4s2EDswQsgKUIJ3WEtGY4b6k
         hoYSaa/uXvGDxgGcL7TYYUQ8bw35NkPAmEc70PENBfePsejaG+SUrTMVMideE1Ed4RNc
         nuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790596662; x=1791201462;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uznnGClxpoNxhfkd79ZikolqPxxdalAG+z6oc7/n6sw=;
        b=ZBEgfC2XSUISh9F3gZfzGIlzB1VGxGApRyl3VlyJpjGWiMj7y/JXhRlT3wC9GruY3F
         mg882ZgRnF7UT0v7Rn5ElBwpZSqvf89ldoyzus5D/s3xF4lgB9gyRQ4HEdnjPP0nbOjS
         AtAabrl7n/B43ZxOvHB2JkwAHYHQnh9hpYrwkcukmJ7k066IEGxQ1BfWsSkdUZqMwTGU
         KDx9y9uEz/C/jlxy58m+exjW6oCULTtrhm6Xp9bYAjf/oGU4ZaHvoNfPIQYp80IqY+qN
         GTP2sdMSWwvSPtZqf/kS7IVd5z6VzXWKdzPSkAKkS+ZXhf0V6SrVg//+arKVfZO7dmA7
         uieA==
X-Gm-Message-State: AFq9FYI60SMAWuk6aWwWp7qMq8kh0S5YvCTwlEZQ9qkpK2VlZ2R1zwwR
	Mg/+DKWXS4cnIXmEIi8nVS8Jl/bgyrVXjuOpGCQ7iQBoTM4ucFxqjNHz
X-Gm-Gg: AYBFou2keI6coa8ONLx6y7WgVALdG5csJCzZHkFuomBaSc42SeLNth+BP7bWE4wlp3z
	j0+Am2A5JOWM5eHdvt0IB0NM1U8Sl4KEQDY/V/hCBxXYXT0XLRa12GvZTE+P/FOKiPvW5Q58f/2
	flfXfsjGhIfg7YVWNi7K0NhMxLRIE4cCKMtweFAloVMBk0wzHQ2vcvEvjfdhQ3ZWJu8p6mHWD4U
	9Ep0gQfdhcxvlPASekI5ke6kMaHzCcIAhKB7mkQ4TKVf8nNP7ulbzGQ8eV+MYTaMRAJmmKNnyZr
	mNuIGunLaPVBD762a2ImOqfg/DkfQzPi9Zow5NyPwQaqnvFmCeKg4tCwNMG6Jms52jtbANkp4M0
	aIg1ZEiwgEpj1Tk4eEaOUomRG2Fipe/dRJo8F9wj/GRgAIv2QEYAugYcsVMNgdcsGlDHKyIaH1d
	wcHswN63XYtcUfvKqFNEolTQwtuDtVs0P0Q2iFZlTODhqMqABUHfFv9tke4UktOwozmBbYu9c0Z
	HknChNcDAgtH5yzu4c=
X-Received: by 2002:a17:90b:53cc:b0:39e:6c6a:2096 with SMTP id 98e67ed59e1d1-3a098970bd7mr10676652a91.55.1790596662346;
        Mon, 28 Sep 2026 04:57:42 -0700 (PDT)
Received: from [100.125.248.95] ([124.70.231.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b99e5711sm19979522a91.17.2026.09.28.04.57.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 04:57:42 -0700 (PDT)
Message-ID: <214177f4-11d1-47f9-94fc-2fc679911b13@gmail.com>
Date: Mon, 28 Sep 2026 19:57:26 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/31] ext4: avoid unnecessary transaction in
 ext4_map_blocks() for unwritten extents
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
 libaokun@linux.alibaba.com, jack@suse.cz, ritesh.list@gmail.com,
 djwong@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
 chengzhihao1@huawei.com, yangerkun@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260903123543.2302999-1-yi.zhang@huaweicloud.com>
 <20260903123543.2302999-9-yi.zhang@huaweicloud.com>
 <aro_npJ95b4Nf978@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <aro_npJ95b4Nf978@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/28/2026 6:21 PM, Ojaswin Mujoo wrote:
> On Thu, Sep 03, 2026 at 08:35:20PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> When ext4_map_blocks() finds an unwritten extent in the extent cache and
>> the caller is willing to accept unwritten extents without conversion,
>> there is no need to start a journal transaction since no metadata update
>> is required. This avoids unnecessary transaction overhead in the
>> upcoming iomap writeback path when overwriting already-allocated
>> unwritten extents.
>>
>> One thing to be careful about, as the comment in ext4_map_blocks()
>> states, if the flags contain EXT4_GET_BLOCKS_CREATE, the function will
>> mark @map as mapped.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Yeahh, I had something similar in one of my WIP branches :)
> 
> Thanks for taking care of this. Feel free to add:
> 
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
> Regards,
> ojaswin

Hi ojaswin,

Thank you for the review! The fast path implemented in the current
version is missing check_block_validity(), I'll add it in the next
iteration.

Thanks,
Yi.

> 
>> ---
>>   fs/ext4/inode.c | 19 ++++++++++++++-----
>>   1 file changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
>> index c9dea4ca5caf..7a5c74af8ff3 100644
>> --- a/fs/ext4/inode.c
>> +++ b/fs/ext4/inode.c
>> @@ -809,14 +809,23 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>>   	 * Note that if blocks have been preallocated
>>   	 * ext4_ext_map_blocks() returns with buffer head unmapped
>>   	 */
>> -	if (retval > 0 && map->m_flags & EXT4_MAP_MAPPED)
>> +	if (retval > 0) {
>>   		/*
>> -		 * If we need to convert extent to unwritten
>> -		 * we continue and do the actual work in
>> -		 * ext4_ext_map_blocks()
>> +		 * If we need to convert written extent to unwritten or
>> +		 * convert unwritten extent to written, continue and do
>> +		 * the actual work in ext4_ext_map_blocks().
>>   		 */
>> -		if (!(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
>> +		if (map->m_flags & EXT4_MAP_MAPPED &&
>> +		    !(flags & EXT4_GET_BLOCKS_CONVERT_UNWRITTEN))
>>   			goto out_handle;
>> +		if (map->m_flags & EXT4_MAP_UNWRITTEN &&
>> +		    (flags & EXT4_GET_BLOCKS_UNWRIT_EXT) &&
>> +		    !(flags & EXT4_GET_BLOCKS_CONVERT)) {
>> +			/* Contains EXT4_GET_BLOCKS_CREATE - mark mapped. */
>> +			map->m_flags |= EXT4_MAP_MAPPED;
>> +			goto out_handle;
>> +		}
>> +	}
>>   
>>   	if (!handle) {
>>   		handle = ext4_journal_start(inode, EXT4_HT_MAP_BLOCKS,
>> -- 
>> 2.52.0
>>

