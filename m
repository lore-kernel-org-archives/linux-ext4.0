From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Thu, 18 Jul 2013 14:53:10 -0400
Message-ID: <20130718185310.GA17548@thunk.org>
References: <1373987883-4466-1-git-send-email-tytso@mit.edu>
 <51E8356C.9030603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39024 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134Ab3GRSxQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Jul 2013 14:53:16 -0400
Content-Disposition: inline
In-Reply-To: <51E8356C.9030603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 18, 2013 at 01:35:24PM -0500, Eric Sandeen wrote:
> > (Should we do this all the time, instead of when the application
> > explicitly requests it?  Maybe; there could be cases with very large,
> > fragmented files accessed by an application such as "file" is only needs
> > to look at a small subset of the file where this could result in an
> > unnecessary work and memory allocated.  OTOH, 95%+ of the time this
> > would probably be a win...)
> 
> I'd say yes, we should - maybe not in all cases but if you need it for
> AIO, try to make it "all the time" at least for that AIO?

The problem is we don't know that we're doing AIO until we see the
first io_submit(2) call.  With this patch series, we'll pull the
contents of the entire leaf tree block into extent cache, but if the
extent tree is larger than that, if we read in the entire extent tree
on the first AIO request, then that first request will delayed even
more, and it's not clear that's a good thing.

> We keep telling application writers not to assume certain things about
> various filesystems, or to write applications that treat ext4 differently 
> han ext3 differently than xfs etc...
> 
> This goes the other way.

That's true, but I couldn't figure out a way where we could make the
file system do it automatically all the time.

> Or what about tying this into POSIX_FADV_WILLNEED?  Hohum, that gets
> into force_page_cache_readahead().  We need POSIX_FADV_WILLNEED_META...

Maybe have fadvise(fd, POSIX_FADV_RANDOM), on the theory that a
program which cares enough to call the fadvise would probably want the
extent tree?  That's not really an exact match for the requisite
semantics, either, though.

In the long run, I suspect if this proves to be useful, adding a new
fadvise flag is what would make sense, I think.  Maybe
POSIX_FADV_WILLNEED_META.

I'd suggest using an ioctl for now, and if application writers find
this functionality useful, we could then add a more generic VFS
interface.  After all, initially punch was implemented only as an
XFS-specific ioctl, and after it was proven to be more generally
useful, we added a generic VFS interface only much later.

	   	   	       		 - Ted
