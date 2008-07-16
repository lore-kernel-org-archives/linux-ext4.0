From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Wed, 16 Jul 2008 18:31:42 +0200
Message-ID: <87bq0x94ep.fsf@frosties.localdomain>
References: <20080715164332.28567.27913.stgit@ichigo>
	<20080715165129.28567.7837.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:40003 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307AbYGPQbo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Jul 2008 12:31:44 -0400
In-Reply-To: <20080715165129.28567.7837.stgit@ichigo> (Jose R. Santos's
	message of "Tue, 15 Jul 2008 11:51:29 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

"Jose R. Santos" <jrs@us.ibm.com> writes:

> diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
> index e9bfe49..5060fda 100644
> --- a/lib/ext2fs/initialize.c
> +++ b/lib/ext2fs/initialize.c
> @@ -200,9 +200,9 @@ errcode_t ext2fs_initialize(const char *name, int flags,
>  		super->s_blocks_per_group = EXT2_MAX_BLOCKS_PER_GROUP(super);
>  	super->s_frags_per_group = super->s_blocks_per_group * frags_per_block;
>  	
> -	super->s_blocks_count = param->s_blocks_count;
> -	super->s_r_blocks_count = param->s_r_blocks_count;
> -	if (super->s_r_blocks_count >= param->s_blocks_count) {
> +	ext2fs_blocks_count_set(super, param->s_blocks_count);
> +	ext2fs_r_blocks_count_set(super, param->s_r_blocks_count);
> +	if (ext2fs_r_blocks_count(super) >= ext2fs_blocks_count(param)) {
>  		retval = EXT2_ET_INVALID_ARGUMENT;
>  		goto cleanup;
>  	}

This needs to preserve the high bits from param:

+	ext2fs_blocks_count_set(super, ext2fs_blocks_count(param));
+	ext2fs_r_blocks_count_set(super, ext2fs_r_blocks_count(param->s_r_blocks_count));

MfG
        Goswin
