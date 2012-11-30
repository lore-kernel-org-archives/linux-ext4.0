From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/4] ext4: remove redundant code in ext4_alloc_inode()
Date: Fri, 30 Nov 2012 14:32:09 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211301431550.8688@dhcp-1-104.brq.redhat.com>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com> <1354257706-6582-3-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab2K3NcU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 08:32:20 -0500
In-Reply-To: <1354257706-6582-3-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 30 Nov 2012, Guo Chao wrote:

> Date: Fri, 30 Nov 2012 14:41:45 +0800
> From: Guo Chao <yan@linux.vnet.ibm.com>
> To: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 3/4] ext4: remove redundant code in ext4_alloc_inode()
> 
> inode_init_always() will initialize inode->i_data.writeback_index
> anyway, no need to do this in ext4_alloc_inode().
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 66a4e20..15d28e3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -940,7 +940,6 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  		return NULL;
>  
>  	ei->vfs_inode.i_version = 1;
> -	ei->vfs_inode.i_data.writeback_index = 0;
>  	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
>  	INIT_LIST_HEAD(&ei->i_prealloc_list);
>  	spin_lock_init(&ei->i_prealloc_lock);
> 

Looks good

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
