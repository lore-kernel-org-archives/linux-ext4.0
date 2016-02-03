From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] ext4: add a line break for proc mb_groups display
Date: Wed, 3 Feb 2016 10:13:56 -0800
Message-ID: <20160203181356.GA5842@birch.djwong.org>
References: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Huaitong Han <huaitong.han@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454505546-4875-1-git-send-email-huaitong.han@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 03, 2016 at 09:19:06PM +0800, Huaitong Han wrote:
> This patch adds a line break for proc mb_groups display.
> 
> Signed-off-by: Huaitong Han <huaitong.han@intel.com>
> ---
>  fs/ext4/mballoc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 61eaf74..4424b7b 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -2285,7 +2285,7 @@ static int ext4_mb_seq_groups_show(struct seq_file *seq, void *v)
>  	if (group == 0)
>  		seq_puts(seq, "#group: free  frags first ["
>  			      " 2^0   2^1   2^2   2^3   2^4   2^5   2^6  "
> -			      " 2^7   2^8   2^9   2^10  2^11  2^12  2^13  ]");
> +			      " 2^7   2^8   2^9   2^10  2^11  2^12  2^13  ]\n");

Oh, heh.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  	i = (sb->s_blocksize_bits + 2) * sizeof(sg.info.bb_counters[0]) +
>  		sizeof(struct ext4_group_info);
> -- 
> 2.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
