Return-Path: <SRS0=7vaa=OF=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40670 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726253AbeK0Bvk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 26 Nov 2018 20:51:40 -0500
Date: Mon, 26 Nov 2018 15:57:16 +0100
From: Jan Kara <jack@suse.cz>
To: Hou Tao <houtao1@huawei.com>
Cc: linux-ext4@vger.kernel.org, xingaopeng@huawei.com, jack@suse.com
Subject: Re: [PATCH] ext2: initialize opts.s_mount_opt as zero before using it
Message-ID: <20181126145716.GC25835@quack2.suse.cz>
References: <20181124112159.16974-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181124112159.16974-1-houtao1@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 24-11-18 19:21:59, Hou Tao wrote:
> From: xingaopeng <xingaopeng@huawei.com>
> 
> We need to initialize opts.s_mount_opt as zero before using it, else we
> may get some unexpected mount options.
> 
> Fixes: 088519572ca8 ("ext2: Parse mount options into a dedicated structure")
> Signed-off-by: xingaopeng <xingaopeng@huawei.com>

Thanks for catching this! I've added the patch to my tree.

								Honza

> ---
>  fs/ext2/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index cb91baa4275d..eb11502e3fcd 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -892,6 +892,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
>  	if (sb->s_magic != EXT2_SUPER_MAGIC)
>  		goto cantfind_ext2;
>  
> +	opts.s_mount_opt = 0;
>  	/* Set defaults before we parse the mount options */
>  	def_mount_opts = le32_to_cpu(es->s_default_mount_opts);
>  	if (def_mount_opts & EXT2_DEFM_DEBUG)
> -- 
> 2.16.2.dirty
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
