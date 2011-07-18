From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 03/12] ext4: prevent a fs without journal from being resized
Date: Mon, 18 Jul 2011 11:17:04 +0800
Message-ID: <4E23A5B0.6030700@tao.ma>
References: <1310957555-15617-1-git-send-email-xiaoqiangnk@gmail.com> <1310957555-15617-4-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:49412 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751736Ab1GRDRJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Jul 2011 23:17:09 -0400
In-Reply-To: <1310957555-15617-4-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/18/2011 10:52 AM, Yongqiang Yang wrote:
> This patch prevents a fs without journal from being resized, because
> it is easy to detroy the fs.
Why you want to do this?  You see any corruption?
At least in our product system, no-journal mode is heavily used and we
really don't want to disable this feature.

Thanks
Tao
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
> ---
>  fs/ext4/resize.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 53d9795..33ab40d 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -33,6 +33,16 @@ int ext4_resize_begin(struct super_block *sb)
>  		return -EPERM;
>  	}
>  
> +	/*
> +	 * We are not allowed to do online-resizing on a filesystem without
> +	 * journal, otherwise, it is easy to destroy the filesystem.
> +	 */
> +	if (!EXT4_SB(sb)->s_journal) {
> +		ext4_warning(sb, "There is no journal for the filesystem, "
> +			     "so online resizing is not allowed\n");
> +		return -EPERM;
> +	}
> +
>  	if (test_and_set_bit_lock(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags))
>  		ret = -EBUSY;
>  

