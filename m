From: tytso@mit.edu
Subject: Re: [Jfs-discussion] benchmark results
Date: Fri, 25 Dec 2009 11:33:41 -0500
Message-ID: <20091225163341.GE32757__23960.8821728782$1261758852$gmane$org@thunk.org>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
 <19251.26403.762180.228181@tree.ty.sabi.co.uk>
 <20091224212756.GM21594@thunk.org>
 <alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
 <20091225161453.GD32757@thunk.org>
 <20091225162238.GB19303@bitmover.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Larry McVoy <lm@bitmover.com>,
	Christian Kujau <lists@nerdbynature.de>,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	xfs@oss.sgi.com, reiserfs-devel@vger.kernel.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53226 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZLYQd6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Dec 2009 11:33:58 -0500
Content-Disposition: inline
In-Reply-To: <20091225162238.GB19303@bitmover.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 25, 2009 at 08:22:38AM -0800, Larry McVoy wrote:
> 
> Dudes, sync() doesn't flush the fs cache, you have to unmount for that.
> Once upon a time Linux had an ioctl() to flush the fs buffers, I used
> it in lmbench.  
> 
> 	ioctl(fd, BLKFLSBUF, 0);
> 
> No idea if that is still supported, but sync() is a joke for benchmarking.

Depends on what you are trying to do (flush has multiple meanings, so
using can be ambiguous).  BLKFLSBUF will write out any dirty buffers,
*and* empty the buffer cache.  I use it when benchmarking e2fsck
optimization.  It doesn't do anything for the page cache.  If you are
measuring the time to write a file, using fsync() or sync() will
include the time to actually write the data to disk.  It won't empty
caches, though; if you are going to measure read as well as writes,
then you'll probably want to do something like "echo 3 >
/proc/sys/vm/drop-caches".

						- Ted
