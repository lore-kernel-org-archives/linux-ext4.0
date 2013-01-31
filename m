From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/9 v4] ext4: adjust interfaces of extent status tree
Date: Thu, 31 Jan 2013 17:02:06 +0100
Message-ID: <20130131160206.GD4612@quack.suse.cz>
References: <1359609477-29845-1-git-send-email-wenqing.lz@taobao.com>
 <1359609477-29845-5-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab3AaQCT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 11:02:19 -0500
Content-Disposition: inline
In-Reply-To: <1359609477-29845-5-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 31-01-13 13:17:52, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Due to two members are added into extent status tree, all interfaces
> need to be adjusted.
  I have one minor comment below...

> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/extents_status.c    | 56 ++++++++++++++++++++++++++++++++++++---------
>  fs/ext4/extents_status.h    | 24 ++++++++++++++++++-
>  fs/ext4/inode.c             |  3 ++-
>  include/trace/events/ext4.h | 34 +++++++++++++++++----------
>  4 files changed, 92 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> index aa4d346..9c7984c 100644
> --- a/fs/ext4/extents_status.c
> +++ b/fs/ext4/extents_status.c
<snip>
> @@ -465,6 +490,9 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
>  
>  			newes.es_lblk = end + 1;
>  			newes.es_len = len2;
> +			newes.es_pblk = ext4_es_get_pblock(&orig_es,
> +				orig_es.es_pblk + orig_es.es_len - len2);
> +			newes.es_status = orig_es.es_status;
>  			err = __es_insert_extent(tree, &newes);
>  			if (err) {
>  				es->es_lblk = orig_es.es_lblk;
> @@ -474,6 +502,8 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
>  		} else {
>  			es->es_lblk = end + 1;
>  			es->es_len = len2;
> +			es->es_pblk = ext4_es_get_pblock(es,
> +				orig_es.es_pblk + orig_es.es_len - len2);
>  		}
>  		goto out;
>  	}
> @@ -498,9 +528,13 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
>  	}
>  
>  	if (es && es->es_lblk < end + 1) {
> +		ext4_lblk_t orig_len = es->es_len;
> +
>  		len1 = ext4_es_end(es) - end;
>  		es->es_lblk = end + 1;
>  		es->es_len = len1;
> +		es->es_pblk = ext4_es_get_pblock(es,
> +						 es->es_pblk + orig_len - len1);
>  	}
>  
>  out:
  So ext4_es_get_pblock() seems a bit confusing. I understand that for
delayed extents physical block doesn't make sence and that you wanted to
save some typing by that function but IMHO it's making the code less
readable. I'd rather see there e.g.:
  if (!ext4_es_is_delayed(es))
	es->es_pblk += orig_len - len1;
and for delayed extents we can just leave es_pblk undefined because nobody
should really look at it anyway.

								Honza

> diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
> index 2eb9cc3..1345c06 100644
> --- a/fs/ext4/extents_status.h
> +++ b/fs/ext4/extents_status.h
> @@ -48,10 +48,32 @@ extern void ext4_exit_es(void);
>  extern void ext4_es_init_tree(struct ext4_es_tree *tree);
>  
>  extern int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
> -				 ext4_lblk_t len);
> +				 ext4_lblk_t len, ext4_fsblk_t pblk,
> +				 int status);
>  extern int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
>  				 ext4_lblk_t len);
>  extern ext4_lblk_t ext4_es_find_extent(struct inode *inode,
>  				struct extent_status *es);
>  
> +static inline int ext4_es_is_written(struct extent_status *es)
> +{
> +	return (es->es_status == EXTENT_STATUS_WRITTEN);
> +}
> +
> +static inline int ext4_es_is_unwritten(struct extent_status *es)
> +{
> +	return (es->es_status == EXTENT_STATUS_UNWRITTEN);
> +}
> +
> +static inline int ext4_es_is_delayed(struct extent_status *es)
> +{
> +	return (es->es_status == EXTENT_STATUS_DELAYED);
> +}
> +
> +static inline ext4_fsblk_t ext4_es_get_pblock(struct extent_status *es,
> +					      ext4_fsblk_t pb)
> +{
> +	return (ext4_es_is_delayed(es) ? ~0 : pb);
> +}
> +
>  #endif /* _EXT4_EXTENTS_STATUS_H */
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 4d066f3..e09c7cf 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1819,7 +1819,8 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
>  				goto out_unlock;
>  		}
>  
> -		retval = ext4_es_insert_extent(inode, map->m_lblk, map->m_len);
> +		retval = ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
> +					       ~0, EXTENT_STATUS_DELAYED);
>  		if (retval)
>  			goto out_unlock;
>  
> diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> index 952628a..43f335a 100644
> --- a/include/trace/events/ext4.h
> +++ b/include/trace/events/ext4.h
> @@ -2068,28 +2068,33 @@ TRACE_EVENT(ext4_ext_remove_space_done,
>  );
>  
>  TRACE_EVENT(ext4_es_insert_extent,
> -	TP_PROTO(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len),
> +	TP_PROTO(struct inode *inode, struct extent_status *es),
>  
> -	TP_ARGS(inode, lblk, len),
> +	TP_ARGS(inode, es),
>  
>  	TP_STRUCT__entry(
> -		__field(	dev_t,	dev			)
> -		__field(	ino_t,	ino			)
> -		__field(	loff_t,	lblk			)
> -		__field(	loff_t, len			)
> +		__field(	dev_t,		dev		)
> +		__field(	ino_t,		ino		)
> +		__field(	ext4_lblk_t,	lblk		)
> +		__field(	ext4_lblk_t,	len		)
> +		__field(	ext4_fsblk_t,	pblk		)
> +		__field(	int,		status		)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->dev	= inode->i_sb->s_dev;
>  		__entry->ino	= inode->i_ino;
> -		__entry->lblk	= lblk;
> -		__entry->len	= len;
> +		__entry->lblk	= es->es_lblk;
> +		__entry->len	= es->es_len;
> +		__entry->pblk	= es->es_pblk;
> +		__entry->status	= es->es_status;
>  	),
>  
> -	TP_printk("dev %d,%d ino %lu es [%lld/%lld)",
> +	TP_printk("dev %d,%d ino %lu es [%u/%u) mapped %llu status %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long) __entry->ino,
> -		  __entry->lblk, __entry->len)
> +		  __entry->lblk, __entry->len,
> +		  __entry->pblk, __entry->status)
>  );
>  
>  TRACE_EVENT(ext4_es_remove_extent,
> @@ -2150,6 +2155,8 @@ TRACE_EVENT(ext4_es_find_extent_exit,
>  		__field(	ino_t,		ino		)
>  		__field(	ext4_lblk_t,	lblk		)
>  		__field(	ext4_lblk_t,	len		)
> +		__field(	ext4_fsblk_t,	pblk		)
> +		__field(	int,		status		)
>  		__field(	ext4_lblk_t,	ret		)
>  	),
>  
> @@ -2158,13 +2165,16 @@ TRACE_EVENT(ext4_es_find_extent_exit,
>  		__entry->ino	= inode->i_ino;
>  		__entry->lblk	= es->es_lblk;
>  		__entry->len	= es->es_len;
> +		__entry->pblk	= es->es_pblk;
> +		__entry->status	= es->es_status;
>  		__entry->ret	= ret;
>  	),
>  
> -	TP_printk("dev %d,%d ino %lu es [%u/%u) ret %u",
> +	TP_printk("dev %d,%d ino %lu es [%u/%u) mapped %llu status %u ret %u",
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  (unsigned long) __entry->ino,
> -		  __entry->lblk, __entry->len, __entry->ret)
> +		  __entry->lblk, __entry->len,
> +		  __entry->pblk, __entry->status, __entry->ret)
>  );
>  
>  #endif /* _TRACE_EXT4_H */
> -- 
> 1.7.12.rc2.18.g61b472e
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
