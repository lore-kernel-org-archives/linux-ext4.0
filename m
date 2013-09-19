From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 61631] kernel BUG at fs/ext4/super.c:818 umounting md raid6
 volume
Date: Thu, 19 Sep 2013 14:58:01 -0400
Message-ID: <20130919185801.GA5677@thunk.org>
References: <bug-61631-13602@https.bugzilla.kernel.org/>
 <bug-61631-13602-QH4wnakS4K@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jfaulkne@ccs.neu.edu
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:34518 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3ISS6F (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Sep 2013 14:58:05 -0400
Content-Disposition: inline
In-Reply-To: <bug-61631-13602-QH4wnakS4K@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 18, 2013 at 10:27:02PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> FYI, this bug only appears after some period of usage.  After a reboot, I can
> umount without error.  After a reboot and an rsync of the gentoo portage tree
> to the filesystem, I can still umount without error.  It seems the filesystem
> only fails to unmount after the filesystem has been in use for a while. 
> However, it is quite consistent in failing to umount after several days of
> usage.

Hmm, can you say a bit more about what sort of files you store on the
file system and how the file system gets used?  What looks like is
going on is that there is a whole series of inodes that have been left
stalled on the orpaned inode list.  By the time we reach that point in
the unmount, the in-memory orphan list should have been cleared.

So here are a couple of things that would be really useful to try.

First of all, if you could try to reproduce the crash, and then before
you do the umount, run "dumpe2fs -h /dev/md1 > ~/dumpe2fs.md1.save;
sync".  Then if the system crashes with the same BUG_ON, send us the
dumpe2fs.md1.save, along with the console output.

The thing which I am trying to determine is whether the on-disk
orphaned inode list is set at the time of the umount.  If it is set,
it would be interesting if you could run sync, wait for things to
settle, check to see if dumpe2fs shows that the orphaned list is
empty, and then see if you can trigger the crash.

The other thing that would be useful is to grab one of the inodes
listed in the console, i.e.:

[642473.269223]   inode md1:20289506 at ffff88000499aed0: mode 100644, nlink 0, next 20367069

... and then run the command: "debugfs -R 'stat <20289506>' /dev/md1"

What I am interested in is the inode's atime/ctime/dtime.  It would be
interesting to see if the file was deleted right before the umount was
attempted.

Thanks for the bug report!  Hopefully we'll be able to figure out why
you are seeing this.

Cheers,

					- Ted
