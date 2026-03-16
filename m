Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8081E263F44
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2026 01:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625320; cv=none; b=RQu977duE9pUXQkSbvEsi907mSFIZPGpDvd/pA5t4qsoEaDI4Jgu0YYpiZwkj30L4nM8s0tAgRf/aYhTepWcTfN5Tkno6+d+tlddLuqiZ6pZ2VOH4yvulPn8vS1JWdCq2P7bd6hv1HBIqpQzqAIIAgV6fe+J6C6TQ1cO+DESXAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625320; c=relaxed/simple;
	bh=7HMhAKJpNvzfHCUMquln84n+IOU/8fvR7Hs+J3oD1CY=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NsZj9ddxRgnFcSiD/sdg7yrWWiLimWwID6sNBqOS4o7oeq+fO8r63/3dKkhuJpst9dSfrq5s1yFhdmAPeRTD9aeIeN+TVl+iQ4HWZqWS24tHFgn/MwKowIQS6H0X0NqQvieHm37EEDel3v7ZZeWlDkpa0dYBGzshcjSBcb6owGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jSC/uMmh; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jSC/uMmh"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8HCL3F5B87Sxh2hmWYBTmQjzWeKHYDiLe6dT7SK9w18=;
	b=jSC/uMmhkQXFVU6sinZyeB0c7E3CqcX1Fnochny96C6QBbcw6Vp7ZBLXyhIKqI+Z8ishQTLMC
	wKyfHjzG7kuaXqbiuilJeFAAfENtxJ28xr3qc0HDhlpqL7HMbrE9U2PjGPF2WdDEY4fFmDzh4Gw
	hs9HMm5zoQX0FdTAcGVVnLU=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fYyPQ0FyqzKm5q;
	Mon, 16 Mar 2026 09:36:58 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id D0BFC402AB;
	Mon, 16 Mar 2026 09:41:56 +0800 (CST)
Received: from kwepemq500016.china.huawei.com (7.202.194.202) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 09:41:56 +0800
Received: from [10.174.178.185] (10.174.178.185) by
 kwepemq500016.china.huawei.com (7.202.194.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 09:41:56 +0800
Subject: Re: [PATCH v2 0/3] decoupling the ext4 test module
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ye Bin <yebin@huaweicloud.com>
References: <20260314075258.1317579-1-yebin@huaweicloud.com>
 <abZVUmszFisfOdmz@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
CC: <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <linux-ext4@vger.kernel.org>,
	<jack@suse.cz>
From: "yebin (H)" <yebin10@huawei.com>
Message-ID: <69B75FE3.80601@huawei.com>
Date: Mon, 16 Mar 2026 09:41:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <abZVUmszFisfOdmz@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500016.china.huawei.com (7.202.194.202)



On 2026/3/15 14:44, Ojaswin Mujoo wrote:
> On Sat, Mar 14, 2026 at 03:52:55PM +0800, Ye Bin wrote:
>> From: Ye Bin <yebin10@huawei.com>
>>
>> This patchset is split out from the "Fix some issues about ext4-test"
>> patchset. It decouples mballoc-test.c and extents-test.c from the
>> ext4 module, resolving the issue where these two tests could not be run
>> when EXT4_KUNIT_TESTS is set to M.
>>
>> Ye Bin (3):
>>    ext4: introduce EXPORT_SYMBOL_FOR_EXT4_TEST() helper
>>    ext4: fix mballoc-test.c is not compiled when EXT4_KUNIT_TESTS=M
>>    ext4: fix extents-test.c is not compiled when EXT4_KUNIT_TESTS=M
>
> Hi Ye,
>
> So thinking about this a bit more, is there any reason we are not using
> the VISIBLE_IF_KUNIT and EXPORT_SYMBOL_IF_KUNIT macros directly?  Is
> there any case that they don't handle?
>
A limitation of directly using the VISIBLE_IF_KUNIT and
EXPORT_SYMBOL_IF_KUNIT macros is that they rely entirely on the
CONFIG_KUNIT configuration being enabled. However, enabling
CONFIG_KUNIT does not necessarily mean that EXT4_KUNIT_TESTS is
enabled. If EXT4_KUNIT_TESTS is not enabled, there is no need to export
the symbols.
> [1] https://docs.kernel.org/dev-tools/kunit/usage.html#testing-static-functions
>>
>>   fs/ext4/Makefile       |   5 +-
>>   fs/ext4/ext4.h         |   5 ++
>>   fs/ext4/ext4_extents.h |  12 +++++
>>   fs/ext4/extents-test.c |   8 ++--
>>   fs/ext4/extents.c      |  39 +++++++++++++---
>>   fs/ext4/mballoc-test.c |  81 ++++++++++++++++----------------
>>   fs/ext4/mballoc.c      | 102 +++++++++++++++++++++++++++++++++++++++--
>>   fs/ext4/mballoc.h      |  30 ++++++++++++
>>   8 files changed, 227 insertions(+), 55 deletions(-)
>>
>> --
>> 2.34.1
>>
>
>
> .
>
