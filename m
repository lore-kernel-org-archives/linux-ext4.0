Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BB11F3BA4;
	Mon, 13 Jul 2026 03:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783914453; cv=none; b=k0m1B58ed7Jw4S/HPOuwfnzEW8jVTxfZqLISlPscRAiQcRDix9M7nYWcmqah3YtKT5/LZNswzFJDNeC5EKSMvuB1NA8iriyvWLkLtwMH0YAmbAwZDT7YRADfQHYjDmdSm+1PJZD+5txIcXN6NABO8ZZ6DtlJROZ4AN2XK1n/CAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783914453; c=relaxed/simple;
	bh=+oh/G4RpEbdQ3G4TJOQPy+Uypy2ThDA62HQ3eP0B0oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDN+wP8tRLEeSVIM+KUGUeojNRMRach3Rfaros6WYQuc63nJ08SLwE9gK3SaMaY87ZDCouo05XuptcWBm3fbon+2TIa8aNqIXStRnBZQdA7dG7Ic8RIVDjO5tT/u9uvCvQJ+fXYTK3W464jIHAnCqkCdOX3fo/Sf1ls6/nx66LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=cJwAiYFA; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="cJwAiYFA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783914446; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=kU96kAPkXfYsslWvW+GRTdhNjwq6F5Jz44bvo7bZJ/g=;
	b=cJwAiYFAgGFofX8xddb8SQCXu9idmCb4g0wZbuXAKZ2rPa0F9jwNWb0drJEP6PH6jM0KH7NX6oZYlMfgYtzmp7U6YRWuQMu8PPDHc2aTbFqjEk3XZ007Rx4HAIFY4mDr0LbVUiJAcg44lWahLGqLPm4WgFGetYEjNlOeDtkD7sg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X6tcKCs_1783914444;
Received: from 30.221.131.131(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0X6tcKCs_1783914444 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Jul 2026 11:47:25 +0800
Message-ID: <cddfc510-0fcf-49e5-975a-6edde4afb39b@linux.alibaba.com>
Date: Mon, 13 Jul 2026 11:47:24 +0800
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ext4: use str_plural() instead of custom macro
To: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, Jan Kara <jack@suse.cz>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhang Yi <yi.zhang@huawei.com>
References: <20260711-remove-plural-macro-v1-1-b3dcd44e4068@gmail.com>
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20260711-remove-plural-macro-v1-1-b3dcd44e4068@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/7/11 14:38, Joshua Crofts wrote:
> Remove the custom PLURAL() macro and use str_plural() from
> string_choices.h instead.
>
> Signed-off-by: Joshua Crofts <joshua.crofts1@gmail.com>
 
Looks good to me, just one nit:

Reviewed-by: Baokun Li <libaokun@huawei.com>

> ---
>  fs/ext4/orphan.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
> index 64ea47624233..e307d6d55451 100644
> --- a/fs/ext4/orphan.c
> +++ b/fs/ext4/orphan.c
> @@ -4,6 +4,7 @@
>  #include <linux/fs.h>
>  #include <linux/quotaops.h>
>  #include <linux/buffer_head.h>
> +#include <linux/string_choices.h>
>  
>  #include "ext4.h"
>  #include "ext4_jbd2.h"
> @@ -486,14 +487,13 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
>  		}
>  	}
>  
> -#define PLURAL(x) (x), ((x) == 1) ? "" : "s"
>  

this leaves two blank lines here

>  	if (nr_orphans)
>  		ext4_msg(sb, KERN_INFO, "%d orphan inode%s deleted",
> -		       PLURAL(nr_orphans));
> +			 nr_orphans, str_plural(nr_orphans));
>  	if (nr_truncates)
>  		ext4_msg(sb, KERN_INFO, "%d truncate%s cleaned up",
> -		       PLURAL(nr_truncates));
> +			 nr_truncates, str_plural(nr_truncates));
>  #ifdef CONFIG_QUOTA
>  	/* Turn off quotas if they were enabled for orphan cleanup */
>  	if (quota_update) {
>
> ---
> base-commit: c143957520c6c9b5cd72e0de8b52b814f0c576fe
> change-id: 20260711-remove-plural-macro-7ecfa879fcae
>
> Best regards,


