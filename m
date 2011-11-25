From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: replace ll_rw_block with other functions
Date: Sat, 26 Nov 2011 00:28:42 +0100
Message-ID: <20111125232842.GB11661@quack.suse.cz>
References: <1322191841-9444-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab1KYX2p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Nov 2011 18:28:45 -0500
Content-Disposition: inline
In-Reply-To: <1322191841-9444-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 25-11-11 11:30:41, Zheng Liu wrote:
> Hi all,
> 
> ll_rw_block() has deprecated since 1da177e4 and some filesystems, such as
> xfs and btrfs, also don't use it. So I propose that maybe we should
> replace it with other functions (e.g. submit_bh() or bh_submit_read()).
> Meanwhile, ext3 might need to replace it too. But I am not sure whether
> or not this proprosal is good.  So any comments are appreciated. Thank
> you. If it is ok and good to ext3, I will generate a patch for it.
  I'm not sure. ll_rw_block() is one of deprecated functions which noone
really tries to deprecate too hard. But using submit_bh() and friends for
consistency probably makes sense.
 
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> ll_rw_block() has deprecated. Thus, we should replace it with other
> functions.
  Let me improve English a bit:
ll_rw_block() is deprecated. Thus we replace it with other functions.

  Besides that I have one comment below:

> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
...
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3858767..cbe1513 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4011,11 +4011,12 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
>  		goto out_bdev;
>  	}
>  	journal->j_private = sb;
> -	ll_rw_block(READ, 1, &journal->j_sb_buffer);
> -	wait_on_buffer(journal->j_sb_buffer);
> -	if (!buffer_uptodate(journal->j_sb_buffer)) {
> -		ext4_msg(sb, KERN_ERR, "I/O error on journal device");
> -		goto out_journal;
> +	if (!bh_uptodate_or_lock(bh)) {
                                 ^^^ Here must be journal->j_sb_buffer

> +		if (bh_submit_read(journal->j_sb_buffer)) {
> +			ext4_msg(sb, KERN_ERR,
> +				"I/O error on journal device");
> +			goto out_journal;
> +		}
>  	}
>  	if (be32_to_cpu(journal->j_superblock->s_nr_users) != 1) {
>  		ext4_msg(sb, KERN_ERR, "External journal has more than one "
> -- 
> 1.7.4.1

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
