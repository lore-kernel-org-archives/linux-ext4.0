From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 2/2] Ext3: remove a useless check for the function ext3_free_blocks_sb
Date: Sun, 27 Jan 2013 00:40:42 -0700
Message-ID: <6EFFDEB0-26DB-4E3C-9B85-A3CBA7833E6B@dilger.ca>
References: <4D40A4B7.6050501@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "jack@suse.cz" <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f50.google.com ([209.85.210.50]:37363 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab3A0Hkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Jan 2013 02:40:43 -0500
Received: by mail-da0-f50.google.com with SMTP id h15so781518dan.37
        for <linux-ext4@vger.kernel.org>; Sat, 26 Jan 2013 23:40:42 -0800 (PST)
In-Reply-To: <4D40A4B7.6050501@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-26, at 15:48, Wang Shilong <wangshilong1991@gmail.com> wrote:

> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> 
> Because 'block + count < block' always comes to false, it is useless
> to have this check, just remove it.

This check can be true if the sum overflows the 32-bit variable it is stored in, so it is not useless...

Cheers, Andreas

> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
> fs/ext3/balloc.c | 1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index 22548f5..c557f22 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -507,7 +507,6 @@ void ext3_free_blocks_sb(handle_t *handle, struct super_block *sb,
>    sbi = EXT3_SB(sb);
>    es = sbi->s_es;
>    if (block < le32_to_cpu(es->s_first_data_block) ||
> -        block + count < block ||
>        block + count > le32_to_cpu(es->s_blocks_count)) {
>        ext3_error (sb, "ext3_free_blocks",
>                "Freeing blocks not in datazone - "
> -- 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
