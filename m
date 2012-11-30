From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/4] ext4: remove unsafe and unnecessary memset()
Date: Fri, 30 Nov 2012 14:20:42 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211301418220.8688@dhcp-1-104.brq.redhat.com>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030442Ab2K3NU4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 08:20:56 -0500
In-Reply-To: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 30 Nov 2012, Guo Chao wrote:

> Date: Fri, 30 Nov 2012 14:41:43 +0800
> From: Guo Chao <yan@linux.vnet.ibm.com>
> To: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 1/4] ext4: remove unsafe and unnecessary memset()
> 
> We memset this page before checking whether it's valid. But we need
> not memset zeroed page at all.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index ad6cd8a..66a4e20 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3206,7 +3206,6 @@ int ext4_calculate_overhead(struct super_block *sb)
>  	ext4_fsblk_t overhead = 0;
>  	char *buf = (char *) get_zeroed_page(GFP_KERNEL);
>  
> -	memset(buf, 0, PAGE_SIZE);
>  	if (!buf)
>  		return -ENOMEM;

Good catch, thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
