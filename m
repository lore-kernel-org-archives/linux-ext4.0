From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH ] ext3: Fix a possible corruption in dx_probe.
Date: Thu, 1 Sep 2011 18:43:33 +0200
Message-ID: <20110901164333.GE2070@quack.suse.cz>
References: <1314806244-8434-1-git-send-email-tm@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Tao Ma <tm@tao.ma>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab1IAQnf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Sep 2011 12:43:35 -0400
Content-Disposition: inline
In-Reply-To: <1314806244-8434-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 31-08-11 23:57:24, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> For all the callers of dx_probe, frame_in is passed in uninitialized.
> So we should set frame->bh to NULL in the beginning of while, not
> the end. Otherwise, the first "goto fail2" will try to brelse(frame->bh)
> while frame->bh is still invalid.
  I think this happens at the beginning of dx_probe().

								Honza
> 
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  fs/ext3/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 34b6d9b..45468b9 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -404,6 +404,7 @@ dx_probe(struct qstr *entry, struct inode *dir,
>  	dxtrace (printk("Look up %x", hash));
>  	while (1)
>  	{
> +		frame->bh = NULL;
>  		count = dx_get_count(entries);
>  		if (!count || count > dx_get_limit(entries)) {
>  			ext3_warning(dir->i_sb, __func__,
> @@ -458,7 +459,6 @@ dx_probe(struct qstr *entry, struct inode *dir,
>  			goto fail2;
>  		}
>  		frame++;
> -		frame->bh = NULL;
>  	}
>  fail2:
>  	while (frame >= frame_in) {
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
