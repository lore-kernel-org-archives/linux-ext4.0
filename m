From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix the loop condition in
	ext4_mb_free_committed_blocks
Date: Wed, 11 Jun 2008 17:04:35 +0530
Message-ID: <20080611113435.GD9008@skywalker>
References: <484F4CC1.3000109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Tso <tytso@MIT.EDU>,
	Mingming Cao <cmm@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
To: Shen Feng <shen@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:48886 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYFKLgB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 Jun 2008 07:36:01 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5BBZn0N006932
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 21:35:49 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m5BBYO1p3833892
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 21:34:24 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5BBYgJ7007060
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 21:34:43 +1000
Content-Disposition: inline
In-Reply-To: <484F4CC1.3000109@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 11, 2008 at 11:55:45AM +0800, Shen Feng wrote:
> 
> Since md is freed before the do-while checks it,
> it's better to change it to while(1).
> 
> Signed-off-by: Shen Feng <shen@cn.fujitsu.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

> ---
>  fs/ext4/mballoc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 42553f6..063f820 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2572,7 +2572,7 @@ ext4_mb_free_committed_blocks(struct super_block *sb)
>  		kfree(md);
>  		ext4_mb_release_desc(&e4b);
> 
> -	} while (md);
> +	} while (1);
> 
>  	mb_debug("freed %u blocks in %u structures\n", count, count2);
>  }
> -- 
> 1.5.4.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
