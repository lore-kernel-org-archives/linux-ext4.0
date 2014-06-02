From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3 v2] quota: protect Q_GETFMT by dqonoff_mutex
Date: Mon, 2 Jun 2014 09:32:45 +0200
Message-ID: <20140602073245.GA3224@quack.suse.cz>
References: <537DD5BA.1050105@gmail.com>
 <538464AD.6050407@gmail.com>
 <20140527101219.GA28035@infradead.org>
 <53854153.40601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	yawei.niu@intel.com, andreas.dilger@intel.com, lai.siyao@intel.com
To: Niu Yawei <yawei.niu@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <53854153.40601@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 28-05-14 09:52:19, Niu Yawei wrote:
> Remove dqptr_sem to make quota code scalable: Protect the
> Q_GETFMT by dqonoff_mutex instead of dqptr_sem.
  I'd make the changelog more verbose. Otherwise the patch looks good to
me. Something like:

dqptr_sem will go away. Protect Q_GETFMT quotactl by dqonoff_mutex instead.
This is also enough to make sure quota info will not go away while we are
looking at it.

								Honza
> 
> Signed-off-by: Lai Siyao <lai.siyao@intel.com>
> Signed-off-by: Niu Yawei <yawei.niu@intel.com>
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
