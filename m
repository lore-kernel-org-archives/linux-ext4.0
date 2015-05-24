From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: resize2fs minimum size wrong
Date: Sat, 23 May 2015 21:34:31 -0400
Message-ID: <20150524013431.GB3270@thunk.org>
References: <5560EEB1.8070003@ubuntu.com>
 <20150523233603.GA3270@thunk.org>
 <55611B06.3040608@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54853 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbbEXBeh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 May 2015 21:34:37 -0400
Content-Disposition: inline
In-Reply-To: <55611B06.3040608@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 23, 2015 at 08:27:50PM -0400, Phillip Susi wrote:
> 
> On 05/23/2015 07:36 PM, Theodore Ts'o wrote:
> > Figuring out the minimum size in a way where we don't screw up and 
> > pick a number too _low_ is tricky, because if resize2fs aborts in
> > the middle, we can end up with a corrupted file system.
> 
> Why is it hard?  Why isn't it simply the number of used blocks, or the
> highest fixed metadata block, whichever is higher?

The amount of space needed for metadata blocks change depending on how
many block groups you have, and as you shrink the block groups, the
amount of space you need the metadata blocks shrink.  You might also
need some of the extra block groups to make sure you have enough
inodes for all of the inodes in the system.

Also, we can't necessarily use all of the space right away; for
example, the inode table for block group #25 lives in block group #16.
If we are shrinking the file system such that block groups #20 through
#25 will no longer be present, we can't use the inode space for those
block groups until *after* the resize has completed successfully,
since we can only free up those blocks after we have made sure we have
evacuated all of the inodes to other parts of the inode table.

> > I'm going to guess the problem has to do with the reserved space 
> > needed so that resize works correctly, and the amount of reserved
> 
> Reserved for what?

Reserved for additional block group descriptors when we are growing
the file system.

					- Ted
