From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: fallocate support for bitmap-based files
Date: Fri, 29 Jun 2007 17:46:15 -0400
Message-ID: <20070629214615.GB5026@schatzie.adilger.int>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org> <20070629205525.GD32178@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Waychison <mikew@google.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:41669 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbXF2VqR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 29 Jun 2007 17:46:17 -0400
Content-Disposition: inline
In-Reply-To: <20070629205525.GD32178@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 29, 2007  16:55 -0400, Theodore Tso wrote:
> What's the eventual goal of this work?  Would it be for mainline use,
> or just something that would be used internally at Google?  I'm not
> particularly ennthused about supporting two ways of doing fallocate();
> one for ext4 and one for bitmap-based files in ext2/3/4.  Is the
> benefit reallyworth it?
> 
> What I would suggest, which would make much easier, is to make this be
> an incompatible extensions (which you as you point out is needed for
> security reasons anyway) and then steal the high bit from the block
> number field to indicate whether or not the block has been initialized
> or not.  That way you don't end up having to seek to a potentially
> distant part of the disk to check out the bitmap.  Also, you don't
> have to worry about how to recover if the "block initialized bitmap"
> inode gets smashed.  
> 
> The downside is that it reduces the maximum size of the filesystem
> supported by ext2 by a factor of two.  But, there are at least two
> patch series floating about that promise to allow filesystem block
> sizes > than PAGE_SIZE which would allow you to recover the maximum
> size supported by the filesytem.

I don't think ext2 is safe for > 8TB filesystems anyways, so this
isn't a huge loss.

The other possibility is, assuming Google likes ext2 because they
don't care about e2fsck, is to patch ext4 to not use any
journaling (i.e. make all of the ext4_journal*() wrappers be
no-ops).  That way they would get extents, mballoc and other speedups.

That said, what is the reason for not using ext3?  Presumably performance
(which is greatly improved in ext4) or is there something else?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
