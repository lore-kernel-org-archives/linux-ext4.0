From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 4/4] ext4: remove redundant initialization in
 ext4_fill_super()
Date: Fri, 30 Nov 2012 14:37:56 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211301435420.8688@dhcp-1-104.brq.redhat.com>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com> <1354257706-6582-4-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536Ab2K3NiF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 08:38:05 -0500
In-Reply-To: <1354257706-6582-4-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 30 Nov 2012, Guo Chao wrote:

> Date: Fri, 30 Nov 2012 14:41:46 +0800
> From: Guo Chao <yan@linux.vnet.ibm.com>
> To: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 4/4] ext4: remove redundant initialization in
>     ext4_fill_super()
> 
> We use kzalloc() to allocate sbi, no need to zero its field.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 15d28e3..a99f6c7 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3799,7 +3799,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
>  	mutex_init(&sbi->s_orphan_lock);
> -	sbi->s_resize_flags = 0;
>  
>  	sb->s_root = NULL;
>  
> 

There are other members of sbi which we initialize to zero even
though we use kzalloc.

Thanks!
-Lukas
