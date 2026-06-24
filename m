Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B833AFAFE;
	Wed, 24 Jun 2026 10:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782295258; cv=none; b=Cfm2xYUHukFRuSJvOp6xW14F5qHxijJ9jrXtQeIixC0BN9BHxboJeRrva982qbt5MLCzxCXF5GmEnOzrzsL5qVp/54PL3tg/vUpNy5cPkITJL0xcs/bo9tYM/x9WiVcv81flDYtGP796ARhfmAudFPL0R8Rs+JHuapWp6QWtZ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782295258; c=relaxed/simple;
	bh=20/mOkQUeE5Qx0c9o4NqSxdUCKBphBYonBFfLmfcBss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fLoi9MuLnLmxD6gC3mVf2D0wfL/BlL4GyQJjBag9RI9D3+rRcjS0hAmJ0x7KAvpXZjfLMwAT8iSaEpVP9vu1rwOAYZLMS5HFMgvcP1flB3TWrMGnTQwo/cyzwYvubtvx5yb0ne4DVRGo7VP7veVNrw5rJLIeYDnUPcUsr55b+3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZVDAoBwm; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZVDAoBwm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=lGzrfY6rus5jPWJ2WjZMjuKUCPfSROVDpjLZUTappyA=;
	b=ZVDAoBwml7pcZ7k5kO6bxeUiifbEsjRLALCyb/IahNcdSpPbTZSSjNm8ujCZ0e
	6T3D7hjIRHLm6kaOT1k+B2C6QzFiT5rLER9GJNP02JCfM7y1tby1lApcb2kE81/l
	AQIk3bz91XDZsaYjucSN7VMrNOOpmm0PsYGIF/z7/PCDw=
Received: from [192.168.127.68] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wCXNnOfqjtqnbgSFQ--.2742S2;
	Wed, 24 Jun 2026 18:00:03 +0800 (CST)
Message-ID: <51efbdd8-76c1-4577-b5ff-a47658c7c0b2@163.com>
Date: Wed, 24 Jun 2026 17:59:59 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 v6 0/3] ext4: improve mballoc statistics reporting and
 control
To: corbet@lwn.net, skhan@linuxfoundation.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com, jack@suse.cz,
 ojaswin@linux.ibm.com, ritesh.list@gmail.com, yi.zhang@huawei.com,
 liubaolin12138@163.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Baolin Liu <liubaolin@kylinos.cn>, liubaolin12138@163.com
References: <20260524015421.2529617-1-liubaolin12138@163.com>
 <1816234d.8a1b.19ef8ff3f2e.Coremail.liubaolin12138@163.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <1816234d.8a1b.19ef8ff3f2e.Coremail.liubaolin12138@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXNnOfqjtqnbgSFQ--.2742S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Wr1xGr4DXr18Ar48Jr4rGrg_yoW8JF1DpF
	yDKan8GF15ur13JrsxKrn5Ww4Sqa4fCw1UJrsIv3409F98tr1ftrZxtryruFyDGrWjva48
	XrW2yry3CFy2ya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUsNVDUUUUU=
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbCwgM8B2o7qqPWTQAA35

Add recipient: liubaolin12138@163.com

在 2026/6/24 17:38, Baolin Liu 写道:
> 
> 
> 
> 
> 
> 
> 
> At 2026-05-24 09:54:18, "Baolin Liu" <liubaolin12138@163.com> wrote:
>>From: Baolin Liu <liubaolin@kylinos.cn>
>>
>>This series improves mballoc statistics reporting and control by adding
>>blocks_allocated to /proc/fs/ext4/<dev>/mb_stats, using
>>READ_ONCE()/WRITE_ONCE() for concurrent accesses to s_mb_stats, and
>>allowing mballoc stats to be controlled through
>>/proc/fs/ext4/<dev>/mb_stats.
>>
>>Changes in v6:
>> - Serialize proc and sysfs updates to s_mb_stats with a mutex so that
>>   clearing mb_stats through the proc control path cannot race with
>>   concurrent administrative writes.
>>
>>Baolin Liu (3):
>>  ext4: add blocks_allocated to mb_stats output
>>  ext4: use READ_ONCE/WRITE_ONCE for s_mb_stats
>>  ext4: allow controlling mballoc stats through proc mb_stats
>>
>> Documentation/ABI/testing/sysfs-fs-ext4 |  3 +-
>> Documentation/admin-guide/ext4.rst      |  9 ++-
>> Documentation/filesystems/proc.rst      | 13 +---
>> fs/ext4/ext4.h                          |  2 +
>> fs/ext4/mballoc.c                       | 58 ++++++++++++++----
>> fs/ext4/sysfs.c                         | 80 ++++++++++++++++++++++++-
>> 6 files changed, 135 insertions(+), 30 deletions(-)
>>
>>-- 
>>2.51.0

