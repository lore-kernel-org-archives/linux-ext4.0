Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6D43AA1B5;
	Mon, 16 Mar 2026 15:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676199; cv=none; b=jZKVslMZYz95TCUdJoC0wcU7zH/ocG1iebIl0eR10fV3ohYxxLLs+kIDUtO/7JyIk/WNyMX1iC9IGhF4MW94HS16Cffo+diSxBk12ycr/rHQuGBBDV03bw/jvlW5z9ubPmeliT8gSmrFLCX4DNaeeJS3LjeItV0CxeqeHK4XyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676199; c=relaxed/simple;
	bh=6lJp3mdOW4/RNYnAHc4dnRGUWB9oZigHM1/EdUTNjq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JRNKH3YrMFj/Gail+xMNdYDFBegdjFbmUDKeAth0aeDb3OM1isDnY6a4y1Yko90tvKFpfGH87o4FGNdQNSkce1lGj661FkyQpnJRcj1y2zQRKUmAQF2GDh0UPcJs+4cig1UMSTOVN25Tu8gaM0wbyrrHuh53Tzfy9awm6lxC4x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=eEhurjiZ; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="eEhurjiZ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773676183; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lY4qYsszOdQjNqeU1TmbSH1ghLl/mfzXbbRAk0MkurA=;
	b=eEhurjiZOaje63NtgKFs66tdUoZpvBZ9qkcGtEdgg6l+OV7Jl0TSJKSehSjpN5kV8MvQXP4S0RswP77eFy+ycCAFB6aRCUew8j9Z28k8TeUIY2XqWWCclA8L9p5V6RgMVV//oeN4tRHd+N+Z/Nb/xVoUoPxFUAJ8OMSffW0tlIw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X.5wv6Y_1773676182;
Received: from 30.120.55.12(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X.5wv6Y_1773676182 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 16 Mar 2026 23:49:43 +0800
Message-ID: <e275a80b-df14-4d05-9334-b10d2e57fbbc@linux.alibaba.com>
Date: Mon, 16 Mar 2026 23:49:41 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix possible NULL pointer dereference in
 ext4_group_desc_free()
To: Zqiang <qiang.zhang@linux.dev>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
 adilger.kernel@dilger.ca, libaokun@linux.alibaba.com
References: <20260316082025.9574-1-qiang.zhang@linux.dev>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260316082025.9574-1-qiang.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 3/16/26 4:20 PM, Zqiang wrote:
> This can happen if the kvmalloc_objs() fails and sbi->s_group_desc pointer
> is NULL in the ext4_group_desc_init(), and then the ext4_group_desc_free()
> is called, leading to a NULL group_desc pointer dereference.
>
> This commit therefore adds a NULL check for sbi->s_group_desc before
> accessing its internal members.
>
> Signed-off-by: Zqiang <qiang.zhang@linux.dev>
> ---
>  fs/ext4/super.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 43f680c750ae..c4307dc04687 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1256,9 +1256,11 @@ static void ext4_group_desc_free(struct ext4_sb_info *sbi)
>  
>  	rcu_read_lock();
>  	group_desc = rcu_dereference(sbi->s_group_desc);
> -	for (i = 0; i < sbi->s_gdb_count; i++)

In ext4_group_desc_init(), s_gdb_count is only assigned after kvmalloc_array
allocation succeeds. Therefore, when kvmalloc_array fails, the
brelse(group_desc[i]) in ext4_group_desc_free() will not actually be
executed,
and thus this NULL pointer dereference issue will not be triggered.


Cheers,
Baokun

> -		brelse(group_desc[i]);
> -	kvfree(group_desc);
> +	if (group_desc) {
> +		for (i = 0; i < sbi->s_gdb_count; i++)
> +			brelse(group_desc[i]);
> +		kvfree(group_desc);
> +	}
>  	rcu_read_unlock();
>  }
>  
