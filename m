From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 7/7 v2] ext4: reclaim extents from extent status tree
Date: Mon, 21 Jan 2013 15:24:43 +0800
Message-ID: <20130121072443.GA24053@gmail.com>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-8-git-send-email-wenqing.lz@taobao.com>
 <20130118051921.GC13785@thunk.org>
 <20130118053947.GD13785@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55570 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3AUHKr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2013 02:10:47 -0500
Received: by mail-pa0-f50.google.com with SMTP id hz10so3233631pad.9
        for <linux-ext4@vger.kernel.org>; Sun, 20 Jan 2013 23:10:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130118053947.GD13785@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 18, 2013 at 12:39:47AM -0500, Theodore Ts'o wrote:
> On Fri, Jan 18, 2013 at 12:19:21AM -0500, Theodore Ts'o wrote:
> > I'm a bit concerned we might be too aggressive,
> > because there are two ways that items can be freed from the
> > extent_status tree.  One is if the inode is not used at all, and when
> > we release the inode, we'll drop all of the entries in the
> > extent_status_tree for that inode.  The second way is via the shrinker
> > which we've registered.
> 
> If we use the sb->s_op->free_cached_objects() approach, something like
> the following change to prune_super() in fs/super.c might address the
> above concern:

Sorry for delay reply.  I believe that sb->s_op->free_cached_objbects()
approach is better.  So in next version I will try to implement this approach.

> 
> diff --git a/fs/super.c b/fs/super.c
> index 12f1237..fb57bd2 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -80,6 +80,7 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
>  	if (sc->nr_to_scan) {
>  		int	dentries;
>  		int	inodes;
> +		int	fs_to_scan = 0;
>  
>  		/* proportion the scan between the caches */
>  		dentries = (sc->nr_to_scan * sb->s_nr_dentry_unused) /
> @@ -87,7 +88,7 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
>  		inodes = (sc->nr_to_scan * sb->s_nr_inodes_unused) /
>  							total_objects;
>  		if (fs_objects)
> -			fs_objects = (sc->nr_to_scan * fs_objects) /
> +			fs_to_scan = (sc->nr_to_scan * fs_objects) /
>  							total_objects;
>  		/*
>  		 * prune the dcache first as the icache is pinned by it, then
> @@ -96,8 +97,23 @@ static int prune_super(struct shrinker *shrink, struct shrink_control *sc)
>  		prune_dcache_sb(sb, dentries);
>  		prune_icache_sb(sb, inodes);
>  
> -		if (fs_objects && sb->s_op->free_cached_objects) {
> -			sb->s_op->free_cached_objects(sb, fs_objects);
> +		/*
> +		 * If as a result of pruning the icache, we released some
> +		 * of the fs_objects, give credit to the fact and
> +		 * reduce the number of fs objects that we should try
> +		 * to release.
> +		 */
> +		if (fs_to_scan) {
> +			int fs_objects_now = sb->s_op->nr_cached_objects(sb);
> +
> +			if (fs_objects_now < fs_objects)
> +				fs_to_scan -= fs_objects - fs_objects_now;
> +			if (fs_to_scan < 0)
> +				fs_to_scan = 0;
> +		}
> +
> +		if (fs_to_scan && sb->s_op->free_cached_objects) {
> +			sb->s_op->free_cached_objects(sb, fs_to_scan);
>  			fs_objects = sb->s_op->nr_cached_objects(sb);
>  		}
>  		total_objects = sb->s_nr_dentry_unused +
> 
> What do folks think?

Do we need to CC' linux-fsdevel mailling list to let other folks review
this patch?

Thanks,
                                                - Zheng
