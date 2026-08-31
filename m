Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAD23C7685;
	Mon, 31 Aug 2026 12:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788180379; cv=none; b=rZc39mOVeFTLkcYD5Dtz9octvQalIoe/C92S9uiceny2GcwR6bkMyE+lf5IbxKGhpoPdxHbL46DKovW+EDZBomY25ZPo4ivk24E63H1lyv/vbkP44YoStM5OA6qnj3iUHIbk42vHDdr7tkmcC37/OvXezSL64PAf1rKXDD+W66w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788180379; c=relaxed/simple;
	bh=AP9kz7HGy+8wQj+tsTGyt1b1AyOIKox0uGop4bIJMXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=eU7W3rKGuF7FCk4XiJ8jDSS3CLlJR/X5IbJcwHDgz7vJTXkrK0pjpJ99ccazY9SUdfjoC0dUKgEzm7X0MvsMg76EHuTp6Pm4DGj+m1tI0TbTQ7brNUFozVTKEGfNaYKk8Q5vYpij7qFBth+N1LRdhwmluuMaLgVM7bYivsTzI8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=clGR40LC; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="clGR40LC"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qJxxsAivN8MHsK2efoQ9PRdDBLYPrZVK1pXp6XxoRTA=;
	b=clGR40LC0wrhCmVUdcS1Q5jXpWyI57zv3NxbzMuR9xgAkovleCDLvAlwm+Xfu8UsgicAbvrG8
	8WoNszDBuAq9mSgodGYrUmuMjqWxiNnWrNDbd3Y9Y9IX02tPHqwFqXzCidHH6BDfnJ3j7k64F41
	EZVEeOxV405iLcbnwSV0QFA=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hYT3Z6DG4zcb4j;
	Mon, 31 Aug 2026 20:35:22 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 1CE1040575;
	Mon, 31 Aug 2026 20:46:05 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 31 Aug 2026 20:46:02 +0800
Message-ID: <0e26fbf2-3dfe-4c73-819e-8255289f7610@huawei.com>
Date: Mon, 31 Aug 2026 20:46:01 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] super: Use acquire for SB_BORN check in
 super_cache_count()
To: Jan Kara <jack@suse.cz>
CC: <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <bcrl@kvack.org>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>,
	<pmladek@suse.com>, <rostedt@goodmis.org>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <akpm@linux-foundation.org>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <horms@kernel.org>, <socketcan@hartkopp.net>,
	<mkl@pengutronix.de>, <kuniyu@google.com>, <willemb@google.com>,
	<jhs@mojatatu.com>, <jiri@resnulli.us>, <kees@kernel.org>,
	<cyphar@cyphar.com>, <tglx@kernel.org>, <liuhangbin@gmail.com>,
	<sdf@fomichev.me>, <nb@tipi-net.de>, <linux-fsdevel@vger.kernel.org>,
	<linux-aio@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-can@vger.kernel.org>
References: <20260825095422.3166067-1-ruanjinjie@huawei.com>
 <20260825095422.3166067-7-ruanjinjie@huawei.com>
 <2uxxlu75vyo7iayzz2udisjmu7dhyiyboiuodriksmorz37cha@3mzh2vwrmafw>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <2uxxlu75vyo7iayzz2udisjmu7dhyiyboiuodriksmorz37cha@3mzh2vwrmafw>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500011.china.huawei.com (7.185.36.131)



在 2026/8/31 20:29, Jan Kara 写道:
> On Tue 25-08-26 17:54:17, Jinjie Ruan wrote:
>> The active SB_BORN check in super_cache_count() pairs with the
>> smp_store_release() in super_wake() when publishing a newly initialized
>> superblock.
>>
>> Replace the historical independent smp_rmb() barrier with an acquire load
>> on sb->s_flags. This expresses the publish-subscribe pattern more clearly
>> and allows weakly-ordered architectures like arm64 to utilize efficient
>> native instructions (e.g., LDAR) instead of a full one-way barrier.
>>
>> Also update the outdated comment to correctly point to super_wake().
>>
>> Assisted-by: Gemini:Gemini-3.1
>> Assisted-by: DeepSeek:DeepSeek-V3
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
> Looks good. Just one nit below. With that addressed feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
>> diff --git a/fs/super.c b/fs/super.c
>> index 05e443173038..5860daea6d40 100644
>> --- a/fs/super.c
>> +++ b/fs/super.c
>> @@ -267,12 +267,11 @@ static unsigned long super_cache_count(struct shrinker *shrink,
>>  	 * However, if we are currently mounting the superblock, the underlying
>>  	 * filesystem might be in a state of partial construction and hence it
>>  	 * is dangerous to access it.  super_trylock_shared() uses a SB_BORN check
>> -	 * to avoid this situation, so do the same here. The memory barrier is
>> -	 * matched with the one in mount_fs() as we don't hold locks here.
>> +	 * to avoid this situation, so do the same here. The acquire is matched
>> +	 * with the smp_store_release() in super_wake() as we don't hold locks here.
>>  	 */
>> -	if (!(sb->s_flags & SB_BORN))
>> +	if (!(smp_load_acquire(&sb->s_flags) & SB_BORN))
>>  		return 0;
> 
> We have super_flags() helper exactly for checks like this so it would be
> good to use it here.

Right! And we can just remove the outdated memory barrier comment, as
the underlying super_flags() implementation already has a self-document.

> 
> 								Honza
> 
>> -	smp_rmb();
>>  
>>  	if (sb->s_op && sb->s_op->nr_cached_objects &&
>>  	    super_fs_objects_eligible(sc))
>> -- 
>> 2.34.1
>>

