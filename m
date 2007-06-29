From: Theodore Tso <tytso@mit.edu>
Subject: Re: fallocate support for bitmap-based files
Date: Fri, 29 Jun 2007 16:55:25 -0400
Message-ID: <20070629205525.GD32178@thunk.org>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@clusterfs.com>,
	Mike Waychison <mikew@google.com>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52980 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbXF2Uzf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 Jun 2007 16:55:35 -0400
Content-Disposition: inline
In-Reply-To: <20070629130120.ec0d1c75.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jun 29, 2007 at 01:01:20PM -0700, Andrew Morton wrote:
> 
> Guys, Mike and Sreenivasa at google are looking into implementing
> fallocate() on ext2.  Of course, any such implementation could and should
> also be portable to ext3 and ext4 bitmapped files.

What's the eventual goal of this work?  Would it be for mainline use,
or just something that would be used internally at Google?  I'm not
particularly ennthused about supporting two ways of doing fallocate();
one for ext4 and one for bitmap-based files in ext2/3/4.  Is the
benefit reallyworth it?

What I would suggest, which would make much easier, is to make this be
an incompatible extensions (which you as you point out is needed for
security reasons anyway) and then steal the high bit from the block
number field to indicate whether or not the block has been initialized
or not.  That way you don't end up having to seek to a potentially
distant part of the disk to check out the bitmap.  Also, you don't
have to worry about how to recover if the "block initialized bitmap"
inode gets smashed.  

The downside is that it reduces the maximum size of the filesystem
supported by ext2 by a factor of two.  But, there are at least two
patch series floating about that promise to allow filesystem block
sizes > than PAGE_SIZE which would allow you to recover the maximum
size supported by the filesytem.

Furthermore, I suspect (especially after listening to a very fasting
Usenix Invited Talk by Jeffery Dean, a fellow from Google two weeks
ago) that for many of Google's workloads, using a filesystem blocksize
of 16K or 32K might not be a bad thing in any case.

It would be a lot simpler....

						- Ted
