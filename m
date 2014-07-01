From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: ext4: journal has aborted
Date: Tue, 1 Jul 2014 12:36:46 -0400
Message-ID: <20140701163646.GA3126@wallace>
References: <CAFnufp3TepsxxX8=WCJ0V=3TELP0rWR-NxFukSL8X=qS1q6Eew@mail.gmail.com>
 <20140701082619.1ac77f1d@archvile>
 <20140701084206.GG9743@birch.djwong.org>
 <53B2A47F.90903@samsung.com>
 <20140701155812.GD2775@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jaehoon Chung <jh80.chung@samsung.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Matteo Croce <technoboy85@gmail.com>,
	David Jander <david@protonic.nl>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:54810 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbaGAQgt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jul 2014 12:36:49 -0400
Received: by mail-qg0-f48.google.com with SMTP id q108so3534436qgd.7
        for <linux-ext4@vger.kernel.org>; Tue, 01 Jul 2014 09:36:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20140701155812.GD2775@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Theodore Ts'o <tytso@mit.edu>:
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
> 
> Normally I would chalk this up to a hardware bug, bug it's possible
> that it is a kernel bug.  If people can reliably reproduce the problem
> where no power failures or other unclean shutdowns were involved
> (since the last time file system has been checked using e2fsck) then
> that would be realy interesting.

Hi Ted:

I saw a similar failure during 3.16-rc3 (plus ext4 stable fixes plus msync
patch) regression on the Pandaboard this morning.  A generic/068 hang
on data_journal required a reboot for recovery (old bug, though rarer lately).
On reboot, the root filesystem - default 4K, and on an SD card - went ro
after the same sort of bad block bitmap / journal abort sequence.  Rebooting
forced a fsck that cleared up the problem.  The target test filesystem was on
a USB-attached disk, and it did not exhibit the same problems on recovery.

So, it looks like there might be more than just hardware involved here, 
although eMMC/flash might be a common denominator.  I'll see if I can come up
with a reliable reproducer once the regression pass is finished if someone
doesn't beat me to it.

Eric


> 
> We should probably also change the message so the message is a bit
> more understanding to people who aren't ext4 developers.
> 
>      		      	     	 	- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
