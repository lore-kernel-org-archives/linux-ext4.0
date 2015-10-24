From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: JBD2 stuck, causing fsck to not run.
Date: Sat, 24 Oct 2015 01:49:58 -0400
Message-ID: <20151024054958.GQ7917@thunk.org>
References: <56161056.1000605@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	SiteGround Operations <operations@siteground.com>,
	Marian Marinov <mm@1h.com>
To: Nikolay Borisov <kernel@kyup.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41855 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbbJXKvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Oct 2015 06:51:42 -0400
Content-Disposition: inline
In-Reply-To: <56161056.1000605@kyup.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 08, 2015 at 09:42:30AM +0300, Nikolay Borisov wrote:
> Hello,
> 
> Yesterday I wanted to run fsck on an ext4 volume. However, fsck was
> saying that the volume was still in use and was aborting. After some
> debugging turned out it was failing in the bd_may_claim() . Further
> investigation revealed that the JBD2 thread for this particular volume
> was stuck with the following trace:
> 
> PID: 14508 TASK: ffff8802c3b8bd80 CPU: 11 COMMAND: "jbd2/dm-11-8"
> #0 [ffff8805d1aefdc0] __schedule at ffffffff815ac3be
> #1 [ffff8805d1aefe10] schedule at ffffffff815ac9ce
> #2 [ffff8805d1aefe30] kjournald2 at ffffffff8127a5ae
> #3 [ffff8805d1aefec0] kthread at ffffffff81073fce
> #4 [ffff8805d1aeff50] ret_from_fork at ffffffff815b0fe2
> 
> This seems pretty normal to me except that at some point ext4_put_super
> should have called jbd2_journal_destroy, which in turn should set the
> JBD2_UNMOUNT flag and wakeup the jbd thread so that it can exit
> gracefully, apparently this hadn't happened. The volume where the
> filesystem was created is an LVM thin volume if it matters.
> 
> I wonder whether it's possible due to corruption that ext4 got confused
> that it's not being journalled and as such skipped part responsible for
> shutting down JBD2? So far this has happened numerous times on a variety
> of kernel - from 3.12.28 to 4.1.6 (which was the most recent as of
> yesterday). Any ideas when this problem manifests again how to debug it
> further?

Sorry, I didn't see this until now.

What I'd suggest in terms of debugging this is to look at the syslog
files.  If there was any kind of corruption problem, ext4 is quite
verbose, and you should see evidence of the problem in the kernel
messages.

I haven't seen anything this at all; but then again, I don't use LVM
thin volumes.  I wonder if this is triggered by some kind of thin
volume error (such as running out of space) which is cause an I/O
operation to the thin volume to never return, and this in turn is
causing the jbd2 thread to hang.  In that's the case, it would be a
dm-thin bug.

As an example of what you might see in the kernel messages:

generic/081 3s ...	[01:34:29][    7.623612] run fstests generic/081 at 2015-10-24 01:34:30
[    9.940253] device-mapper: snapshots: Snapshot overflowed: Unable to allocate exception.
[    9.942928] EXT4-fs warning (device dm-1): ext4_end_bio:329: I/O error -5 writing to inode 12 (offset 4194304 size 1048576 starting block 15345)
[    9.944618] Buffer I/O error on device dm-1, logical block 14337
[    9.945375] Buffer I/O error on device dm-1, logical block 14338
[    9.946146] Buffer I/O error on device dm-1, logical block 14339
[    9.946913] Buffer I/O error on device dm-1, logical block 14340
[    9.947724] Buffer I/O error on device dm-1, logical block 14341
[    9.948724] Buffer I/O error on device dm-1, logical block 14342
[    9.949475] Buffer I/O error on device dm-1, logical block 14343
[    9.950228] Buffer I/O error on device dm-1, logical block 14344
[    9.951020] Buffer I/O error on device dm-1, logical block 14345
[    9.951763] Buffer I/O error on device dm-1, logical block 14346
[   10.119280] EXT4-fs warning (device dm-1): ext4_end_bio:329: I/O error -5 writing to inode 12 (offset 2097152 size 2097152 starting block 14321)
[   10.141397] Buffer I/O error on dev dm-1, logical block 114689, lost sync page write
[   10.142311] JBD2: Error -5 detected when updating journal superblock for dm-1-8.
[   10.143286] Aborting journal on device dm-1-8.
[   10.143910] Buffer I/O error on dev dm-1, logical block 114689, lost sync page write
[   10.145125] JBD2: Error -5 detected when updating journal superblock for dm-1-8.
[   10.150526] Buffer I/O error on dev dm-1, logical block 1, lost sync page write
[   10.151999] EXT4-fs error (device dm-1): ext4_put_super:808: Couldn't clean up the journal
[   10.153600] EXT4-fs (dm-1): Remounting filesystem read-only
[   10.154768] EXT4-fs (dm-1): previous I/O error to superblock detected
[   10.156023] Buffer I/O error on dev dm-1, logical block 1, lost sync page write
 [01:34:33] 4s
Ran: generic/081
Passed all 1 tests

Note the verbosity in the kernel logs; if someting goes wrong, you'll
see complaints from the ext4, jbd2, buffer cache, and device-mapper
layers.  We reguarly do run tests that trigger a variety of errors,
such as a snapshot overflowing, ENOSPC errors, file system corruption,
etc. and I've never seen something like what you've reported where the
file system doesn't let go of the block device.  (This is one of the
reasons why I'd first turn my suspicions to something going wrong in
the dm-thin layer, since that is one thing that we aren't exercising
in our regression testing.)

Cheers,

					- Ted
