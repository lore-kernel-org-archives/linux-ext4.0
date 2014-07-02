From: David Jander <david@protonic.nl>
Subject: Re: ext4: journal has aborted
Date: Wed, 2 Jul 2014 11:44:23 +0200
Message-ID: <20140702114423.132f27f9@archvile>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
	<20140701082619.1ac77f1d@archvile>
	<20140701084206.GG9743@birch.djwong.org>
	<53B2A47F.90903@samsung.com>
	<20140701155812.GD2775@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Matteo Croce <technoboy85@gmail.com>,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from protonic.xs4all.nl ([83.163.252.89]:1933 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaGBJoT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Jul 2014 05:44:19 -0400
In-Reply-To: <20140701155812.GD2775@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi Ted,

On Tue, 1 Jul 2014 11:58:12 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> On Tue, Jul 01, 2014 at 09:07:27PM +0900, Jaehoon Chung wrote:
> > Hi,
> > 
> > i have interesting for this problem..Because i also found the same problem..
> > Is it Journal problem?
> > 
> > I used the Linux version 3.16.0-rc3.
> > 
> > [    3.866449] EXT4-fs error (device mmcblk0p13): ext4_mb_generate_buddy:756: group 0, 20490 clusters in bitmap, 20488 in gd; block bitmap corrupt.
> > [    3.877937] Aborting journal on device mmcblk0p13-8.
> > [    3.885025] Kernel panic - not syncing: EXT4-fs (device mmcblk0p13): panic forced after error
> 
> This message means that the file system has detected an inconsistency
> --- specifically, that the number of blocks marked as in use in the
> allocation bbitmap is different from what is in the block group
> descriptors.
> 
> The file system has been marked to force a panic after an error, at
> which point e2fsck will be able to repair the inconsistency.
> 
> What's not clear is *how* the why this happened.  It can happen simply
> because of a hardware problem.  (In particular, not all mmc flash
> devices handle power failures gracefully.)  Or it could be a cosmic,
> ray, or it might be a kernel bug.

I understand all this.

> Normally I would chalk this up to a hardware bug, bug it's possible
> that it is a kernel bug.  If people can reliably reproduce the problem
> where no power failures or other unclean shutdowns were involved
> (since the last time file system has been checked using e2fsck) then
> that would be realy interesting.

If you read my first reply to Matteo, you would have noticed that I can
reliably reproduce this bug with ext4 and also that I can be pretty confident
that this is NOT a hardware issue. Here's (again) why:

The eMMC device supports eMMC 4.41 and is configured with all the "hardening"
features necessary for embedded systems that boot from eMMC: Enhanced mode is
active (SLC NAND mode) and reliable-writes are turned on. This means that (at
least by design) when a power cut occurs it is guaranteed that:

1.- The sector currently being written will be either in the old state or in
the new (re-written) state, but never "in-between" or in an unstable state
(what happens to regular MLC NAND flash).

2.- No other sectors of the flash may be affected by write interruptions on
one sector.

So power-cuts should always end up just requiring a journal-replay on next
mount. No real corruption should ever occur this way. Right?

I have been testing with both EXT3 and EXT4 on this device and I only see
problems when using EXT4. Furthermore, the process of reproducing the test
produces with almost 100% reliability this error _ALWAYS_ when using EXT4, and
until now I have not been able to use this procedure to corrupt or otherwise
harm an EXT3 filesystem beyond simply replaying the journal on the next boot.

Please tell me what you want me to test to continue investigating. I am
convinced this is a kernel-bug, but I'd be happy if you managed to prove me
wrong. I could even try git bisecting if you think this could help, but if I
have to go too far back in time to find a working version I will get into
trouble getting the kernel to boot on my hardware without patching a lot of
things on each iteration....

> We should probably also change the message so the message is a bit
> more understanding to people who aren't ext4 developers.

That would be nice, but not really necessary. Let's better find the bug and
solve it.

Best regards,

-- 
David Jander
Protonic Holland.
