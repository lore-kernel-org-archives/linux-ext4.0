From: Jan Kara <jack@suse.cz>
Subject: Re: [patch] ext4: checking for NULL instead of IS_ERR
Date: Wed, 6 Jan 2016 14:05:11 +0100
Message-ID: <20160106130511.GA29528@quack.suse.cz>
References: <20160106100425.GG23185@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Li Xi <pkuelelixi@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160106100425.GG23185@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 06-01-16 13:04:25, Dan Carpenter wrote:
> The dqget() function returns error pointers on error, it doesn't return
> NULL.
> 
> Fixes: 76481d7a60a4 ('ext4: add project quota support')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Correct. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 50b2207..103a7a3 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4844,8 +4844,8 @@ static int ext4_statfs_project(struct super_block *sb,
>  
>  	qid = make_kqid_projid(projid);
>  	dquot = dqget(sb, qid);
> -	if (!dquot)
> -		return -ESRCH;
> +	if (IS_ERR(dquot))
> +		return PTR_ERR(dquot);
>  	spin_lock(&dq_data_lock);
>  
>  	limit = (dquot->dq_dqb.dqb_bsoftlimit ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
