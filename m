From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: guarantee already started handles to successfully
 finish while ro remounting
Date: Fri, 6 May 2016 09:00:34 -0400
Message-ID: <20160506130034.GE31860@thunk.org>
References: <593570881.453531462514471895.JavaMail.weblogic@ep2mlwas08c>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	=?utf-8?B?7J206riw7YOc?= <kitae87.lee@samsung.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53802 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506AbcEFNAk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 May 2016 09:00:40 -0400
Content-Disposition: inline
In-Reply-To: <593570881.453531462514471895.JavaMail.weblogic@ep2mlwas08c>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 06, 2016 at 06:01:11AM +0000, Daeho Jeong wrote:
> > Hmm, I'm not really comfortable with putting this hack in, since this
> > is papering over the real problem, which is that Android is trying to
> > use the emergency remount read-only sysrq option and this is
> > fundamentally unsafe.  I'm not sure what else could break if it is
> > situation normal that there is active processes busily writing to the
> > file system and sysrq-u followed by reboot is the normal way the
> > Android kernel does a reboot.
> 
> > A much better solution would be to change the Android userspace to
> > call the FIFREEZE ioctl on each mounted file system, and then call for
> > a reboot.
> 
> I agree with you. I know that current Android shutdown procedure is
> not a safe way. But, without this patch, "even not in Android system",
> when we trigger the emergency read-only remount while evicting inodes,
> i_size of the inode becomes zero and the inode is not in orphan list,
> but blocks of the inode are still allocated to the inode, because
> ext4_truncate() will fail while stating the handle which was already started
> by ext4_evict_inode(). This causes the filesystem inconsistency and
> we will encounter an ext4 kernel panic in the next boot by this problem.
> 
> I think that this kind of filesystem crash can occur anywhere that
> the same journal handle is repeatly used. During an atomic filesystem
> operation, a part of the operation will succeed and the other one will fail.

Sure, but if this were a bug, then it could happen under a normal
crash scenario.  In this particular case, under what circumstances
could i_size be set to zero *and* the inode is not on the orphan list
*and* ext4_evict_inode() is getting called?

If that could happen, then we could have problems without emergency
unmount, and we should fix that problem.

The real problem here is that we want emergency unmount to be
completely safe, butting MS_RDONLY randomly isn't safe against file
system corruption.  The idea is you do this only when you have no
other choice, and the consequences would be worse --- and where you
would be prepared to do a file system consistency check afterwards.

We can either fix Android userspace, or we could add a per-file system
callback which tries (as much as possible) to make an emergency
unmount safe.  In this particular case, it would probably involve
setting the "file system is corrupt flag" to force a file system
consistency check at the next reboot.  Because if you use emergency
unmount, all bets are off, and there may be other problems....

	     	      	       	     	 - Ted
