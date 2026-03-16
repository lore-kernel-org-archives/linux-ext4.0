Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A96322D785
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 01:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625005; cv=none; b=LGYCfz7N3JDchU4Rplz3JnAI97tuylf8778sqfWrU+503dSrvbrkHK97tcHO5eLxgx75jGXzwXLL9ZgXxp65c/xG8oCiPdgqC3JP+3AEJ1pMtgUVE9OLLsspYz9itIOnMOsh2mQwnoa/IUkYQneKH+5C0DDDMZzKE3ToWChhSxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625005; c=relaxed/simple;
	bh=t7/kdyEN91eM5zwS/SxO4RYy2CDoRkV/BxiMhAmpi7A=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cpgYQH6hwQZXoE5IHXh00Dwo8tzrmF+mWBQAXZ1RFSUFV78hprr14xCceOpzmL1yY6aEbRXXhiwYy7mY5YTpd9yjYjfSJ4ucWjj6HFIz3l0kOpr6nk1AxLl0VvecuViKh4jtr5J3nsa9dP9mhm2C58S6QiEFtOxPHcg5sBE83y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=eKSmagyT; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="eKSmagyT"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Tki79+TSS+WPFsf9cqJEpt2PSMXubVSmIl8Kjd9/Kcw=;
	b=eKSmagyT6PGHk7dfajTst1d5QSvDwiu0151tZHYCzCFpOUgz7eSYe11jKjoJLJBsQ/Lwxx29w
	oNpCyhmNTe21ZL67vFEZKPQjgcPy47JkfP+1AoqTJh136yenyVju7t7ipJDU1m6IUtPl4BTEo9Q
	TT9BFsP9qqpkX9m6Oe5s0+Q=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fYyGY1QgBznTXQ;
	Mon, 16 Mar 2026 09:31:01 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 443A24056C;
	Mon, 16 Mar 2026 09:36:34 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 09:36:34 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 09:36:33 +0800
Subject: Re: [PATCH v3 3/5] ext4: fix the error handling process in
 extents_kunit_init).
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Ye Bin
	<yebin@huaweicloud.com>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<linux-ext4@vger.kernel.org>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
 <20260314074903.1314851-4-yebin@huaweicloud.com>
 <h5qitwzt.ritesh.list@gmail.com>
CC: <jack@suse.cz>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69B75EA0.60402@huawei.com>
Date: Mon, 16 Mar 2026 09:36:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <h5qitwzt.ritesh.list@gmail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500016.china.huawei.com (7.202.194.202)



On 2026/3/14 20:29, Ritesh Harjani (IBM) wrote:
> Ye Bin <yebin@huaweicloud.com> writes:
>
>> From: Ye Bin <yebin10@huawei.com>
>>
>> The error processing in extents_kunit_init() is improper, causing
>> resource leakage.
>> Reconstruct the error handling process to prevent potential resource
>> leaks
>>
>
> Minor nit.
>
>> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
>> Signed-off-by: Ye Bin <yebin10@huawei.com>
>> ---
>>   fs/ext4/extents-test.c | 44 ++++++++++++++++++++++++++++++------------
>>   1 file changed, 32 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
>> index 3d4663d99eb1..543236a31e13 100644
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
>> @@ -313,6 +319,20 @@ static int extents_kunit_init(struct kunit *test)
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
>> +	if (sbi->s_es_shrinker)
>> +		ext4_es_unregister_shrinker(sbi);
>
> I don't think this extra check is necessary.
> ext4_es_unregister_shrinker() already has checks in place.
>
I was mainly thinking about what abnormal behavior might be caused if 
percpu_counter_destroy() is called before percpu_counter_init() is called.
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>
>> +	deactivate_locked_super(sb);
>> +	kfree(sbi);
>> +
>> +	return err;
>>   }
>>
>>   /*
>> --
>> 2.34.1
>
> .
>
