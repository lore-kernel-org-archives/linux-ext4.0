From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: [PATCH] ext4: fix null pointer deref on mount
Date: Thu, 22 Jan 2009 01:43:16 +0100
Message-ID: <4977C124.5030102@ph.tum.de>
References: <4961603B.5020505@ph.tum.de> <20090105170259.GB8939@mit.edu> <49627285.8060407@ph.tum.de> <20090105213938.GG8939@mit.edu> <49628EBF.2040805@ph.tum.de> <20090105234411.GD14500@mit.edu> <20090106041230.GA21733@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:42938 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbZAUXn0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Jan 2009 18:43:26 -0500
In-Reply-To: <20090106041230.GA21733@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dear Ted,

one (hopefully) last thing about this patch:

>  	blocks_count = (ext4_blocks_count(es) -
>  			le32_to_cpu(es->s_first_data_block) +
>  			EXT4_BLOCKS_PER_GROUP(sb) - 1);
>  	do_div(blocks_count, EXT4_BLOCKS_PER_GROUP(sb));
> +	if (blocks_count > ((uint64_t)1<<32) - EXT4_DESC_PER_BLOCK(sb)) {
> +		printk(KERN_WARNING "EXT4-fs: groups count too large: %u "
> +		       "(block count %llu, first data block %u, "
> +		       "blocks per group %lu)\n", sbi->s_groups_count,
> +		       ext4_blocks_count(es),
> +		       le32_to_cpu(es->s_first_data_block),
> +		       EXT4_BLOCKS_PER_GROUP(sb));
> +		goto failed_mount;
> +	}
>  	sbi->s_groups_count = blocks_count;
>  	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
>  		   EXT4_DESC_PER_BLOCK(sb);

When you printk() sbi->s_groups_count it is not yet initialised, I think 
blocks_count should be used there instead.

Kind regards,

Thiemo
