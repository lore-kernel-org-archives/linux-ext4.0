Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A1A3EA66;
	Sun,  5 Jul 2026 07:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783237250; cv=none; b=I6oWZJt8Mq8FqTc5XnTOgn4KPSi1HXk1TlRs7PTFwDF4dQsDFiLrLjV1Gb6rHnqHbEPui2yE4snAWg7qe+G+lyvTk4zVFEPD2Ir5P9HKdRZlJRSD9es/a/nmAHFnAzwkpLPDsHXWDYwQavYQk66Ng7Kckdjl/0ZIZW2fVWALc/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783237250; c=relaxed/simple;
	bh=vO48+m7+2WQQja+iFM4NWC6kEpNIK4AUz/HzNYfxPek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KMcnrdV6NOmP+oCFYl16ufO2GhZnCFddoUKZ0f7hur6JDDfK82TGEGcPiEDSAptFQehLk1aIk4JLryip6nEZhH3ishcOtd1as5iNwWrx3OgSQ0fXluY4SLKNkC9Nma8Ih4ZM5wEf/llqJ9ilm57c7MnmKs49vSCpw48hf7mQAHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e5zXHx/s; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e5zXHx/s"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783237238; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=poWmIpfrKGOp1k1Ii9e1PAXNinbhHNMj6ySg8b7FjMo=;
	b=e5zXHx/sKDc6JjCgTgP51Z8DzVwAGauK0bsCj1Sz/8atjYqTmlgbZPjyGlXj2DW+ijLr4hacB8oB4+jmq7LDL80r/+vNI81WXVWxqOx0j3hnOa3p0TZZ0rykhhpL+V2ImoiTW2cN2j9A70nHQOHzK6sMSmzzJZROUtoS3Ymllaw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X6NSUrE_1783237236;
Received: from 30.170.105.22(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X6NSUrE_1783237236 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 05 Jul 2026 15:40:37 +0800
Message-ID: <18cab6b1-d94e-4a82-a518-ba3c2ef02864@linux.alibaba.com>
Date: Sun, 5 Jul 2026 15:40:35 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
To: Theodore Tso <tytso@mit.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, Wang Jun <1742789905@qq.com>,
 adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 25125332@bjtu.edu.cn,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
 <2026062643-tamer-limes-a320@gregkh>
 <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>
 <2026070210-catty-grape-2568@gregkh>
 <b93095c6-0717-4616-9702-570b2927429b@linux.alibaba.com>
 <2026070315-crescent-factoid-616d@gregkh>
 <2904d1db-11fa-450a-89ea-20fe133fa268@linux.alibaba.com>
 <akehR1wEgK23wFp4@mit.edu>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <akehR1wEgK23wFp4@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/7/3 19:48, Theodore Tso wrote:
> On Fri, Jul 03, 2026 at 04:44:32PM -0500, Baokun Li wrote:
>>>> Either applying this fix patchset or reverting the incorrectly merged
>>>> commit should resolve the issue.
>>> How about submitting a revert so that we can start fresh and work from
>>> there?
>> Alright, I can help review the patches.
> Can you also double check whether your patchset actually fixes a bug
> in 6.6?  As near as I can tell, it wasn't needed for 6.1 at all.
>

The earlier patches in the "get rid of ppath" series that I tagged as
bugfixes have already been backported to stable.

The remaining "get rid of ppath" patches without a Fixes: tag (the ones
recently picked up by stable) are there purely for code readability and
to reduce the risk of future misuse — they don't fix any actual bug.

Looking at what was pulled in, the patch carries a tag:

  Stable-dep-of: 22784ca541c0 ("ext4: subdivide EXT4_EXT_DATA_VALID1")

which in turn is a dependency of:

  58ddae5d77b1 ("ext4: don't zero the entire extent if
EXT4_EXT_DATA_PARTIAL_VALID1")

— a fix for a stale data read when free space is low.

However, the dependency of 22784ca541c0 on the "get rid of ppath"
series is purely a context (textual) dependency; not backporting
those patches should cause no functional issues.


Thanks,
Baokun

