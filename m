From: Tao Ma <tm@tao.ma>
Subject: Re: metadata_csum + unclean shutdown = failure to boot
Date: Mon, 08 Oct 2012 12:03:26 +0800
Message-ID: <5072508E.3040806@tao.ma>
References: <20121008031704.17730.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:48964 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750725Ab2JHEDa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Oct 2012 00:03:30 -0400
In-Reply-To: <20121008031704.17730.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/08/2012 11:17 AM, George Spelvin wrote:
> I'm testing that patch, but you may want to fix it a bit more before submitting to
> stable@...
> fs/ext4/resize.c: In function 'update_backups':
> fs/ext4/resize.c:973:39: error: too many arguments to function 'ext4_superblock_csum_set'
> In file included from fs/ext4/ext4_jbd2.h:20:0,
>                  from fs/ext4/resize.c:17:
> fs/ext4/ext4.h:2049:13: note: declared here
> 
> The fix is of course obvious and I'm compiling it now.
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index 41f6ef6..e781259 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -970,7 +970,7 @@ static void update_backups(struct super_block *sb,
>  		goto exit_err;
>  	}
>  
> -	ext4_superblock_csum_set(sb, (struct ext4_super_block *)data);
> +	ext4_superblock_csum_set(sb);
this line is already removed in my commit bef53b01 and will be in
stable. So this patch should work as expected.

Thanks
Tao
>  
>  	while ((group = ext4_list_backups(sb, &three, &five, &seven)) < last) {
>  		struct buffer_head *bh;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

