From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/47] libext2fs: add a way to check the theoretical
 maximum extent tree depth
Date: Sun, 14 Dec 2014 22:38:45 -0800
Message-ID: <20141215063845.GB5368@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
 <20141107215212.883.11364.stgit@birch.djwong.org>
 <20141214022357.GC29787@thunk.org>
 <20141214031111.GB27255@birch.djwong.org>
 <20141215034822.GH17575@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30979 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaLOGiy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2014 01:38:54 -0500
Content-Disposition: inline
In-Reply-To: <20141215034822.GH17575@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Dec 14, 2014 at 10:48:22PM -0500, Theodore Ts'o wrote:
> On Sat, Dec 13, 2014 at 07:11:11PM -0800, Darrick J. Wong wrote:
> > > But if you look at the above code, there is nothing which is inode or
> > > handle specific.  The value is only dependent on fs->blocksize.  But
> > > to calculate this value the function calls ul_log2 three times, which
> > > is implemented using a looping construct.  So we will be recalculating
> > > what is effectively a constant value every single inode in an ext4
> > > file system, which seems very unfortunate.
> > 
> > How about I save the last fs->blocksize and the last result, and return the
> > cached last result if fs->blocksize == lastblocksize?
> 
> That sounds like a plan.  BTW, it looks like I had accidentally
> included this in the next branch, but adding a cache won't disturb the
> API, so that's fine.

Ok, I'll send the patch that adds the cache.

--D

> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
