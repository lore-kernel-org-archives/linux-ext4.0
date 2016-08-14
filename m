From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: fix reference counting bug on block allocation error
Date: Sun, 14 Aug 2016 16:19:08 -0400
Message-ID: <20160814201908.GO10626@thunk.org>
References: <20160727052921.5B41C35574@git2.kroah.org>
 <20160814183206.GA11040@kroah.com>
 <57B0BA84.1000600@oracle.com>
 <20160814185125.GA4077@kroah.com>
 <20160814185805.GA8087@kroah.com>
 <57B0C058.9010800@oracle.com>
 <20160814190919.GA9517@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vegard Nossum <vegard.nossum@oracle.com>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54416 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbcHNUTk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Aug 2016 16:19:40 -0400
Content-Disposition: inline
In-Reply-To: <20160814190919.GA9517@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 14, 2016 at 09:09:19PM +0200, Greg KH wrote:
> Huh?  Ok, this odd:
> 	$ git describe --contains 8556e8f3b6
> 	fatal: cannot describe '8556e8f3b6c4c11601ce1e9ea8090a6d8bd5daae'
> 
> Yet just a plain 'git describe' does work...
> 
> That's what threw me off, I only use --contains as that shows the
> release the commit is in.
> 
> Ok, that makes me feel a bit better (that my scripts didn't miss the
> patch, it was just old), but I wonder what is going on with git...

Yeah, that's partially my fault.  Back in 2009, I was using a version
of guilt (quilt for git) that didn't enforce the requirement that
within a particular linear sequence of commits, the Committer time
must be always be increasing.  In other words, things like this are
never supposed to happen:

% git log --pretty="%h %ci %s"  -7 e8134b2
e8134b2 2009-01-05 21:38:26 -0500 ext4: Fix race between read_block_bitmap() and mark_diskspace_used()
5d1b1b3 2009-01-05 22:19:52 -0500 ext4: fix BUG when calling ext4_error with locked block group
b7be019 2008-11-23 23:51:53 -0500 ext4: Fix lockdep recursive locking warning
7a2fcbf 2009-01-05 21:36:55 -0500 ext4: don't use blocks freed but not yet committed in buddy cache init
fb68407 2008-11-06 17:50:21 -0500 jbd2: Call journal commit callback without holding j_list_lock
c3a326a 2008-11-25 15:11:52 -0500 ext4: cleanup mballoc header files
920313a 2009-01-05 21:36:19 -0500 ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during resize

... because it hopelessly confuses commands like "git describe".  As
you have rediscovered.  :-)

The guilt command was fixed a long time ago to not do this thing, but
the nasty commits from late 2008 and early 2009 are still in the tree.
Fortunately, it's rare that we need to refer to commits this old, and
so people don't run into this often.

						- Ted
