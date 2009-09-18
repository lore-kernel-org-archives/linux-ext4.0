From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH, RFC] mke2fs: get device topology values from blkid
Date: Fri, 18 Sep 2009 12:43:10 -0400
Message-ID: <20090918164310.GD26991@mit.edu>
References: <4AB2B6B9.7010506@redhat.com> <20090918055547.GO2537@webber.adilger.int> <4AB39375.6040506@redhat.com> <20090918142024.GU2537@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45674 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZIRQnM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Sep 2009 12:43:12 -0400
Content-Disposition: inline
In-Reply-To: <20090918142024.GU2537@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 18, 2009 at 08:20:24AM -0600, Andreas Dilger wrote:
> On Sep 18, 2009  09:04 -0500, Eric Sandeen wrote:
> > Andreas Dilger wrote:
> >>> +	rc = blkid_probe_set_device(pr, fd, 0, 0);
> >>
> >> Is this in the e2fsprogs blkid code yet?  I'm guessing not, since you
> >
> > right, not yet.  I don't know what the long-term plan is for e2fsprogs  
> > blkid; keeping 2 trees in sync seems like a lot of work w/o much gain...
> 
> I thought that was Ted's plan?  We usually recommend people to update to
> the latest e2fsprogs, yet not everyone will be able to upgrade to the
> latest util-linux, especially if it is pulling in other libraries that
> can cause package conflicts (e.g. with xfstools or similar).

I wasn't planning on keeping the blkid in e2fsprogs in sync with
util-linux-ng; however, I did want to allow people who wanted to
recompile the latest version of e2fsprogs (to pick up critical bug
fixes, for example) on existing distributions (you know, for those
silly Enterprise Linux Distro customers running RHEL 5 or SLES 11 that
pay some of our collective salaries :-) to be able to do so.

If there is an issue that not all versions of util-linux-ng have the
topology calls available, we'll need some autoconf magic, of course
--- especially if some community distro's have shipped or will have
shipped versions of util-linux-ng w/o the topology functions.

I don't particularly much care about screwing over a Linux From
Scratch or Gentoo user who refuses to upgrade.  I care a tiny bit more
about supporting a community distro (it's nice if we can support a
given Community distro for at least a 12 months or so before we start
making life difficult for them).  But to make life easier for
Enterprise Linux users, and the Level 3 help desk people at IBM,
Novell, and Red Hat who might need the latest version of e2fsprogs to
fix some customer's file system corruption problem, we should provide
an easy way for them to download and update that customer to the
latest version of e2fsprogs.  The simplest way to do that is to stub
out the new blkid topology functions has null inline functions in
blkid.h.

Does that make sense to everyone?

						- Ted
