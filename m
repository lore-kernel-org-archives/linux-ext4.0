From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 1/2] ext4: improve extents status tree trace point
Date: Tue, 14 Jan 2014 14:14:49 +0100
Message-ID: <20140114131449.GE21327@quack.suse.cz>
References: <1389686801-11367-1-git-send-email-wenqing.lz@taobao.com>
 <1389686801-11367-2-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>, Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbaANNOw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Jan 2014 08:14:52 -0500
Content-Disposition: inline
In-Reply-To: <1389686801-11367-2-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 14-01-14 16:06:40, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> This commit improves the trace point of extents status tree.  We rename
> trace_ext4_es_shrink_enter in ext4_es_count() because it is also used
> in ext4_es_scan() and we don't identify them from the result.
> 
> Further this commit fixes a variable name in trace point in order to
> keep consistency with others.
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  fs/ext4/extents_status.c    |    6 +++---
>  include/trace/events/ext4.h |   28 ++++++++++++++++++++--------
>  2 files changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index 3981ff7..eb7ae61 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
> @@ -1017,7 +1017,7 @@ static unsigned long ext4_es_count(struct shrinker *shrink,
>  
>  	sbi = container_of(shrink, struct ext4_sb_info, s_es_shrinker);
>  	nr = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> -	trace_ext4_es_shrink_enter(sbi->s_sb, sc->nr_to_scan, nr);
> +	trace_ext4_es_shrink_count(sbi->s_sb, sc->nr_to_scan, nr);
>  	return nr;
>  }
>  
> @@ -1030,14 +1030,14 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
>  	int ret, nr_shrunk;
>  
>  	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> -	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
> +	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
>  
>  	if (!nr_to_scan)
>  		return ret;
>  
>  	nr_shrunk = __ext4_es_shrink(sbi, nr_to_scan, NULL);
>  
> -	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
> +	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
>  	return nr_shrunk;
>  }
>  
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 197d312..35d28f8 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -2366,7 +2366,7 @@ TRACE_EVENT(ext4_es_lookup_extent_exit,
>  		  show_extent_status(__entry->found ? __entry->status : 0))
>  );
>  
> -TRACE_EVENT(ext4_es_shrink_enter,
> +DECLARE_EVENT_CLASS(ext4__es_shrink_enter,
>  	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
>  
>  	TP_ARGS(sb, nr_to_scan, cache_cnt),
> @@ -2388,26 +2388,38 @@ TRACE_EVENT(ext4_es_shrink_enter,
>  		  __entry->nr_to_scan, __entry->cache_cnt)
>  );
>  
> -TRACE_EVENT(ext4_es_shrink_exit,
> -	TP_PROTO(struct super_block *sb, int shrunk_nr, int cache_cnt),
> +DEFINE_EVENT(ext4__es_shrink_enter, ext4_es_shrink_count,
> +	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
> +
> +	TP_ARGS(sb, nr_to_scan, cache_cnt)
> +);
> +
> +DEFINE_EVENT(ext4__es_shrink_enter, ext4_es_shrink_scan_enter,
> +	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
> +
> +	TP_ARGS(sb, nr_to_scan, cache_cnt)
> +);
> +
> +TRACE_EVENT(ext4_es_shrink_scan_exit,
> +	TP_PROTO(struct super_block *sb, int nr_shrunk, int cache_cnt),
>  
> -	TP_ARGS(sb, shrunk_nr, cache_cnt),
> +	TP_ARGS(sb, nr_shrunk, cache_cnt),
>  
>  	TP_STRUCT__entry(
>  		__field(	dev_t,	dev			)
> -		__field(	int,	shrunk_nr		)
> +		__field(	int,	nr_shrunk		)
>  		__field(	int,	cache_cnt		)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->dev		= sb->s_dev;
> -		__entry->shrunk_nr	= shrunk_nr;
> +		__entry->nr_shrunk	= nr_shrunk;
>  		__entry->cache_cnt	= cache_cnt;
>  	),
>  
> -	TP_printk("dev %d,%d shrunk_nr %d cache_cnt %d",
> +	TP_printk("dev %d,%d nr_shrunk %d cache_cnt %d",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> -		  __entry->shrunk_nr, __entry->cache_cnt)
> +		  __entry->nr_shrunk, __entry->cache_cnt)
>  );
>  
>  #endif /* _TRACE_EXT4_H */
> -- 
> 1.7.9.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
