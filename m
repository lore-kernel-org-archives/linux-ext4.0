Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9A7275B03;
	Tue,  1 Sep 2026 01:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788227055; cv=none; b=ePQiIvYMEcueDIV45xEVjja6pGwmd8/kfKRNdMIxyRfGIqUdc1hUH2PmSfvzTNI2WY3O9O6hBTQDcFqvzhQTAoHErNIROEDdkZyQQF/smhA0gHRaEH7NMIgUgNgkVPXrpm5tQzbpdzZ4KBBPur6tEzdVr4Y1mmU9Z2Up4vgzLMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788227055; c=relaxed/simple;
	bh=TB6RZD/pt7Gz8TU3lj3c6JpMlbDlwhfy9NYrF5ISpKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EpDYS2IJYud1dLcUO3ThbBGViA1eKIre7+ZlkIWNdizKU1IoLAQtmOqcby2JgtJKyNUAa+/EHV0IPO3i+i68b0Gg9EAruUPQmer+WUfwgl1HLQY8F7wKRu1jqUvW4ZyuCW2rUE4SwHNjC+md1C1Xbw+cd2gFppwXiWKp4wg/qrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=tlNmZK3x; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="tlNmZK3x"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=N36HLPGcjsZJzfg6qhBaQf589Afsp8pwfdoIrnl6OtA=;
	b=tlNmZK3xuIYt4C3tGPgcR0z1kNZ2XiMu/JKnt0zt7LX2UBANk4iDBPWxJ0taIS6DcddFlkp38
	MBPfYalEna/PP9C9nlRSF/MTe5TClD4SW7jDtl4G2ZUABZ1gBfookUXwnNB1lfM9RM/EBZAXuqL
	3zN37a05cU3rci5OdZA4N4g=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hYpJY2gH6z1T4JN;
	Tue,  1 Sep 2026 09:32:45 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 1014F202E6;
	Tue,  1 Sep 2026 09:44:05 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 1 Sep 2026 09:44:02 +0800
Message-ID: <c9e5f38c-d067-494a-8eaa-b1f2c2ee305f@huawei.com>
Date: Tue, 1 Sep 2026 09:44:01 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] fs: aio: Use acquire/release for ring->tail
 publication
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
 <20260825095422.3166067-4-ruanjinjie@huawei.com>
 <x75um7rluga7zvqhe4wdqj76hjnyazpaxqs4ugme4eaompfsf6@zzj5flkfcw26>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <x75um7rluga7zvqhe4wdqj76hjnyazpaxqs4ugme4eaompfsf6@zzj5flkfcw26>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)



在 2026/8/31 20:13, Jan Kara 写道:
> On Tue 25-08-26 17:54:14, Jinjie Ruan wrote:
>> Replace the smp_wmb() + WRITE_ONCE(ring->tail) and READ_ONCE(ring->tail)
>> + smp_rmb() barrier pair with smp_store_release()/smp_load_acquire()
>> on `ring->tail`.
>>
>> This expresses the publish/subscribe pattern more clearly and allows
>> architectures with native acquire/release instructions (e.g. arm64's
>> STLR/LDAR) to avoid the cost of full one-way barriers (DMB ISHST/ISHLD).
>>
>> The release ensures event data written before updating ring->tail is
>> visible to readers that observe the new tail value via acquire, which
>> is exactly the ordering the barrier pair provided.
>>
>> No functional change intended.
>>
>> Assisted-by: DeepSeek:DeepSeek-V3
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
> The patch looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> Just one nit below:
> 
>> diff --git a/fs/aio.c b/fs/aio.c
>> index d78acc69f487..4413c82688cc 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -1206,13 +1206,12 @@ static void aio_complete(struct aio_kiocb *iocb)
>>  	/* after flagging the request as done, we
>>  	 * must never even look at it again
>>  	 */
>> -	smp_wmb();	/* make event visible before updating tail */
>> -
>> -	ctx->tail = tail;
>> +	WRITE_ONCE(ctx->tail, tail);
> 
> I don't thing ctx->tail is accessed anywhere outside of completion_lock so
> I think this WRITE_ONCE is pointless.

I agree with that. I'll drop the unnecessary WRITE_ONCE in v2.

> 
> 								Honza

