Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0702B30569A;
	Thu,  3 Sep 2026 02:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788401829; cv=none; b=ie225Xz68odr4pR7oquRty88Qg+pCIl1l7+pnSye+0HRKKqt+Byt1XwEdoYhTRdCG+uiDVSAyBtngSiB4jxpEhIjBkTvceh6LAcfgu8BZclJjshTZBalXzJm3xicCQtHH9s/J01nvlDIkP5yVua7+PF37mAYgEYKpHMn+bRILHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788401829; c=relaxed/simple;
	bh=47V+vDREza1Jke9T2OlqAsrLIDf18mvchBIjfR/fPfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ac7ixIataEvFMR4mFULK8BI+n0XFpfjQLTR2wy3P6J9yN2cERauyvtU5eevZEG9HjKZpeYG/ufv0sNTWBtUQtQOiclrnswkvTrEROS41+59UApx3cVv65oGw7EtbzF6yEG4+Gb+AJ6BKyFW7zQjThckeZiBN0K0yQ2NrdhmflG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=m+hjODqc; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="m+hjODqc"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ClBLlr16SaRl4J7fK6tLV1b9pAlghdZN45yFsSJHVsM=;
	b=m+hjODqcZwuKoUphxD4/B0YqH6P3615yLNS3HQUbbb7DCBHhxIqu7iMuHPF96Uqw8IulzurtV
	S35d2yhEzkwAaMx2SVdwWEuk+JJrRzuSagsUQwUYLcMjaFDREnNZajSvrGfJIufzgBPuapQVyw8
	+HkSw1A1bb4PV2cXN8N8fxI=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hb2xb3lJhznV0D;
	Thu,  3 Sep 2026 10:05:39 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 4E8ED4057A;
	Thu,  3 Sep 2026 10:16:52 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 3 Sep 2026 10:16:51 +0800
Message-ID: <d8752b50-3db4-495f-a1c6-1047299c819c@huawei.com>
Date: Thu, 3 Sep 2026 10:16:50 +0800
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
 <apgek5EhgjxpDCkh@ashevche-desk.local>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <apgek5EhgjxpDCkh@ashevche-desk.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/9/2 21:03, Andy Shevchenko 写道:
> On Wed, Sep 02, 2026 at 03:47:58PM +0800, Jinjie Ruan wrote:
>> Replace smp_wmb()/smp_rmb() with smp_store_release()/smp_load_acquire()
>> when publishing and consuming `nr_extents`. This expresses the
>> publish/subscribe pattern more clearly and allows architectures with
>> native acquire/release instructions (e.g. arm64's STLR/LDAR) to avoid
>> the cost of full one-way barriers (DMB ISHST/ISHLD).
>>
>> No functional change intended.
> 
> Please, locate Cc list...
> 
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Seth Forshee <sforshee@kernel.org>
>> Cc: Kees Cook <kees@kernel.org>
>> Cc: Aleksa Sarai <cyphar@cyphar.com>o
> 
> ...(all the above)...
> 
>> Assisted-by: DeepSeek:DeepSeek-V3
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
> 
> ...somewhere here. It will have the same effect on the email thread and it will
> unload the commit message from the unneeded noise.

Many thanks for your kind reminder.

> 
>> v2:
>> - Add missing load replace in copy_mnt_idmap()
>> ---
>>  fs/mnt_idmapping.c      |  5 ++---
>>  kernel/user_namespace.c | 24 +++++++++++++-----------
>>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> ...
> 
> This comment applies to the whole series.
> Also note, `b4 trailers` can handle that, you can keep the

Previously, I added Cc and review tags manually. I'll take some time to
learn how to use b4 trailers to manage the format properly.

> 
>   ---
>   Cc: ...
> 
> in the local Git. You can find some details in the subthread here
> https://lore.kernel.org/lkml/20260123113708.416727-19-bigeasy@linutronix.de/
> 

