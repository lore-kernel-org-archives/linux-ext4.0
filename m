From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: fix possible memory leak in ext4_xattr_set_acl()
Date: Mon, 8 Oct 2012 14:36:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210081435240.25096@localhost>
References: <1349694672-16992-1-git-send-email-eugene.shatokhin@rosalab.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab2JHMgh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Oct 2012 08:36:37 -0400
In-Reply-To: <1349694672-16992-1-git-send-email-eugene.shatokhin@rosalab.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 8 Oct 2012, Eugene Shatokhin wrote:

> Date: Mon,  8 Oct 2012 15:11:12 +0400
> From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
> To: linux-ext4@vger.kernel.org
> Cc: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
> Subject: [PATCH] ext4: fix possible memory leak in ext4_xattr_set_acl()
> 
> In ext4_xattr_set_acl(), if ext4_journal_start() returns an error,
> posix_acl_release() will not be called for 'acl' which may result
> in a memory leak.
> 
> This patch fixes that.
> 
> Signed-off-by: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
> ---
>  fs/ext4/acl.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/acl.c b/fs/ext4/acl.c
> index a5c29bb..8535c45 100644
> --- a/fs/ext4/acl.c
> +++ b/fs/ext4/acl.c
> @@ -410,8 +410,10 @@ ext4_xattr_set_acl(struct dentry *dentry, const char *name, const void *value,
>  
>  retry:
>  	handle = ext4_journal_start(inode, EXT4_DATA_TRANS_BLOCKS(inode->i_sb));
> -	if (IS_ERR(handle))
> -		return PTR_ERR(handle);
> +	if (IS_ERR(handle)) {
> +		error = PTR_ERR(handle);
> +		goto release_and_out;
> +	}
>  	error = ext4_set_acl(handle, inode, type, acl);
>  	ext4_journal_stop(handle);
>  	if (error == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
> 

Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks for catching that.
-Lukas
