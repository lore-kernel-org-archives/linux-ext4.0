Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E2A2472AE;
	Thu,  3 Sep 2026 01:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788399774; cv=none; b=Wp0aK3JCmW9w1qPXHSy8xkkkc9DTPUAoaYyaELM20gPpWmRBLg2lidHMoK5O1TMK2EqmJitzCqCw07Wm7WEBH6lC7VZ2eejL/bCFH8+c99bVtF7PDF0XRXXptOHSD/5dbyYykTHS09U17SwGQH0OKUVa8/b5VaGBDcTLxQUd23U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788399774; c=relaxed/simple;
	bh=hwpEuxVD/9Bq/YzTjwAvPBqgFlC2SPXsYiaJ4/VaNRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kWVyVhWt09wSzHAsR+rCvJSPGFuIr2SxkYXGHfn4Z8QW9+cs4FOzoSQYGyAYMzXAG3lrv1i74Ea9jRbhgWRBU6bEoIgzB2RZeqOMC4TK7szVKFX0fNg/4YwCstY+oK8n4KeaV7fbSkYSRCKbbtYgaZI4BBqPL3IQoWO50o5yxTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=X85m0g9D; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="X85m0g9D"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Syyvxs0/HwnbtLn0FvywOXFsVyuveCrAIzy0j65geqo=;
	b=X85m0g9DC3A0ppiIeYfMPjPEikzTPDvqSHJq8Oh6veduOIrfC8/HOUa12jE3RTsWUHGKlFP7d
	93dyjVnlHLZdX530QglBaz3JSEm8VNp9+k7eK/VO/1oL8OscqrKJhJHT241nX6pmqa0fbq5JwkP
	TuMtJGfV6RnXfXbwKVMiyPA=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hb2Bg0JkLzcbXM;
	Thu,  3 Sep 2026 09:31:55 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id EA26E4057F;
	Thu,  3 Sep 2026 09:42:41 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 3 Sep 2026 09:42:40 +0800
Message-ID: <1d84f549-30f8-4070-b9b6-2d6c8ed10131@huawei.com>
Date: Thu, 3 Sep 2026 09:42:39 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/8] user_namespace: Use acquire/release for nr_extents
 synchronization
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <bcrl@kvack.org>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<jack@suse.cz>, <tytso@mit.edu>, <adilger.kernel@dilger.ca>,
	<libaokun@linux.alibaba.com>, <ojaswin@linux.ibm.com>,
	<ritesh.list@gmail.com>, <yi.zhang@huawei.com>, <sforshee@kernel.org>,
	<akpm@linux-foundation.org>, <pmladek@suse.com>, <rostedt@goodmis.org>,
	<linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <kees@kernel.org>,
	<tglx@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <20260902074805.398540-2-ruanjinjie@huawei.com>
 <apgek5EhgjxpDCkh@ashevche-desk.local> <apge-t-tp00Tl9TL@ashevche-desk.local>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <apge-t-tp00Tl9TL@ashevche-desk.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/9/2 21:04, Andy Shevchenko 写道:
> On Wed, Sep 02, 2026 at 04:03:23PM +0300, Andy Shevchenko wrote:
>> On Wed, Sep 02, 2026 at 03:47:58PM +0800, Jinjie Ruan wrote:
>>> Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
>>> when publishing and consuming `nr_extents`. This expresses the
>>> publish/subscribe pattern more clearly and allows architectures with
>>> native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
>>> the cost of full one-way barriers (DMB ISHST/ISHLD).
>>>
>>> No functional change intended.
>>
>> Please, locate Cc list...
>>
>>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>>> Cc: Christian Brauner <brauner@kernel.org>
>>> Cc: Jan Kara <jack@suse.cz>
>>> Cc: Seth Forshee <sforshee@kernel.org>
>>> Cc: Kees Cook <kees@kernel.org>
>>> Cc: Aleksa Sarai <cyphar@cyphar.com>o
>>
>> ...(all the above)...
> 
> Important remark: this is only about Cc, the regular tags have to be
> in the commit message trailers (such as Reviewed-by).

Got it. Will separate Cc from trailers.

> 
>>> Assisted-by: DeepSeek:DeepSeek-V3
>>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>>> ---
>>
>> ...somewhere here. It will have the same effect on the email thread and it will
>> unload the commit message from the unneeded noise.
>>
>>> v2:
>>> - Add missing load replace in copy_mnt_idmap()
>>> ---
>>>  fs/mnt_idmapping.c      |  5 ++---
>>>  kernel/user_namespace.c | 24 +++++++++++++-----------
>>>  2 files changed, 15 insertions(+), 14 deletions(-)
>>
>> ...
>>
>> This comment applies to the whole series.
>> Also note, `b4 trailers` can handle that, you can keep the
>>
>>   ---
>>   Cc: ...
>>
>> in the local Git. You can find some details in the subthread here
>> https://lore.kernel.org/lkml/20260123113708.416727-19-bigeasy@linutronix.de/
> 

