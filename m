Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF7A40F751;
	Thu, 24 Sep 2026 06:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233085; cv=none; b=sKGlKCgjtaFpK96tYX5XU0AucgdcBuWk6LeKjyosBcCrNZmreT4KkJyzbTuOXG+cbAb8KwHI6Iirl1fCDyDm/agwG7UrMNCRWVs4MKaDxiZTIXQV2FieT5GtnT3c/rRjlfImehfLGZLJv1lrHOcN4+qpbk12KI1h+m4soiyHMdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233085; c=relaxed/simple;
	bh=JMZ+EPTbLfVypfogci24tcihheNflkKtenlo+Tlg6wM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qoH9ZXwJRcRpkXJruRLyASnEUBFQ45JR9GSGCvIa40mJJFrZwPP9gD81rD2E6fmp+53Z5ZWbucNHgqqynOrYRHeiruX3kf6P8wxfN9VZ8DGVK+vW8cImtu4Rf6GCOILYU7U7wcqFgDOiK18sr8snjj+HVEtxNnIYYDR5xTkf/+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c441JyCg; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c441JyCg"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790233072; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=s2DojDt7ACpMhRkBk2Xuxzp43/gGjtmk+P4/cjgdDIo=;
	b=c441JyCgktrtTcNVh0rFbdhmNlNRX9zvY/PugElveg3Ly3rmvyPQzbD7SCzBrDAz0znnHXTBih/LVpvxK2LVLisVZAUscCzL5ql5YQhFcDj+p++kjXMG7hz3+Boecumzt7gw5RvyFBopzsyKAfI4Zyt7Ljl6h5HvRuCMmx9Rs28=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XBYyJSH_1790233071;
Received: from 30.221.147.180(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XBYyJSH_1790233071 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Sep 2026 14:57:51 +0800
Message-ID: <0d6aab78-ad58-457b-b880-03edb73a68eb@linux.alibaba.com>
Date: Thu, 24 Sep 2026 14:57:50 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: Fix sparse warning in extents kunit test when
 EXT4_KUNIT_TESTS=m
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
 Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Ye Bin <yebin10@huawei.com>, kernel test robot <lkp@intel.com>
References: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260922135808.3371159-1-ojaswin@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Ojaswin,

On 2026/9/22 21:58, Ojaswin Mujoo wrote:
> When kunit tests are compiled as modules, the extents kunit test emits
> a sparse warning:

This is not module-specific, it also shows up with
EXT4_KUNIT_TESTS=y, so maybe the "=m" can be dropped.

>>> fs/ext4/extents-test.c:59:3: sparse: sparse: symbol 'k_ctx' was not
>    declared. Should it be static?
>
> Fix this by declaring it as static.
>
> Fixes: cb1e0c1d1fad ("ext4: kunit tests for extent splitting and conversion")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609221900.Pgwrcp41-lkp@intel.com/


Missing Signed-off-by, otherwise looks good to me.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>


> ---
>  fs/ext4/extents-test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ext4/extents-test.c b/fs/ext4/extents-test.c
> index bd7795a82607..9669b2197fca 100644
> --- a/fs/ext4/extents-test.c
> +++ b/fs/ext4/extents-test.c
> @@ -48,7 +48,7 @@
>  #define EXT_DATA_LBLK 10
>  #define EXT_DATA_LEN 3
>  
> -struct kunit_ctx {
> +static struct kunit_ctx {
>  	/*
>  	 * Ext4 inode which has only 1 unwrit extent
>  	 */


