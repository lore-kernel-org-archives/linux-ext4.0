From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [PATCH] e2fsprogs: clean up ext2fs_bg_flags_ interfaces
Date: Wed, 09 Sep 2009 15:19:24 -0400
Message-ID: <8893.1252523964@alphaville.usa.hp.com>
References: <4AA7FC13.6060109@redhat.com>
Reply-To: nicholas.dokos@hp.com
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:45561 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZIITTU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Sep 2009 15:19:20 -0400
Cc: nicholas.dokos@hp.com
In-Reply-To: Message from Eric Sandeen <sandeen@redhat.com>
   of "Wed, 09 Sep 2009 14:03:47 CDT." <4AA7FC13.6060109@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> ...  				}
> diff --git a/e2fsck/super.c b/e2fsck/super.c
> index 409d472..b8eee6b 100644
> --- a/e2fsck/super.c
> +++ b/e2fsck/super.c
> @@ -637,8 +637,8 @@ void check_super_block(e2fsck_t ctx)
>  		should_be = 0;
>  		if (!ext2fs_group_desc_csum_verify(fs, i)) {
>  			if (fix_problem(ctx, PR_0_GDT_CSUM, &pctx)) {
> -				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
> -				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
> +				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT);
> +				ext2fs_bg_flags_clear(fs, i, EXT2_BG_INODE_UNINIT);
>  				ext2fs_bg_itable_unused_set(fs, i, 0);
>  				should_be = 1;
>  			}

Wouldn't something like this be better? There are a few places where this
could be done:


> -				ext2fs_bg_flag_clear (fs, i, EXT2_BG_BLOCK_UNINIT);
> -				ext2fs_bg_flag_clear (fs, i, EXT2_BG_INODE_UNINIT);
> +				ext2fs_bg_flags_clear(fs, i, EXT2_BG_BLOCK_UNINIT | EXT2_BG_INODE_UNINIT);


Thanks,
Nick
