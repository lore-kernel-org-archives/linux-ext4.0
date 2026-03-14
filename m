Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD41C701F
	for <linux-ext4@vger.kernel.org>; Sat, 14 Mar 2026 02:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773454871; cv=none; b=rNwmnt3YM9DCV8T5RMFp7G5p2flVKOfl/t2Q3T1Bf+u3sJeb1DzxDsZJkWrRIDzI2FgIoOJ+Uoq/CUUPsOpZRKuc+Gx5iJV8oACzvf0LjdIqfv6rPlQ8vdTawoJqhRIjx5QolcdLaOrLDWWWdRG86KmwUylhOx1EsIlNOCCcopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773454871; c=relaxed/simple;
	bh=znSomJJdozl0hMJerIglLUCOX+lVXvssVLlogmj5MDQ=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=l451D5IDV/WiZPpH57dOBFRNq9gCIqtBakHRg/rB4nRsr/CHUYA0lC3no8wU0DqRAbzi+6sjpsQLYK1Yf72JKCzf2R4l7WprprszsjcouAlrZz5/v/n2zd/1W9AdkfwazgeHUwxgdkjp2cZ+w25arfXURUCZvrB0KDFbsTPeNH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=FnMPeFhS; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="FnMPeFhS"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Jd3DnUptsv5623hJDnXs6RpjqUQvi0tdazT8oVAoskg=;
	b=FnMPeFhS2qsfdwi62GbEqsbcD+WrqfWR4cb48fe5LlaXYcLMJeTveyzxnDnTkFJKHf7YhCJdP
	innHI5zzXn1773CGdfoPdAecJNet7NwdZWkwxpmamKTltlt/Wj5hJ0++JtmNhL58brmDWO4CfQ8
	YXjvlQvuZd8Bg+byZGErtsE=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fXlLq03msz12LFj;
	Sat, 14 Mar 2026 10:15:31 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id DEE5A2025E;
	Sat, 14 Mar 2026 10:21:04 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Mar 2026 10:21:04 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 14 Mar 2026 10:21:04 +0800
Subject: Re: [PATCH -next 6/8] ext4: fix the error handling process in
 extents_kunit_init).
To: Ritesh Harjani <ritesh.list@gmail.com>, Ye Bin <yebin@huaweicloud.com>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>
References: <20260310130412.3156753-1-yebin@huaweicloud.com>
 <20260310130412.3156753-7-yebin@huaweicloud.com>
 <sea4sz73.ritesh.list@gmail.com>
CC: <jack@suse.cz>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69B4C60C.8010205@huawei.com>
Date: Sat, 14 Mar 2026 10:21:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <sea4sz73.ritesh.list@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500016.china.huawei.com (7.202.194.202)



On 2026/3/13 20:15, Ritesh Harjani wrote:
> Ye Bin <yebin@huaweicloud.com> writes:
>
>> From: Ye Bin <yebin10@huawei.com>
>>
>> The error processing in extents_kunit_init() is improper, causing
>> resource leakage.
>> Reconstruct the error handling process to prevent potential resource
>> leaks
>>
>> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
>> Signed-off-by: Ye Bin <yebin10@huawei.com>
>> ---
>>   fs/ext4/extents-test.c | 41 +++++++++++++++++++++++++++++------------
>>   1 file changed, 29 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
>> index 70d84c0a18e2..7e2796f72d45 100644
>> --- a/fs/ext4/extents-test.c
>> +++ b/fs/ext4/extents-test.c
>> @@ -222,33 +222,37 @@ static int extents_kunit_init(struct kunit *test)
>>   		(struct kunit_ext_test_param *)(test->param_value);
>>   	int err;
>>
>> -	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
>> -	if (IS_ERR(sb))
>> -		return PTR_ERR(sb);
>> -
>> -	sb->s_blocksize = 4096;
>> -	sb->s_blocksize_bits = 12;
>> -
>>   	sbi = kzalloc_obj(struct ext4_sb_info);
>>   	if (sbi == NULL)
>>   		return -ENOMEM;
>>
>> +	sb = sget(&ext_fs_type, NULL, ext_set, 0, NULL);
>> +	if (IS_ERR(sb)) {
>> +		kfree(sbi);
>> +		return PTR_ERR(sb);
>> +	}
>> +
>>   	sbi->s_sb = sb;
>>   	sb->s_fs_info = sbi;
>>
>> +	sb->s_blocksize = 4096;
>> +	sb->s_blocksize_bits = 12;
>> +
>>   	if (!param || !param->disable_zeroout)
>>   		sbi->s_extent_max_zeroout_kb = 32;
>>
>>   	/* setup the mock inode */
>>   	k_ctx.k_ei = kzalloc_obj(struct ext4_inode_info);
>> -	if (k_ctx.k_ei == NULL)
>> -		return -ENOMEM;
>> +	if (k_ctx.k_ei == NULL) {
>> +		err = -ENOMEM;
>> +		goto out_deactivate;
>> +	}
>>   	ei = k_ctx.k_ei;
>>   	inode = &ei->vfs_inode;
>>
>>   	err = ext4_es_register_shrinker(sbi);
>>   	if (err)
>> -		return err;
>> +		goto out_deactivate;
>>
>>   	ext4_es_init_tree(&ei->i_es_tree);
>>   	rwlock_init(&ei->i_es_lock);
>> @@ -264,8 +268,10 @@ static int extents_kunit_init(struct kunit *test)
>>   	inode->i_sb = sb;
>>
>>   	k_ctx.k_data = kzalloc(EXT_DATA_LEN * 4096, GFP_KERNEL);
>> -	if (k_ctx.k_data == NULL)
>> -		return -ENOMEM;
>> +	if (k_ctx.k_data == NULL) {
>> +		err = -ENOMEM;
>> +		goto out_deactivate;
>> +	}
>>
>>   	/*
>>   	 * set the data area to a junk value
>> @@ -310,6 +316,17 @@ static int extents_kunit_init(struct kunit *test)
>>   	up_write(&sb->s_umount);
>>
>>   	return 0;
>> +
>> +out_deactivate:
>> +	kfree(k_ctx.k_ei);
>> +	k_ctx.k_ei = NULL;
>> +
>> +	kfree(k_ctx.k_data);
>> +	k_ctx.k_data = NULL;
>> +
>> +	deactivate_locked_super(sb);
>
> So I guess the right thing to do for now is, what Ojaswin also mentioned
> [1].  Let's go with patch [2], as is.. and we can fix all the remaining
> issues as part of this series. With that in mind, this patch series
> needs to be applid on top of [2]. So that means.. our error handling
> should also properly take care of unregister shrinker and freeing sbi..
>
> [1]: https://lore.kernel.org/linux-ext4/abPh6GX0t22m628D@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com/
> [2]: https://lore.kernel.org/linux-ext4/5bb9041471dab8ce870c191c19cbe4df57473be8.1772381213.git.ritesh.list@gmail.com/#t
>
> -ritesh
>
I will base on your patch and then create a separate patchset for the
fixes and send it.
>
>> +
>> +	return err;
>>   }
>>
>>   /*
>> --
>> 2.34.1
>
>
> .
>
