From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RFC PATCH 1/2] ext4: improve extents status tree trace point
Date: Wed, 25 Dec 2013 11:23:20 +0800
Message-ID: <20131225032320.GB23505@gmail.com>
References: <1387536165-15956-1-git-send-email-wenqing.lz@taobao.com>
 <1387536165-15956-2-git-send-email-wenqing.lz@taobao.com>
 <20131223083903.GA9199@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62598 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab3LYDT5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 24 Dec 2013 22:19:57 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so6855641pdj.39
        for <linux-ext4@vger.kernel.org>; Tue, 24 Dec 2013 19:19:56 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131223083903.GA9199@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 23, 2013 at 09:39:03AM +0100, Jan Kara wrote:
> On Fri 20-12-13 18:42:44, Zheng Liu wrote:
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > This commit improves the trace point of extents status tree.  For
> > improving the shrinker, we need to collect more details from trace
> > point.  First we put more enter/exit pairs in insertion, deletion,
> > and caching code path in order to collect the latency of these code
> > path.  Then we rename trace_ext4_es_shrink_enter in ext4_es_count()
> > because it is also used in ext4_es_scan() and we don't identify
> > them from the result.
>   Umm, I think you can use a generic 'function trace' infrastructure to
> trace entry & exit into arbitrary functions in kernel. So there shouldn't
> be a need to introduce extra entry & exit tracepoints.

Ah, thanks for reminding me.  Yes, 'function trace' is extreme useful!

                                                - Zheng

