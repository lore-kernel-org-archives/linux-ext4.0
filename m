Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7942B19CCF5;
	Fri, 24 Apr 2026 02:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776998118; cv=none; b=FfWNYFFab8Myq/Wte0qZjKc0RDcoGXggGdwFqaCH6y/39MU91A8te0QzLIDnawiV8qrnZeJrd77WA4bIIe0rNHp2GnTrDlMSkmEgUour66aFN+2gMRkjpNM6VSK06O5z4iCbvEIOEfAGcY75/ei4SPMYBZaPRB1qGFsmukoi9Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776998118; c=relaxed/simple;
	bh=10XaqAudCsSlqbAYFp9fTBvjlWUZJX5miIT59I3sSMs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cD6ATSa7GJ2JOsrkmBH9G+oPk50SFWn8osse7Cj/sDWwdZC13j7FCZ2WxpnJtWYyvyweSeyPRB2wNpX2wh+zvvmhDXckc6zR1ErbZTT2UTl8mRKaC8pciC7n/ixrZ0TSJ3NrXLl5oMIK0MAvlYf34yS6qchZXJJWbY69T7Dlpkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wKnue62j; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wKnue62j"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776998107; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QaX8XkqkhgvwEi+A7WkcshBdGBRMJb/05eM5+Izdvew=;
	b=wKnue62jDzFfxElolC1M5nkHAMFvDD+SIP2wuMA4ArUcWpEg1lhBkTnMKhcrwKEH9WFJWXz3pfLvfs/wZzKTBRXI8kDGx1VzKDapg5kvD923ccISVOurzx4tIT42f/WMgVAqbr8LcKtFcvRPsKLLDNWp8kMADTkDxlCqlP4Lgpg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X1b7H7R_1776998105;
Received: from 30.221.130.231(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X1b7H7R_1776998105 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 24 Apr 2026 10:35:06 +0800
Message-ID: <afdf84d7-7fbd-4d47-ae67-996f5339b2ea@linux.alibaba.com>
Date: Fri, 24 Apr 2026 10:35:05 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 v3 1/2] ext4: add blocks_allocated to mb_stats output
To: Baolin Liu <liubaolin12138@163.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, ojaswin@linux.ibm.com,
 ritesh.list@gmail.com, yi.zhang@huawei.com, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, wangguanyu@vivo.com,
 Baolin Liu <liubaolin@kylinos.cn>, Andreas Dilger <adilger@dilger.ca>
References: <20260422015026.7170-1-liubaolin12138@163.com>
 <20260422015026.7170-2-liubaolin12138@163.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260422015026.7170-2-liubaolin12138@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2026/4/22 09:50, Baolin Liu wrote:
> From: Baolin Liu <liubaolin@kylinos.cn>
>
> Add blocks_allocated to /proc/fs/ext4/<dev>/mb_stats so that the
> reported statistics match the mballoc summary printed at unmount time.
>
> Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>

Looks good, feel free to add:

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>  fs/ext4/mballoc.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 20e9fdaf4301..1e13ef62cb9d 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3211,6 +3211,8 @@ int ext4_seq_mb_stats_show(struct seq_file *seq, void *offset)
>  			"\tTo enable, please write \"1\" to sysfs file mb_stats.\n");
>  		return 0;
>  	}
> +	seq_printf(seq, "\tblocks_allocated: %u\n",
> +		   atomic_read(&sbi->s_bal_allocated));
>  	seq_printf(seq, "\treqs: %u\n", atomic_read(&sbi->s_bal_reqs));
>  	seq_printf(seq, "\tsuccess: %u\n", atomic_read(&sbi->s_bal_success));
>  

