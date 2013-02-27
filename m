From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix possible memory leak in ext4_remount()
Date: Wed, 27 Feb 2013 13:45:11 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1302271343391.3310@localhost>
References: <CAPgLHd-J=j=aVCpjutq2B1+NMqxz=v50xNcEQA_57Ni_7v9HKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab3B0Mp0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Feb 2013 07:45:26 -0500
In-Reply-To: <CAPgLHd-J=j=aVCpjutq2B1+NMqxz=v50xNcEQA_57Ni_7v9HKA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 27 Feb 2013, Wei Yongjun wrote:

> Date: Wed, 27 Feb 2013 13:18:53 +0800
> From: Wei Yongjun <weiyj.lk@gmail.com>
> To: tytso@mit.edu, adilger.kernel@dilger.ca
> Cc: yongjun_wei@trendmicro.com.cn, linux-ext4@vger.kernel.org
> Subject: [PATCH] ext4: fix possible memory leak in ext4_remount()
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> 'orig_data' is malloced in ext4_remount() and should be freed
> before leaving from the error handling cases, otherwise it will
> cause memory leak.

Good catch, thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  fs/ext4/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 373d46c..8ae09e3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4538,6 +4538,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
>  			if (!old_opts.s_qf_names[i]) {
>  				for (j = 0; j < i; j++)
>  					kfree(old_opts.s_qf_names[j]);
> +				kfree(orig_data);
>  				return -ENOMEM;
>  			}
>  		} else
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
