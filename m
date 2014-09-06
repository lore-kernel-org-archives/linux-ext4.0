From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] ext4: include journal blocks of internal journal in
 df overhead calcs
Date: Sat, 6 Sep 2014 13:17:36 -0700
Message-ID: <20140906201736.GC10351@birch.djwong.org>
References: <1408084971-1456-1-git-send-email-chintzung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chin-Tsung Cheng <chintzung@gmail.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1408084971-1456-1-git-send-email-chintzung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Aug 15, 2014 at 02:42:51PM +0800, Chin-Tsung Cheng wrote:
> The journal blocks of external journal device should not
> be counted as overhead.

Hi Ted,

Would you mind queueing this one up for 3.17?  It fixes this problem:

# df /mnt
/dev/sda      64Z   64Z  2.8G 100% /mnt

...which is a regression introduced in commit 0875a2b448 ("ext4: include
journal blocks in df overhead calcs") when one creates an ext4 with an
external journal.

It doesn't look like this patch is in any upstream tree.

--D

> 
> Signed-off-by: Chin-Tsung Cheng <chintzung@gmail.com>
> ---
>  fs/ext4/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 32b43ad..a80b122 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -3316,8 +3316,8 @@ int ext4_calculate_overhead(struct super_block *sb)
>  			memset(buf, 0, PAGE_SIZE);
>  		cond_resched();
>  	}
> -	/* Add the journal blocks as well */
> -	if (sbi->s_journal)
> +	/* Add the internal journal blocks as well */
> +	if (sbi->s_journal && !sbi->journal_bdev)
>  		overhead += EXT4_NUM_B2C(sbi, sbi->s_journal->j_maxlen);
>  
>  	sbi->s_overhead = overhead;
> -- 
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
