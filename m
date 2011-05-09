From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: Avoid segmentation fault in
 ext2fs_alloc_generic_bmap.
Date: Mon, 9 May 2011 17:45:28 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105091743330.3694@dhcp-27-109.brq.redhat.com>
References: <1304955207-4066-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab1EIPpe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 May 2011 11:45:34 -0400
In-Reply-To: <1304955207-4066-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 9 May 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> In case of error, ext2fs_alloc_generic_bmap free the memory
> in the wrong order. So change it to free description first
> and then the bitmap.
> 
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  lib/ext2fs/gen_bitmap64.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> index df095ac..8b9e4c5 100644
> --- a/lib/ext2fs/gen_bitmap64.c
> +++ b/lib/ext2fs/gen_bitmap64.c
> @@ -129,8 +129,8 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
>  
>  	retval = bitmap->bitmap_ops->new_bmap(fs, bitmap);
>  	if (retval) {
> -		ext2fs_free_mem(&bitmap);
>  		ext2fs_free_mem(&bitmap->description);
> +		ext2fs_free_mem(&bitmap);
>  		return retval;
>  	}

I have actually sent the same patch a while ago:

http://www.spinics.net/lists/linux-ext4/msg23763.html

but Ted have not picked up this yet.

-Lukas

>  
> 
