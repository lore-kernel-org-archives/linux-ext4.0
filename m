From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Emergency remount readonly and EFBIG errors when unlinking files
 on 3.18 android kernel
Date: Tue, 26 Apr 2016 23:07:36 -0400
Message-ID: <20160427030736.GB30021@thunk.org>
References: <571FE6DB.8030604@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Nikhilesh Reddy <reddyn@codeaurora.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45634 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbcD0DHj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 Apr 2016 23:07:39 -0400
Content-Disposition: inline
In-Reply-To: <571FE6DB.8030604@codeaurora.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 26, 2016 at 03:08:27PM -0700, Nikhilesh Reddy wrote:
> As you know Android uses emergency remount instead of doing something like
> "umount -a" in its shutdown/reboot path.

No, I didn't know that.  (And I wish I didn't.  Yelch, what an ugly
hack.)

> Teh issue doesnt happen all the writer processes are killed before the
> emergency remount

Is there a missing "if", as in "if all the writer processes".... ?

Note that an emergency remount is very much an emergency.  So we don't
do a graceful shutdown of any pending writes.  (Normally we would
return EBUSY if there anything that would prevent a clean remount.)
In the emergency remount path, we bypass all of these checks.

> And on disk we see that one of the files being written to has incorrect
> ext4_inode->i_blocks_lo ( which is less than the the size of the file by
> something like 2k)
> 
> When unlinking this file the vfs inode->iblocks underflows and we end up
> with EFBIG if EXT4_FEATURE_RO_COMPAT_HUGE_FILE is not enabled in the
> superblock.
> 
> Is this a known issue?

No, this isn't a known issue.  I've never seen anything like this, but
all of the tests we do assume a forced poweroff, which we simulate
using dm-flakey.  We do *not* test the blunt-force-trauma which is
inflected on the file system structures which results from doing an
emergency remount.

Off by 2k really doesn't make sense.  I could see if it was off by 4k,
but 2k is really wierd.

> I would appreciate if you could point me in the right direction and any help
> you can give me.

Well, what I'd do is create a new ioctl interface which simulates an
emergency ro on just the one device, and try to create a reliable
repro.  Eventually we'll want to add some tests for this in xfstests.

		   	      	     	  - Ted
					  
