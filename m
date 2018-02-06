From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: report delalloc reserve as non-free in statfs
 mangled by project quota
Date: Tue, 6 Feb 2018 14:46:49 +0100
Message-ID: <20180206134649.r727hoku3wc33huo@quack2.suse.cz>
References: <151756800585.979296.13086151972011935611.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-kernel@vger.kernel.org,
        Dmitry Monakhov <dmonakhov@openvz.org>, Li Xi <lixi@ddn.com>,
        Jan Kara <jack@suse.cz>
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49077 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751822AbeBFNqx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 6 Feb 2018 08:46:53 -0500
Content-Disposition: inline
In-Reply-To: <151756800585.979296.13086151972011935611.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 02-02-18 13:40:05, Konstantin Khlebnikov wrote:
> This reserved space isn't committed yet but cannot be used for allocations.
> For userspace it has no difference from used space. XFS already does this.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Fixes: 689c958cbe6b ("ext4: add project quota support")

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/super.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 5de959fb0244..13ce97b9e820 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5227,7 +5227,8 @@ static int ext4_statfs_project(struct super_block *sb,
>  		 dquot->dq_dqb.dqb_bsoftlimit :
>  		 dquot->dq_dqb.dqb_bhardlimit) >> sb->s_blocksize_bits;
>  	if (limit && buf->f_blocks > limit) {
> -		curblock = dquot->dq_dqb.dqb_curspace >> sb->s_blocksize_bits;
> +		curblock = (dquot->dq_dqb.dqb_curspace +
> +			    dquot->dq_dqb.dqb_rsvspace) >> sb->s_blocksize_bits;
>  		buf->f_blocks = limit;
>  		buf->f_bfree = buf->f_bavail =
>  			(buf->f_blocks > curblock) ?
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
