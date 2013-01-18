From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 7/7 v2] ext4: reclaim extents from extent status tree
Date: Fri, 18 Jan 2013 00:19:21 -0500
Message-ID: <20130118051921.GC13785@thunk.org>
References: <1357901627-3068-1-git-send-email-wenqing.lz@taobao.com>
 <1357901627-3068-8-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jan kara <jack@suse.cz>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44121 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab3ARFT2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 00:19:28 -0500
Content-Disposition: inline
In-Reply-To: <1357901627-3068-8-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2013 at 06:53:47PM +0800, Zheng Liu wrote:
> +
> +static int ext4_es_shrink(struct shrinker *shrink, struct shrink_control *sc)
> +{
> +	struct ext4_es_shrinker *es_shrinker = container_of(shrink,
> +				struct ext4_es_shrinker, es_shrinker);
> +	struct ext4_inode_info *ei;
> +	int nr_to_scan = sc->nr_to_scan;
> +	int ret, shrunk_nr = 0;
> +
> +	if (!nr_to_scan)
> +		return shrunk_nr;

This doesn't look right.  To quote from include/linux/shrinker.h:

/*
 * A callback you can register to apply pressure to ageable caches.
 *
 * 'sc' is passed shrink_control which includes a count 'nr_to_scan'
 * and a 'gfpmask'.  It should look through the least-recently-used
 * 'nr_to_scan' entries and attempt to free them up.  It should return
 * the number of objects which remain in the cache.  If it returns -1, it means
 * it cannot do any scanning at this time (eg. there is a risk of deadlock).
 *
 * ...
 *
 * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
 * querying the cache size, so a fastpath for that case is appropriate.
 */

The first thing the shrink_slab() function will do is call the
shrinker with nr_to_scan set to zero.  Since the shrinker function is
currently returning the number of items that were discarded, instead
of the number of objects that were deleted, when nr_to_scan is zero,
the function returns zero.  This will cause shrink_slab() to bail out,
which means the shrinker code isn't actually going to release any
objects.  (i.e., at the moment it is a no-op).

It might also be a good idea to add a trace point so we can debug what
is going on with the shrinker, so we can known when its called, and
how much progress it has made in releasing objcts when the system is
under memory pressure.


Also, one of the things that we need to think about is making sure we
have the right balance.  We don't want to be too aggressive in
shrinking the extent status tree cache, but we want to be a good
citizen as well.  I'm a bit concerned we might be too aggressive,
because there are two ways that items can be freed from the
extent_status tree.  One is if the inode is not used at all, and when
we release the inode, we'll drop all of the entries in the
extent_status_tree for that inode.  The second way is via the shrinker
which we've registered.

So I am a bit concerned that we may end up giving twice.  There's also
a place where we can register a fs-specific shrinker via
sb->s_op->nr_cached_objects() and sb->s_op->free_cached_objects().
That might be better since it will allow us to balance across file
systems a bit more fairly.

Anyway, we're going to have to do some testing to make sure we're
doing something sane in low memory situations.  Not doing any
shrinking is clearly bad, but I'm a bit worried that we could end up
doing too much shrinking, and our performance in memory constrained
scenarios might suffer as a result.

					- Ted
