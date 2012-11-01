From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: fix metadata checksum calculation for the superblock
Date: Thu, 1 Nov 2012 00:18:18 -0700
Message-ID: <20121101071818.GG19576@blackbox.djwong.org>
References: <20121101064942.GF19576@blackbox.djwong.org>
 <20121101070731.21349.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tm@tao.ma, tytso@mit.edu
To: George Spelvin <linux@horizon.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16955 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab2KAHSY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Nov 2012 03:18:24 -0400
Content-Disposition: inline
In-Reply-To: <20121101070731.21349.qmail@science.horizon.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 01, 2012 at 03:07:31AM -0400, George Spelvin wrote:
> > Yes, it would be useful to know what's going on with this directory file,
> > since it seems to fallback to linear scan, yet e2fsck -D doesn't fix it.
> > What I was /going/ for was that the kernel would notice a bad directory
> > and flag it for fsck on reboot.  Upon reboot, fsck would be run, notice
> > the bad dir, and feed it to the directory rebuilder to get it fixed
> > for good.  However, there doesn't seem to be any real checksum mismatch,
> > so the rebuild doesn't happen.
> 
> That's what confuses me.  I had already run e2fsck -D (which I assume
> rebuilds all directories, even if unnecessary) before observing the
> problem.  The other odd clue is that it's always nfsd that chokes;
> other accesses to the directory (ls -U, ls -lU, grep -r) don't produce
> the message.

Oh, so ... it's just nfsd that causes the linear fallback?  Regular (i.e.
non-nfs) users can see everything in the dir, no error messages?

Now *that* is odd. :)

You know, I was starting to wonder what on earth would even cause the fallback
in the first place.  It even looked like most of the "your dir is corrupt"
exits from that function would spit out an error or be somehow obviously
broken.

> > Also ... refresh my memory -- some files have disappeared as a result of this
> > happening?
> 
> I haven't observed it, no.  But the nature of the symptoms suggests it
> might be happening.

Hum.  When linear scan happens on a hashed dir, it's scanning the same blocks
that the hash scan sees.   The htree block looks like a regular directory block
with one huge "unused" dirent that wraps all the htree data.  So, the linear
scan should find the exact same files as a htree scan would.  If it doesn't,
something's wrong.  But you say it isn't, so I imagine it's fine.

<shrug> Another thing for me to ponder tomorrow. :)

--D
