Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA012FA0DF;
	Wed, 22 Apr 2026 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776851803; cv=none; b=bX2X5UvebXKHyjnFm4do/SETGHGyU6wE250O5lvICsEel6YFuSNqiPVAOXc6Q7XcBOPPh6czwrb5Cp7ZBcesGz7tr5eX0mbFIiSK4rDFGQZTnl5hhastXMzKV/1L4qzZPUJEZFfTQ/REQFVia7xtzGcER9tFJBSPttqyvihTb0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776851803; c=relaxed/simple;
	bh=GI0lm0N02kr3SJ8ySVG4AnHRdwbwa4tEIdc2IkZzmNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghgq/mGcRGCHxmp4EYgCQuLVjRr9MTMx3K52QBuS0Ykl7b/2KAKiYtl1LUXfGlbGesKLBI6ivVcK7y43O0RBRcIjyX+fcYzD9oBIV8aaT9149qkLLWde2B9MgNvZ2/ZMa2O0DVCrulNbF6s0sVbgL9ywmACi1iDDlgf964PgUos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=BfxMq0i0; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="BfxMq0i0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=wN386xYpn6IPxAHc5Xs15Js8rZ8xE+0zcUkTmbOjaWo=;
	b=BfxMq0i0ka+XFthXfuqTPs5tm5j0NuYVstijZWxUChuflWCDhs7xraUhF3et/x
	Uq3MsWrCqIkAyeO6jyDH21XeM1TFAuvIyvg2+0xITDOeROEh7rrXIjZt9mHr7flz
	pnQAJJrpXARIs8hYUAfUhyM5S0JGI++m4hHghBx2llg4M=
Received: from [192.168.56.68] (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgBniu8xm+hpsaqvAw--.58S2;
	Wed, 22 Apr 2026 17:56:06 +0800 (CST)
Message-ID: <6a1ebe1f-501e-4cea-854c-2e70fdeb3590@163.com>
Date: Wed, 22 Apr 2026 17:55:59 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 v3 0/2] add blocks_allocated to mb_stats and clear
 mb_stats
To: tytso@mit.edu, adilger.kernel@dilger.ca, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, yi.zhang@huawei.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 wangguanyu@vivo.com
References: <20260422015026.7170-1-liubaolin12138@163.com>
From: liubaolin <liubaolin12138@163.com>
In-Reply-To: <20260422015026.7170-1-liubaolin12138@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgBniu8xm+hpsaqvAw--.58S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFyxCFW7CF17tFWUGr1DGFg_yoWkKrcE93
	40qFyrA343tF18GFyxGa1rJFW29FWxCF1UJFn8Jr4fZ34DJrZ5AFWDGr13Ar1xWr4a9rn8
	CF97XryIyF1IqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjqQ6tUUUUU==
X-CM-SenderInfo: xolxutxrol0iasrtmqqrwthudrp/xtbC6RaIU2nomzaUswAA3v



在 2026/4/22 9:50, Baolin Liu 写道:
> The series contains two patches:
>   - add blocks_allocated to /proc/fs/ext4/<dev>/mb_stats
>   - allow writing 0 to /proc/fs/ext4/<dev>/mb_stats to clear the current
>     mballoc statistics
> 
> Changes since v2:
>   - Add mb_stats documentation to patch 2
>   - Add Reviewed-by tags
> 
> Baolin Liu (2):
>    ext4: add blocks_allocated to mb_stats output
>    ext4: allow clearing mballoc stats through mb_stats
> 
>   Documentation/admin-guide/ext4.rst |  5 ++++
>   Documentation/filesystems/proc.rst |  3 +++
>   fs/ext4/ext4.h                     |  1 +
>   fs/ext4/mballoc.c                  | 31 +++++++++++++++++++++++
>   fs/ext4/sysfs.c                    | 40 ++++++++++++++++++++++++++++--
>   5 files changed, 78 insertions(+), 2 deletions(-)
> 
Dear All,
    This commit adds the description of the ext4 proc parameter mb_stats 
to the corresponding documentation.
    I noticed that the documentation also lacks descriptions for the 
es_shrinker_info, fc_info, mb_structs_summary, and options parameters.
    However, these parameters are irrelevant to the work done in this 
series of patches.
    I will commit a separate patch later to explain the other parameters.
    This time, I only explain mb_stats.

    Thanks,
    Baolin


