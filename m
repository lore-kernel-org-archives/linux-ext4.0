Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F9636C9D5
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jul 2026 06:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782972613; cv=none; b=TNYgVONzv1vbf4fvelTv+p4uAsVP8+HnPgxJvlH6LQFhRFElFlBpbVXJ7jvKRRs3/zttE9xmWufL/P6/dwkPgE2iZ+BDxOaUHVq6LvA4JC96Gnuw+9R8fvMQ//zwrfu0kbHKwkVHHuNaSHTtNx02g+4IZInQYK9wfhwYJxdALuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782972613; c=relaxed/simple;
	bh=2mVa806GdsgnBUdtwgowmJH5DKkzweKJma2DxtSgPI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=upAdzoztY48sVNFzhq9er7U4Lwu4Ep6O4OGX1a0cNq71GjACkS3T2UbqqF3cI0KCvA2zsBmWcHE0HirfPQmrI4XRAoKFeYSZBZAH/tfPKZe4AQusBPh4IRVWzhdLeAQDb5lESvvQgAIckXadIJD6TLVdW7gUHxz8fsJJV+plqrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ijJw/ilO; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ijJw/ilO"
Message-ID: <8b1d5b5d-61f5-40b1-95d4-35f98a280db8@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782972600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4RkVF5jg7OnZN5tmk1b/EFsXMnULO9gOlk19FjEZoQU=;
	b=ijJw/ilOjcdKFD0ygUOYE//04Rf1ZQOb5omPfPZp11rgZqAhjNE8IzN6Y+AgBbao7VvaL6
	KIBNHNCN+XaInpJ8hI/lyObI9ubVMkzQQRIMKsK18UmTHUsWVyGfAr6juB+6p1yYppdl1g
	aaQTYdZi1n/43dBpk7o6g8eNfpqNVGg=
Date: Thu, 2 Jul 2026 14:09:53 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Wang Jun <1742789905@qq.com>, tytso@mit.edu, adilger.kernel@dilger.ca,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, libaokun1@huawei.com, 25125332@bjtu.edu.cn,
 Jan Kara <jack@suse.cz>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
References: <tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com>
 <2026062643-tamer-limes-a320@gregkh>
 <rrsgndgpxyrmu6okb43u6wkdaibbidlbyqgugeeijd2b44sf4y@6lzmm4v4xvdp>
 <2026070210-catty-grape-2568@gregkh>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <2026070210-catty-grape-2568@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 7/2/26 1:47 PM, Greg KH wrote:
> On Thu, Jul 02, 2026 at 09:48:33AM +0800, Jiayuan Chen wrote:
>> Hi Greg,
>>
>> Any update here ?
> What is "here"?  There is no context in this email :(


Sorry I dropped the context:

https://lore.kernel.org/stable/tencent_C982B0201FE8F041BD5B4FC1ED7D646A740A@qq.com/


This patch is trying to fix the regression which Introduced by this series:

     [PATCH 6.6 046/567] ext4: get rid of ppath in ext4_ext_insert_extent()

https://lore.kernel.org/all/20260323134534.939905793@linuxfoundation.org/


The series was also backported to 6.1 but reverted later.

https://lore.kernel.org/all/20260408010208.746177-1-sashal@kernel.org/


So I'm confused about the next action will we accept Wang Jun's patch or 
we just revert it as 6.1 did ?



>
>> We rebased the 6.6 stable one week ago and also found the same regression.
> What regression?  Again, no context :(
>
> confused,
>
> greg k-h
