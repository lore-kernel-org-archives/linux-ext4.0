From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] ext4: make es shrinker handle nr_to_scan correctly (Re:
 [RFC PATCH 2/2] ext4: improve ...)
Date: Wed, 15 Jan 2014 11:02:32 +0800
Message-ID: <20140115030232.GA12899@gmail.com>
References: <1387536165-15956-1-git-send-email-wenqing.lz@taobao.com>
 <1387536165-15956-3-git-send-email-wenqing.lz@taobao.com>
 <20131223085419.GB9199@quack.suse.cz>
 <20131225033448.GC23505@gmail.com>
 <20131230210917.GD5457@quack.suse.cz>
 <20131231082015.GA24822@gmail.com>
 <20131231105912.GB11920@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38517 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOC6g (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jan 2014 21:58:36 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so496444pdj.22
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jan 2014 18:58:36 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131231105912.GB11920@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 31, 2013 at 11:59:12AM +0100, Jan Kara wrote:
[...]
> > Subject: [PATCH] ext4: make es shrinker handle nr_to_scan correctly
> > 
> > From: Zheng Liu <wenqing.lz@taobao.com>
> > 
> > Nr_to_scan means that the shrinker needs to traverse nr_to_scan objects
> > rather than reclaim nr_to_scan objects.  This commit makes es shrinker
> > handle it correctly.  But after this __ext4_es_shrink() couldn't
> > guarantee that it can reclaim objects.  Hence we need to enlarge value
> > from 1 to 128 in ext4_es_insert/remove_extent() to avoid returning
> > ENOMEM error.  Before we use a list to track all reclaimable objects,
> > there is a tradeoff between returning ENOMEM and discarding too many
> > objects from extent status tree.
>   But the way you've implemented this won't quite work - reclaim never asks
> a slab cache to scan large number of objects in one round - the maximum is
> 128. So if you have 128 unreclaimable objects at the beginning of your
> object list you would never reclaim anything - that is what I was speaking
> about in my original email. So you have to implement some 'cycling' of head
> pointer so that you can continue scanning when asked next time instead of
> staring over from the beginning of the list. This logic doesn't play well
> with the LRU approach we try to do in the extent cache. So I really see two
> viable approaches
> 
> 1) Trivial: Forget about LRU, just have a list of inodes with extents in
> extent cache. Shrinker will remember ino + offset pair it stopped scanning
> at and continues scanning the list of inodes from there (restarting the scan
> from the beginning if inode got reclaimed in the mean time).
> 
> 2) Complex: Keep the LRU algorithm and try to make it more CPU efficient.
> 
> Approach 1) can possibly reclaim extents which are still very useful. OTOH
> these extents will be loaded quickly back and then it should take full
> cycle over all other extents to get back to these and reclaim them again.
> So it needn't be too bad.

Sorry for the delay.  I have sent out two patches for adding some
statistics in extent status tree shrinker and doing some cleanups for
the tracepoint of the shrinker.  Thanks for your review.

As you have mentioned above, now we have two approaches for improving
the shrinker.  IMHO, I prefer the LRU list approach.  But I don't have
any number to prove it.  So my plan is that both of them will be
implemented.  Then we can measure the performance of them, and decide
one of them as a final solution.

Thanks,
                                                - Zheng

