From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] mbcache2: Reimplement mbcache
Date: Wed, 16 Dec 2015 16:52:09 +0100
Message-ID: <20151216155209.GD16918@quack.suse.cz>
References: <1449683858-28936-1-git-send-email-jack@suse.cz>
 <1449683858-28936-2-git-send-email-jack@suse.cz>
 <CAHpGcMJ_gWOTt89E9RnxSY4-yhdU_OQ14Jb5gJvETzQ_NXvXmA@mail.gmail.com>
 <20151215110809.GA1899@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org, Laurent GUERBY <laurent@guerby.net>,
	Andreas Dilger <adilger@dilger.ca>
To: Andreas =?iso-8859-1?Q?Gr=FCnbacher?=
	<andreas.gruenbacher@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965747AbbLPPwM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Dec 2015 10:52:12 -0500
Content-Disposition: inline
In-Reply-To: <20151215110809.GA1899@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-12-15 12:08:09, Jan Kara wrote:
> > > +/*
> > > + * mb2_cache_entry_delete - delete entry from cache
> > > + * @cache - cache where the entry is
> > > + * @entry - entry to delete
> > > + *
> > > + * Delete entry from cache. The entry is unhashed and deleted from the lru list
> > > + * so it cannot be found. We also drop the reference to @entry caller gave us.
> > > + * However entry need not be freed if there's someone else still holding a
> > > + * reference to it. Freeing happens when the last reference is dropped.
> > > + */
> > > +void mb2_cache_entry_delete(struct mb2_cache *cache,
> > > +                           struct mb2_cache_entry *entry)
> > 
> > This function should become static; there are no external users.
> 
> It's actually completely unused. But if we end up removing entries for
> blocks where refcount hit maximum, then it will be used by the fs. Thinking
> about removal of entries with max refcount, the slight complication is that
> when refcount decreases again, we won't insert the entry in cache unless
> someone calls listattr or getattr for inode with that block. So we'll
> probably need some more complex logic to avoid this.
> 
> I'll first gather some statistics on the lengths of hash chains and hash
> chain scanning when there are few unique xattrs to see whether the
> complexity is worth it.

So I did some experiments with observing length of hash chains with lots of
same xattr blocks. Indeed hash chains get rather long in such case as you
expected - for F files having V different xattr blocks hash chain lenght is
around F/V/1024 as expected.

I've also implemented logic that removes entry from cache when the refcount
of xattr block reaches maximum and adds it back when refcount drops. But
this doesn't make hash chains significantly shorter because most of xattr
blocks end up close to max refcount but not quite at the maximum (as the
benchmark ends up adding & removing references to blocks mostly
randomly).

That made me realize that any strategy based solely on xattr block refcount
isn't going to significantly improve the situation. What we'd have to do is
something like making sure that we cache only one xattr block with given
contents. However that would make insertions more costly as we'd have to
compare full xattr blocks for duplicates instead of just hashes.

So overall I don't think optimizing this case is really worth it for now.
If we see some real world situation where this matters, we can reconsider
the decision.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
