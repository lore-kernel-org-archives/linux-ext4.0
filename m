From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] ext4: Clear lockdep subtype for quota files on quota off
Date: Mon, 8 May 2017 10:44:42 -0600
Message-ID: <20170508164442.GA10855@linux.intel.com>
References: <20170505085327.27103-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Ross Zwisler <ross.zwisler@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37538 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752483AbdEHQot (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 8 May 2017 12:44:49 -0400
Content-Disposition: inline
In-Reply-To: <20170505085327.27103-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 05, 2017 at 10:53:27AM +0200, Jan Kara wrote:
> Quota files have special ranking of i_data_sem lock. We inform lockdep
> about it when turning on quotas however when turning quotas off, we
> don't clear the lockdep subclass from i_data_sem lock and thus when the
> inode gets later reused for a normal file or directory, lockdep gets
> confused and complains about possible deadlocks. Fix the problem by
> resetting lockdep subclass of i_data_sem on quota off.
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Yep, this fixes the lockdep warning for me, thanks!

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>

> ---
>  fs/ext4/super.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a9c72e39a4ee..77043dc7f704 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -846,14 +846,9 @@ static inline void ext4_quota_off_umount(struct super_block *sb)
>  {
>  	int type;
>  
> -	if (ext4_has_feature_quota(sb)) {
> -		dquot_disable(sb, -1,
> -			      DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
> -	} else {
> -		/* Use our quota_off function to clear inode flags etc. */
> -		for (type = 0; type < EXT4_MAXQUOTAS; type++)
> -			ext4_quota_off(sb, type);
> -	}
> +	/* Use our quota_off function to clear inode flags etc. */
> +	for (type = 0; type < EXT4_MAXQUOTAS; type++)
> +		ext4_quota_off(sb, type);
>  }
>  #else
>  static inline void ext4_quota_off_umount(struct super_block *sb)
> @@ -5476,7 +5471,7 @@ static int ext4_quota_off(struct super_block *sb, int type)
>  		goto out;
>  
>  	err = dquot_quota_off(sb, type);
> -	if (err)
> +	if (err || ext4_has_feature_quota(sb))
>  		goto out_put;
>  
>  	inode_lock(inode);
> @@ -5496,6 +5491,7 @@ static int ext4_quota_off(struct super_block *sb, int type)
>  out_unlock:
>  	inode_unlock(inode);
>  out_put:
> +	lockdep_set_quota_inode(inode, I_DATA_SEM_NORMAL);
>  	iput(inode);
>  	return err;
>  out:
> -- 
> 2.12.0
> 
