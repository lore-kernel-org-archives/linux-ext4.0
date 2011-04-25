From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext2: fix error msg when mounting fs with too-large blocksize
Date: Mon, 25 Apr 2011 10:11:26 -0500
Message-ID: <4DB58F1E.3090303@redhat.com>
References: <1303626991-6704-1-git-send-email-hao.bigrat@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Robin Dong <sanbai@taobao.com>
To: Robin Dong <hao.bigrat@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1DYPLd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Apr 2011 11:11:33 -0400
In-Reply-To: <1303626991-6704-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/24/11 1:36 AM, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> When ext2 mounts a filesystem, it attempts to set the block device
> blocksize with a call to sb_set_blocksize, which can fail for
> several reasons.  The current failure message in ext2 prints:
> 
>   EXT2-fs (loop1): error: blocksize is too small
> 
> which is not correct in all cases.  This can be demonstrated
> by creating a filesystem with
> 
>   # mkfs.ext2 -b 8192
> 
> on a 4k page system, and attempting to mount it.
> 
> Change the error message to a more generic:
> 
>   EXT2-fs (loop1): bad blocksize 8192
> 
> to match the error message in ext3.

I couldn't have said it better myself :)  As long as you're ok with not having the extra error message you originally had, for now ...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Robin Dong <sanbai@taobao.com>
> ---
>  fs/ext2/super.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 0a78dae..1dd62ed 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -898,7 +898,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  		brelse(bh);
>  
>  		if (!sb_set_blocksize(sb, blocksize)) {
> -			ext2_msg(sb, KERN_ERR, "error: blocksize is too small");
> +			ext2_msg(sb, KERN_ERR,
> +				"error: bad blocksize %d", blocksize);
>  			goto failed_sbi;
>  		}
>  

