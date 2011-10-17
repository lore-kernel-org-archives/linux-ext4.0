From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] ext4: fix wrong verification in ext4_ext_insert_index
Date: Mon, 17 Oct 2011 16:49:32 +0800
Message-ID: <4E9BEC1C.3050905@tao.ma>
References: <1318831867-8225-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:56163 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752084Ab1JQItj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Oct 2011 04:49:39 -0400
In-Reply-To: <1318831867-8225-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi yongqiang,
On 10/17/2011 02:11 PM, Yongqiang Yang wrote:
> After inserting an new index, current number of indexes should
> be greater than original number by 1.  So if the new index is
> less or equal than LAST_INDEX + 1, then indexes are continugous.
> If new index will be placed on the end, then ix will equals
> LAST_INDEX + 1. Index entries has been verifiyed in pervious code
> in ext4_ext_insert_index.
Thanks for the effort. But actually this is caused by my original patch
4fd30c033, and your fix doesn't resolve the problem I want to fix. So
consider ix is already overflow, the check can't prevent it from
stamping on the memory after this extent block. I have sent another fix
for it.

Thanks
Tao
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/extents.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 2dff31e..322398e 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -779,7 +779,7 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
>  		ix = curp->p_idx;
>  	}
>  
> -	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr))) {
> +	if (unlikely(ix > EXT_LAST_INDEX(curp->p_hdr) + 1)) {
>  		EXT4_ERROR_INODE(inode, "ix > EXT_LAST_INDEX!");
>  		return -EIO;
>  	}

