From: Coly Li <coly.li@suse.de>
Subject: Re: [PATCH, RFC] support discard in non-journal ext4
Date: Thu, 13 May 2010 17:08:33 +0800
Message-ID: <4BEBC191.7060305@suse.de>
References: <20100513050014.879651BC316@ruihe.smo.corp.google.com>
Reply-To: coly.li@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40249 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0EMIzL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 May 2010 04:55:11 -0400
In-Reply-To: <20100513050014.879651BC316@ruihe.smo.corp.google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 05/13/2010 01:00 PM, Jiaying Zhang Wrote:
> This patch issues discard request for freed blocks in ext4_free_blocks()
> if ext4 is mounted with discard option and without journal.
> 
> Author: Jiaying Zhang <jiayingz@google.com>
> Date:   Wed May 12 21:11:46 2010 -0700
> 
>     Issue discard request in ext4_free_blocks() when ext4 has no journal and
>     is mounted with discard option.
>     
>     Signed-off-by: Jiaying Zhang <jiayingz@google.com>
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index a291cc3..d51b79a 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2513,6 +2513,22 @@ int ext4_mb_release(struct super_block *sb)
>  	return 0;
>  }
>  
> +static void ext4_issue_discard(struct super_block *sb, ext4_group_t block_group,
> +		ext4_grpblk_t block, int count)
> +{
> +	int ret;
> +	ext4_fsblk_t discard_block;
> +
> +	discard_block = block + ext4_group_first_block_no(sb, block_group);
> +	trace_ext4_discard_blocks(sb,
> +			(unsigned long long) discard_block, count);
> +	ret = sb_issue_discard(sb, discard_block, count);
> +	if (ret == EOPNOTSUPP) {
> +		ext4_warning(sb, "discard not supported, disabling");
> +		clear_opt(EXT4_SB(sb)->s_mount_opt, DISCARD);
> +	}
> +}
> +

How about make it as an inline routine? Thanks.

-- 
Coly Li
SuSE Labs
