Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3764A175A94
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2026 02:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773800500; cv=none; b=pb/VptyCSiq9K5LeChHlYbAHD79msOrHaZ1Uz94G/KDFmhEDLu/+APscQN38ZJ9Bs2ormCgX7p0rCg/F7DXw4mVbiXhI6DJLJeyRwibBMWsEbVtqueqH/496PHTrHZwfeoRM3nrQIPFMSjylp5doVLOxTWIq8OMOSSb9Dc/c+5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773800500; c=relaxed/simple;
	bh=GraK2Aba5B9PUrf3QQng6QzpbqB9FRyiTbLIVA/Uw7Y=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MOk4a60fkqvGj/HH7u9RYducw04F4Arjy8sUPHA4rxoZj4ugFiZ9yqNVmCtK9E1CTKtGqg2AX40yDlQ4EYlOqcWzQZChQKiuVtExNXnvV2sZBc7kLWiJEuGrEeKcxxqF8JR/vKBcA1tDmpsIrEawcbl4rCtgTd6hFKp5aoz/UEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=C+dEC1ac; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="C+dEC1ac"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DnqWLOnYSmhtMkIiVDXogc5cpjayjSjSN9tKbjQJoIg=;
	b=C+dEC1ac0GyiiZsdm8Ahg54+9HsPgPT35yYPMv477In5/YNlYbK67rTzEm3qCQ1L8MY3EyOaI
	f/LPsIs2od6AQY5v88ucK7v1AjTixmWretnBUk8UYRuVlzV3FTZKM03TIIgiQ/bF4I7f7BS1owY
	Ao4TTXifizCPJY4LFOwAaE0=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fbC9Y6j23znV1M;
	Wed, 18 Mar 2026 10:16:01 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id CE2E04056B;
	Wed, 18 Mar 2026 10:21:33 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 18 Mar 2026 10:21:19 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 18 Mar 2026 10:21:19 +0800
Subject: Re: [PATCH v3 1/5] ext4: call deactivate_super() in
 extents_kunit_exit()
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ye Bin <yebin@huaweicloud.com>
References: <20260314074903.1314851-1-yebin@huaweicloud.com>
 <20260314074903.1314851-2-yebin@huaweicloud.com>
 <abZGBuItRfxDGe7m@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>,
	<jack@suse.cz>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69BA0C1E.3060207@huawei.com>
Date: Wed, 18 Mar 2026 10:21:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <abZGBuItRfxDGe7m@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500016.china.huawei.com (7.202.194.202)



On 2026/3/15 13:39, Ojaswin Mujoo wrote:
> On Sat, Mar 14, 2026 at 03:48:59PM +0800, Ye Bin wrote:
>> From: Ye Bin <yebin10@huawei.com>
>>
>> Call deactivate_super() is called in extents_kunit_exit() to cleanup
>> the file system resource.
>>
>> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
>> Signed-off-by: Ye Bin <yebin10@huawei.com>
>> ---
>>   fs/ext4/extents-test.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
>> index 5496b2c8e2cd..e3d23e3cda87 100644
>> --- a/fs/ext4/extents-test.c
>> +++ b/fs/ext4/extents-test.c
>> @@ -146,6 +146,7 @@ static void extents_kunit_exit(struct kunit *test)
>>   	struct ext4_sb_info *sbi = sb->s_fs_info;
>>
>>   	ext4_es_unregister_shrinker(sbi);
>> +	deactivate_super(sbi->s_sb);
>>   	kfree(sbi);
>>   	kfree(k_ctx.k_ei);
>>   	kfree(k_ctx.k_data);
>> --
>> 2.34.1
>
> Hi,
>
> We need to keep this patch after Patch 2 because else there is a
> deadlock:
>
> extents_kunit_init()
>    sget
>      down_write(s_umount)
> extents_kunit_exit()
>    deactivate_super
>      down_write(s_umount)
>
> Regards,
> ojaswin
>
Thank you for your suggestion. I will change the order of the two
patches and release another version.
>
> .
>
