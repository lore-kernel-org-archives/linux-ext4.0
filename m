Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBB7412C08;
	Fri,  4 Sep 2026 07:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788506422; cv=none; b=QhdM/tW2mRHpwYoGRF9dHY8eXCkAWGX3d+Pb9hzw8/WZkWkPch9l+xEMU2dzhDrz1x8bga8wLfwS3CGYzMNEFggumegLHrLYMvUAXhC3RnBgKWrvYQQgvBRzeSXWReAq0y/jvSdEMOkWmUnGdOe6S6zlvUOc5UnCVCoiyHjdexI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788506422; c=relaxed/simple;
	bh=p4d0dYw56yYEgiROOScQizDjwMIRsCID6kb8JN+Oio4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ayuYERuLfyZmOej2EblbzikKniRR4uiinyW6wWhntzZvTE3lNk0ZjhK0wxlLTIwCKl4qMc0mjAYp9Gh7IfZUAp/GZktDeo0vOv+g09WFzHzhbKbJZXDKME9r/2PxrVZEPvKBM2uNZRjoZ9HeGBE6KLrzCRJ8H1mBar3AmZImYJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=G+S+mkvn; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="G+S+mkvn"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=elhCMLlv6addeVJhTAMH4AZztV6+lN1fBi4N6jg/Hes=;
	b=G+S+mkvnwheaAgmEpR99K5hl6iebTT6Y4BZ63v6JQrUq5qNLUHxmmMJyHjqtDQYfVMjAGX8nJ
	Eq479iD+3yCWhX8U7DOxA/F4VG2yueoH/4gkb3b6opMoQ7zK9RWP3vctK7tpBU07JeV2Zv0V8Ro
	lihMDRcTyslMBGgCHvHBnrI=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hbncr4ykZz1T4MQ;
	Fri,  4 Sep 2026 15:08:44 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id EDB5640579;
	Fri,  4 Sep 2026 15:20:08 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 kwepemk200008.china.huawei.com (7.202.194.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 15:20:07 +0800
Message-ID: <c2400971-42bc-463c-a644-d2e307bd88ac@huawei.com>
Date: Fri, 4 Sep 2026 15:20:07 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] Convert barrier pairs to acquire/release for
 better performance
To: Theodore Tso <tytso@mit.edu>
CC: <bcrl@kvack.org>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<jack@suse.cz>, <adilger.kernel@dilger.ca>, <libaokun@linux.alibaba.com>,
	<ojaswin@linux.ibm.com>, <ritesh.list@gmail.com>, <yi.zhang@huawei.com>,
	<sforshee@kernel.org>, <akpm@linux-foundation.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <senozhatsky@chromium.org>, <kees@kernel.org>,
	<tglx@kernel.org>, <linux-fsdevel@vger.kernel.org>, <linux-aio@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-ext4@vger.kernel.org>
References: <20260902074805.398540-1-ruanjinjie@huawei.com>
 <apgv5w116frzutwH@mit.edu>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <apgv5w116frzutwH@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk200008.china.huawei.com (7.202.194.74)



在 2026/9/2 22:19, Theodore Tso 写道:
> On Wed, Sep 02, 2026 at 03:47:57PM -0500, Jinjie Ruan wrote:
>>
>> This series converts some existing smp_wmb()/smp_rmb() barrier pairs to
>> smp_store_release()/smp_load_acquire() across various subsystems.
> 
> I would like to land the ext4 related patches through the ext4 tree,
> so please detach them from this patch series.  That's because I want
> to be able to monitor the regression testing before sending a pull
> request to Linus.

Hi Ted,

Thanks for your feedback. I will split out the ext4-related patches.

Thanks,
Jinjie

> 
> More generally, I think we should be looking at this kind of barrier
> conversion on a per site basis.  If there is a bug that isn't notice,
> it can result in a very hard to debug problem.  And if the benefit of
> speeding up a particular code path isn't particularly that great,
> maybe the cost vs benefit vs risk calculation might cause us to decide
> to take a pass on the change.
> 
> Cheers,
> 
> 					- Ted

