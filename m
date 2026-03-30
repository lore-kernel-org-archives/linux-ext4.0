Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223612494F0
	for <linux-ext4@vger.kernel.org>; Mon, 30 Mar 2026 07:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774854172; cv=none; b=rQt5XT7PAa5eEu7oiFcjVw/9UZdm0hTmYv+fqyXLp1tHabn0xzLfmNKUQb9W5ma4TGMyzKhyXL969Nx/UwU/+G1e8JZMhnbSG06Mya6j8bRo65rxcUQMI3Ku8KXOvp0eRXrNze6UVBBnVy8o9Vr1KnQhMmX5uXqSloncJt+amws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774854172; c=relaxed/simple;
	bh=UUxp9zVdjuMCkrTYyWHAgwLQg1C+01S5X3Kmdw8ZfDQ=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qsULBwL0LzBCb9QGDwoYPadj0vbhaD1kG7LZjJeN37z0rdyaqhEGR3n/TSqTq8exgkD38FRnaBaZ5Iege06MofKx7J5ZVenaqgcw1n8cKsOkb60RFur13/eV7WZZnVwiLE9WJZDU59GSexsVlzsEI/wu8UxVnPAjrz2Lnxfyjpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=2A4B09ik; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="2A4B09ik"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HCVKBFwb11nrfFL+Y7KYDFH0Rm5Q+OFvbfLuTs1Jujo=;
	b=2A4B09iknR9ycvNxpFS3+x867zPIt6rcWEh43yXw8Xio6aZGHeM2+vObAq5pGUAo6GJl48XAy
	KiqDvXiIh/d/Qg0ROLwLEqNXlP6Hik8iWlo+2T1bC8SFU4jxBYekBxq8A341/FZBz1lLDewGukl
	zFdk+bJAszqW5noxOfQXs30=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fkhrg3dpqz12LDJ;
	Mon, 30 Mar 2026 14:57:23 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 0ABCC4056D;
	Mon, 30 Mar 2026 15:02:48 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:02:47 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 30 Mar 2026 15:02:47 +0800
Subject: Re: [PATCH v4 3/5] ext4: fix the error handling process in
 extents_kunit_init).
To: Ritesh Harjani <ritesh.list@gmail.com>, Ye Bin <yebin@huaweicloud.com>,
	<tytso@mit.edu>, <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>
References: <20260319125434.333117-1-yebin@huaweicloud.com>
 <20260319125434.333117-4-yebin@huaweicloud.com>
 <ldfnxo07.ritesh.list@gmail.com>
CC: <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69CA2016.3030207@huawei.com>
Date: Mon, 30 Mar 2026 15:02:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ldfnxo07.ritesh.list@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500016.china.huawei.com (7.202.194.202)



On 2026/3/20 9:56, Ritesh Harjani wrote:
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
>> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
>> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>>   fs/ext4/extents-test.c | 43 ++++++++++++++++++++++++++++++------------
>>   1 file changed, 31 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
>> index 3d4663d99eb1..4ce3f81f6409 100644
>> --- a/fs/ext4/extents-test.c
>> +++ b/fs/ext4/extents-test.c
>> @@ -225,33 +225,37 @@ static int extents_kunit_init(struct kunit *test)
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
>
> Even though the patch looks ok, but still wanted to check if ...
>
> Do you think we can move ext4_es_register_shrinker() before setting up
> the mock inode and on error we simply return err?
> That way, there won't be any ambiguity in the error handling for calling
> ext4_es_unregister_shrinker()?
Sorry, I've been a bit busy lately. The idea is good, and I will send a
new version of the patch.
>
>>
>>   	ext4_es_init_tree(&ei->i_es_tree);
>>   	rwlock_init(&ei->i_es_lock);
>> @@ -267,8 +271,10 @@ static int extents_kunit_init(struct kunit *test)
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
>> @@ -313,6 +319,19 @@ static int extents_kunit_init(struct kunit *test)
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
>> +	ext4_es_unregister_shrinker(sbi);
>
> -ritesh
>
>
> .
>
