From: Jan Kara <jack@suse.cz>
Subject: Re: Journal under-reservation bug on first >2G file
Date: Thu, 2 Oct 2014 13:26:45 +0200
Message-ID: <20141002112645.GD19748@quack.suse.cz>
References: <542B1C38.9010409@redhat.com>
 <542B1EFC.4050500@redhat.com>
 <C355A8E9-1799-43AB-9F57-4EFE1BBE3767@dilger.ca>
 <20141001115320.GA2903@thunk.org>
 <542C1314.3030603@redhat.com>
 <20141001195954.GD2903@thunk.org>
 <542C65FD.5040405@redhat.com>
 <20141001224325.GE2903@thunk.org>
 <542CE755.9040503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaJBL0s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Oct 2014 07:26:48 -0400
Content-Disposition: inline
In-Reply-To: <542CE755.9040503@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 02-10-14 00:49:09, Eric Sandeen wrote:
> On 10/1/14 5:43 PM, Theodore Ts'o wrote:
> > On Wed, Oct 01, 2014 at 03:37:17PM -0500, Eric Sandeen wrote:
> >>
> >> Ok.  I guess this is only an issue for ext4 - well, at least this specific
> >> issue.  Delalloc makes it much different than ext2 & ext3, which reserve quite a
> >> lot more.  Whether there's a corner case over there which breaks, I dunno...
> >>
> >> So it seems like the simplest test is simply: Are we RW mounted with delalloc?
> >> And if so, update the feature.  Seems simpler than mucking with "which features
> >> are unique to ext4"
> > 
> > I'd do "are we RW mounted with the extents feature".  That way we
> > don't need to worry about someone accidentally mounting a partition
> > meant for Hurd using ext4, which would imply delalloc, and then
> > causing Hurd to no longer be able to deal with the file system.  That
> > *shouldn't* happen, but if someone accidentally mounts the file system
> > with -t ext4, but it seems safer to gate it on the existence of the
> > extents feature.
> 
> Problem is, we can hit the same problem with an ext3 filesystem (no
> extents) mounted with -t ext4 (enabling delalloc).
> 
> Ugh.  Can't we just bump the da write reservation to 2 and be done with it? ;)
> (AFAICT the non-delalloc reservations can be wildly overestimated).
> 
> Or maybe ext4_journal_extend() when we try to update the superblock?
> It could fail, but it wouldn't be catastrophic if it did, fsck would find
> that the feature is missing...
  A couple of notes:
1) Using 2 would be fine. Journal code is clever enough and it returns
unused handle credits to the transaction so using 2 instead of 1 limits
only the number of handles in ext4_da_write_begin() running in parallel.
So I'd frankly just bump the number to 2 (with a comment!) and be done with
it.

2) If we want to optimize a bit, we can check whether the write is going to
extend beyond 2G and first set the feature in a separate transaction.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