> 
> 								Honza
> 
> > Cc: "Theodore Ts'o" <tytso@mit.edu>
> > Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/extents_status.c    |   15 ++++++++------
> >  include/trace/events/ext4.h |   46 ++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 50 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> > index 3981ff7..e842d74 100644
> > --- a/fs/ext4/extents_status.c
> > +++ b/fs/ext4/extents_status.c
> > @@ -660,7 +660,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
> >  	newes.es_len = len;
> >  	ext4_es_store_pblock(&newes, pblk);
> >  	ext4_es_store_status(&newes, status);
> > -	trace_ext4_es_insert_extent(inode, &newes);
> > +	trace_ext4_es_insert_extent_enter(inode, &newes);
> >  
> >  	ext4_es_insert_extent_check(inode, &newes);
> >  
> > @@ -678,6 +678,7 @@ retry:
> >  
> >  error:
> >  	write_unlock(&EXT4_I(inode)->i_es_lock);
> > +	trace_ext4_es_insert_extent_exit(inode, &newes);
> >  
> >  	ext4_es_print_tree(inode);
> >  
> > @@ -701,7 +702,7 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
> >  	newes.es_len = len;
> >  	ext4_es_store_pblock(&newes, pblk);
> >  	ext4_es_store_status(&newes, status);
> > -	trace_ext4_es_cache_extent(inode, &newes);
> > +	trace_ext4_es_cache_extent_enter(inode, &newes);
> >  
> >  	if (!len)
> >  		return;
> > @@ -714,6 +715,7 @@ void ext4_es_cache_extent(struct inode *inode, ext4_lblk_t lblk,
> >  	if (!es || es->es_lblk > end)
> >  		__es_insert_extent(inode, &newes);
> >  	write_unlock(&EXT4_I(inode)->i_es_lock);
> > +	trace_ext4_es_cache_extent_exit(inode, &newes);
> >  }
> >  
> >  /*
> > @@ -887,7 +889,7 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
> >  	ext4_lblk_t end;
> >  	int err = 0;
> >  
> > -	trace_ext4_es_remove_extent(inode, lblk, len);
> > +	trace_ext4_es_remove_extent_enter(inode, lblk, len);
> >  	es_debug("remove [%u/%u) from extent status tree of inode %lu\n",
> >  		 lblk, len, inode->i_ino);
> >  
> > @@ -901,6 +903,7 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
> >  	err = __es_remove_extent(inode, lblk, end);
> >  	write_unlock(&EXT4_I(inode)->i_es_lock);
> >  	ext4_es_print_tree(inode);
> > +	trace_ext4_es_remove_extent_exit(inode, lblk, len);
> >  	return err;
> >  }
> >  
> > @@ -1017,7 +1020,7 @@ static unsigned long ext4_es_count(struct shrinker *shrink,
> >  
> >  	sbi = container_of(shrink, struct ext4_sb_info, s_es_shrinker);
> >  	nr = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> > -	trace_ext4_es_shrink_enter(sbi->s_sb, sc->nr_to_scan, nr);
> > +	trace_ext4_es_shrink_count(sbi->s_sb, sc->nr_to_scan, nr);
> >  	return nr;
> >  }
> >  
> > @@ -1030,14 +1033,14 @@ static unsigned long ext4_es_scan(struct shrinker *shrink,
> >  	int ret, nr_shrunk;
> >  
> >  	ret = percpu_counter_read_positive(&sbi->s_extent_cache_cnt);
> > -	trace_ext4_es_shrink_enter(sbi->s_sb, nr_to_scan, ret);
> > +	trace_ext4_es_shrink_scan_enter(sbi->s_sb, nr_to_scan, ret);
> >  
> >  	if (!nr_to_scan)
> >  		return ret;
> >  
> >  	nr_shrunk = __ext4_es_shrink(sbi, nr_to_scan, NULL);
> >  
> > -	trace_ext4_es_shrink_exit(sbi->s_sb, nr_shrunk, ret);
> > +	trace_ext4_es_shrink_scan_exit(sbi->s_sb, nr_shrunk, ret);
> >  	return nr_shrunk;
> >  }
> >  
> > diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
> > index 197d312..8b3ff82 100644
> > --- a/include/trace/events/ext4.h
> > +++ b/include/trace/events/ext4.h
> > @@ -2221,19 +2221,31 @@ DECLARE_EVENT_CLASS(ext4__es_extent,
> >  		  __entry->pblk, show_extent_status(__entry->status))
> >  );
> >  
> > -DEFINE_EVENT(ext4__es_extent, ext4_es_insert_extent,
> > +DEFINE_EVENT(ext4__es_extent, ext4_es_insert_extent_enter,
> >  	TP_PROTO(struct inode *inode, struct extent_status *es),
> >  
> >  	TP_ARGS(inode, es)
> >  );
> >  
> > -DEFINE_EVENT(ext4__es_extent, ext4_es_cache_extent,
> > +DEFINE_EVENT(ext4__es_extent, ext4_es_insert_extent_exit,
> >  	TP_PROTO(struct inode *inode, struct extent_status *es),
> >  
> >  	TP_ARGS(inode, es)
> >  );
> >  
> > -TRACE_EVENT(ext4_es_remove_extent,
> > +DEFINE_EVENT(ext4__es_extent, ext4_es_cache_extent_enter,
> > +	TP_PROTO(struct inode *inode, struct extent_status *es),
> > +
> > +	TP_ARGS(inode, es)
> > +);
> > +
> > +DEFINE_EVENT(ext4__es_extent, ext4_es_cache_extent_exit,
> > +	TP_PROTO(struct inode *inode, struct extent_status *es),
> > +
> > +	TP_ARGS(inode, es)
> > +);
> > +
> > +DECLARE_EVENT_CLASS(ext4__es_remove_extent,
> >  	TP_PROTO(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len),
> >  
> >  	TP_ARGS(inode, lblk, len),
> > @@ -2258,6 +2270,18 @@ TRACE_EVENT(ext4_es_remove_extent,
> >  		  __entry->lblk, __entry->len)
> >  );
> >  
> > +DEFINE_EVENT(ext4__es_remove_extent, ext4_es_remove_extent_enter,
> > +	TP_PROTO(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len),
> > +
> > +	TP_ARGS(inode, lblk, len)
> > +);
> > +
> > +DEFINE_EVENT(ext4__es_remove_extent, ext4_es_remove_extent_exit,
> > +	TP_PROTO(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len),
> > +
> > +	TP_ARGS(inode, lblk, len)
> > +);
> > +
> >  TRACE_EVENT(ext4_es_find_delayed_extent_range_enter,
> >  	TP_PROTO(struct inode *inode, ext4_lblk_t lblk),
> >  
> > @@ -2366,7 +2390,7 @@ TRACE_EVENT(ext4_es_lookup_extent_exit,
> >  		  show_extent_status(__entry->found ? __entry->status : 0))
> >  );
> >  
> > -TRACE_EVENT(ext4_es_shrink_enter,
> > +DECLARE_EVENT_CLASS(ext4__es_shrink_enter,
> >  	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
> >  
> >  	TP_ARGS(sb, nr_to_scan, cache_cnt),
> > @@ -2388,7 +2412,19 @@ TRACE_EVENT(ext4_es_shrink_enter,
> >  		  __entry->nr_to_scan, __entry->cache_cnt)
> >  );
> >  
> > -TRACE_EVENT(ext4_es_shrink_exit,
> > +DEFINE_EVENT(ext4__es_shrink_enter, ext4_es_shrink_count,
> > +	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
> > +
> > +	TP_ARGS(sb, nr_to_scan, cache_cnt)
> > +);
> > +
> > +DEFINE_EVENT(ext4__es_shrink_enter, ext4_es_shrink_scan_enter,
> > +	TP_PROTO(struct super_block *sb, int nr_to_scan, int cache_cnt),
> > +
> > +	TP_ARGS(sb, nr_to_scan, cache_cnt)
> > +);
> > +
> > +TRACE_EVENT(ext4_es_shrink_scan_exit,
> >  	TP_PROTO(struct super_block *sb, int shrunk_nr, int cache_cnt),
> >  
> >  	TP_ARGS(sb, shrunk_nr, cache_cnt),
> > -- 
> > 1.7.9.7
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
