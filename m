From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: let ext4_page_mkwrite stop started handle in
 failure
Date: Thu, 15 Sep 2011 14:28:00 +0200
Message-ID: <20110915122800.GA4739@quack.suse.cz>
References: <1316055390-14476-1-git-send-email-xiaoqiangnk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933461Ab1IOM2B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 08:28:01 -0400
Content-Disposition: inline
In-Reply-To: <1316055390-14476-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 15-09-11 10:56:30, Yongqiang Yang wrote:
> The started journal handle should be stopped in failure case.
> 
> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
  Correct.
  Acked-by: Jan Kara <jack@suse.cz>

									Honza
> ---
>  fs/ext4/inode.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index bcf5257..c8529be 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4624,6 +4624,7 @@ retry_alloc:
>  			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
>  			unlock_page(page);
>  			ret = VM_FAULT_SIGBUS;
> +			ext4_journal_stop(handle);
>  			goto out;
>  		}
>  		ext4_set_inode_state(inode, EXT4_STATE_JDATA);
> -- 
> 1.7.5.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
