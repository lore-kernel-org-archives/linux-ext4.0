From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 2/4] ext4: use sync_inode_metadata() when sync inode
 metadata
Date: Fri, 30 Nov 2012 14:24:48 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211301423100.8688@dhcp-1-104.brq.redhat.com>
References: <1354257706-6582-1-git-send-email-yan@linux.vnet.ibm.com> <1354257706-6582-2-git-send-email-yan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: Guo Chao <yan@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030416Ab2K3NYz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Nov 2012 08:24:55 -0500
In-Reply-To: <1354257706-6582-2-git-send-email-yan@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 30 Nov 2012, Guo Chao wrote:

> Date: Fri, 30 Nov 2012 14:41:44 +0800
> From: Guo Chao <yan@linux.vnet.ibm.com>
> To: tytso@mit.edu
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 2/4] ext4: use sync_inode_metadata() when sync inode metadata
> 
> We have a dedicated interface to sync inode metadata.
> 
> Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
> ---
>  fs/ext4/fsync.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index be1d89f..dfbc1fe 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -44,7 +44,6 @@
>   */
>  static int ext4_sync_parent(struct inode *inode)
>  {
> -	struct writeback_control wbc;
>  	struct dentry *dentry = NULL;
>  	struct inode *next;
>  	int ret = 0;
> @@ -66,10 +65,7 @@ static int ext4_sync_parent(struct inode *inode)
>  		ret = sync_mapping_buffers(inode->i_mapping);
>  		if (ret)
>  			break;
> -		memset(&wbc, 0, sizeof(wbc));
> -		wbc.sync_mode = WB_SYNC_ALL;
> -		wbc.nr_to_write = 0;         /* only write out the inode */
> -		ret = sync_inode(inode, &wbc);
> +		ret = sync_inode_metadata(inode, 1);
>  		if (ret)
>  			break;
>  	}
> 

Makes sense.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

