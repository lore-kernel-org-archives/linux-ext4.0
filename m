From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] quota: Handle Q_GETNEXTQUOTA when quota is disabled
Date: Fri, 1 Apr 2016 10:39:56 -0400
Message-ID: <20160401143956.GD29897@thunk.org>
References: <1459267904-10755-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1459267904-10755-1-git-send-email-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 29, 2016 at 06:11:43PM +0200, Jan Kara wrote:
> Currently we oopsed when Q_GETNEXTQUOTA got called when quota was
> disabled. Properly check whether quota is enabled for the filesystem
> before calling into quota format handler.
> 
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index ba827daea5a0..ff21980d0119 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -2047,11 +2047,20 @@ int dquot_get_next_id(struct super_block *sb, struct kqid *qid)
>  	struct quota_info *dqopt = sb_dqopt(sb);
>  	int err;
>  
> -	if (!dqopt->ops[qid->type]->get_next_id)
> -		return -ENOSYS;
> +	mutex_lock(&dqopt->dqonoff_mutex);
> +	if (!sb_has_quota_active(sb, qid->type)) {
> +		err = -ESRCH;
> +		goto out;
> +	}
> +	if (!dqopt->ops[qid->type]->get_next_id) {
> +		err = -ENOSYS;
> +		goto out;
> +	}

Don't you also have to test if dqopt->ops[qid->type] is NULL?  e.g.,
if the quota inode hasn't been loaded for that quota type?

Also, I notice you have this queued on the for_next branch and not the
for_linus branch.  I was hoping you could push this to Linus sooner
than the next merge cycle, since this is (a) making my testing hard,
and (b) it makes it easy for an attacker to crash the system.  For
similar reasons, perhaps this should have a cc: stable@vger.kernel.org
tag?

Thanks,

					- Ted
