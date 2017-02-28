From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: preload block group descriptors
Date: Tue, 28 Feb 2017 08:19:56 -0800
Message-ID: <20170228161956.GE5266@birch.djwong.org>
References: <1487609153-3367-1-git-send-email-artem.blagodarenko@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, alexey.lyashkov@gmail.com,
        Andrew Perepechko <andrew.perepechko@seagate.com>
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40854 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752700AbdB1QUp (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Feb 2017 11:20:45 -0500
Content-Disposition: inline
In-Reply-To: <1487609153-3367-1-git-send-email-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 20, 2017 at 07:45:53PM +0300, Artem Blagodarenko wrote:
> From: Andrew Perepechko <andrew.perepechko@seagate.com>
> 
> With enabled meta_bg option block group descriptors
> reading IO is not sequential and requires optimization.
> 
> Signed-off-by: Andrew Perepechko <andrew.perepechko@seagate.com>
> ---
>  fs/ext4/super.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a673558..0e52c91 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3879,6 +3879,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	bgl_lock_init(sbi->s_blockgroup_lock);
>  
> +	/* Pre-read the descriptors into the buffer cache */
> +	for (i = 0; i < db_count; i++) {
> +		block = descriptor_loc(sb, logical_sb_block, i);
> +		sb_breadahead(sb, block);
> +	}

Why does the libext2fs patch start readahead only on the meta bgs
whereas this patch starts it for all of them?  I suppose it's just as
well that the kernel prefetches all of them, but I was curious. :)

--D

> +
>  	for (i = 0; i < db_count; i++) {
>  		block = descriptor_loc(sb, logical_sb_block, i);
>  		sbi->s_group_desc[i] = sb_bread_unmovable(sb, block);
> -- 
> 1.8.3.1
> 
