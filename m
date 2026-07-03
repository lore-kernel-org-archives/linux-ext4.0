Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BF536E460;
	Fri,  3 Jul 2026 07:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783065442; cv=none; b=QAf/e3TEDuVOuGWsgwNB4AqYhVGCLo4+poyGwEXrbIF5vfqGzKYamqqVPJwrDgXVXTsbnM8pfoh48pHfdwKM3D6BKl8QCIHUPaw003ZYbj8CGWN3Xi6HyYj168He8+UjFtyQBc3gPgKxfcGB+orxAv7BxO0r0DfvxowZ4CmKw7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783065442; c=relaxed/simple;
	bh=Vta1+vp2i+4VI6pEZZ43d5zvxBshInKjYhg+Kpo4600=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GNkYd1Hv9kpGIFoUVhoWb/stx9rPqxCGEgV6jiTYqomVEk26+auOGRJugKfvfoqPkG2ynFb0bUWDy508X6kBIPvJpQm2GRTKaEwqdik2zA1CHk+0AKVo9eU8lnICE+PuTCXK1eCRvGfNbyC/VljR/wo7qevRmGYnstKhEOyhDUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PBJM57/N; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PBJM57/N"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783065432; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gzZn24puWspThT2YANHj6Y56yEZL3byW0T0qvsKl+OA=;
	b=PBJM57/NATGucMxvYSSXdsx+qgj+OYiYzYWVzuvJIJcpZXDZXySv0dCH4A4BNfb/URw9e7Zlm7i5hfvYb0yAj52rUtcawLO5LZhMxYVTsBY2FXg7/POoWpKEQksXYJdqQuyWf69NPU/YGivY3tvdQlxef/wx/+xJ54vL7fQfAZM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X6IcxhT_1783065430;
Received: from 30.221.129.235(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X6IcxhT_1783065430 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jul 2026 15:57:10 +0800
Message-ID: <b93095c6-0717-4616-9702-570b2927429b@linux.alibaba.com>
Date: Fri, 3 Jul 2026 15:57:09 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, Wang Jun <1742789905@qq.com>,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, libaokun1@huawei.com,
 25125332@bjtu.edu.cn, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
 <2026062643-tamer-limes-a320@gregkh>
 <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>
 <2026070210-catty-grape-2568@gregkh>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <2026070210-catty-grape-2568@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/7/2 13:47, Greg KH wrote:
> On Thu, Jul 02, 2026 at 09:48:33AM +0800, Jiayuan Chen wrote:
>> Hi Greg,
>>
>> Any update here ?
> What is "here"?  There is no context in this email :(
>
>> We rebased the 6.6 stable one week ago and also found the same regression.
> What regression?  Again, no context :(
>
> confused,
>
> greg k-h

For some reason, LTS only merged a subset of my patchset, causing
some commits to lack their prerequisite patches. This leads to error
numbers being interpreted as valid pointers.

For details, see the fix patchset that Erkun submitted to 6.6.y
(it fell through the cracks for some reason):

https://lore.kernel.org/all/20260421113416.4040274-1-yangerkun@huawei.com/

Either applying this fix patchset or reverting the incorrectly merged
commit should resolve the issue.


Thanks,
Baokun