> 
> 								Honza
> 
> > Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> > ---
> >  fs/ext4/extents_status.c |   28 ++++++++++++++++------------
> >  1 file changed, 16 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
> > index eb7ae61..87795d1 100644
> > --- a/fs/ext4/extents_status.c
> > +++ b/fs/ext4/extents_status.c
> > @@ -146,7 +146,7 @@ static int __es_insert_extent(struct inode *inode, struct extent_status *newes);
> >  static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
> >  			      ext4_lblk_t end);
> >  static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
> > -				       int nr_to_scan);
> > +				       int *nr_to_scan);
> >  static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> >  			    struct ext4_inode_info *locked_ei);
> >  
> > @@ -670,7 +670,7 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
> >  		goto error;
> >  retry:
> >  	err = __es_insert_extent(inode, &newes);
> > -	if (err == -ENOMEM && __ext4_es_shrink(EXT4_SB(inode->i_sb), 1,
> > +	if (err == -ENOMEM && __ext4_es_shrink(EXT4_SB(inode->i_sb), 128,
> >  					       EXT4_I(inode)))
> >  		goto retry;
> >  	if (err == -ENOMEM && !ext4_es_is_delayed(&newes))
> > @@ -824,7 +824,7 @@ retry:
> >  				es->es_lblk = orig_es.es_lblk;
> >  				es->es_len = orig_es.es_len;
> >  				if ((err == -ENOMEM) &&
> > -				    __ext4_es_shrink(EXT4_SB(inode->i_sb), 1,
> > +				    __ext4_es_shrink(EXT4_SB(inode->i_sb), 128,
> >  						     EXT4_I(inode)))
> >  					goto retry;
> >  				goto out;
> > @@ -938,8 +938,6 @@ static int __ext4_es_shrink(struct ext4_sb_info *sbi, int nr_to_scan,
> >  
> >  retry:
> >  	list_for_each_safe(cur, tmp, &sbi->s_es_lru) {
> > -		int shrunk;
> > -
> >  		/*
> >  		 * If we have already reclaimed all extents from extent
> >  		 * status tree, just stop the loop immediately.
> > @@ -966,13 +964,11 @@ retry:
> >  			continue;
> >  
> >  		write_lock(&ei->i_es_lock);
> > -		shrunk = __es_try_to_reclaim_extents(ei, nr_to_scan);
> > +		nr_shrunk += __es_try_to_reclaim_extents(ei, &nr_to_scan);
> >  		if (ei->i_es_lru_nr == 0)
> >  			list_del_init(&ei->i_es_lru);
> >  		write_unlock(&ei->i_es_lock);
> >  
> > -		nr_shrunk += shrunk;
> > -		nr_to_scan -= shrunk;
> >  		if (nr_to_scan == 0)
> >  			break;
> >  	}
> > @@ -1003,8 +999,16 @@ retry:
> >  
> >  	spin_unlock(&sbi->s_es_lru_lock);
> >  
> > -	if (locked_ei && nr_shrunk == 0)
> > -		nr_shrunk = __es_try_to_reclaim_extents(locked_ei, nr_to_scan);
> > +	if (locked_ei && nr_shrunk == 0) {
> > +		/*
> > +		 * We try to reclaim objects from locked inode.  We don't
> > +		 * want to discard too many objects from this inode because
> > +		 * it might be accessed frequently.
> > +		 */
> > +		if (!nr_to_scan)
> > +			nr_to_scan = 8;
> > +		nr_shrunk = __es_try_to_reclaim_extents(locked_ei, &nr_to_scan);
> > +	}
> >  
> >  	return nr_shrunk;
> >  }
> > @@ -1085,7 +1089,7 @@ void ext4_es_lru_del(struct inode *inode)
> >  }
> >  
> >  static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
> > -				       int nr_to_scan)
> > +				       int *nr_to_scan)
> >  {
> >  	struct inode *inode = &ei->vfs_inode;
> >  	struct ext4_es_tree *tree = &ei->i_es_tree;
> > @@ -1114,7 +1118,7 @@ static int __es_try_to_reclaim_extents(struct ext4_inode_info *ei,
> >  			rb_erase(&es->rb_node, &tree->root);
> >  			ext4_es_free_extent(inode, es);
> >  			nr_shrunk++;
> > -			if (--nr_to_scan == 0)
> > +			if (--(*nr_to_scan) == 0)
> >  				break;
> >  		}
> >  	}
> > -- 
> > 1.7.9.7
> > 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
