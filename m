From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [patch] ext4: signedness bug breaks ext4_inode_touch_time_cmp()
Date: Thu, 20 Jun 2013 23:24:50 +0800
Message-ID: <20130620152450.GB20615@gmail.com>
References: <20130620080858.GA15095@elgon.mountain>
 <20130620141310.GB28309@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130620141310.GB28309@thunk.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 20, 2013 at 10:13:10AM -0400, Theodore Ts'o wrote:
> On Thu, Jun 20, 2013 at 11:08:58AM +0300, Dan Carpenter wrote:
> > "diff" is unsigned so this doesn't sort the LRU list correctly.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > This was introduced in 6480bad916be "ext4: improve extent cache shrink
> > mechanism to avoid to burn CPU time"
> 
> Thanks for pointing this out!  The following patch is better I think
> because it uses the time_after() abstraction.  I will be folding the
> following into Zheng's "ext4: improve extent cache shrink > mechanism
> to avoid to burn CPU time".

Thanks for fixing it.  The patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

> 
> I've desk checked this but we may want to do some explicit testing to
> make sure we are in fact ejecting the appropriate inode from the list.

I will check it tomorrow.  If there still has a problem, I will try to
fix it.

                                                - Zheng

> 
>      	     	    	 	      - Ted
> 
>  fs/ext4/extents_status.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 80dcc59..ee018d5 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -880,17 +880,15 @@ static int ext4_inode_touch_time_cmp(void *priv, struct list_head *a,
>  				     struct list_head *b)
>  {
>  	struct ext4_inode_info *eia, *eib;
> -	unsigned long diff;
> -
>  	eia = list_entry(a, struct ext4_inode_info, i_es_lru);
>  	eib = list_entry(b, struct ext4_inode_info, i_es_lru);
>  
> -	diff = eia->i_touch_when - eib->i_touch_when;
> -	if (diff < 0)
> -		return -1;
> -	if (diff > 0)
> +	if (eia->i_touch_when == eib->i_touch_when)
> +		return 0;
> +	if (time_after(eia->i_touch_when, eib->i_touch_when))
>  		return 1;
> -	return 0;
> +	else
> +		return -1;
>  }
>  
>  static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
