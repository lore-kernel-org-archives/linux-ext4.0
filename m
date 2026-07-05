Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BDF25B085;
	Sun,  5 Jul 2026 07:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783237885; cv=none; b=B2vcEqviP0iAsJR8sR7fVU0aFMiqM3oPDDet+OluJKK28e7/KmJij0HEtQneR7ANtEhEcAp12AruyLyFzn8gFy4yzYdk0YZmFHkJvDRfrc88zmoVWRZueeNqmqzJjP5Da60mognrKFJA5C/mI2YHftvGJc7no2qOBpzpRlTG38E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783237885; c=relaxed/simple;
	bh=3Bwt3M2wgCD6OzbUoQOBKFvxA1RF5WcWe7RcrhPcR6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b6XmMrL7A6+yoJF1vWwHdMhzKCR4324voLtOF8EeReLwoewzlyx90RRM+v3UEEMpgRN1LHbSRNX0hLCi3IR0j0dMmRQrYhPwTCthvskGAw9zpacyvm92MR7uEK9EB59rz5x60xc/zbCOidSZn+WwxAMCNQWqDhJ56NJB+NySFX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ssjovp9a; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ssjovp9a"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783237872; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3Bwt3M2wgCD6OzbUoQOBKFvxA1RF5WcWe7RcrhPcR6U=;
	b=ssjovp9aOS8hCMvUKxOfuNBz7S1ll5edj1evaCRL9847Ky+12i3artmKT0ewnHwiG7XLwqU0iVR0834v2ExuoNjlwsiTiaAmyYaODHq0un5Jt4V17kasKr6JgBSpPglBuZiNX6eNM+PvgRKLRa5jyTLRrEwFi8PJYPNektq8P8Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X6NSY3p_1783237870;
Received: from 30.170.105.22(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X6NSY3p_1783237870 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 05 Jul 2026 15:51:10 +0800
Message-ID: <93838bc1-01d5-4def-87a2-729d9f2115d7@linux.alibaba.com>
Date: Sun, 5 Jul 2026 15:51:09 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: get rid of ppath in get_ext_path()
To: Sasha Levin <sashal@kernel.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, Wang Jun <1742789905@qq.com>,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, libaokun1@huawei.com,
 25125332@bjtu.edu.cn, Jan Kara <jack@suse.cz>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Greg KH <gregkh@linuxfoundation.org>
References: <2026070315-crescent-factoid-616d@gregkh>
 <2026070315-stable-reply-0002@kernel.org>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <2026070315-stable-reply-0002@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/7/4 10:04, Sasha Levin wrote:
> On Fri, Jul 03, 2026 at 10:20:35AM +0200, Greg KH wrote:
>> On Fri, Jul 03, 2026 at 03:57:09PM +0800, Baokun Li wrote:
>>> Either applying this fix patchset or reverting the incorrectly merged
>>> commit should resolve the issue.
>> How about submitting a revert so that we can start fresh and work from
>> there?
> I've queued upstream 6b854d552711 ("ext4: get rid of ppath in get_ext_path()")
> for 6.6.y. It completes the partial series that went into 6.6.130 (which
> stopped one patch short of it) and adds the IS_ERR_OR_NULL() checks to
> ext4_free_ext_path() / ext4_ext_drop_refs(), resolving the reported oops. Yoann
> Congal also posted a backport of the same commit yesterday.
>
> Given that 6.6.y is nine patches into this series, completing it looked
> less risky than unwinding all of them plus redoing the fixes on top.
>
> Baokun, if the other two patches from yangerkun's April set
> (ext4_force_split_extent_at() / convert_initialized_extent()) are still
> needed on 6.6.y, I'm happy to take those as well.
>

Thanks for your work! Backporting just the first patch is sufficient
to address the reported issue.

The other two are there to keep the interface consistent and to avoid
potential issues with future adaptations, but it's fine to leave them
out for now.


Cheers,
Baokun

