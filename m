From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Move bdget out of critical section
Date: Sun, 3 Apr 2011 11:40:58 +0200
Message-ID: <20110403094058.GA5141@quack.suse.cz>
References: <1301734876-22207-1-git-send-email-gaoyang.zyh@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, Zhu Yanhai <gaoyang.zyh@taobao.com>,
	tytso@mit.edu
To: Zhu Yanhai <zhu.yanhai@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab1DDAhj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Apr 2011 20:37:39 -0400
Content-Disposition: inline
In-Reply-To: <1301734876-22207-1-git-send-email-gaoyang.zyh@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 02-04-11 17:01:16, Zhu Yanhai wrote:
> bdget() should not be called when we hold spinlocks since
> it might sleep.
> 
> Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
  Looks good.
Acked-by: Jan Kara <jack@suse.cz>

PS: Added Ted to CC since he merges JBD2 patches.


								Honza
> ---
>  fs/jbd2/journal.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 90407b8..33dd3ef 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2413,10 +2413,12 @@ const char *jbd2_dev_to_name(dev_t device)
>  	new_dev = kmalloc(sizeof(struct devname_cache), GFP_KERNEL);
>  	if (!new_dev)
>  		return "NODEV-ALLOCFAILURE"; /* Something non-NULL */
> +	bd = bdget(device);
>  	spin_lock(&devname_cache_lock);
>  	if (devcache[i]) {
>  		if (devcache[i]->device == device) {
>  			kfree(new_dev);
> +			bdput(bd);
>  			ret = devcache[i]->devname;
>  			spin_unlock(&devname_cache_lock);
>  			return ret;
> @@ -2425,7 +2427,6 @@ const char *jbd2_dev_to_name(dev_t device)
>  	}
>  	devcache[i] = new_dev;
>  	devcache[i]->device = device;
> -	bd = bdget(device);
>  	if (bd) {
>  		bdevname(bd, devcache[i]->devname);
>  		bdput(bd);
> -- 
> 1.7.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
