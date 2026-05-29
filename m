Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71327348C58;
	Fri, 29 May 2026 07:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780039939; cv=none; b=fbIiu/tWAfG5RKYJoI2KYuqDKIgByOFlt04I3FS/RuLVDO2XGyASsrLzVd6BcCsCWpDdVa7g5XbTV12vBb9LBls863fUQSF2RnT7dHhu5g0trcoOw2lvoOg2TWSjuhBTa7v3egnTzwUCy5oKAyPMbtFKjkvrM4yM5ofAPN7K8zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780039939; c=relaxed/simple;
	bh=HW/bSag8il2av+UJkXvbPQq2PF+9dWaghrIZKSKO6BI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=UzXOibvX3jMeKed4sZy5CPn/dcbPweHyTxftWiSWpQZmDSCudrdZKeoubDPBZNWN54b5C0rG66l7fAc8O2L0vFAY4YKv0fHhWBgmcnylx/Rz6OgnS+Or31VZG/7e7Ro2awgZQMk7jkYgRkXkVoYAfEFn60xbX1GliUSkM1MbSAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=XlbG/dBS; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="XlbG/dBS"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780039933; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=XsMYWbdUIEzPaql7isQ9/8c0FLW0IT7eoYaMbLPEQVY=;
	b=XlbG/dBSzlonqu7UxABM6mwHw/wBXNK5iqA2DzzimWp+8WE8W6TCDabjm0TpYEtbq/tFB6lGUdkhHqrxG24QhEknPvX8sAb0DNb+Tods0tMsFiwhG7NtwXW5d5bb2rVMpTD9JZYI0xiHEJgckNuICcUkZ3YuIPNa3Ksyd2uLBSI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X3ofXyX_1780039931;
Received: from 30.221.147.25(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X3ofXyX_1780039931 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 29 May 2026 15:32:12 +0800
Message-ID: <d1ebc755-afe5-4d14-99e5-e9638f47915c@linux.alibaba.com>
Date: Fri, 29 May 2026 15:32:11 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: convert legacy ext4_debug() to standard pr_debug()
To: lirongqing <lirongqing@baidu.com>
References: <20260521074634.2697-1-lirongqing@baidu.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
 Zhang Yi <yi.zhang@huawei.com>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Ritesh Harjani
 <ritesh.list@gmail.com>, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260521074634.2697-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/5/21 15:46, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
>
> The ext4 file system historically implemented its own debug logging macro
> ext4_debug() via EXT4FS_DEBUG conditional compilation. This legacy
> implementation suffers from two major drawbacks:
>
> 1. It makes two consecutive un-serialized printk() calls, which can
>    lead to severe log interleaving and corruption under multi-core
>    concurrent workloads.
> 2. It completely bypasses the standard modern kernel dynamic debug
>    (CONFIG_DYNAMIC_DEBUG) infrastructure.
>
> Clean up the legacy implementation by leveraging pr_debug(). This squashes
> the multiple printk() calls into a single atomic execution, ensuring
> log integrity, while seamlessly hooking ext4 into the kernel's native
> dynamic debug framework.
>
> The redundant __FILE__ and __LINE__ macros are intentionally removed from
> the string format because the dynamic debug infrastructure can already
> append them automatically at runtime (via the '+fl' flags) if desired.
> This avoids redundancy and double-logging in modern production/debugging
> environments while keeping the macro clean and robust against dangling
> comma compiler errors.
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Thanks for cleaning this up.

> ---
>  fs/ext4/ext4.h | 20 ++------------------
>  1 file changed, 2 insertions(+), 18 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 94283a9..39e86ff 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -62,24 +62,8 @@
>   */
>  #define DOUBLE_CHECK__
>  
> -/*
> - * Define EXT4FS_DEBUG to produce debug messages
> - */
> -#undef EXT4FS_DEBUG
> -

This looks like it's just disabling EXT4FS_DEBUG, but it's actually
the only toggle point — enabling debug required manually flipping this
to #define EXT4FS_DEBUG in the source.

Since balloc.c, ialloc.c, and page-io.c still have #ifdef EXT4FS_DEBUG
blocks that weren't cleaned up here, it would be cleaner to replace
those with CONFIG_EXT4_DEBUG so they fall under a single
Kconfig-controlled umbrella.

> -/*
> - * Debug code
> - */
> -#ifdef EXT4FS_DEBUG
> -#define ext4_debug(f, a...)						\
> -	do {								\
> -		printk(KERN_DEBUG "EXT4-fs DEBUG (%s, %d): %s:",	\
> -			__FILE__, __LINE__, __func__);			\
> -		printk(KERN_DEBUG f, ## a);				\
> -	} while (0)
> -#else
> -#define ext4_debug(fmt, ...)	no_printk(fmt, ##__VA_ARGS__)
> -#endif
> +#define ext4_debug(fmt, ...)						\
> +	pr_debug("EXT4-fs DEBUG %s: " fmt, __func__,  ##__VA_ARGS__)

Nit: an extra space between __func__, and ##__VA_ARGS__.

>  
>   /*
>    * Turn on EXT_DEBUG to enable ext4_ext_show_path/leaf/move in extents.c

Also, could ext4_debug be moved next to ext_debug and placed under
#ifdef CONFIG_EXT4_DEBUG together, for a cleaner layout?


Cheers,
Baokun

