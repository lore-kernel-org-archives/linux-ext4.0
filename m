From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v2] ext4: don't work without procfs
Date: Wed, 5 Oct 2011 15:00:45 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1110051456440.4423@dhcp-27-109.brq.redhat.com>
References: <1317743049-4641-1-git-send-email-yargil@free.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Yargil <yargil@free.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934365Ab1JENAu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Oct 2011 09:00:50 -0400
In-Reply-To: <1317743049-4641-1-git-send-email-yargil@free.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 4 Oct 2011, Yargil wrote:

> Regression from commit dd68314ccf3fb918c1fb6471817edbc60ece4b52
> The problem come from the test of the return value of proc_mkdir
> that is always false without procfs and abort the init of ext4.

Looks good. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> ---
>  fs/ext4/super.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 44d0c8d..9b51b17 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4985,8 +4985,10 @@ static int __init ext4_init_fs(void)
>  	if (!ext4_kset)
>  		goto out6;
>  	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
> +#ifdef CONFIG_PROC_FS
>  	if (!ext4_proc_root)
>  		goto out5;
> +#endif
>  
>  	err = ext4_init_feat_adverts();
>  	if (err)
> 

-- 
