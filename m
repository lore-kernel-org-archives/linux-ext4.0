Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D636377EB8;
	Fri,  3 Jul 2026 08:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068279; cv=none; b=h+nqQ5d0ZpUPnXAnHMj4zCRXcUQwBpxixRf8LlubXmV4GFQuop+1WzfysrNxNMp2k4m19/pAErahPnC45v2yl+q3npoA/wUlzXIjC/qUEcfs1/zEqNNmvZaCK11r/flHuXaQwUtyF403dEwUOcq5u4B4biBiep5XvxvtTYc/mBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068279; c=relaxed/simple;
	bh=5f5VORH3zawg/gO3b17vYMgZ7k1ax6oaoAxOZ6GP99g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CQV/1vGPeot0qAiC4WtIRVEYBwTJRVgqi+wU3Ys9KeqACcOfXYIkLJm4kN6SMwIbxTFQt8nmsc0ahxcjSb+9Fn00+7NwUHG8iJ/WQ2O9xXrawB4tSacvwZet8OiyVkrJhCXZE29MyIZmR8+HoNqz7EAk698Ts48mCCAZYY2EhGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XH1OtT0m; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XH1OtT0m"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783068273; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=heLiIQaQ67iQ8EJ+Osbvfe//KC72f/O5+l/x4rW5RyQ=;
	b=XH1OtT0mQh7l17sKw2Jg9NkVC8PS3Ae95e072pvjRn6ZOSiKoDflw/eDFc3TO9IkQHWDT+w1/xTxTd7QygYFPFofc5Fi7Jdm7WeWbATmRiyENMO+qT2yoFpN+fJCCJKzx57iTSnkbB5Ke+A5kuFf5E7ojQ1R6Ljee4Kex2Pi+EM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X6IjTR5_1783068272;
Received: from 30.221.129.235(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X6IjTR5_1783068272 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jul 2026 16:44:33 +0800
Message-ID: <2904d1db-11fa-450a-89ea-20fe133fa268@linux.alibaba.com>
Date: Fri, 3 Jul 2026 16:44:32 +0800
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
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 25125332@bjtu.edu.cn,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
 <2026062643-tamer-limes-a320@gregkh>
 <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>
 <2026070210-catty-grape-2568@gregkh>
 <b93095c6-0717-4616-9702-570b2927429b@linux.alibaba.com>
 <2026070315-crescent-factoid-616d@gregkh>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <2026070315-crescent-factoid-616d@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/7/3 16:20, Greg KH wrote:
> On Fri, Jul 03, 2026 at 03:57:09PM +0800, Baokun Li wrote:
>> On 2026/7/2 13:47, Greg KH wrote:
>>> On Thu, Jul 02, 2026 at 09:48:33AM +0800, Jiayuan Chen wrote:
>>>> Hi Greg,
>>>>
>>>> Any update here ?
>>> What is "here"?  There is no context in this email :(
>>>
>>>> We rebased the 6.6 stable one week ago and also found the same regression.
>>> What regression?  Again, no context :(
>>>
>>> confused,
>>>
>>> greg k-h
>> For some reason, LTS only merged a subset of my patchset, causing
>> some commits to lack their prerequisite patches. This leads to error
>> numbers being interpreted as valid pointers.
>>
>> For details, see the fix patchset that Erkun submitted to 6.6.y
>> (it fell through the cracks for some reason):
>>
>> https://lore.kernel.org/all/20260421113416.4040274-1-yangerkun@huawei.com/
>>
>> Either applying this fix patchset or reverting the incorrectly merged
>> commit should resolve the issue.
> How about submitting a revert so that we can start fresh and work from
> there?

Alright, I can help review the patches.


Thanks,
Baokun

