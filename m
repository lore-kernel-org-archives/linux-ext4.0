From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 5/6] jbd2: replace current_kernel_time64 with ktime
 equivalent
Date: Fri, 22 Jun 2018 09:41:42 +0200
Message-ID: <20180622074142.kjs6sozf3it42wef@quack2.suse.cz>
References: <20180620153322.54221-1-arnd@arndb.de>
 <20180620153322.54221-5-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>, y2038@lists.linaro.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180620153322.54221-5-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 20-06-18 17:33:02, Arnd Bergmann wrote:
> jbd2 is one of the few callers of current_kernel_time64(), which
> is a wrapper around ktime_get_coarse_real_ts64(). This calls the
> latter directly for consistency with the rest of the kernel that
> is moving to the ktime_get_ family of time accessors.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/jbd2/commit.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index 8de0e7723316..150cc030b4d7 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -121,7 +121,7 @@ static int journal_submit_commit_record(journal_t *journal,
>  	struct commit_header *tmp;
>  	struct buffer_head *bh;
>  	int ret;
> -	struct timespec64 now = current_kernel_time64();
> +	struct timespec64 now;
>  
>  	*cbh = NULL;
>  
> @@ -134,6 +134,7 @@ static int journal_submit_commit_record(journal_t *journal,
>  		return 1;
>  
>  	tmp = (struct commit_header *)bh->b_data;
> +	ktime_get_coarse_real_ts64(&now);
>  	tmp->h_commit_sec = cpu_to_be64(now.tv_sec);
>  	tmp->h_commit_nsec = cpu_to_be32(now.tv_nsec);
>  
> -- 
> 2.9.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
