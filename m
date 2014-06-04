From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] quota: protect Q_GETFMT by dqonoff_mutex
Date: Wed, 4 Jun 2014 17:36:08 +0200
Message-ID: <20140604153608.GA22927@quack.suse.cz>
References: <537DD5BA.1050105@gmail.com>
 <538464AD.6050407@gmail.com>
 <20140527101219.GA28035@infradead.org>
 <538541FE.3070203@gmail.com>
 <20140602083436.GC3224@quack.suse.cz>
 <538D9AB0.9090607@gmail.com>
 <20140603154301.GE30706@quack.suse.cz>
 <538E9E40.8090202@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbaFDPgM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2014 11:36:12 -0400
Content-Disposition: inline
In-Reply-To: <538E9E40.8090202@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 04-06-14 12:19:12, Niu Yawei wrote:
> Subject: [PATCH 1/5] quota: protect Q_GETFMT by dqonoff_mutex
> 
> dqptr_sem will go away. Protect Q_GETFMT quotactl by
> dqonoff_mutex instead. This is also enough to make sure
> quota info will not go away while we are looking at it.
> 
> Signed-off-by: Lai Siyao <lai.siyao@intel.com>
> Signed-off-by: Niu Yawei <yawei.niu@intel.com>
  Thanks! I've merged all the five patches to my tree. I will give them
some testing. I won't push them in this merge window but it should go in in
the next one.

								Honza
> ---
>  fs/quota/quota.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/quota/quota.c b/fs/quota/quota.c
> index 2b363e2..e4851cb 100644
> --- a/fs/quota/quota.c
> +++ b/fs/quota/quota.c
> @@ -79,13 +79,13 @@ static int quota_getfmt(struct super_block *sb, int type, void __user *addr)
>  {
>  	__u32 fmt;
>  
> -	down_read(&sb_dqopt(sb)->dqptr_sem);
> +	mutex_lock(&sb_dqopt(sb)->dqonoff_mutex);
>  	if (!sb_has_quota_active(sb, type)) {
> -		up_read(&sb_dqopt(sb)->dqptr_sem);
> +		mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
>  		return -ESRCH;
>  	}
>  	fmt = sb_dqopt(sb)->info[type].dqi_format->qf_fmt_id;
> -	up_read(&sb_dqopt(sb)->dqptr_sem);
> +	mutex_unlock(&sb_dqopt(sb)->dqonoff_mutex);
>  	if (copy_to_user(addr, &fmt, sizeof(fmt)))
>  		return -EFAULT;
>  	return 0;
> -- 
> 1.7.1
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
