From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: make the extent_status code more robust against
 ENOMEM failures
Date: Mon, 15 Jul 2013 18:05:11 +0800
Message-ID: <20130715100511.GA5144@gmail.com>
References: <1373861557-15573-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:38671 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3GOJqY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Jul 2013 05:46:24 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so11062824pbc.16
        for <linux-ext4@vger.kernel.org>; Mon, 15 Jul 2013 02:46:24 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1373861557-15573-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 15, 2013 at 12:12:37AM -0400, Theodore Ts'o wrote:
> Some callers of ext4_es_remove_extent() and ext4_es_insert_extent()
> may not be completely robust against ENOMEM failures (or the
> consequences of reflecting ENOMEM back up to userspace may lead to
> xfstest or user application failure).
> 
> To mitigate against this, when trying to insert an entry in the extent
> status tree, try to shrink the inode's extent status tree before
> returning ENOMEM.  If there are entries which don't record information
> about extents under delayed allocations, freeing one of them is
> preferable to returning ENOMEM.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Zheng Liu <wenqing.lz@taobao.com>

Thanks for fixing this.  The patch looks good to me.
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng
> ---
>  fs/ext4/extents_status.c | 51 ++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 39 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 4b8df7f..91cb110 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -148,6 +148,8 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  			      ext4_lblk_t end);
>  static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
>  				       int nr_to_scan);
> +static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> +			    struct ext4_inode_info *locked_ei);
>  
>  int __init ext4_init_es(void)
>  {
> @@ -665,7 +667,13 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
>  	err = __es_remove_extent(inode, lblk, end);
>  	if (err != 0)
>  		goto error;
> +retry:
>  	err = __es_insert_extent(inode, &newes);
> +	if (err == -ENOMEM && __ext4_es_shrink(EXT4_SB(inode->i_sb), 1,
> +					       EXT4_I(inode)))
> +		goto retry;
> +	if (err == -ENOMEM && !ext4_es_is_delayed(&newes))
> +		err = 0;
>  
>  error:
>  	write_unlock(&EXT4_I(inode)->i_es_lock);
> @@ -744,8 +752,10 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  	struct extent_status orig_es;
>  	ext4_lblk_t len1, len2;
>  	ext4_fsblk_t block;
> -	int err = 0;
> +	int err;
>  
> +retry:
> +	err = 0;
>  	es = __es_tree_search(&tree->root, lblk);
>  	if (!es)
>  		goto out;
> @@ -780,6 +790,10 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  			if (err) {
>  				es->es_lblk = orig_es.es_lblk;
>  				es->es_len = orig_es.es_len;
> +				if ((err == -ENOMEM) &&
> +				    __ext4_es_shrink(EXT4_SB(inode->i_sb), 1,
> +						     EXT4_I(inode)))
> +					goto retry;
>  				goto out;
>  			}
>  		} else {
> @@ -889,22 +903,14 @@ static int ext4_inode_touch_time_cmp(void *priv, struct list_head *a,
>  		return -1;
>  }
>  
> -static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
> +static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> +			    struct ext4_inode_info *locked_ei)
>  {
> -	struct ext4_sb_info *sbi = container_of(shrink,
> -					struct ext4_sb_info, s_es_shrinker);
>  	struct ext4_inode_info *ei;
>  	struct list_head *cur, *tmp;
>  	LIST_HEAD(skiped);
> -	int nr_to_scan = sc->nr_to_scan;
>  	int ret, nr_shrunk = 0;
>  
> -	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> -	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
> -
> -	if (!nr_to_scan)
> -		return ret;
> -
>  	spin_lock(&sbi->s_es_lru_lock);
>  
>  	/*
> @@ -933,7 +939,7 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
>  			continue;
>  		}
>  
> -		if (ei->i_es_lru_nr == 0)
> +		if (ei->i_es_lru_nr == 0 || ei == locked_ei)
>  			continue;
>  
>  		write_lock(&ei->i_es_lock);
> @@ -952,6 +958,27 @@ static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
>  	list_splice_tail(&skiped, &sbi->s_es_lru);
>  	spin_unlock(&sbi->s_es_lru_lock);
>  
> +	if (locked_ei && nr_shrunk == 0)
> +		nr_shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
> +
> +	return nr_shrunk;
> +}
> +
> +static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +	struct ext4_sb_info *sbi = container_of(shrink,
> +					struct ext4_sb_info, s_es_shrinker);
> +	int nr_to_scan = sc->nr_to_scan;
> +	int ret, nr_shrunk;
> +
> +	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> +	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
> +
> +	if (!nr_to_scan)
> +		return ret;
> +
> +	nr_shrunk = __ext4_es_shrink(sbi, nr_to_scan, NULL);
> +
>  	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
>  	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
>  	return ret;
> -- 
> 1.7.12.rc0.22.gcdd159b
> 
