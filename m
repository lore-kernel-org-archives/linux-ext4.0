From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: Count internal journal as bsddf overhead in
 ext3_statfs
Date: Tue, 19 Aug 2014 23:20:13 +0200
Message-ID: <20140819212013.GA3271@quack.suse.cz>
References: <1408088971-3221-1-git-send-email-chintzung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chin-Tsung Cheng <chintzung@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408088971-3221-1-git-send-email-chintzung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 15-08-14 15:49:31, Chin-Tsung Cheng wrote:
> The journal blocks of external journal device should not
> be counted as overhead.
  Thanks. I've added the patch to my tree.

								Honza

> 
> Signed-off-by: Chin-Tsung Cheng <chintzung@gmail.com>
> ---
>  fs/ext3/super.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 08cdfe5..622e882 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -2828,8 +2828,9 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
>  		 */
>  		overhead += ngroups * (2 + sbi->s_itb_per_group);
>  
> -		/* Add the journal blocks as well */
> -                overhead += sbi->s_journal->j_maxlen;
> +		/* Add the internal journal blocks as well */
> +		if (sbi->s_journal && !sbi->journal_bdev)
> +			overhead += sbi->s_journal->j_maxlen;
>  
>  		sbi->s_overhead_last = overhead;
>  		smp_wmb();
> -- 
> 1.9.3
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
